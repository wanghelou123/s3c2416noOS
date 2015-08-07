//核心板上的LED用的是GPB0管脚
//by whl 2015-08-06 

void delay(volatile int count)
{
	volatile int i = count;
	while(i--);
}

int main()
{
	// 配置引脚
	volatile unsigned long *gpbcon = (volatile unsigned long *)0x56000010;
	volatile unsigned long *gpbdat = (volatile unsigned long *)0x56000014;
	*gpbcon = ( 0x1<<0 );

	while (1)
	{
		// LED灭
		*gpbdat = (1<<0); 
		delay(0x100000);
		// LED亮
		*gpbdat = (0<<0);	
		delay(0x100000);	
	}
	return 0;
}

