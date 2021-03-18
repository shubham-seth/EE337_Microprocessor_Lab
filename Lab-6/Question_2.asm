ORG 00H
LJMP main
ORG 300H
	
main:
	CLR P0.0 ;setting as output pin
	MOV TMOD, #11H
	MOV R0, #0A0H
	LOOP_SA:
		MOV TH1, #9EH
		MOV TL1, #68H
		CLR TCON.7
		SETB TCON.6
		sa_wave_generator:
			ACALL Sa_square_wave
			JNB TCON.7, sa_wave_generator
		DJNZ R0, LOOP_SA
	
	MOV R0, #88H
	LOOP_RE:
		MOV TH1, #9EH
		MOV TL1, #68H
		CLR TCON.7
		SETB TCON.6
		re_wave_generator:
			ACALL Re_square_wave
			JNB TCON.7, re_wave_generator
		DJNZ R0, LOOP_RE
		
LJMP main
		
Sa_square_wave:
	high_pulse:
		MOV TH0, #0EFH
		MOV TL0, #0B6H
		CLR TCON.5
		SETB TCON.4
		SETB P0.0
		checker_high: jb TCON.5, low_pulse ;Checks if enough time has elapsed
		sjmp checker_high
	low_pulse:
		MOV TH0, #0EFH
		MOV TL0, #0B6H
		CLR TCON.5
		SETB TCON.4
		CLR P0.0
		checker_low: jb TCON.5, out_sa ;Checks if enough time has elapsed
		sjmp checker_low
	out_sa:
		RET
	
Re_square_wave:
	high_pulse_re:
		MOV TH0, #0F1H
		MOV TL0, #7FH
		CLR TCON.5
		SETB TCON.4
		SETB P0.0
		checker_high_re: jb TCON.5, low_pulse_re ;Checks if enough time has elapsed
		sjmp checker_high_re
	low_pulse_re:
		MOV TH0, #0F1H
		MOV TL0, #7FH
		CLR TCON.5
		SETB TCON.4
		CLR P0.0
		checker_low_re: jb TCON.5, out_re ;Checks if enough time has elapsed
		sjmp checker_low_re
	out_re:
		RET
	
here:
	END