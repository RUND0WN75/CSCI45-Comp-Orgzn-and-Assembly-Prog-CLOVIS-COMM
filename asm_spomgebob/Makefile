a.out: main.o asm_spongebob.o
	g++ -O3 main.o asm_spongebob.o

asm_spongebob.o: asm_spongebob.s
	g++ -c -o asm_spongebob.o asm_spongebob.s

main.o: main.cc
	g++ -O3 -c main.cc

clean:
	rm -f a.out core *.o
