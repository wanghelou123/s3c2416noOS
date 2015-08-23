link.bin: start.o clock.o  uart.o main.o
	arm-linux-ld -T link.lds -o link.elf $^
	arm-linux-objcopy -O binary link.elf link.bin
	arm-linux-objdump -D link.elf > link_elf.dis
%.o : %.S
	arm-linux-gcc -o $@ $< -c
%.o : %.c
	arm-linux-gcc -o $@ $< -c

clean:
	rm *.o *.elf *.bin *.dis *~ -rf
