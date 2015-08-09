void uart_init(void);
char getchar(void);
void putchar(char c);

void delay(volatile int count){
	while(count --);
}

int main()
{
	char c;
	uart_init();
	while(1) {
		c = getchar();
		putchar(c);
		//putchar('C');
		//delay(0x100000);
	}
	return 0;
}
