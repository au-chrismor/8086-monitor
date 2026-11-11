# SYSTEM HARDWARE

**Please Note**

This is a live project and not everything here is going to be stable or consistent.  Please check against the **main** branch before making major decisions.

## CORE

The following components are defined

- CPU: Intel 8086 @ 4MHz
- Timing Generator: Intel 8284
    - Crystal Oscillator: 12MHz
- System Controller: Intel 8288
- RAM: 64KB (2 x 62256 Chips)
- EEPROM: 16KB (2 x AT28C64B)
- Communications: Intel 8250
    - 8250 clock: 1.8432MHz
- Parallel I/O: Intel 8255

### CORE NOTES

You could do all of this with an 8088 and just use a single RAM and EEPROM if you wish.  The code will work just fine.

I chose to use an 8086 because it's the original design, and the work I do here would lend itself to an 80186 through 80486 before the hardware gets too complicated.  I would like to try at least an 80186 or 80286 in the future.

