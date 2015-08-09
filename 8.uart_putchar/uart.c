#define GPHCON	(*(volatile unsigned long *)0x56000070)
#define ULCON0	(*(volatile unsigned long *)0x50000000) /*UART LINE CONTROL REGISTER*/
#define UCON0	(*(volatile unsigned long *)0x50000004) /*UART CONTROL REGISTER*/
#define UFCON0	(*(volatile unsigned long *)0x50000008) /*UART FIFO CONTROL REGISTER*/
#define UMCON0	(*(volatile unsigned long *)0x5000000C) /*UART MODEM CONTROL REGISTER*/
#define UBRDIV0 (*(volatile unsigned long *)0x50000028) /*UART BAUD RATE DIVISOR REGISTER*/
#define UFSTAT0 (*(volatile unsigned long *)0x50000018) /*UART FIFO STATUS REGISTER*/
#define URXH0   (*(volatile unsigned char *)0x50000024) /*UART channel 0 receive buffer register*/
#define UTXH0   (*(volatile unsigned char *)0x50000020) /*UART channel 0 transmit buffer register*/

void uart_init(void)
{
	/*将GPH0, GPH1配置为功能引脚*/
	GPHCON = (GPHCON & ~0XFFFF)|0XAAAA;

	/*8N1, datasheet p332*/
	ULCON0 = (ULCON0 & ~0X7F)|0x03;

	/*时钟：PCLK, 禁止中断， 使能UART发送，接收:*/
	UCON0 =  0X05;

	/*使用FIFO*/
	UFCON0 |= (1<<0);

	/*禁止自动流控制*/
	UMCON0 = (UMCON0 & ~(1<<4));

}

char getchar(void)
{
	while((UFSTAT0 & 0x7f) == 0);

	return URXH0;
}

void putchar(char c)
{
	while(UFSTAT0 & (1<<14));	

	UTXH0 = c;
}

