; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start

ORG 00BH
timer0_isr:
	ADD A, #01H
	mov TH0, #00H		;Turn on the timer
	mov TL0, #00H
	mov TMOD, #01H
	CLR TCON.5
	SETB TCON.4
	RETI

org 200h
start:
	  mov P2,#00h
      mov P1,#01h
	  ;initial delay for lcd power up

	;here1:setb p1.0
      acall delay
	;clr p1.0
	  acall delay
	;sjmp here1


	  acall lcd_init      ;initialise LCD
	
	  acall delay
	  acall delay
	  acall delay
	  mov a,#80h
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string1
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  mov a,#0C0h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string2
	  acall lcd_sendstring
	  
	  acall delay_2s
	  setb P1.4			;Turn on LED P1.4 after 2 seconds7
	  
	  SETB EA
	  SETB ET0
	  mov A, #00H ; Accumulatir holds number of times the timer overflows

	  mov TH0, #00H		;Turn on the timer
	  mov TL0, #00H
	  mov TMOD, #01H
	  CLR TCON.5
	  SETB TCON.4
	  jb P1.0, value_1
	  value_0:	
		jnb P1.0, value_0
		jb P1.0, toggled
	   
	  value_1:
		jb P1.0, value_1
		jnb P1.0, toggled
	  
	  toggled:
		clr P1.4
		CLR TCON.4
			
	MOV B, A ; Storing Value of A in B
	
	CLR EA
	CLR ET0
	; All that's left now is to display the numbers
	mov a,#80h
    acall lcd_command	 ;send command to LCD
    acall delay
    mov   dptr,#my_string3
    acall lcd_sendstring	   ;call text strings sending routine
    acall delay
	
	mov a,#0C0h		  ;Put cursor on second row,3 column
	acall lcd_command
	acall delay
	mov   dptr,#my_string4
	acall lcd_sendstring
	acall delay
	
	MOV A, B
	ANL A, #0F0H
	SWAP A
	acall lcd_send_hex_string
	acall delay
	
	MOV A, B
	ANL A, #0FH
	acall lcd_send_hex_string
	acall delay
	
	mov   dptr,#my_string5
	acall lcd_sendstring
	acall delay
		
	MOV A, TH0
	ANL A, #0F0H
	SWAP A
	acall lcd_send_hex_string
	acall delay
	
	MOV A, TH0
	ANL A, #0FH
	acall lcd_send_hex_string
	acall delay
	
	MOV A, TL0
	ANL A, #0F0H
	SWAP A
	acall lcd_send_hex_string
	acall delay
	
	MOV A, TL0
	ANL A, #0FH
	acall lcd_send_hex_string
	acall delay
	
	acall delay_5s
	
LJMP start			//stay here 

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

lcd_send_hex_string: ; The data to be sent is stored in the last 4 bits of the accumulator
	JB ACC.3, decider
	SJMP sending_numerals
	decider:
		JB ACC.2, sending_alphabets
		JB ACC.1, sending_alphabets
	sending_numerals: ;When value of A is in 0-9
		ADD A, #30H
		acall lcd_senddata
		RET
	sending_alphabets: ;When value of A is in A-F
		ADD A, #37H
		acall lcd_senddata
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
	 
; ----------------------------------------------------------- ;
delay_5s:
	acall delay_2s
	acall delay_2s
	acall delay_1s
	RET

delay_2s:
	MOV R0, #0A0H
	LOOP:
		acall delay_min
		DJNZ R0, LOOP
	RET
	
delay_1s:
	MOV R0, #50H
	LOOP_1s:
		acall delay_min
		DJNZ R0, LOOP_1s
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

;------------- ROM text strings---------------------------------------------------------------
org 500h
my_string1:
         DB   "Toggle SW1", 00H
my_string2:
		 DB   "When LED Glows", 00H
my_string3:
		 DB   "Reaction Time", 00H
my_string4:
		 DB   "Count is ", 00H
my_string5:
		 DB   " ", 00H


end