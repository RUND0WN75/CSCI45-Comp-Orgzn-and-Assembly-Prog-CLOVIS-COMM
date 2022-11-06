.global creative
creative: 
    push {lr}
    push {r4-r12}
    mov r4, #0           //i = 0;
    mov r11, #16
    mul r6, r2, r3       //Stride = Width * Height;

width:
    cmp r4, r2
    bge return
    mov r5, #0           //j = 0

height:
    cmp R5, R3           //j < height
    addge r4, #1         //i++
    bge width            //if j >= height, go to width
    mul r8, r5, r2       // j*width
    add r8, r4           // (j*width) + i
    //Widening (8-bit x 8-bit = 16-bit)
    mov r12, #0          // k < 3

widen:
    ldrb r9, [r0, r8]    //get the data held in the array for RED
    add r7, r6, r8       //(j*width+i) + stride
    ldrb r10, [r0, r7]   //get the data held in the array for GREEN
    add r7, r6           //(j*width+i) + stride
    ldrb r11, [r0, r7]   //get the data held in the array for BLUE
    add r12, #1          //Add 1 to our r or g or b counter
    cmp r12, #2          //jump to green
    beq green
    cmp r12, #3          //jump to blue
    beq blue

red:
    mov r6, #130        //Modified
    mul r9, r6, r9      //multiply the number with RED value
    asr r9, #8          //shift the number to the right 8 times because we multiplied by 256

	//Modified
    mov r6, #230        //same as above but for GREEN

    mul r10, r6, r10
    asr r10, #8

	//Modified
    mov r6, #130         //same as above but for BLUE
    
	mul r11, r6, r11
    asr r11, #8
    mul r6, r2, r3       //We reset the register for Stride. Stride = Width * Height;

    add r7, r9, r10  //RED + GREEN
    add r7, r11  //(RED+GREEN) + BLUE
    B clamp

green:
    //Do the same as RED
    mov r6, #130 //Modified

    mul r9, r6, r9
    asr r9, #8

    mov r6, #90 //Modified

    mul R10, R6, R10
    asr r10, #8

    mov r6, #70 //Modified
    mul r11, r6, r11
    asr r11, #8
    mul r6, r2, r3       //Reset again. Stride = Width * Height;

    add r7, r9, r10  //RED + GREEN
    add r7, r11  //(RED+GREEN) + BLUE
    add r8, r6, r8   //j*width+i   + stride //add stride to the location of the RED pixel for the GREEN plane.
    B clamp

blue:
//SAME
    mov r6, #170 //Modified
    mul r9, r6, r9
    asr r9, #2 

    mov r6, #600 //Modified
    mul r10, r6, r10
    asr r10, #14 

    mov r6, #140 //Modified
    mul r11, r6, r11
    asr r11, #16 
    mul r6, r2, r3       //Stride = Width * Height;

    add r7, r9, r10  //RED + GREEN
    add r7, r7, r11  //(RED+GREEN) + BLUE

    add r8, r6, r8   //j*width+i   + stride
    add r8, r6       //j*width+i   + stride + stride //add stride again for BLUE plane

clamp:
    cmp r7, #255    //clamp RED/GREEN/BLUE
    movgt r7, #255  //if (R/G/B > 255) R/G/B = 255
    B save

save:
    cmp r12, #3 //If we finished all 3 colors we exit
    bgt increment
    strb r7, [r1, r8] //Store red/green/blue to outs

    mul r8, r5, r2       // reset j*width
    add r8, r4           // (j*width) + i

    B widen

increment:
    add r5, #1           //j++
    B height

return:
	pop {r4-r12}
	pop {pc}

