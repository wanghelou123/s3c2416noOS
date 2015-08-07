@******************************************************************************
@ File��led_on.S
@ ���ܣ�LED��Ƴ��򣬵���LED1
@******************************************************************************       
.text
.global _start
_start:     
	// �ؿ��Ź�
	ldr r0, =0x53000000
	mov r1, #0
	str r1, [r0] 

	LDR     R0,=0x56000010      @ R0��ΪGPBCON�Ĵ������˼Ĵ�������ѡ��˿�B�����ŵĹ���
	LDR     R1,=(0x1<<0)
	STR     R1,[R0]             @ ����GPB0Ϊ�����
	LDR     R0,=0x56000014      @ R0��ΪGPBDAT�Ĵ������˼Ĵ������ڶ�/д�˿�B�����ŵ�����	    

	mov r2, #0x1000
led_blink:
	MOV		R1,#0x00000000      @����LED��                          
	STR		R1,[R0]   
	

	// ��ʱ 
	bl delay

	MOV		R1,#0x00000001      @LED����
	STR		R1,[R0]   

	// ��ʱ 
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