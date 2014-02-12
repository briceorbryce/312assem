; ex1
; briceorbryce

%include "asm_io.inc"

segment .data	
	msg1	db	"Enter a character: ", 0
	msg2	db	"Enter a integer: ", 0
	msg3	db	"The character entered was: ", 0
	msg4	db	"The integer entered was: ", 0

segment .bss
	chartr	resd	1	; holds the char the user puts
	integer	resd	1	; holds the integer the user puts

segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha
; start

	mov	eax, msg1	; print msg1 "enter a char"
	call	print_string

	call	read_char	; user entered char - stored in EAX
	mov	[chartr], eax	; store in mem

	mov	eax, msg2	; print msg2 "enter a int"
	call	print_string

	call	read_int	; user entered int - stored in EAX
	mov	[integer], eax	; store in mem


	mov	eax, msg3	; print msg3 "the char entered was"
	call	print_string
	mov	eax, [chartr]	; pass user input to EAX to print to console
	call	print_char
	call	print_nl

	mov	eax, msg4	; print msg4 "the int entered was"
	call	print_string
	mov	eax, [integer]	; pass user input to EAX to print to console
	call	print_int
	call	print_nl

; end
	popa
	mov	eax, 0
	leave
	ret

