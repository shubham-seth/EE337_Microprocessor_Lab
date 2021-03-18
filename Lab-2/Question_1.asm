ORG 00H
LJMP main
ORG 100H

memcpy:
	MOV R0, 51H ; M1 in R0
	MOV R1, 52H ; M2 in R1
	MOV R2, 50H ; N is in 52H
	
	MOV A, R0 ; M1 location in accumulator
	CLR C ; clear the carry flag before subtraction
	SUBB A, R1 ; M1-M2 in accumulator. If >0 then forward pass, else backward pass
	JC backpass ; If M1-M2<0, then borrow occurs, i.e. carry is set

	forwardpass:
		MOV A, @R0 ; (A)=M1
		MOV @R1, A ; (R1)=M1, (A)=M1
		INC R0
		INC R1
		DJNZ R2, forwardpass
	JMP done;
	
	backpass:
		MOV A, R0
		ADD A, R2
		ADD A, #0FFH
		MOV R0, A ; R0 = M1+N-1
		MOV A, R1
		ADD A, R2
		ADD A, #0FFH 
		MOV R1, A ; R1 = M2+N-1
		loop:
			MOV A, @R0
			MOV @R1, A
			DEC R0
			DEC R1
			DJNZ R2, loop
		
	done: RET
		
main:
	MOV 50H, #0AH
	MOV 51H, #65H
	MOV 52H, #60H
	
	MOV 60H, #5H
	MOV 61H, #6H
	MOV 62H, #7H
	MOV 63H, #8H
	MOV 64H, #9H
	MOV 65H, #0AH
	MOV 66H, #0BH
	MOV 67H, #0CH
	MOV 68H, #0DH
	MOV 69H, #0EH
	MOV 6AH, #0BH
	MOV 6BH, #0CH
	MOV 6CH, #0DH
	MOV 6DH, #0EH
	MOV 6EH, #10H
	MOV 6FH, #11H
		
	LCALL memcpy
	
END