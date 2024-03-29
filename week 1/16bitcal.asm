cpu "8085.tbl"
hof "int8"
org 9000h

LDA 8000H   ;input mode 
CPI 00H
JZ SUM

CPI 01H
JZ DIFF

CPI 02H
JZ MULT

CPI 03H
JZ DIV



; addition

SUM:
MVI A, 00H
STA 8204H
STA 8205H
STA 8206H
STA 8207H
MVI C, 00H
LHLD 8200H
XCHG
LHLD 8202H
DAD D
JNC AHEAD
INR C
AHEAD:
SHLD 8204H
MOV A, C
STA 8206H
MVI A, 00H
STA 8000H
RST 5



;subtraction

DIFF:
MVI A, 00H
STA 8204H
STA 8205H
STA 8206H
STA 8207H
MVI C,00H
MVI B,00H
LHLD 8200H
XCHG
LHLD 8202H
MOV A,E
SUB L
JNC SKIPSUB
INR C
SKIPSUB: 
MOV E,A
MOV A,D
SUB C
JNC SKIP3SUB
INR B
SKIP3SUB:
SUB H
JNC SKIP2SUB
INR B
SKIP2SUB:
MOV D,A
XCHG
SHLD 8204H
MOV A,B
STA 8206H
MVI A, 00H
STA 8000H
RST 5

;multiplication

MULT:
MVI A, 00H
STA 8204H
STA 8205H
STA 8206H
STA 8207H
LHLD 8200H
SPHL
LHLD 8202H
XCHG
LXI H,0000H
LXI B,0000H
NEXTMULT: 
DAD SP
JNC LOOPMULT
INX B
LOOPMULT: 
DCX D
MOV A,E
ORA D
JNZ NEXTMULT
SHLD 8204H ;LSB
MOV L,C
MOV H,B
SHLD 8206H ;MSB
MVI A, 00H
STA 8000H
RST 5


;division

DIV:
MVI A, 00H
STA 8204H
STA 8205H
STA 8206H
STA 8207H
LXI B,0000H ;quotient
LHLD 8200H ;DE HOLDS DIVISOR
XCHG
LHLD 8202H
LOOP2DIV:
MOV A,L
SUB E
MOV L,A
MOV A,H
SBB D
MOV H,A
JC LOOP1DIV
INX B
JMP LOOP2DIV
LOOP1DIV: 
DAD D
SHLD 8206H
MOV L,C
MOV H,B
SHLD 8204H  
MVI A, 00H
STA 8000H
RST 5


