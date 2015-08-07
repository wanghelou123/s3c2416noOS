.global _start
.global delay
_start:
	//关闭看门狗
	ldr r0, =0x53000000
	mov r1, #0
	str r1, [r0]
	bl main

delay:
	cmp r0, #0
	sub r0, r0, #1
	bne delay
	mov pc, lr
