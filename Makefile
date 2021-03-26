sandbox.bin: sandbox.asm
	nasm -f bin -o $@ $<

.PHONY: run
run: sandbox.bin
	qemu-system-i386 -fda $<

