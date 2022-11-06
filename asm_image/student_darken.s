//Partners:  Walkup and Watson
#Write your image darkening code here in assembly
.global sdarken
sdarken:
/*
void darken(unsigned char *in,unsigned char *out, int width, int height) {
		for (int i = 0; i < width*height*3; i++)
			out[i] = in[i] / 2; //Divide red by 2
		return;
}
*/
	//push {lr}
	//push {r4-r12}
	/*
	r0 = in
	r1 = out
	r2 = width
	r3 = height
	*/
	//i < width*height*3;
	mov r5, r0 //in
	mov r6, r1 //out
	mov r7, r2 //width
	mov r8, r3 //height
	mul r3, r2, r3 //width*height
	mov r4, #3
	mul r2, r3, r4 //height*3
	mov r4, #0
top:
	cmp r4, r2
	bge return
	//out[i] = in[i] / 2; //Divide red by 2
	ldrb r9, [r5, r4] //in[i]
	//ldrb r10, [r1, r6] //out[i]
	//mov r11, #4 //ints are 4 bits
	//lsl r9, #2 //ints are 4 bits
	lsr r9, #1
	strb r9, [r6, r4]
	//strb r10, [r1, r6]
	add r4, #1
	bal top

return:
	mov r1, r6
	//push {r4-r12}
	//push {pc}
	//MOV PC,LR 
