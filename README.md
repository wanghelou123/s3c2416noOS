s3c2416noOS

一、板子上的资源：
1、板子上的按键为GPF3
2、核心板指示灯为GPB0
3、zigbee led: GPD3
4、network led: GPD4
5、3G led: GPD5

二、关于栈
1、栈的作用: 栈有三个作用，包括： 保存现场； 传递参数:汇编代码调用 C 函数时，需传递参数； 保存临时
变量:包括函数的非静态局部变量以及编译器自动生成的其他临时变量

2、s3c2416内部有8KB的SRAM，写裸机程序时可以作为栈使用
如果直接烧写到NAND上，初始化方法：
ldr sp, =0x00000200

如果在SDRAM中运行程序，但是当iROM实始化完之后8KB的SRAM会被映身成为0x40000200
ldr sp, =0x40000200


三、
1、s3c2416有两个PLL: MPLL 和 EPLL
MPLL用于产生 ARMCLK, HCLK, PCLK, DDRCLK
EPLL用于产生 USBHOST, LCDCLK, I2SCLK, UARTCLK
2、实始化时钟分为4步：
1)设置分频
CLKDIV0:0x4C00_0024
2)设置锁定时间
LOCKCON0:0x4C00_0000
3)设置PLL
MPLLCON:0x4C00_0010
4)设置各种时钟开关
CLKSRC:0x4C00_0020

四、UART
1、s3c2416有4个uart, 每个uart包含一个波特率产生器、发送器、接收器、一个控制单元
波特率产生器可以靠PCLK, EXTUARTCLK, EPLL产生时钟，发送器和接收器包含64字节的FIFO和数据移位

2、9针串口引脚定义
针脚  定义            符号
1     载波检测        DCD
2     接收数据        RXD
3     发送数据        TXD
4     数据终端准备好  DTR
5     信号地          SG
6     数据准备好      DSR
7     请求发送        RTS
8     清除发送        CTS
9     振铃提示        RI

3、初始化串口
1）配置引脚用于RX/TX功能
	GPHCON 0x56000070
	GPHDAT 0x56000074
	GPH0:TXD[0]
	GPH1:TXD[0]
2）设置数据格式
3）设置波特率
