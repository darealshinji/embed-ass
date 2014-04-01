all:
	gcc -O2 -Os -Wall -c uuencode-simple.c -o uuencode-simple.o
	g++ uuencode-simple.o -o uuencode-simple -s
clean:
	rm -f uuencode-simple uuencode-simple.o
