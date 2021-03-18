ORG 00H
LJMP main
ORG 100H
	
main:
	here:
		ACALL read_nibble		
	LJMP here
	
read_nibble:
	MOV P1, #0FH
	SETB P1.4
	SETB P1.5
	SETB P1.6
	SETB P1.7
	ACALL delay
	MOV A, P1
	ANL A, #0FH
	MOV 4EH, A
	RL A
	RL A
	RL A
	RL A
	MOV P1, A
	ACALL delay
	RET

delay:
	MOV R3, #50
	LOOP_5s:
		MOV R2, #100
		LOOP_100ms: ;100ms delay causing loop
			MOV R0, #182
			LOOP_1ms: ;1ms delay causing loop
				MOV R1, #4
				LOOP_in:
				DJNZ R1, LOOP_in
			DJNZ R0, LOOP_1ms
		DJNZ R2, LOOP_100ms
	DJNZ R3, LOOP_5s
	RET
	
END