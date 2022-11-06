	.global asm_if		@DM - Don't modify
asm_if:					@DM - Don't modify
	PUSH {LR}			@DM: Preserve LR for the calling function
	PUSH {R4-R12}		@DM: This preserves the R4 through R12 from the calling function
/*
int asm_if(int a, int b, int c, int d) {
    return ((a | b) && (c | d)) || ((a | ~d) & (~b & d));
}
*/
	//Write yo code here
	MOV R7, R3 //d r3
	MOV R6, R2 //c r2
	MOV R5, R1 //b r1
	MOV R4, R0 //a r0

	// (a | b)
	ORR R4, R4, R5

	// (c | d)
	ORR R6, R6, R7

	//((a | b) && (c | d))
	CMP R6, #0
	MOVGT R6, #1
	CMP R4, #0
	MOVGT R4, #1
	AND R4, R4, R6

	// (a | ~d) ~ = bitwise not
	MVN R9, R7
	ORR R8, R0, R9
		
	// (~b & d)
	MVN R5, R5
	AND R5, R7

	//((a | ~d) & (~b & d))
	AND R5, R5, R8
	CMP r5, #0
	MOVGT R5, #1
	ORR R5, R4, R5
	MOV R0, R5


return:
	POP {R4-R12}         @DM: Restore R4 through R12 for the calling function
	POP {PC}             @DM: Return from a function
