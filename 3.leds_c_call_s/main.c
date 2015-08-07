void delay(int count);

int main()
{
	volatile unsigned long * gpbcon =  (volatile unsigned long *)0x56000010;
	volatile unsigned long * gpbdat =  (volatile unsigned long *)0x56000014;
	*gpbcon = (0x01<<0);

	while(1) {
		*gpbdat = 1<<0;
		delay(0x100000);
		*gpbdat = 0<<0;
		delay(0x100000);
	}

	return 0;
}
