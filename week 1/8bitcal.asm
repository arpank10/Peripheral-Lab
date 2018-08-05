cpu "8085.tbl"
hof "int8"
org 9000h

LDA 8202H
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
MVI C, 00H      
LDA 8200H      
MOV B, A        
LDA 8201H       
ADD B           
JNC LOOPSUM        
INR C           
LOOPSUM:  
STA 8203H       
MOV A, C        
STA 8204H       
RST 5  


; substraction

DIFF:
MVI C, 00H      
LDA 8201H      
MOV B, A        
LDA 8200H
SUB B           
JP LOOPDIFF
CMA
INR A        
INR C           
LOOPDIFF:  
STA 8203H       
MOV A, C        
STA 8204H    
RST 5   

; multiplication

MULT:
MVI D, 00H
LDA 8200H
MOV B, A
LDA 8201H
MOV C, A
MVI A, 00H
LOOPMULT: 
ADD B
JNC NEXTMULT
INR D
NEXTMULT:
DCR C
JNZ LOOPMULT
STA 8203H
MOV A,D
STA 8204H
RST 5

; division


DIV:
MVI A,00H
STA 8203H
STA 8204H
LDA 8201H
CPI 00H
JZ END
MOV B, A
MVI C, 00H
LDA 8200H
NEXTDIV:
CMP B
JC LOOPDIV
SUB B
INR C
JMP NEXTDIV
LOOPDIV:
STA 8204H
MOV A,C
STA 8203H 
END:
RST 5


