@ BSS section
.bss
z: .word
@ DATA SECTION

.data 
NUM: .word 5 
FNUM: .word 0
string1: .asciz "Enter the number to  compute the Nth Fibonacci Number\n"
string4: .asciz "Result:\n"
	   
@ TEXT section
    .text

.global _main


.text 

_main:
      	MOV R0,#0
	LDR R0,[R0] 
	LDR R1,=string1 
	swi 0x69

	swi 0x6c 		@ Read the number to compute the Nth Fibonacci Number
	MOV R1,R0
	PUSH {R1}		
	BL FIB 			@ Subroutine Call
	
	mov r3,r0
	mov r0,#0
	ldr r0,[r0] 
	ldr     r1,=string4
	swi 0x69
		
	mov r1,r3
	swi 0x6b

	SWI 0x11 
	

FIB:				@ Implementation of Fibonacci	
	POP {R1}		
	CMP R1,#1 		@ Compare if n == 1 	
	MOVLE R0,R1 			
	MOVLE PC,lr 		@Return to the calling function if n ==1
	PUSH {LR}		@ Save the return address
	SUB R1,R1,#2		@ Compute f(b-2)
	PUSH {R1}
	BL FIB 			@ Call Recursivery FIB with the parameter f(b-2)
	PUSH {R0} 		
	ADD R1,R1,#1 		@ Compute f(b-1)
	PUSH {R1}
	BL FIB 			@ Call Recursivery FIB with the parameter f(b-1)
	POP {R2}		
	ADD R0,R0,R2		@Compute f(b) = f(b-1)+f(b-2)
	ADD R1,R1,#1
	POP {PC}		@ Return to the main function call
.end