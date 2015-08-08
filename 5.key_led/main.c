//板子上的按键为GPF3
//核心板指示灯为GPB0
//zigbee led: GPD3
//network led: GPD4
//3G led: GPD5

int main()
{
	volatile unsigned long * gpbcon = ((volatile unsigned long *)0x56000010);
	volatile unsigned long * gpbdat = ((volatile unsigned long *)0x56000014);
	volatile unsigned long * gpdcon = ((volatile unsigned long *)0x56000030);
	volatile unsigned long * gpddat = ((volatile unsigned long *)0x56000034);
	volatile unsigned long * gpfcon = ((volatile unsigned long *)0x56000050);
	volatile unsigned long * gpfdat = ((volatile unsigned long *)0x56000054);

	/*配置GPB0为输出*/
	*gpbcon &= ~(3<<0);
	*gpbcon |= (0x1<<0);	

	/*配置GPD3, GPD4, GPD5为输出*/
	*gpdcon &= ~(3<<3*2 | 3<<4*2 | 3<<5*2);
	*gpdcon |= (1<<3*2 | 1<<4*2 | 1<<5*2);

	/*配置GPF3为输入*/
	*gpfcon &= ~(3<<6);
	*gpfcon |= (0<<6);	

	while(1) {
		if(!(*gpfdat & (1<<3))) {//低电平表示按下
			*gpbdat &= ~(1<<0);	
			*gpddat &= ~(1<<3 | 1<<4 | 1<<5);
		} else {
			*gpbdat |= (1<<0);	
			*gpddat |= (1<<3 | 1<<4 | 1<<5);
		}
	}

	return 0;
}
