/********************************************************************************************************
2015-08-23 whl 

			s3c2416 DDR2 INITIALIZATION SEQUENCE
1. Setting the BANKCFG & BANKCON1, 2, 3
2. Wait 200us to allow DRAM power and clock stabilize.
3. Wait minimum of 400 ns then issue a PALL(pre-charge all) command.
   Program the INIT[1:0] to ‘01b’. This automatically issues a PALL(pre-charge all) command to the DRAM.
4. Issue an EMRS command to EMR(2), provide LOW to BA0, High to BA1.
   Program the INIT[1:0] of Control Register1 to ‘11b’ & BANKCON3[31]=’1b’

5. Issue an EMRS command to EMR(3), provide High to BA0 and BA1.
   Program the INIT[1:0] of Control Register1 to ‘11b’ & BANKCON3[31:30]=’11b’

6. Issue an EMRS to enable DLL and RDQS, nDQS, ODT disable.


7. Issue a Mode Register Set command for DLL reset.(To issue DLL Reset command, provide HIGH to A8 and
   LOW to BA0-BA1, and A13-A15.) Program the INIT[1:0] to ‘10b’. & BANKCON3[8]=’1b’

8. Issue a PALL(pre-charge all) command.
   Program the INIT[1:0] to ‘01b’. This automatically issues a PALL(pre-charge all) command to the DRAM.

9. Issue 2 or more auto-refresh commands.

10. Issue a MRS command with LOW to A8 to initialize device operation.
   Program the INIT[1:0] to ‘10b’. & BANKCON3[8]=’0b’

11. Wait 200 clock after step 7, execute OCD Calibration.

12. The external DRAM is now ready for normal operation

ps:
   EMRS ==>	 (EXTENDED ) MODE REGISTER SET REGISTER  datasheet:P155

		KT451163QJ-BCF7
32Mx16, 84 FBGA
CAS Latency	6
tRCD(min)	15
tRP(min)	15
tRC(min)	15

#of Bank		4			
Bank Addres		BA0,BA1		//Bank Address Inputs
Auto precharge	A10/AP		//A10 is sampled during a Precharge command to determine 
							//whether the Precharge applies to one bank (A10 LOW) or all banks (A10 HIGH).`
Row Address		A0~A12		//行地址
Column Address	A0~A9		//列地址

********************************************************************************************************/
//#define BANKCFG		(*(volatile unsigned long *)0x48000000) /*Mobile DRAM configuration register*/
//#define BNAKCONF1	(*(volatile unsigned long *)0x48000004) /*Mobile DRAM control register*/
//#define BNAKCONF2	(*(volatile unsigned long *)0x48000008) /*Mobile DRAM timing control register*/
//#define BNAKCONF3	(*(volatile unsigned long *)0x4800000C) /*Mobile DRAM (E)MRS register*/
//#define REFRESH		(*(volatile unsigned long *)0x48000010) /*Mobile DRAM refresh control register*/
//#define TIMEOUT		(*(volatile unsigned long *)0x48000014)	/*Write Buffer Time out control register*/

#define DRAM_BASE		0x48000000
#define	BANKCFG_OFFSET	0x00
#define	BANKCON1_OFFSET	0x04
#define	BANKCON2_OFFSET	0x08
#define	BANKCON3_OFFSET	0x0C
#define REFRESH_OFFSET	0x10
#define	TIMEOUT_OFFSET	0x14

; KT451163QJ-BCF70(DDR2-800 6-6-6)64MB,Row Addr A0~A12, Column Addr A0~A9
; 设置DDR2 13位行地址，10位列地址，DDR2接口，16位总线
; DDR命令根据nRAS,nCAS,nWE,nCS控制总线分辨
; Active命令,打开行及bank地址
; Read命令,在Active后,打开列地址读
; Write命令,在Active后,打开列地址写
; Precharge命令,关闭bank,根据A[10]确定关闭指定或所有bank(只能同时访问一个bank)
; AUTOREFRESH or SELF REFRESH命令,刷新命
; LOAD MODEREGISTER命令,写模式寄存器

.global sdr_ctrl_asm_init
sdr_ctrl_asm_init:
	//1. Setting the BANKCFG & BANKCON1, 2, 3
	ldr r0, =DRAM_BASE
	ldr r1, =(2<<17)|(2<<11)|(0<<6)|(1<<1)|(1<<0)
	str r1, [r0, BANKCFG_OFFSET]
	
	ldr r1, =(3<<28)|(1<<26)|(1<<8)|(1<<7)|(1<<6)|(0<<5)|(1<<4)
	str r1, [r0, BANKCON1_OFFSET]

	;s3c2416 DDR2寄存器的CLK设置值是相对HCLK的,HCLK=133MHZ,1clock=7.518ns
	;tRAS[23:20] 45ns= 6clock
	;tARFC[19:16] 105ns	= 14clock
	;CAS Latency[5:4] 6tCK,tcK=2.5ns,15ns = 2clock
	;tRCD[3:2] 15ns=2clock
	;tRP[1:0]  15ns=2clock		

	ldr r1, =(5<<20)|(13<<16)|(2<<4)|(2<<2)|(2<<0)
	str r1, [r0, BANKCON2_OFFSET]
	


	/*2. Wait 200us to allow DRAM power and clock stabilize.*/
	
	/*3. Wait minimum of 400 ns then issue a PALL(pre-charge all) command.
		Program the INIT[1:0] to ‘01b’. Th
		is automatically issues a PALL(pre-charge all) command to the DRAM
	*/
	ldr	r1, [r0, BANKCON1_OFFSET]
	bic r1, #0x03
	orr r1, #0x01
	str r1, [r0, BANKCON1_OFFSET]

	/*
		4. Issue an EMRS command to EMR(2), provide LOW to BA0, High to BA1.
		Program the INIT[1:0] of Control Register1 to ‘11b’ & BANKCON3[31]=’1b’
	*/
	ldr r1, =(2<<30)
	str r1, [r0, BANKCON3_OFFSET]
	ldr r1, [r0, BANKCON1_OFFSET]
	orr r1, #0x03
	str	r1, [r0, BANKCON1_OFFSET]

	/*
		5. Issue an EMRS command to EMR(3), provide High to BA0 and BA1.
		   Program the INIT[1:0] of Control Register1 to ‘11b’ & BANKCON3[31:30]=’11b’
	*/	
	ldr r1, =(3<<30)
	str r1, [r0, BANKCON3_OFSET]
	ldr r1, [r0, BANKCON1_OFFSET]
	orr r1, 0x03
	str r1, [r0, BANKCON1_OFFSET]

	/*
		6. Issue an EMRS to enable DLL and RDQS, nDQS, ODT disable.
	*/

	ldr r1, =(0x01<<30)|(0x00<<27)|(0x01<<26)|(0x00<<16);
	str r1, [r0, BANKCON3_OFSET]
	ldr r1, [r0, BANKCON1_OFFSET]
	orr r1, 0x03
	str r1, [r0, BANKCON1_OFFSET]

	/*
		7. Issue a Mode Register Set command for DLL reset.(To issue DLL Reset command, provide HIGH to A8 and
		   LOW to BA0-BA1, and A13-A15.) Program the INIT[1:0] to ‘10b’. & BANKCON3[8]=’1b’
	*/
	LDR     R1,=0x0000FFFF
	LDR     R2,[R0, #BANKCON3_OFS]
	BIC     R2,R2, R1
	LDR     R1,=(0x1<<9)+(1<<8)+(0<<7)+(3<<4)                     
	ORR     R1,R1, R2
	STR     R1,[R0, #BANKCON3_OFS]
	ldr r1, [r0, BANKCON1_OFFSET]
	bic r1, 0x03
	orr r1, 0x02
	str r1, [r0, BANKCON1_OFFSET]

	/*
		8. Issue a PALL(pre-charge all) command.
		 Program the INIT[1:0] to ‘01b’. This automatically issues a PALL(pre-charge all) command to the DRAM.
	*/
	ldr r1, [r0, BANCON1_OFFSET]
	bic r1, 0x03
	orr r1, 0x01
	str r1, [r0, BANCON1_OFFSET]

	/*
		9. Issue 2 or more auto-refresh commands.
	*/
	ldr r1, =0x20
	str r1,[r0,REFRESH_OFFSET] 

	/*
		10. Issue a MRS command with LOW to A8 to initialize device operation.
		   Program the INIT[1:0] to ‘10b’. & BANKCON3[8]=’0b’
	*/
	ldr     R1,=0x0000FFFF
	ldr     r2,[R0, #BANKCON3_OFS]
	bic     r2,r2, r1
	ldr     r1,=(0x1<<9)+(0<<8)+(0<<7)+(3<<4)                     
	orr     r1,r1, r2
	str     r1,[r0, #BANKCON3_OFS]
	ldr r1, [r0, BANKCON1_OFFSET]
	bic r1, 0x03
	orr r1, 0x02
	str r1, [r0, BANKCON1_OFFSET]

	/*
		11. Wait 200 clock after step 7, execute OCD Calibration.
	*/
	ldr r1, =200;
0	subs r1, r1, #1
	bne %b0


	/*
		12. The external DRAM is now ready for normal operation
	*/
