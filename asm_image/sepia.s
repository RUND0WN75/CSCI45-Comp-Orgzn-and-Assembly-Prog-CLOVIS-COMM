#Partners: Walkup and Watson
#Got help from Vaquilar/Green
#define R(i,j) (j*width+i)
#define G(i,j) (stride+j*width+i)
#define B(i,j) (stride+stride+j*width+i)
/*void sepia(unsigned char *in,unsigned char *out, int width, int height) {
    const int stride = width*height;
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            //Widen (8-bit x 8-bit = 16-bit)
            unsigned short r = in[R(i,j)]*0.393 + in[G(i,j)]*0.769 + in[B(i,j)]*0.189;
            unsigned short g = in[R(i,j)]*0.349 + in[G(i,j)]*0.686 + in[B(i,j)]*0.168;
            unsigned short b = in[R(i,j)]*0.272 + in[G(i,j)]*0.534 + in[B(i,j)]*0.131;
            //Saturate (clamp to 255)
            if (r > 255) r = 255;
            if (g > 255) g = 255;
            if (b > 255) b = 255;
            //Narrow (16-bit to 8-bit)
            out[R(i,j)] = r;
            out[G(i,j)] = g;
            out[B(i,j)] = b;
        }
    }
}*/
.global student_sepia
student_sepia: 
    push {lr}
    push {r4-r12}
    MOV R4, #0           //int i = 0;
    MOV R11, #16
    MUL R6, R2, R3       //Stride = Width * Height;

width:
    CMP R4, R2
    BGE return
    MOV R5, #0           //int j = 0

height:
    CMP R5, R3           //j < height
    ADDGE R4, #1         //i++
    BGE width            //if j >= height, goto width
    MUL R8, R5, R2       // j*width
    ADD R8, R4           // (j*width) + i
    //We will Attempt to Widen (8-bit x 8-bit = 16-bit)
    MOV R12, #0          // k < 3 //gimme more registers plees, third counter

widen:
    LDRB R9, [R0, R8]    //get the data held in the array for RED
    ADD R7, R6, R8       //(j*width+i) + stride
    LDRB R10, [R0, R7]   //get the data held in the array for GREEN
    ADD R7, R6           //(j*width+i) + stride
    LDRB R11, [R0, R7]   //get the data held in the array for BLUE
    ADD R12, #1          //Add 1 to our r or g or b counter
    CMP R12, #2          //jump to green
    BEQ green
    CMP R12, #3          //jump to blue
    BEQ blue

red:
    MOV R6, #101        //101 comes from the decimal * 256
    MUL R9, R6, R9      //multiply the number with RED value
    ASR R9, #8          //shift the number to the right 8 times because we multiplied by 256


    MOV R6, #197        //same as above but for GREEN
    MUL R10, R6, R10
    ASR R10, #8
    MOV R6, #48         //same as above but for BLUE
    MUL R11, R6, R11
    ASR R11, #8
    MUL R6, R2, R3       //We reset the register for Stride. Stride = Width * Height;

    ADD R7, R9, R10  //RED + GREEN
    ADD R7, R7, R11  //(RED+GREEN) + BLUE

    B clamp

green:
    //Do the same as RED
    MOV R6, #90
    MUL R9, R6, R9
    ASR R9, #8


    MOV R6, #176
    MUL R10, R6, R10
    ASR R10, #8


    MOV R6, #43
    MUL R11, R6, R11
    ASR R11, #8
    MUL R6, R2, R3       //Reset again. Stride = Width * Height;



    ADD R7, R9, R10  //RED + GREEN
    ADD R7, R7, R11  //(RED+GREEN) + BLUE
    ADD R8, R6, R8   //j*width+i   + stride //add stride to the location of the RED pixel for the GREEN plane.
    B clamp

blue:
//SAME

    MOV R6, #70
    MUL R9, R6, R9
    ASR R9, #8


    MOV R6, #137
    MUL R10, R6, R10
    ASR R10, #8

    MOV R6, #34
    MUL R11, R6, R11
    ASR R11, #8
    MUL R6, R2, R3       //Stride = Width * Height;



    ADD R7, R9, R10  //RED + GREEN
    ADD R7, R7, R11  //(RED+GREEN) + BLUE

    ADD R8, R6, R8   //j*width+i   + stride
    ADD R8, R6       //j*width+i   + stride + stride //add stride again for BLUE plane


clamp:
    CMP R7, #255    //clamp RED/GREEN/BLUE
    MOVGT R7, #255  //if (R/G/B > 255) R/G/B = 255
    B save

save:
    CMP R12, #3 //If we finished all 3 colors we exit
    BGT increment
    STRB R7, [R1, R8] //Store red/green/blue to outs

    MUL R8, R5, R2       // reset j*width
    ADD R8, R4           // (j*width) + i

    B widen

increment:
    ADD R5, #1           //j++
    B height
	
return:
    pop {r4-r12}
    pop {pc}
