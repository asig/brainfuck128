.PHONY: clean


all: brainfuck128.prg bfc128.prg
clean:
	rm *.prg *.o

%.prg:	%.bas
	petcat -w70 -o $@ -- $<

run: brainfuck128.prg
	x128 -80 $<
