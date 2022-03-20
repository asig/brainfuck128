# How to run brainfuck
```
make run
```

If you don't know what cool things you could do in Brainfuck, how about trying this? 
`++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.`


# How to start the emulator with "file system drive"
```
x128 \
    -fs8 `pwd` \
    -fs8convertp00 \
    -iecdevice8
```

# Random notes
1) It seems that you can only write to disk images in x128 if you set "Use IEC drive" to true.