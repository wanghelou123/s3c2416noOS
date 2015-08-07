// 启动代码
.global _start

_start:
	// 关看门狗
	ldr r0, =0x53000000
	mov r1, #0
	str r1, [r0] 
		 
	// 设置栈
	ldr sp, =0x40002000
	
	// 调用C函数点灯
	bl main
	
halt:
	b halt	
