# ---------------------------------------------------------------------------
# boot.s - minimal 8086 bootstrap ROM (GNU as, Intel syntax)
#
# Memory map assumed:
#   RAM  0x00000-0x1FFFF (128KB)        (IVT lives at 0x00000-0x003FF)
#   ROM  0xFC000-0xFFFFF (16KB)         (reset vector at 0xFFFF0)
# I/O:
#   8237 DMA Controller 1 at 0x0000 - 0x001F
#   8237 DMA Controller 2 at 0x0020 - 0x003F
#   8259A Interrupt Controller 1 at 0x0040 - 0x005F
#   8259A Interrupt Controller 2 at 0x0060 - 0x007F
#   8254 Timer at 0x0080 - 0x0083
#   DS1501 Real Time Clock at 0x00A0 - 0x00BF
#   8250 UART 1 at 0x00C0 - 0x00DF
#   8250 UART 2 at 0x00E0 - 0x00FF
#   8255 PPI 1 at 0x0100 - 0x011F
#   8255 PPI 2 at 0x0120 - 0x013F
#
# The ROM is linked at offset 0 and executed with CS = 0xFC00, so
# physical address = 0xFC000 + offset. The reset stub sits at offset
# 0x3FF0 (= physical 0xFFFF0) and far-jumps to 'start' with CS = 0xFC00.
#
# Only plain 8086 instructions are used (no 186+ immediate shifts,
# push imm, etc.).
# ---------------------------------------------------------------------------

        .intel_syntax noprefix
        .code16
        .include                "constants.s"
        
# ---------------------------------------------------------------------------
        .section                .text
        .org 0

start:
        cli
        cld

        # Stack: SS=0, SP=0 -> first push lands at 0x0FFFE (top of 64KB RAM).
        # It grows down toward the IVT at 0x000-0x3FF; keep data/stack use
        # well clear of that.
        xor     ax, ax
        mov     ss, ax
        xor     sp, sp
        mov     ds, ax                                          # DS = ES = 0 -> RAM
        mov     es, ax

        call    uart_init

        mov     bx, offset banner
        call    puts

echo_loop:
        call    getc
        cmp     al, 0x0D                                        # CR -> echo CR LF
        jne     1f
        call    putc
        mov     al, 0x0A
1:      call    putc
        jmp     echo_loop

# ---------------------------------------------------------------------------
# uart_init - 9600 8N1, interrupts disabled (polled)
# clobbers AX, DX
# ---------------------------------------------------------------------------
uart_init:
        mov     dx, offset UART1_IER
        xor     al, al
        out     dx, al                                          # no UART interrupts yet

        mov     dx, offset UART1_LCR
        mov     al, LCR_DLAB
        out     dx, al                                          # open divisor latch

        mov     dx, offset UART1_DLL
        mov     al, UART1_BAUD_DIV & 0xFF
        out     dx, al
        mov     dx, offset UART1_DLM
        mov     al, UART1_BAUD_DIV >> 8
        out     dx, al

        mov     dx, offset UART1_LCR
        mov     al, LCR_8N1                                     # 8 data, no parity, 1 stop; DLAB=0
        out     dx, al

        mov     dx, offset UART1_MCR
        mov     al, MCR_DTR_RTS_OUT2
        out     dx, al

        # flush any stale status/data
        mov     dx, offset UART1_LSR
        in      al, dx
        mov     dx, offset UART1_RBR
        in      al, dx
        mov     dx, offset UART1_IIR
        in      al, dx
        mov     dx, offset UART1_MSR
        in      al, dx
        ret

# ---------------------------------------------------------------------------
# getc - wait for a byte, return it in AL
# ---------------------------------------------------------------------------
getc:
        push    dx
        mov     dx, offset UART1_LSR
1:      in      al, dx
        test    al, LSR_DR
        jz      1b
        mov     dx, offset UART1_RBR
        in      al, dx
        pop     dx
        ret

# ---------------------------------------------------------------------------
# putc - send AL (preserves all registers)
# ---------------------------------------------------------------------------
putc:
        push    ax
        push    dx
        mov     ah, al
        mov     dx, offset UART1_LSR
1:      in      al, dx
        test    al, LSR_THRE
        jz      1b
        mov     al, ah
        mov     dx, offset UART1_THR
        out     dx, al
        pop     dx
        pop     ax
        ret

# ---------------------------------------------------------------------------
# puts - send NUL-terminated string in ROM; BX = offset within ROM segment
# (reads via CS: because DS points at RAM). Clobbers BX.
# ---------------------------------------------------------------------------
puts:
        push    ax
1:      mov     al, cs:[bx]
        inc     bx
        or      al, al
        jz      2f
        call    putc
        jmp     1b
2:      pop     ax
        ret

banner:
        .asciz  "\r\n8086 ready\r\n"

# ---------------------------------------------------------------------------
# Reset vector: CPU starts at FFFF:0000 = physical 0xFFFF0 = ROM offset 0x3FF0
# Emitted as raw bytes: JMP FAR 0xFC00:start
# ---------------------------------------------------------------------------
        .org 0x3FF0
reset:
        .byte   0xEA
        .word   start
        .word   0xFC00

        .org 0x3FFF                                             # pad image to exactly 16384 bytes
        .byte   0xFF
