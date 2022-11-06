#define cimg_display 0
#include "CImg.h"
#include <iostream>
#include <cstdlib>
using namespace cimg_library;
using namespace std;

//This will dump the contents of an image file to the screen
void print_image (unsigned char *in, int width, int height) {
	for (int i = 0; i < width*height*3; i++)
		cout << (unsigned int)in[i] << endl;
}
#ifdef creativity //creativity.s
extern "C" {
	//.global creative in the .s file
	void creative(unsigned char *in,unsigned char *out, int width, int height);
}
#endif
/*
#else 
extern "C" {
	//This function will reduce the brightness of all colors in the image by half, and write the results to out

	// Option 1
	//You will need to implement this loop here in ARM32 assembly 
	
	void darken(unsigned char *in,unsigned char *out, int width, int height) {
		for (int i = 0; i < width*height*3; i++)
			out[i] = in[i] / 2; //Divide red by 2
		return;
	}
*/	

	//Sepia toning
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

	/* Option 2
	void darken(unsigned char *in,unsigned char *out, int width, int height) {
		int stride = width*height;
		for (int i = 0; i < width*height; i++)
			//The first 2D array of width*height pixels is red
			out[i] = in[i] / 2; //Divide red by 2
			//The second 2D array of width*height pixels is green
			out[i+stride] = in[i+stride] / 2; //Divide green by 2
			//The third 2D array of width*height pixels is blue
			out[i+stride+stride] = in[i+stride+stride] / 2; //Divide blue by 2
		return;
	}
	*/
	/*
	//Option 3 - This seg faults
	void darken(unsigned char *in2,unsigned char *out2, int width, int height) {
		//Cast from a pointer to a 1D array to a pointer to a 3D array
		unsigned char*** in = (unsigned char***)in2;
		unsigned char*** out = (unsigned char***)out2;
		for (int color = 0; color < 3; color++) {
			for (int i = 0; i < height; i++) {
				for (int j = 0; i < width; i++) {
					out[color][i][j] = in[color][i][j] / 2;
				}
			}
		}
		return;
	}
}
	*/

void usage() {
	cout << "Error: this program needs to be called with a command line parameter indicating what file to open.\n";
	cout << "For example, a.out kyoto.jpg\n";
	exit(1);
}

int main(int argc, char **argv) {
	if (argc != 2) usage(); //Check command line parameters

	//PHASE 1 - Load the image
	clock_t start_time = clock();
	CImg<unsigned char> image(argv[1]);
	CImg<unsigned char> darkimage(image.width(),image.height(),1,3,0);
	clock_t end_time = clock();
	cerr << "Image load time: " << double(end_time - start_time)/CLOCKS_PER_SEC << " secs\n";

	//PHASE 2 - Do the image processing operation
	start_time = clock();
#ifdef creativity
	start_time = clock();
	creative(image,darkimage,image.width(),image.height());
	end_time = clock();
	cerr << "Student sepia time: " << double(end_time - start_time)/CLOCKS_PER_SEC << " secs\n";
/*
#else
	darken(image,darkimage,image.width(),image.height());
	end_time = clock();
	cerr << "Reference darken time: " << double(end_time - start_time)/CLOCKS_PER_SEC << " secs\n";
*/
#endif
	//end_time = clock();
	//cerr << "Darken time: " << double(end_time - start_time)/CLOCKS_PER_SEC << " secs\n";

	//PHASE 3 - Write the image
	start_time = clock();
	darkimage.save_jpeg("output.jpg",50);
	//darkimage.save_png("output.png");
	end_time = clock();
	cerr << "Image write time: " << double(end_time - start_time)/CLOCKS_PER_SEC << " secs\n";
}
