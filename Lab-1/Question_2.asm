ORG 00H
LJMP main_function

ORG 100H
main_function:

	MOV 70H, #61H
	MOV 71H, #45H
	
	MOV A, 70H
	ANL A, #0F0H
	SWAP A
	ACALL encoder
	MOV 72H, A
	
	MOV A, 70H
	ANL A, #0FH
	ACALL encoder
	MOV 73H, A
	
	MOV A, 71H
	ANL A, #0F0H
	SWAP A
	ACALL encoder
	MOV 74H, A
	
	MOV A, 71H
	ANL A, #0FH
	ACALL encoder
	MOV 75H, A

SJMP main_function

encoder:
	MOV R0, A
	ANL 00H, #01H
	
	RR A
	MOV R1, A
	ANL 01H, #01H
	
	RR A
	MOV R2, A
	ANL 02H, #01H
	
	RR A
	MOV R3, A
	ANL 03H, #01H
	
	RR A
	XRL A, R0
	XRL A, R2
	XRL A, R3
	
	RR A
	XRL A, R0
	XRL A, R1
	XRL A, R3
	
	RR A
	XRL A, R1
	XRL A, R2
	XRL A, R3
	
	RR A
	RR A
	RET

END