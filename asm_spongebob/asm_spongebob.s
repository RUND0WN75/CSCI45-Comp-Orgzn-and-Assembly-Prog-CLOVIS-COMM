//COde here
	.global asm_spongebob      @DM - Don't modify
asm_spongebob:                 @DM - Don't modify

/*
DETERMINE RUNNING TIME WITH THIS COMMAND: a.out < /public/asm_spongebob/inputfile9

void cpp_spongebob(char *str) {
        if (!str) return;
        for (size_t i = 0; str[i]; i++) {
                char c = str[i];
                if (isalpha(c)) {
                        bool coinflip = rand() % 2; AND R0,R0,#7 is mod 8
                        if (coinflip) c = toupper(c);
                        else c = tolower(c);
                }
                str[i] = c;
        }
}

bl rand
bl isupper
bl toupper
bl isalpha
bl tolower

    x = arr[0]
    ldrb r4, [r0, #0] //Reading first byte from a string
*/

//	ldr r5, #0 //Storing the address of a string
//	ldr r4, #0 //Stores the index of a character of the string
	
    PUSH {LR}           @DM: Preserve LR for the calling function
    PUSH {R4-R12}       @DM: This preserves the R4 through R12 from the calling function

	mov r4, r0
	mov r5, #-1 //Storing the index of the first character in a string

top: //Iterating through the string
	add r5, #1
	ldrb r6, [r4, r5] //Loading the character of a string
    mov r0, r6 //Copy into r0
    cmp r0, #0
    beq return 
	mov r0, r6
    bl isalpha //Compare to 0
	cmp r0, #0
	//addeq r5, #1 //Iterate to prevent infinite looping
	beq top //continue;
    bl rand //Do we flip a letter?
    ands r0, r0, #1 //If we do, flip it. Compare to 0
	mov r0, r6
	blgt toupper
	bleq tolower
	mov r6, r0 
    strb r6, [r4, r5]
    //add r5, #1
    bal top
  
return:
    POP {R4-R12}         @DM: Restore R4 through R12 for the calling function
    POP {PC}             @DM: Return from a function
