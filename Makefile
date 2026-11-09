# Makefile - build the 8086 boot ROM and split it for a pair of EEPROMs
#
# Targets:
#   make           build rom.bin, rom_lo.bin, rom_hi.bin
#   make flash     program both chips with minipro (prompts between chips)
#   make verify    verify both chips against the images
#   make dump      show the reset vector area of each image
#   make clean

SRC      := boot.s
OBJ      := boot.o
ROM      := rom.bin
# LO = even bytes -> D0-D7, HI = odd bytes -> D8-D15
ROM_LO   := rom_lo.bin
ROM_HI   := rom_hi.bin
ROM_SIZE := 16384

AS       := as
LD       := ld
OBJCOPY  := objcopy

# Change to the exact name shown by: minipro -l | grep -i 28C64
DEVICE   := AT28C64B@DIP28
PROG     := minipro

.PHONY: all flash verify dump clean

all: $(ROM_LO) $(ROM_HI)

$(OBJ): $(SRC)
	$(AS) --32 -o $@ $<

$(ROM): $(OBJ)
	$(LD) -m elf_i386 -e 0 -Ttext=0 --oformat binary -o $@ $<
	@size=$$(wc -c < $@); \
	if [ "$$size" -ne $(ROM_SIZE) ]; then \
		echo "error: $@ is $$size bytes, expected $(ROM_SIZE)"; rm -f $@; exit 1; \
	fi

$(ROM_LO): $(ROM)
	$(OBJCOPY) -I binary -O binary --interleave=2 --byte=0 $< $@

$(ROM_HI): $(ROM)
	$(OBJCOPY) -I binary -O binary --interleave=2 --byte=1 $< $@

flash: all
	@echo "Insert the LO chip (even bytes, D0-D7)."; read -p "Press Enter to program..." x
	$(PROG) -p "$(DEVICE)" -w $(ROM_LO)
	@echo "Insert the HI chip (odd bytes, D8-D15)."; read -p "Press Enter to program..." x
	$(PROG) -p "$(DEVICE)" -w $(ROM_HI)

verify: all
	@echo "Insert the LO chip."; read -p "Press Enter to verify..." x
	$(PROG) -p "$(DEVICE)" -m $(ROM_LO)
	@echo "Insert the HI chip."; read -p "Press Enter to verify..." x
	$(PROG) -p "$(DEVICE)" -m $(ROM_HI)

dump: all
	@echo "LO tail:"; tail -c 16 $(ROM_LO) | od -A x -t x1
	@echo "HI tail:"; tail -c 16 $(ROM_HI) | od -A x -t x1

clean:
	rm -f $(OBJ) $(ROM) $(ROM_LO) $(ROM_HI)
