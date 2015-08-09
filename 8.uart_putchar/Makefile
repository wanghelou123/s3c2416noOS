uart.bin: start.o clock.o  uart.o main.o
	arm-linux-ld -Ttext 0x00000000 start.o clock.o uart.o  main.o -o uart.elf	
	arm-linux-objcopy -O binary uart.elf uart.bin
	arm-linux-objdump -D uart.elf > uart_elf.dis
%.o : %.S
	arm-linux-gcc -o $@ $< -c
%.o : %.c
	arm-linux-gcc -o $@ $< -c

clean:
	rm *.o *.elf *.bin *.dis *~ -rf
