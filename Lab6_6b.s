

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
	ldr r1,=string1  @ Output the String1 through interrupt
	swi 0x69

	swi 0x6c 		@ Read the number of enteries input into r5 and r7
	mov r5,r0
	mov r7,r0

	ldr r8, =arr              @ get address of arr
Loop:				@ Loop to get the input from User and store it in a array	
	mov r0,#0	 
	ldr r0,[r0] 
	ldr r1,=string2
	swi 0x69

	swi 0x6c 		@ Read the number to be searched input from user using interrupt
	mov r6,r0

	
	sub r3,r7,r5
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
	swi 0x6b		 @Output the return value

	SWI 0x11 


SEARCH:				@ Implementation of the subroutine Search using Binary Search assuming array is already sorted	
	POP {r0}		@ No to be Searched
	POP {r7}		@ No of Enteries
	POP {r8}		@ Base address of Array

	PUSH {LR}		@ Saving the return address of the subroutine
	mov r1,#0	
	mov r3,#-1
Loop1:
	
	add r5,r1,r7	@ Add the lower limit and upper limit
	LSR R5,#1	@ Divide the above value by 2
	CMP r5,r7	@ Comparing the calculated lower limit and upper limit
	BEQ Return	@ Jump to return if calculated lower limit is equal to upper limit
	lsl r2, r5, #2          @ multiply index*4 to get array offset
        add r2, r8, r2          @ R2 now has the element address	
	LDR r6, [r2]
	CMP r6,r0		@Comparing the current indexed element of array with User input Search item 
	BLT Lessthan	  @Jump to Lessthan if the current indexed element of array is less than User input search item
	CMP r6,r0
	BGT Greaterthan  @Jump to Greaterthan if the current indexed element of array is greater than User input search item
	CMP r6,r0
	BEQ Equal	@Jump to Equal if the current indexed element of array is equal to User input search item
	BL Loop1

Lessthan:	
	mov r1,r5	
	add r1,r1,#1	@Make the calculated lower limit Plus one as the current lower limit
	BL Loop1	@Continue the loop

Greaterthan:
	mov r7,r5
	add r7,r7,#-1	@Make the calculated lower limit minus one as the current upper limit
	BL Loop1	@Continue the loop

Equal:
	mov r3,r5
	Add r3,r3,#1	@If it is equal then the searched item is found ,return the index

Return: 		@ Return logic of the subroutine
	POP {LR}	
	PUSH {r3}	 @ Save the return data in the stack
	MOV PC,LR 	@Jump to the saved return address of Search subroutine
.end

	

