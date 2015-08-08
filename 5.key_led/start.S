.global _start
_start:
	//关闭看门狗
	ldr r0, =0x53000000
	mov r1, #0
	str r1, [r0]

	//设置栈,s3c2416内核有8KB的SRAM
	ldr sp, =0x00002000

	//开启iCache
	mrc p15, 0, r0, c1, c0, 0
	ldr r1, =(1<<12)
	orr r0, r1
	mcr p15, 0, r0, c1, c0, 0

	//跳到C函数中
	bl main

halt:
	bl halt

