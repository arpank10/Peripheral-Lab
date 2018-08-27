cpu "8085.tbl"
hof "int8"


;assignment-3 part A
; group - 3

GTHEX: EQU 030EH
OUTPUT: EQU 0389H
HXDSP: EQU 034FH
RDKBD: EQU 03BAH
CLEAR: EQU 02BEH

org 9000h

MVI A,83H  ;configuring control word
OUT 03H

BEGIN:
	CALL TERMINATECHECK  ;checking haulting condition(status of D2)
	IN 01H							 ;making portB as input
	CMA									 ;complimenting the accumulator's value
	ANI 40H							 ;checking D6 status
	CPI 40H
	JZ CONT							 ;if D6 is low, jump to "CONT"
	JMP BEGIN            ;else check again for D6
	RST 5

CONT:
	MVI A,01H						 ;make accumulator's value 01H
	OUT 00H							 ;show the accumulator's value of 01H on portA
	CALL DELAY           ;delay of time
	MVI A,02H
	OUT 00H
	CALL DELAY
	MVI A,04H
	OUT 00H
	CALL DELAY
	MVI A,08H
	OUT 00H
	CALL DELAY
	MVI A,10H            ;make accumulator's value 10H
	OUT 00H              ;show the accumulator's value of 10H on portA
	CALL DELAY           ;delay of time
	MVI A,20H
	OUT 00H
	CALL DELAY
	MVI A,40H
	OUT 00H
	CALL DELAY
	MVI A,80H
	OUT 00H
	CALL DELAY
	JMP CONT            ;go on loop again

;checking for haulting case
TERMINATECHECK:
 	IN 01H
	CMA                 ;complimenting the accumulator's value because we have to check the low condition
	ANI 04H
	CPI 04H             ;check the status of D2
	JZ TERMINATE        ;if D2 is low, terminate the program
	RET


; delay of time
DELAY:

CALL HOLDCHECK		      ;checking the holding case
CALL TERMINATECHECK     ;checking the terminating case
LOOP4:   MVI D, 04H     ;if neither holding case nor terminating case, traverse the loop for delay
LOOP1:  MVI E, 0DEH
LOOP2:  DCR E
	    JNZ LOOP2
	    DCR D
	    JNZ LOOP1
	    DCR C
	    JNZ LOOP4
	    RET

TERMINATE:
	MVI A, 00H     ;make accumulator 00H
	OUT 00H        ;display 00 on portA
	RST 5          ;hault


;checking the holding condition
HOLDCHECK:

BEG:
	CALL TERMINATECHECK      ;checking the terminate condition
	MVI A,00H                ;make accumulator 00H
	IN 01H                   ;making portB as input
	CMA                      ;complimenting the accumulator
	ANI 20H                  ;checking the status of D2
	CPI 20H
	JZ BEG                   ;if D2 is low, go back to starting of BEG for holding it
	CMA
	ANI 40H                  ;if D2 is not low, check the status of D6
	CPI 40H
	JNZ BEG									 ;if D6 is not low, jump to BEG again , because its a holding case, otherwise return
	RET
