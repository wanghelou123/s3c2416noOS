#define	CLKDIV0   (*(volatile unsigned long *)0x4c000024)
#define LOCKCON0  (*(volatile unsigned long *)0x4c000000)
#define	MPLLCON   (*(volatile unsigned long *)0x4c000010)
#define CLKSRC    (*(volatile unsigned long *)0x4c000020) 

#define ARMDIV	1
#define PREDIV	2
#define PCLKDIV	1
#define HCLKDIV	1
#define CLK_DIV_VAL	((ARMDIV<<9) | (PREDIV<<4) | (PCLKDIV<<2) | (HCLKDIV<<0))

#define	MPLLEN_STOP	0
#define	MDIV		400
#define	PDIV		3
#define SDIV		1
#define MPLL_VAL	((MPLLEN_STOP<<24) | (MDIV<<14) | (PDIV<<5) | (SDIV)<<0)
void clock_init()
{
	//ARMDIV=1, PREDIV=2, HCLKDIV=1
	//PLL		= 800MHz
	//ARMCLK	= 400MHz
	//HCLK		= 133MHz
	//PCLK		= 66MHz
	//DDRCLK	= 266MHz
	//SSMCCLK	= 66MHz
	CLKDIV0	= (CLKDIV0&( ~(0x1e37)))|CLK_DIV_VAL;

	//设置locktime
	LOCKCON0 = 0xffff;

	//设置MPLL
	MPLLCON = MPLL_VAL;

	//设置时钟源,datasheet p104
	CLKSRC |= (1<<4);
}
