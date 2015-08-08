led.bin: start.o main.o
	arm-linux-ld -Ttext 0x00000000 start.o main.o -o led.elf	
	arm-linux-objcopy -O binary led.elf led.bin
	arm-linux-objdump -D led.elf > led_elf.dis
%.o : %.S
	arm-linux-gcc -o $@ $< -c
%.o : %.c
	arm-linux-gcc -o $@ $< -c

clean:
	rm *.o *.elf *.bin *.dis *~ -rf
