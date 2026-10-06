ASM = nasm
ASMFLAGS = -f bin

SRC = boot/stage1.s
SRC2 = boot/stage2.s 
OUT = bootloader.bin
# USE cat archive.bin > archive2.bin to archive3.bin with archive1.bin and archive2.bin 
all: $(OUT)

$(OUT): $(SRC)
	$(ASM) $(ASMFLAGS)   -o $(OUT) $(SRC)
Main:
	cat stage1.bin stage2.bin > bootloader.bin
run: $(OUT)
	qemu-system-x86_64 -drive format=raw,file=$(OUT)

clean:
	rm -f $(OUT)

