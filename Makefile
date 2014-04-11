all: clean
	gcc -O2 -Os -Wall -c uuencode-simple.c -o uuencode-simple.o
	g++ uuencode-simple.o -o uuencode-simple -s

clean:
	rm -f uuencode-simple uuencode-simple.o
	test/test.sh clean >/dev/null

check: all
	test/test.sh

install: all
	install -m755 embed-ass /usr/bin
	install -m755 uuencode-simple /usr/bin

install-local: all
	mkdir -p /usr/local/bin
	install -m755 embed-ass /usr/local/bin
	install -m755 uuencode-simple /usr/local/bin
