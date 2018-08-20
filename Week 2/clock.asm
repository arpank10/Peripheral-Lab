cpu "8085.tbl"
hof "int8"

org 9000h
GTHEX: EQU 030EH
HXDSP: EQU 034FH
OUTPUT:EQU 0389H
CLEAR: EQU 02BEH
RDKBD: EQU 03BAH

CURDT: EQU 8FF1H
UPDDT: EQU 044CH
CURAD: EQU 8FEFH
UPDAD: EQU 0440H

MVI A,00H
MVI B,00H

; HOURS
LXI H,8840H
MVI M,00H

LXI H,8841H
MVI M,00H

; MINUTES
LXI H,8842H
MVI M,00H

LXI H,8843H
MVI M,00H

LXI H,8840H
CALL OUTPUT

MVI A,00H
MVI B,00H
CALL GTHEX		;Taking input hours and seconds and storing them in HL register pair
MOV H,D
MOV L,E

FIRST:
	MOV A,H 	;Comparing hours with 24
	CPI 24H	
	JC SECOND
	; if Accumulator(Hour) < 24 ==> Valid and jump to SECOND
START:
	MVI H,00H
	JC LOOP
SECOND:
	MOV A,L 	;Comparing minutes with 60 
	CPI 60H
	JC LOOP
	; if Accumulator(mINUTE) < 60 ==> Valid and jump to loop
THIRD:
	MVI L,00H 	
	

LOOP:

HR_MIN:
	SHLD CURAD  ;VALUE OF HL IS STORED IN CURAD(hours and minutes)
	MVI A,00H
NXT_SEC:
	STA CURDT   	 ;Store accumulator value (seconds) in CURDT 
	CALL UPDAD		 ;Update address field of display
	CALL UPDDT		 ;Update data field of display
	CALL DELAY		 ;Delay of 1 second
	LDA CURDT		 ;Increment seconds
	ADI 01H ;ADD ONE TO SECONDS 
	DAA ; BINARY TO BCD VALUE
	CPI 60H
	JNZ NXT_SEC
	LHLD CURAD
	MOV A,L
	ADI 01H			;Increment minutes if seconds is 60
	DAA
	MOV L,A
	CPI 60H
	JNZ HR_MIN
	MVI L,00H
	MOV A,H
	ADI 01H        	;Increment hours if minutes is 60
	DAA
	MOV H,A
	CPI 24H
	JNZ HR_MIN
	LXI H,0000H     ;If time is 23:59:60 change it to 00:00:00
	JMP LOOP
DELAY: 				;This nested loop causes delay of one second
	MVI C,03H
OUTLOOP:
	LXI D,9F00H
INLOOP:
	DCX D ; DECREMENT REG PAIR BY ONE
	MOV A,D
	ORA E ; LOGICAL OR OPERATION WITH FF(VALUE OF REG E)
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET
RST 5