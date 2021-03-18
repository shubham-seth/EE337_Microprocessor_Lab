ORG 00H
LJMP main
ORG 300H
	
main:
	MOV TH0, #0FFH
	MOV TL0, #0F8H
	MOV TMOD, #01H
	CLR TCON.5
	SETB TCON.4
	here: 
		JBC TCON.5, to_end
	SJMP here
	to_end: CLR TCON.4
	stopper: SJMP stopper
END