//Write the assembly equivalent of this C++ code:
//int baz(int x, int y, int z) { return 5*x + 5*x*y + 5*x*y*z; }
//Par: 11 strokes

.global baz
baz:
	//Your code here
	//OLD CODE
	/*
	mov r4, #5 //x = 5
	mul r0, r0, r1 //5*x
	mul r0, r0, r2 //5*x*y
	mul r0, r0, r3 //5*x*y*z
	mla r0, r4, r5, r6
	*/

	//NEW ATTEMPT
	
	/*mov r4, #1
	mov r3, #5
	add r2, r2, r4
	mul r0, r0, r3
	mla r1, r1, r2, r4
	mul r0, r0, r1
	bx lr*/
	
 	ADD R4, R0, R0, LSL #2
    MUL R5, R4, R1
    MUL R6, R5, R2
    ADD R7, R5, R6
    ADD R0, R4, R7
    BX LR
