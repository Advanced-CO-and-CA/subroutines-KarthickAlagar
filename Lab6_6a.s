

.equ SWI_Open, 0x66    @@;open a file
.equ SWI_Close,0x68    @@;close a file
.equ SWI_PrChr,0x00    @@; Write 1 byte to file handle
.equ SWI_RdBytes, 0x6a @@; Read n bytes from file handle
.equ SWI_WrBytes, 0x69 @@; Write n bytes to file handle
.equ Stdin, 0          @@; 0 is the file descriptor for STDIN
.equ Stdout, 1         @@; Set output target to be Stdout
.equ SWI_Exit, 0x11    @@; Stop execution
@ bss section

    .bss



@ data section

    .data

string1: .asciz "Enter the number of enteries\n"
string2: .asciz "Enter the input number:\n"
string3: .asciz "Enter the number to be searched:\n"
string4: .asciz "Index of the Searched Number:\n"
arr:	.word 0



@ TEXT section

      .text



.globl _main

_main:

 	mov r0,#0
	ldr r0,[r0] 
	ldr r1,=string1 	@ Output the String1 through interrupt	
	swi 0x69

	swi 0x6c 		@ Read the number of enteries input into r5 and r7	
	mov r5,r0
	mov r7,r0

	ldr r8, =arr              @ get address of arr
Loop:					
	mov r0,#0		@ Loop to get the input from User and store it in a array
	ldr r0,[r0] 
	ldr r1,=string2
	swi 0x69

	swi 0x6c 		@ Read the input from User in r0 using interrupt
	mov r6,r0

	
	sub r3,r7,r5		@ Storing the input into the array
        lsl r2, r3, #2          @ multiply index*4 to get array offset
        add r2, r8, r2          @ R2 now has the element address	
	STR r6, [r2] 

	subs r5,r5,#1
	BNE Loop

	mov r0,#0
	ldr r0,[r0] 
	ldr     r1,=string3
	swi 0x69	
	swi 0x6c 		@ Read the number to be searched input from user using interrupt

  				@ Passing the parameter using Stack
	PUSH {r8}		@ Base address of Array
	PUSH {r7}		@ No of Enteries
	PUSH {r0}		@ No to be Searched
	BL SEARCH		@ Call the subroutine Search	
	mov r0,#0
	ldr r0,[r0] 
	ldr     r1,=string4	
	swi 0x69
		
	POP {R1}
	swi 0x6b	  @Output the return value

	SWI 0x11 


SEARCH:				@ Implementation of the subroutine Search	
	POP {r0}		@ No to be Searched
	POP {r7}		@ No of Enteries
	POP {r8}		@ Base address of Array

	PUSH {LR}		@ Saving the return address of the subroutine
	mov r1,#-1	
	mov r3,#-1
Loop1:

	add r1,r1,#1		@ Incrementing the index
	CMP r1,r7		@ Comparing to see the search is completed or not
	BEQ Return
        lsl r2, r1, #2          @ multiply index*4 to get array offset
        add r2, r8, r2          @ R2 now has the element address	
	LDR r6, [r2]
	CMP r6,r0		@Comparing the current indexed element of array with User input Search item 
	BNE Loop1		@ Continue to Loop it is not equak
	ADD r1,r1,#1	
	mov r3, r1		@If it is equal store the index in r3
	
Return: 			@ Return logic of the subroutine
	POP {LR}		
	PUSH {r3}	        @ Save the return data in the stack
	MOV PC,LR 		@Jump to the saved return address of Search subroutine
.end

	

