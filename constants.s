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

        .equ    LCR_DLAB,       0x80
        .equ    LCR_8N1,        0x03
        .equ    MCR_DTR_RTS_OUT2,   0x0B                        # OUT2 gates the INT pin on many
                                                                # 8250 designs; harmless to set now
        .equ    LSR_DR,         0x01                            # receive data ready
        .equ    LSR_THRE,       0x20                            # transmit holding register empty

# ---- 8259A PIC registers ---------------------------------------------------
        .equ    PIC1_CMD,       PIC1_BASE + 0 * PIC1_STRIDE     # First 8259A Command Port
        .equ    PIC1_DATA,      PIC1_BASE + 1 * PIC1_STRIDE     # First 8259A Data Port
        .equ    PIC2_CMD,       PIC2_BASE + 0 * PIC2_STRIDE     # Second 8259A Command Port
        .equ    PIC2_DATA,      PIC2_BASE + 1 * PIC2_STRIDE     # Second 8259A Data Port

# ---- 8237 DMA Controller registers -----------------------------------------
        .equ    DMA1_START_0,   DMA1_BASE + 0 * DMA1_STRIDE     # Start Address Register channel 0/4
        .equ    DMA1_COUNT_0,   DMA1_BASE + 1 * DMA1_STRIDE     # Count Register channel 0/4
        .equ    DMA1_START_1,   DMA1_BASE + 2 * DMA1_STRIDE     # Start Address Register channel 1/4
        .equ    DMA1_COUNT_1,   DMA1_BASE + 3 * DMA1_STRIDE     # Count Register channel 1/4
        .equ    DMA1_START_2,   DMA1_BASE + 4 * DMA1_STRIDE     # Start Address Register channel 2/6 
        .equ    DMA1_COUNT_2,   DMA1_BASE + 5 * DMA1_STRIDE     # Count Register channel 2/6
        .equ    DMA1_START_3,   DMA1_BASE + 6 * DMA1_STRIDE     # Start Address Register channel 3/7  
        .equ    DMA1_COUNT_3,   DMA1_BASE + 7 * DMA1_STRIDE     # Count Register channel 3/7
        .equ    DMA1_STATUS,    DMA1_BASE + 8 * DMA1_STRIDE     # Status Register (Read)
        .equ    DMA1_CMD,       DMA1_STATUS                     # Command Register (Write)
        .equ    DMA1_REQ,       DMA1_BASE + 9 * DMA1_STRIDE     # Request Register
        .equ    DMA1_SCMR,      DMA1_BASE + 10 * DMA1_STRIDE    # Single-Channel Mask Register
        .equ    DMA1_MODE,      DMA1_BASE + 11 * DMA1_STRIDE    # Mode Register
        .equ    DMA1_FFR,       DMA1_BASE + 12 * DMA1_STRIDE    # Flip-Flop Reset Register
        .equ    DMA1_IMR,       DMA1_BASE + 13 * DMA1_STRIDE    # Intermediate Register (Read)
        .equ    DMA1_MRR,       DMA1_IMR                        # Master Reset Register (Write)
        .equ    DMA1_MSKR,      DMA1_BASE + 14 * DMA1_STRIDE    # Mask Reset Register
        .equ    DMA1_MCMR,      DMA1_BASE + 15 * DMA1_STRIDE    # Multi-Channel Mask Register

        .equ    DMA2_START_0,   DMA2_BASE + 0 * DMA2_STRIDE     # Start Address Register channel 0/4
        .equ    DMA2_COUNT_0,   DMA2_BASE + 1 * DMA2_STRIDE     # Count Register channel 0/4
        .equ    DMA2_START_1,   DMA2_BASE + 2 * DMA2_STRIDE     # Start Address Register channel 1/4
        .equ    DMA2_COUNT_1,   DMA2_BASE + 3 * DMA2_STRIDE     # Count Register channel 1/4
        .equ    DMA2_START_2,   DMA2_BASE + 4 * DMA2_STRIDE     # Start Address Register channel 2/6 
        .equ    DMA2_COUNT_2,   DMA2_BASE + 5 * DMA2_STRIDE     # Count Register channel 2/6
        .equ    DMA2_START_3,   DMA2_BASE + 6 * DMA2_STRIDE     # Start Address Register channel 3/7  
        .equ    DMA2_COUNT_3,   DMA2_BASE + 7 * DMA2_STRIDE     # Count Register channel 3/7
        .equ    DMA2_STATUS,    DMA2_BASE + 8 * DMA2_STRIDE     # Status Register (Read)
        .equ    DMA2_CMD,       DMA2_STATUS                     # Command Register (Write)
        .equ    DMA2_REQ,       DMA2_BASE + 9 * DMA2_STRIDE     # Request Register
        .equ    DMA2_SCMR,      DMA2_BASE + 10 * DMA2_STRIDE    # Single-Channel Mask Register
        .equ    DMA2_MODE,      DMA2_BASE + 11 * DMA2_STRIDE    # Mode Register
        .equ    DMA2_FFR,       DMA2_BASE + 12 * DMA2_STRIDE    # Flip-Flop Reset Register
        .equ    DMA2_IMR,       DMA2_BASE + 13 * DMA2_STRIDE    # Intermediate Register (Read)
        .equ    DMA2_MRR,       DMA2_IMR                        # Master Reset Register (Write)
        .equ    DMA2_MSKR,      DMA2_BASE + 14 * DMA2_STRIDE    # Mask Reset Register
        .equ    DMA2_MCMR,      DMA2_BASE + 15 * DMA2_STRIDE    # Multi-Channel Mask Register

# ---- DS1501 registers ------------------------------------------------------
        .equ    RTC1_SEC,       RTC1_BASE + 0 * RTC1_STRIDE     # Seconds (BCD Encoded)
        .equ    RTC1_MIN,       RTC1_BASE + 1 * RTC1_STRIDE     # Minutes    
        .equ    RTC1_HR,        RTC1_BASE + 2 * RTC1_STRIDE     # Hours    
        .equ    RTC1_DOW,       RTC1_BASE + 3 * RTC1_STRIDE     # Day of Week (1-7)
        .equ    RTC1_DAY,       RTC1_BASE + 4 * RTC1_STRIDE     # Day of Month
        .equ    RTC1_MON,       RTC1_BASE + 5 * RTC1_STRIDE     # Month
        .equ    RTC1_YEAR,      RTC1_BASE + 6 * RTC1_STRIDE     # Year (0-99)
        .equ    RTC1_CENT,      RTC1_BASE + 7 * RTC1_STRIDE     # Century (0-39)
        .equ    RTC1_ALM_SEC,   RTC1_BASE + 8 * RTC1_STRIDE     # Alarm Seconds
        .equ    RTC1_ALM_MIN,   RTC1_BASE + 9 * RTC1_STRIDE     # Alarm Minutes
        .equ    RTC1_ALM_HR,    RTC1_BASE + 10 * RTC1_STRIDE    # Alarm Minutes
        .equ    RTC1_ALM_DAY,   RTC1_BASE + 11 * RTC1_STRIDE    # Alarm Day or Date
        .equ    RTC1_WD_MS,     RTC1_BASE + 12 * RTC1_STRIDE    # Watch Dog x 10mS
        .equ    RTC1_WD_SEC,    RTC1_BASE + 13 * RTC1_STRIDE    # Watch Dog Seconds
        .equ    RTC1_CTRL_A,    RTC1_BASE + 14 * RTC1_STRIDE    # Control A
        .equ    RTC1_CTRL_B,    RTC1_BASE + 15 * RTC1_STRIDE    # Control B
        .equ    RTC1_RAM_ADR,   RTC1_BASE + 16 * RTC1_STRIDE    # RAM Address (0 - 0xFF)
        .equ    RTC1_RAM_DATA,  RTC1_BASE + 19 * RTC1_STRIDE    # RAM Data (0 - 0xFF)

