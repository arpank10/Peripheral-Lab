cpu "8085.tbl"
hof "int8"


;assignment-3 part B
; group - 3

GTHEX: EQU 030EH
OUTPUT: EQU 0389H
HXDSP: EQU 034FH
RDKBD: EQU 03BAH
CLEAR: EQU 02BEH

CURDT: EQU 8FF1H    ;current data
UPDDT: EQU 044CH    ;update data
CURAD: EQU 8FEFH    ;current address
UPDAD: EQU 0440H    ;update address

org 9000h

MVI A,8BH           ;configuring the control word
OUT 03H


MVI B,00H  ;storing the initial level0 on reg B

MOV A,B
STA 9251H  ;storing the current level of game on memory address 9251H


MVI C,23H  ;storing the first random number 23H on reg C
MOV A,C
STA 9250H  ;storing the random number in address 9250H
MVI A,08H
STA CURDT ; making the initial point as 08 i.e. that is we are starting the game from point 08H
PUSH PSW
CALL UPDDT ;display the points on data section
POP PSW

MAIN:

LDA 9250H  ;load the random number from 9250H on accumulator
MOV C,A
MOV A,C
OUT 00H    ;display the random number on portA

LDA 9251H  ;load the level of game on accumulator
MOV B,A    ;store the level on B reg

MVI H,00H
MOV L,B
SHLD CURAD
PUSH PSW
CALL UPDAD  ;display the level of game on address section
POP PSW

;CALL DELAY0

LDA 9251H  ;load the level on accumulator
CPI 00H    ;compare it with 00H
JZ LEVEL0  ;if level is 0, then jump to LEVEL0
CPI 01H    ;else compare it with 01H
JZ LEVEL1  ;if level is 1,jump to level1
CALL CHECK ; else call CHECK if level is neither 0 nor 1
JMP TEMP2

LEVEL0:
CALL DELAY0  ;
JMP TEMP2

LEVEL1:
CALL DELAY1   ;calling DELAY1

TEMP2:
LDA 9251H  ;load level on accumulator
MOV B,A

MVI H,00H
MOV L,B
SHLD CURAD
PUSH PSW
CALL UPDAD  ;display the updated level on address section of device
POP PSW


;level update
LDA CURDT   ;load point on accumulator
CPI 12H     ;compare it with 12H
JZ UPDATE2  ;if point is equal to 12, jump to UPDATE2
LDA CURDT
CPI 10H     ;else compare the pointto 10H
JZ UPDATE1  ;if point is equal to 10H, jump to UPDATE1
JMP MAIN1   ;if point is neither 10 nor 12, jump to MAIN1

UPDATE1:
MVI B,01H
MOV A,B
STA 9251H   ;update the level to 1 and store it to 9251H
JMP DISPLAYLEVEL  ;jump to DISPLAYLEVEL

UPDATE2:
MVI B,02H
MOV A,B
STA 9251H ;make the level of game as 2 and store it to address 9251H

;update and display the level on address section of device
DISPLAYLEVEL:
LDA 9251H

MVI H,00H
MOV L,A
SHLD CURAD
PUSH PSW
CALL UPDAD
POP PSW

MAIN1:


LDA 9250H  ;load accumulator with current random number
MOV C,A

MOV A,C
RAL        ;rotating by one bit
XRA C      ;taking XOR for generating next random number
MOV C,A
MOV A,C
STA 9250H  ;store the next random number in 9250H address


JMP MAIN   ; jump to MAIN


DELAY0:

;time delay by traversing the loop based on clock frequency of 8085 device
MVI H,32H
JMP OUTLOOP
DELAY1:

MVI H,24H
OUTLOOP:
	LXI D,9F00H
INLOOP:
	DCX D ; DECREMENT REG PAIR BY ONE
	MOV A,D
	ORA E ; LOGICAL OR OPERATION WITH FF(VALUE OF REG E)
	JNZ INLOOP
	DCR H
	JNZ OUTLOOP

	LDA 9250H		;load the random number on accumulator
	MOV C,A     ;move it to reg C
	IN 01H      ;take the input from portB
	CMP C       ;comparing input with random number
	JZ RESTORE1 ;if a match, jump to RESTORE1

	;restore2
	LDA CURDT
	CALL DEC    ;call dec if its not a match
	STA CURDT
	PUSH PSW
	CALL UPDDT  ;display the update point on data section
	POP PSW
	LDA CURDT   ;load point on accumulator
	CPI 00H     ;compare the point with 00H
	JNZ SS      ;jump to SS if not equal
	RST 5       ;hault if the point is 0(terminating case)

	;generate and store the next random number in 9250H
	SS:

	LDA 9250H
	MOV C,A

	MOV A,C
	RAL
	XRA C
	MOV C,A
	MOV A,C
	STA 9250H

	RET


	RESTORE1:
	LDA CURDT   ;load the point on accumulator
	ADI 01H     ;add one point to curent point, because its a match
	DAA
	STA CURDT
	PUSH PSW
	CALL UPDDT  ;display the incremented point on data section of device
	POP PSW

	LDA 9250H
	MOV C,A

	;for generating next random number and storing it to 9250H
	MOV A,C
	RAL
	XRA C    ;taking the XOR of current random number and the number generated by shifting current number by one place
	MOV C,A
	MOV A,C
	STA 9250H ;storing the new random number in 9250H address

	RET

CHECK:

; delay for the level2 by traversing the loop based on clock frequency of device
MVI H,40H
LOOPOUT2:
	LXI D,9F00H
LOOPIN2:
	DCX D ; DECREMENT REG PAIR BY ONE
	MOV A,D
	ORA E ; LOGICAL OR OPERATION WITH FF(VALUE OF REG E)
	JNZ LOOPIN2
	DCR H
	JNZ LOOPOUT2

	LDA 9250H
	MOV C,A
	IN 01H    ; take the input of portB
	CMA       ;complimenting the value of accumulator
	CMP C     ;compare if its a match or not
	JZ RES    ; jump to RES if its a match

	;restore2
	LDA CURDT
	CALL DEC  ;decrementing the point because its not a match
	STA CURDT
	PUSH PSW
	CALL UPDDT  ;update and display the point on data section of device
	POP PSW
	LDA CURDT
	CPI 00H     ; compare the point with 0
	JNZ ABC     ;if point is not 0, jump to ABC
	RST 5       ;else if point is 0, hault the game
	ABC:

  ;generate and store the next random number in address 9250H
	LDA 9250H
	MOV C,A

	MOV A,C
	RAL
	XRA C
	MOV C,A
	MOV A,C
	STA 9250H

	RET


	RES:
	LDA CURDT
	ADI 01H   ;add one point because its a match
	DAA
	STA CURDT
	PUSH PSW
	CALL UPDDT  ;update and display the point on data section of device
	POP PSW


	;generate and store the next random number on address 9250H
	LDA 9250H
	MOV C,A

	MOV A,C
	RAL
	XRA C
	MOV C,A
	MOV A,C
	STA 9250H

	RET

	;decrementing the value
	DEC:
	STA 8004H
	ANI 0FH
	CPI 00H
	JNZ LOOP8
	LDA 8004H
	SBI 07H
	RET
	LOOP8:
	 LDA 8004H
	 SBI 01H
	 RET
