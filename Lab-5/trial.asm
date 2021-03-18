ORG 00H
LJMP main
ORG 300H

main:
	MOV R0, #50H
	LOOP:
		acall delay
		DJNZ R0, LOOP
	LJMP final

delay:
	MOV TH0, #9EH
	MOV TL0, #68H
	MOV TMOD, #01H
	CLR TCON.5
	SETB TCON.4
	here: 
		JBC TCON.5, to_end
	SJMP here
	to_end: CLR TCON.4
	RET

final:
END