ASM = nasm
ASMFLAGS = -f bin

SRC = boot/stage1.s
SRC2 = boot/stage2.s 
OUT = bootloader.bin
# USE cat archive.bin > archive2.bin to archive3.bin with archive1.bin and archive2.bin 
all: $(OUT)

Compile:
	nasm $(ASMFLAGS) $(SRC) -o stage1.bin
	nasm $(ASMFLAGS) $(SRC2) -o stage2.bin

Main: Compile
	cat stage1.bin stage2.bin > bootloader.bin
run: Main
	qemu-system-x86_64 -drive format=raw,file=$(OUT)

clean:
	rm -f $(OUT)
	
