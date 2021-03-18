LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 00H
LJMP main
ORG 300H
	
main:
	mov P2,#00h
	mov P1,#00h
	acall delay
	acall delay
	acall lcd_init      ;initialise LCD

	acall delay
	acall delay
	acall delay

	MOV 70H, #56H
	MOV 71H, #71H
	
	
	MOV A, #80H ; LEVEL-1
	acall lcd_command
	acall delay
	mov dptr,#my_string1   	   ;Load DPTR with sring1 Addr
	acall lcd_sendstring	   ;call text strings sending routine
	acall delay
	MOV A, #0C0H
	acall lcd_command
	acall delay
	mov dptr,#my_string5	   ;Load DPTR with sring1 Addr
	acall lcd_sendstring	   ;call text strings sending routine
	acall delay
	
	MOV A, 70H
	ANL A, #0FH
	MOV P3, A
	acall send_binary_string
	ACALL delay_1s
	
	
	MOV A, #80H ; LEVEL-2
	acall lcd_command
	acall delay
	mov dptr,#my_string2   	   ;Load DPTR with sring1 Addr
	acall lcd_sendstring	   ;call text strings sending routine
	acall delay
	MOV A, #0C0H
	acall lcd_command
	acall delay
	mov dptr,#my_string5	   ;Load DPTR with sring1 Addr
	acall lcd_sendstring	   ;call text strings sending routine
	acall delay
	
	MOV A, 70H
	ANL A, #0F0H
	SWAP A
	MOV P3, A
	acall send_binary_string
	ACALL delay_1s
	
	
	MOV A, #80H ; LEVEL-3
	acall lcd_command
	acall delay
	mov dptr,#my_string3   	   ;Load DPTR with sring1 Addr
	acall lcd_sendstring	   ;call text strings sending routine
	acall delay
	MOV A, #0C0H
	acall lcd_command
	acall delay
	mov dptr,#my_string5	   ;Load DPTR with sring1 Addr
	acall lcd_sendstring	   ;call text strings sending routine
	acall delay
	
	MOV A, 71H
	ANL A, #0FH
	MOV P3, A
	acall send_binary_string
	ACALL delay_1s
	
	
	MOV A, #80H ; LEVEL-4
	acall lcd_command
	acall delay
	mov dptr,#my_string4   	   ;Load DPTR with sring1 Addr
	acall lcd_sendstring	   ;call text strings sending routine
	acall delay
	MOV A, #0C0H
	acall lcd_command
	acall delay
	mov dptr,#my_string5	   ;Load DPTR with sring1 Addr
	acall lcd_sendstring	   ;call text strings sending routine
	acall delay
	
	MOV A, 71H
	ANL A, #0F0H
	SWAP A
	MOV P3, A
	acall send_binary_string
	ACALL delay_1s
	LJMP main
	
; ----------------------------------------------------------- ;
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

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine


;----------------------SENDING BINARY DATA---------------------------------------------------
send_binary_string:
	JBC P3.3, sender1_3
	JNB P3.3, sender0_3
	control_back_1:
	JBC P3.2, sender1_2
	JNB P3.2, sender0_2
	control_back_2:
	JBC P3.1, sender1_1
	JNB P3.1, sender0_1
	control_back_3:
	JBC P3.0, sender1_0
	JNB P3.0, sender0_0
	control_back_4:
	RET
	
sender1_3: 
	ACALL send1
	SJMP control_back_1
	
sender0_3: 
	ACALL send0
	SJMP control_back_1

sender1_2: 
	ACALL send1
	SJMP control_back_2
	
sender0_2: 
	ACALL send0
	SJMP control_back_2
	
sender1_1: 
	ACALL send1
	SJMP control_back_3
	
sender0_1: 
	ACALL send0
	SJMP control_back_3
	
sender1_0: 
	ACALL send1
	SJMP control_back_4
	
sender0_0: 
	ACALL send0
	SJMP control_back_4
	
send0:
	mov dptr,#my_string6	   ;Load DPTR with sring1 Addr
	acall lcd_sendstring	   ;call text strings sending routine
	acall delay
	RET
	
send1:
	mov dptr,#my_string7
	acall lcd_sendstring
	acall delay
	RET

;------------- ROM text strings---------------------------------------------------------------
org 100h
my_string1:
         DB   "Level-1", 00H
my_string2:
         DB   "Level-2", 00H
my_string3:
         DB   "Level-3", 00H
my_string4:
         DB   "Level-4", 00H
my_string5:
		 DB   "Value: ", 00H
my_string6:
		 DB   "0", 00H
my_string7:
		 DB   "1", 00H			 

END