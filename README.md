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


