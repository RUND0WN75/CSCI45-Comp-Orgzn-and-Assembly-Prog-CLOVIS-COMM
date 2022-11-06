a.out: main.o creativity.o
	g++ -mfpu=neon main.o creativity.o

#student_darken.o: student_darken.s
#	as -mfpu=neon -o student_darken.o student_darken.s

creativity.o: creativity.s
	as -mfpu=neon -o creativity.o creativity.s -g

#Took out the '#' in front of g++ for all lines except line 3
main.o: main.cc
	#g++ -c -Dcimg_display=0 -fexceptions main.cc
	#g++ -O1 -c -Dcimg_display=0 -fexceptions main.cc
	#g++ -O3 -c -Dcimg_display=0 -fexceptions main.cc
	#g++ -mfpu=neon -c -Dcimg_display=0 -Dstudent_darken -fexceptions main.cc
	#g++ -O3 -mfpu=neon -c -Dcimg_display=0 -Dsepia -fexceptions main.cc
	g++ -O3 -mfpu=neon -c -Dcimg_display=0 -Dcreativity -fexceptions main.cc

clean:
	rm -rf *.o a.out output.*
