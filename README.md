# Simple 8086 bootstrap and monitor

## Introduction

I am building an 8086-based computer from scratch because I like making things hard for myself.  The components in use so far are:

- 8086 CPU (obvious huh?)
- 64K RAM at 0x0
- 16K EEPROM at top of memory
- 8250 UART at I/O 0x3F8 (Like the PC)
- 8255 PPI at I/O 0x378 (Similar the PC)

## Please note

I am **NOT** designing a PC here.  While I used some of the addresses and a lot of the same parts, this is a simple machine along the lines of the Developer Boards of the 1970's and 1980's.

## What's here?

Right now, there is "boot.s" which initialises the segments and the 8250.  Once running it just echoes back whatever you send via the serial connection.

I know it doesn't sound like much yet, but trust me it's a big deal when you started with nothing.

## What's next?

The next steps will include:

- Initialising the 8255 so it could light a LED
- Initialise an 8259A PIC to support interrupts
- Some monitor functions to examine and edit memory as well as run a program.

## Building

You will need GNU Assembler (FreeBSD or Most Linux flavours) and objcopy to split the output into "high" and "low" EEPROM images.  If you want to build for an 8088, you can skip that step and use "rom.bin"

I have also included support for minipro if you want to automate burning the images as well, but this isn't essential.

