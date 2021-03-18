ORG 00H
LJMP main
ORG 300H
	
main:
	MOV P1, #00H
	MOV P1, #0F0H
	acall delay_1s
	MOV P1, #00H
	acall delay_1s
LJMP main
	
delay_1s:
	MOV R0, #50H
	LOOP:
		acall delay_min
		DJNZ R0, LOOP
	RET

delay_min:
	MOV TH0, #9EH
	MOV TL0, #68H
	MOV TMOD, #01H
	CLR TCON.5
	SETB TCON.4
	here: 
		JBC TCON.5, to_end
	SJMP here
	to_end: 
		CLR TCON.4
	RET
	
END