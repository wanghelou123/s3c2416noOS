@******************************************************************************
@ File：led_on.S
@ 功能：LED点灯程序，点亮LED1
@******************************************************************************       
.text
.global _start
_start:     
	// 关看门狗
	ldr r0, =0x53000000
	mov r1, #0
	str r1, [r0] 

	LDR     R0,=0x56000010      @ R0设为GPBCON寄存器。此寄存器用于选择端口B各引脚的功能
	LDR     R1,=(0x1<<0)
	STR     R1,[R0]             @ 设置GPB0为输出口
	LDR     R0,=0x56000014      @ R0设为GPBDAT寄存器。此寄存器用于读/写端口B各引脚的数据	    

	mov r2, #0x1000
led_blink:
	MOV		R1,#0x00000000      @点亮LED灯                          
	STR		R1,[R0]   
	

	// 延时 
	bl delay

	MOV		R1,#0x00000001      @LED灯灭
	STR		R1,[R0]   

	// 延时 
	bl delay

	sub r2, r2, #1
	cmp r2,#0
	bne led_blink
halt:
	b halt

delay:
	mov r1, #0x100000
delay_loop:
	cmp r1, #0
	sub r1, r1, #1
	bne delay_loop
	mov pc, lr
