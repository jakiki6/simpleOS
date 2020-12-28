run: os.img
	qemu-system-i386 -hda $< --enable-kvm

os.img: loader.bin kernel.bin
	cat loader.bin > os.img
	cat kernel.bin >> os.img

%.bin: %.asm
	nasm -f bin -o $@ $<

clean:
	rm os.img *.bin 2> /dev/null || true

.PHONY: run clean
