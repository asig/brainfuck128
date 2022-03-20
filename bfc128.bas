   10 print chr$(14);:rem switch to lower case
   20 if rgr(0)=5 then fast
   30 print "Brainfuck Compiler for the Commodore 128"
   40 print "(c) 2022 Andreas Signer <asigner@gmail.com>"
   50 print "Please enter your program";
   60 input p$
   70 print "Destination filename";
   80 input fi$
   90 dim bs%(32):rem stack with starting addresses of blocks
  100 sp%=0
  110 dim c%(4096): rem code array
  120 pc%=0
  125 e$="": rem error message
  130 rem initialize code array with code to clean data block
  140 read a$
  150 if a$<>"xx" then c%(pc%)=dec(a$):pc%=pc%+1:goto 140
  160 ip%=1
  200 if e$<>"" then goto 500:
  210 if ip%>len(p$) then goto 320
  220 c$=mid$(p$,ip%,1):ip%=ip%+1
  230 if c$=">" then gosub 1000:goto 200
  240 if c$="<" then gosub 2000:goto 200
  250 if c$="+" then gosub 3000:goto 200
  260 if c$="-" then gosub 4000:goto 200
  270 if c$="." then gosub 5000:goto 200
  280 if c$="," then gosub 6000:goto 200
  290 if c$="[" then gosub 7000:goto 200
  300 if c$="]" then gosub 8000:goto 200
  310 goto 200
  320 if sp% <> 0 then e$="Unterminated blocks":goto 500
  330 c%(pc%)=96:pc%=pc%+1:rem rts
  340 print "Program size is"pc%
  350 print "Saving code to "fi$"...";
  360 gosub 10000:rem write file
  370 print:print "Done."
  380 print "To try it out, run"
  390 print "run "chr$(34)fi$chr$(34)
  400 end
  500 print "Error: "e$". No code generated"
  510 end
 1000 rem ">" --> inx
 1010 c%(pc%)=232:pc%=pc%+1
 1020 return
 2000 rem "<" --> dex
 2010 c%(pc%)=202:pc%=pc%+1
 2020 return
 3000 rem "+" --> inc $1d00,x
 3010 c%(pc%)=254:pc%=pc%+1
 3020 c%(pc%)=0:pc%=pc%+1
 3030 c%(pc%)=29:pc%=pc%+1
 3040 return
 4000 rem "-" --> dec $1d00,x
 4010 c%(pc%)=222:pc%=pc%+1
 4020 c%(pc%)=0:pc%=pc%+1
 4030 c%(pc%)=29:pc%=pc%+1
 4040 return
 5000 rem "." --> lda $1d00,x; jsr $ffd2
 5010 c%(pc%)=189:pc%=pc%+1
 5020 c%(pc%)=0:pc%=pc%+1
 5030 c%(pc%)=29:pc%=pc%+1
 5040 c%(pc%)=32:pc%=pc%+1
 5050 c%(pc%)=210:pc%=pc%+1
 5060 c%(pc%)=255:pc%=pc%+1
 5070 return
 6000 rem "." --> jsr $ffcf; sta $1d00,x
 6010 c%(pc%)=32:pc%=pc%+1
 6020 c%(pc%)=207:pc%=pc%+1
 6030 c%(pc%)=255:pc%=pc%+1
 6040 c%(pc%)=157:pc%=pc%+1
 6050 c%(pc%)=0:pc%=pc%+1
 6060 c%(pc%)=29:pc%=pc%+1
 6070 return
 7000 rem "[" --> lda $1d00,x; bne +3; jmp xxxx 
 7010 bs%(sp%)=pc%
 7020 sp%=sp%+1
 7030 c%(pc%)=189:pc%=pc%+1
 7040 c%(pc%)=0:pc%=pc%+1
 7050 c%(pc%)=29:pc%=pc%+1
 7060 c%(pc%)=208:pc%=pc%+1
 7070 c%(pc%)=3:pc%=pc%+1
 7080 c%(pc%)=76:pc%=pc%+1
 7090 pc%=pc%+2:rem jump address will be patched later
 7100 return
 8000 rem "]" --> lda $1d00,x; beq +3; jmp xxxx
 8010 if sp%=0 then e$="No open block":return
 8020 sp%=sp%-1
 8025 p%=bs%(sp%)+6: rem address of jmp to patch
 8030 d%=bs%(sp%)+7680+8: rem address of command after matching "["
 8035 j%=pc%+7680+8: rem address of command after "]"
 8030 c%(pc%)=189:pc%=pc%+1
 8040 c%(pc%)=0:pc%=pc%+1
 8050 c%(pc%)=29:pc%=pc%+1
 8060 c%(pc%)=240:pc%=pc%+1
 8070 c%(pc%)=3:pc%=pc%+1
 8080 c%(pc%)=76:pc%=pc%+1
 8090 c%(pc%)=d%-int(d%/256)*256:pc%=pc%+1
 8100 c%(pc%)=d%/256:pc%=pc%+1
 8100 c%(p%+0)=j%-int(j%/256)*256
 8110 c%(p%+1)=int(j%/256)
 8100 return
 10000 rem save code to prg
 10010 rem dopen seems to always create seq files with vars, so go old-school
 10020 open 1,8,1,fi$+",p,w"
 10030 if ds <> 0 then e$="Can't open file: "+ds$:close1:return
 10030 print#1, chr$(1);chr$(28);:rem start address
 10040 rem write basic header (14 bytes)
 10040 print#1,chr$(12)chr$(28)chr$(1)chr$(0)chr$(158)chr$(32)chr$(55)chr$(54)chr$(56)chr$(48)chr$(0)chr$(0)chr$(0)chr$(0);
 10070 rem fill with 0 until $1d00 (254-14 bytes)
 10080 fori=14to254:print#1,chr$(0);:next
 10090 rem write data block ($1d00 - $1dff)
 10100 fori=0to255:print#1,chr$(0);:next
 10110 rem write code
 10120 for i=0topc%
 10130 print#1,chr$(c%(i));
 10140 next
 10150 close 1
 10160 return
 20000 rem code to initialize data block
 20010 data a2,00    : rem ldx #$00
 20010 data a9,00    : rem lda #$00
 20020 data 9d,00,1d : rem sta 1d00,x
 20030 data e8       : rem inx
 20040 data d0,fa    : rem bne 1e04
 20050 data xx
