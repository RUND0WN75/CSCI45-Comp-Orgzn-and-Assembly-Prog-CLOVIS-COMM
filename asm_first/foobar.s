//This file has two functions in it, foo and bar
//The other files have one each. 
//Par: 6 strokes

//Foo should be the assembly version of this function:
//int foo(int x) { return 4*x; }
.global foo
foo:
    //Your code here - DONE
	mov r1, #4 //Storing a value of 4 into register 1
	mul r0, r0, r1 //Doing the multiplication and storing the result in register 0
	BX LR //returning the answer

//Bar should be the assembly version of this function:
//int bar(int x, int y) { return xy - pow(y,2); }
.global bar
bar:
    //Your code here - DONE
	MUL R2, R1, R1 //pow(y,2)
	MUL R0, R0, R1 //Multiplying x*y
	SUB R0, R0, R2 //subtraction
	BX LR
