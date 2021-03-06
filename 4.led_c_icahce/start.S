.global _start
.global delay
_start:
	//关闭看门狗
	ldr r0, =0x53000000
	mov r1, #0
	str r1, [r0]

	//设置栈
	ldr sp, =0x00000200

	//开启i-cache
	ldr r1, =(1<<12)
	orr	r0, r0, r1		//set bit 12(I) I-cache
	mcr p15, 0, r0, c1, c0, 0

	//调用C函数
	bl main

delay:
	cmp r0, #0
	sub r0, r0, #1
	bne delay
	mov pc, lr
