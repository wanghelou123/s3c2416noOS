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
	}
	return 0;
}
