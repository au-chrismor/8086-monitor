# ---------------------------------------------------------------------------
# boot.s - minimal 8086 bootstrap ROM (GNU as, Intel syntax)
#
# Memory map assumed:
#   RAM  0x00000-0x0FFFF (64KB)   (IVT lives at 0x00000-0x003FF)
#   ROM  0xFC000-0xFFFFF (16KB)   (reset vector at 0xFFFF0)
# I/O:
#   8250 UART at 0x3F8, 8255 PPI at 0x378
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

# ---- hardware configuration ------------------------------------------------
        .equ UART_BASE,   0x3F8
        .equ UART_STRIDE, 1             # set to 2 if registers sit on even
                                        # addresses only (see notes)
        .equ UART_CLK,    1843200       # 8250 crystal/clock input, Hz
        .equ BAUD,        9600
        .equ BAUD_DIV,    UART_CLK / (16 * BAUD)    # 12 for 1.8432 MHz

        .equ PPI_BASE,    0x378
        .equ PPI_STRIDE,  1

# ---- 8250 registers --------------------------------------------------------
        .equ UART_RBR,    UART_BASE + 0 * UART_STRIDE   # read  (DLAB=0)
        .equ UART_THR,    UART_BASE + 0 * UART_STRIDE   # write (DLAB=0)
        .equ UART_DLL,    UART_BASE + 0 * UART_STRIDE   # DLAB=1
        .equ UART_IER,    UART_BASE + 1 * UART_STRIDE   # DLAB=0
        .equ UART_DLM,    UART_BASE + 1 * UART_STRIDE   # DLAB=1
        .equ UART_IIR,    UART_BASE + 2 * UART_STRIDE
        .equ UART_LCR,    UART_BASE + 3 * UART_STRIDE
        .equ UART_MCR,    UART_BASE + 4 * UART_STRIDE
        .equ UART_LSR,    UART_BASE + 5 * UART_STRIDE
        .equ UART_MSR,    UART_BASE + 6 * UART_STRIDE

        .equ LCR_DLAB,    0x80
        .equ LCR_8N1,     0x03
        .equ MCR_DTR_RTS_OUT2, 0x0B     # OUT2 gates the INT pin on many
                                        # 8250 designs; harmless to set now
        .equ LSR_DR,      0x01          # receive data ready
        .equ LSR_THRE,    0x20          # transmit holding register empty

# ---------------------------------------------------------------------------
        .section .text
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
        mov     ds, ax                  # DS = ES = 0 -> RAM
        mov     es, ax

        call    uart_init

        mov     bx, offset banner
        call    puts

echo_loop:
        call    getc
        cmp     al, 0x0D                # CR -> echo CR LF
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
        mov     dx, offset UART_IER
        xor     al, al
        out     dx, al                  # no UART interrupts yet

        mov     dx, offset UART_LCR
        mov     al, LCR_DLAB
        out     dx, al                  # open divisor latch

        mov     dx, offset UART_DLL
        mov     al, BAUD_DIV & 0xFF
        out     dx, al
        mov     dx, offset UART_DLM
        mov     al, BAUD_DIV >> 8
        out     dx, al

        mov     dx, offset UART_LCR
        mov     al, LCR_8N1             # 8 data, no parity, 1 stop; DLAB=0
        out     dx, al

        mov     dx, offset UART_MCR
        mov     al, MCR_DTR_RTS_OUT2
        out     dx, al

        # flush any stale status/data
        mov     dx, offset UART_LSR
        in      al, dx
        mov     dx, offset UART_RBR
        in      al, dx
        mov     dx, offset UART_IIR
        in      al, dx
        mov     dx, offset UART_MSR
        in      al, dx
        ret

# ---------------------------------------------------------------------------
# getc - wait for a byte, return it in AL
# ---------------------------------------------------------------------------
getc:
        push    dx
        mov     dx, offset UART_LSR
1:      in      al, dx
        test    al, LSR_DR
        jz      1b
        mov     dx, offset UART_RBR
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
        mov     dx, offset UART_LSR
1:      in      al, dx
        test    al, LSR_THRE
        jz      1b
        mov     al, ah
        mov     dx, offset UART_THR
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

        .org 0x3FFF                     # pad image to exactly 16384 bytes
        .byte   0xFF
