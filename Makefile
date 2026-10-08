ASM = nasm
ASMFLAGS = -f bin
BUILD = build
SRC = boot/stage1.s
SRC2 = boot/stage2.s 
OUT = build/bootloader.bin
# USE cat archive.bin > archive2.bin to archive3.bin with archive1.bin and archive2.bin 
all: $(OUT)

Compile:
	mkdir -p $(BUILD) 
	nasm $(ASMFLAGS) $(SRC) -o $(BUILD)/stage1.bin
	nasm $(ASMFLAGS) $(SRC2) -o $(BUILD)/stage2.bin

Main: Compile
	
	cat build/stage1.bin build/stage2.bin > build/bootloader.bin
run: Main
	qemu-system-x86_64 -drive format=raw,file=$(OUT)

clean:
	rm -rf $(BUILD)
	
