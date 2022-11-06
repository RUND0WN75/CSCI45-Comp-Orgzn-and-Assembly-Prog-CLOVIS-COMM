//Write the C++ equivalent of this code:
//int quz(int x, int y, int z, int w) { return (x-y)*(z+w) - (x-y)*(-1*z + -1*w); }
//Par: 7 strokes

.global quz
quz:
	//Your code here - DONE
	mov r4, #2
	add r2, r2, r3
	sub r0, r0, r1
	mul r0, r0, r4
	mul r0, r0, r2
	bx lr
