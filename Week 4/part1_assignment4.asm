
cpu "8085.tbl"
hof "int8"


org 9000h
CURDT: EQU 8FF1H     ;current data
UPDDT: EQU 044cH     ;update data
CURAD: EQU 8FEFH     ;current address
UPDAD: EQU 0440H     ;update address

MVI A,8BH
OUT 43H

MVI A,02H
STA 8100H

MVI A,80H					;All ports are configured as output
OUT 03H

MVI A,88H
				;initial bit pattern
LOOP:
PUSH PSW

OUT 00H						;Port A (PA0-PA3) used to control the stepper motor
MVI D,02H					;Channel number 02
MVI E,02H
CALL CONVERT			;Convert A to D
MOV B,A           ;store the converted voltage to reg B
STA 9251H
MVI A,0FFH
SUB B             ;store (FF - converted voltage) to accumulator
STA 9250H
MOV C,A
CALL DELAY
CALL DISPLAY
POP PSW
RRC               ;Each binary bit of the accumulator is rotated right by one position
JMP LOOP


DELAY:
	LDA 9250H
	MOV C,A
	LOOP4a:  MOV D,A      ;so more the voltage, less the value in accumulator, so less the delay and hence more the speed.
	LOOP1a:  MVI E,12H
	LOOP2a:  DCR E
	    JNZ LOOP2a
	    DCR D
	    JNZ LOOP1a
	    DCR C
	    JNZ LOOP4a

RET


; converting analog to digital
CONVERT:
	MVI A,00H
	ORA D
	OUT 40H

	; START SIGNAL
	MVI A,20H
	ORA D
	OUT 40H

	NOP       ;No-operation for delay
	NOP

	; START PULSE OVER
	MVI A,00H
	ORA D
	OUT 40H

; EOC = PC0                     ;EOC for End of conversion
; CHECK FOR EOC PULSE
WAIT1:
	IN 42H
	ANI 01H
	JNZ WAIT1
WAIT2:
	IN 42H
	ANI 01H
	JZ WAIT2

; READ SIGNAL
	MVI A,40H
	ORA D
	OUT 40H
	NOP

	; GET THE CONVERTED DATA FROM PORT B
	IN 41H

	; SAVE A SO THAT WE CAN DEASSERT THE SIGNAL
	PUSH PSW

	; DEASSERT READ SIGNAL
	MVI A,00H
	ORA D
	OUT 40H
	POP PSW

RET

DISPLAY:
		;call DELAY
		PUSH PSW


DISPKBD:
		LDA 8100H
		STA 8FF0H
		XRA A
		STA CURAD
		POP PSW
		LDA 9251H
		STA CURDT
		PUSH D
		MVI B,00H
		CALL UPDAD
		MVI B,00H
		CALL UPDAD
		MVI B,00
		CALL UPDDT
		POP D
		RET
