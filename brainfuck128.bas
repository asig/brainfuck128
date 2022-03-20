   10 dim d%(1000)
   20 ip%=1
   30 dp%=0
   40 print chr$(14);:rem switch to lower case
   50 if rgr(0)=5 then fast
   60 print "Brainfuck for the Commodore 128"
   70 print "(c) 2022 Andreas Signer <asigner@gmail.com>"
   80 print "Please enter your program:"
   90 input p$
  100 if ip%>=len(p$) then print:print "Program terminated":end
  105 c$=mid$(p$,ip%,1)
  110 ip%=ip%+1
  120 if c$=">" then dp%=dp%+1:goto100
  130 if c$="<" then dp%=dp%-1:goto100
  140 if c$="+" then d%(dp%)=d%(dp%)+1:goto100
  150 if c$="-" then d%(dp%)=d%(dp%)-1:goto100
  160 if c$="." then print chr$(d%(dp%));:goto100
  170 if c$="," then gosub 1000:goto100
  180 if c$="[" then gosub 2000:goto 100
  190 if c$="]" then gosub 3000:goto 100
  200 goto 100:rem ignoring invalid instructions to allow for readability
 1000 rem wait for input
 1010 get i$
 1020 if i$="" then goto 1010
 1030 d%(dp%)=asc(i$)
 1040 return
 2000 rem skip forward
 2010 if d%(dp%)<>0 then return
 2020 n%=1
 2030 c$=mid$(p$,ip%,1)
 2040 ip%=ip%+1
 2050 if c$="]" then n%=n%-1
 2060 if c$="[" then n%=n%+1
 2070 if n%=0 then return
 2080 goto 2030
 3000 rem skip backward
 3010 if d%(dp%)=0 then return
 3020 n%=1:ip%=ip%-1
 3030 ip%=ip%-1
 3040 c$=mid$(p$,ip%,1)
 3050 if c$="]" then n%=n%+1
 3060 if c$="[" then n%=n%-1
 3070 if n%=0 then ip%=ip%+1:return
 3080 goto 3030
