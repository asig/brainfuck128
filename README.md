# How to run brainfuck

## Interpreter
For the interpreter, just execute `make run`

If you don't know what cool things you could do in Brainfuck, how about trying this? 
`++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.`

## Compiler
There is also a brainfuck compiler that generates native Commodore 128 "prg"s
that can be loaded via `dload`.

To run the compiler, execute `make bfc128.prg`; then `dload "bfc128.prg"` in
VICE and just run it.

The compiler will ask you for the program, as well as the file name of the
prg it should create

### Limitations
The data pointer is 8 bit, so you're limited to 256 bytes of data.

### Memory layout
$1c01 - $1cff: Standard BASIC header and padding
$1d00 - $1dff: 256 bytes of data
$1e00 - ...: Executable code

### Register usage
The X register is used as the data pointer

### Code patterns

### Code generation
`>` | INX                             
`<` | DEX                             
'+'	| INC $1D00,X                     
'-' | DEC $1D00,X                     
'.' | LDA $1D00,x; JSR $FFD2          
',' | JSR $FFCF; STA $1D00,X          
'[' | LDA $1D00,X; BNE +3; JMP XXXX   
']' | LDA $1D00,X; BEQ +3; JMP XXXX   


# Random other bits

## How to start the emulator with "file system drive"
```
x128 \
    -fs8 `pwd` \
    -fs8convertp00 \
    -iecdevice8
```

## Writing to floppy images in x128
It seems that you can only write to disk images in x128 if you set "Use IEC drive" to true.