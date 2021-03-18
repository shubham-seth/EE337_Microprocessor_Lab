org 000H
ljmp start

org 100H
start:
	MOV 60H, #0H
	MOV 61H, #2H
	MOV A, 60H
	ADD A, 61H
	MOV 62H, A
	
	CLR PSW.5
	MOV C, PSW.2
	CPL C
	MOV PSW.5, C
end