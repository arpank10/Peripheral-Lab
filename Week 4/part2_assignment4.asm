
cpu "8085.tbl"
hof "int8"


org 9000h

MVI A,8BH             ;Configuring Port A as output of J2,others input
OUT 43H               ;Configuring all ports as output in J1


MVI A,80H
OUT 03H


MVI A,88H 		;POSITION OF MOTOR'S ROTATOR , VARIES IN 88 44 22 00
STA 9300H
MVI A,10H     ;POSITION OF MOTOR'S ACTUAL IN HEX
STA 9301H
LOOP:

;CALL DISPLAY
CALL FUNC
CALL DELAY
JMP LOOP

FUNC:

LDA 9301H				; ACTUAL POSITION
MOV B,A         ; store the actual motor position in reg B
MVI D,02H
CALL CONVERT 			; TO GO TO
CMP B             ;compare the input voltage value after conversion with the actual position of motor

JC LESSFUNC						; TO GO TO IS LESS THAN ACTUAL POS

JZ ENDFUNC             ; go to endfunc if both values are equal

MOREFUNC:						; TO GO TO IS MORE THAT ACTUAL POS
LDA 9301H
CPI 0F0H            ; compare the actual motor position with the highest value
JC MOREFUNCL1       ;if value is less, then go to MOREFUNCL1
JZ MOREFUNCL2
JMP MOREFUNCL2      ;jump to MOREFUNCL2 if value  is not less than 0F0H
MOREFUNCL1:
LDA 9300H
RRC                 ;Each binary bit of the accumulator is rotated right by one position
OUT 00H
STA 9300H
CALL DELAY          ;call delay
LDA 9300H
RRC
OUT 00H
STA 9300H
LDA 9301H
ADI 05H            ;incrementing the value by 05H
MOREFUNCL2:STA 9301H
JMP ENDFUNC

LESSFUNC:
LDA 9301H
CPI 05H             ; compare the actual motor position with the lowest value
JC LESSFUNCL2       ;if actual value is more than 05H , then go to LESSFUNCL1
JZ LESSFUNCL2
JMP LESSFUNCL1      ;if actual value is less than or equal to 05H , then go to LESSFUNCL2
LESSFUNCL1:
LDA 9300H
RLC                 ;Each binary bit of the accumulator is rotated left by one position
OUT 00H
STA 9300H
CALL DELAY
LDA 9300H
RLC
OUT 00H
STA 9300H
LDA 9301H
SBI 05H             ;decrementing the value by 05H
LESSFUNCL2:STA 9301H
ENDFUNC:
RET


; delay function
DELAY:
MVI C, 20H
LOOP4a:   MVI D, 16H
LOOP1a:  MVI E, 0DEH
LOOP2a:  DCR E
	    JNZ LOOP2a
	    DCR D
	    JNZ LOOP1a
	    DCR C
	    JNZ LOOP4a

RET


CONVERT:
	MVI A,00H
	ORA D
	OUT 40H

	                ; START SIGNAL
	MVI A,20H
	ORA D
	OUT 40H

	NOP
	NOP

                 	; START PULSE OVER
	MVI A,00H
	ORA D
	OUT 40H

                  ; EOC = PC0
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
		call DELAY
		PUSH PSW

		MOV A,E
		STA 8FEFH
		XRA A
		STA 8FF0H
		POP PSW
		STA 8FF1H
		PUSH D
		MVI B,00H
		CALL 0440H
		MVI B,00H
		CALL 0440H
		MVI B,00
		CALL 044CH
		POP D
		RET
