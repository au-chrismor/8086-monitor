# ---- hardware configuration ------------------------------------------------
#
#       DMA Settings
#
        .equ DMA1_BASE,         0x0000
        .equ DMA1_STRIDE,       1                               # set to 2 if registers sit on even

        .equ DMA2_BASE,         0x0020
        .equ DMA2_STRIDE,       1                               # set to 2 if registers sit on even
#
#       PIC Settings
#
        .equ PIC1_BASE,         0x0040
        .equ PIC1_STRIDE,       1                               # set to 2 if registers sit on even

        .equ PIC2_BASE,         0x0060
        .equ PIC2_STRIDE,       1                               # set to 2 if registers sit on even
#
#       Timer Settings
#
        .equ TMR1_BASE,         0x0080
        .equ TMR1_STRIDE,       1                               # set to 2 if registers sit on even
#
#       RTC/NVR Settings
#
        .equ RTC1_BASE,         0x00A0
        .equ RTC1_STRIDE,       1                               # set to 2 if registers sit on even
#        
#       UART Settings
#
        .equ UART_CLK,          1843200                         # 8250 crystal/clock input, Hz

        .equ UART1_BASE,        0x00C0
        .equ UART1_STRIDE,      1                               # set to 2 if registers sit on even
        .equ UART1_BAUD,        9600
        .equ UART1_BAUD_DIV,    UART_CLK / (16 * UART1_BAUD)    # 12 for 1.8432 MHz
                                                                # addresses only (see notes)
        .equ UART2_BASE,        0x00E0
        .equ UART2_STRIDE,      1                               # set to 2 if registers sit on even
        .equ UART2_BAUD,        9600
        .equ UART2_BAUD_DIV,    UART_CLK / (16 * UART1_BAUD)    # 12 for 1.8432 MHz

        .equ PPI1_BASE,         0x0100
        .equ PPI1_STRIDE,       1

        .equ PPI2_BASE,         0x0120
        .equ PPI2_STRIDE,       1

# ---- 8250 registers --------------------------------------------------------
        .equ UART1_RBR,         UART1_BASE + 0 * UART1_STRIDE   # read  (DLAB=0)
        .equ UART1_THR,         UART1_BASE + 0 * UART1_STRIDE   # write (DLAB=0)
        .equ UART1_DLL,         UART1_BASE + 0 * UART1_STRIDE   # DLAB=1
        .equ UART1_IER,         UART1_BASE + 1 * UART1_STRIDE   # DLAB=0
        .equ UART1_DLM,         UART1_BASE + 1 * UART1_STRIDE   # DLAB=1
        .equ UART1_IIR,         UART1_BASE + 2 * UART1_STRIDE
        .equ UART1_LCR,         UART1_BASE + 3 * UART1_STRIDE
        .equ UART1_MCR,         UART1_BASE + 4 * UART1_STRIDE
        .equ UART1_LSR,         UART1_BASE + 5 * UART1_STRIDE
        .equ UART1_MSR,         UART1_BASE + 6 * UART1_STRIDE

        .equ UART2_RBR,         UART2_BASE + 0 * UART1_STRIDE   # read  (DLAB=0)
        .equ UART2_THR,         UART2_BASE + 0 * UART1_STRIDE   # write (DLAB=0)
        .equ UART2_DLL,         UART2_BASE + 0 * UART1_STRIDE   # DLAB=1
        .equ UART2_IER,         UART2_BASE + 1 * UART1_STRIDE   # DLAB=0
        .equ UART2_DLM,         UART2_BASE + 1 * UART1_STRIDE   # DLAB=1
        .equ UART2_IIR,         UART2_BASE + 2 * UART1_STRIDE
        .equ UART2_LCR,         UART2_BASE + 3 * UART1_STRIDE
        .equ UART2_MCR,         UART2_BASE + 4 * UART1_STRIDE
        .equ UART2_LSR,         UART2_BASE + 5 * UART1_STRIDE
        .equ UART2_MSR,         UART2_BASE + 6 * UART1_STRIDE

        .equ LCR_DLAB,          0x80
        .equ LCR_8N1,           0x03
        .equ MCR_DTR_RTS_OUT2,  0x0B                            # OUT2 gates the INT pin on many
                                                                # 8250 designs; harmless to set now
        .equ LSR_DR,            0x01                            # receive data ready
        .equ LSR_THRE,          0x20                            # transmit holding register empty

