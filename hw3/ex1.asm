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

	mov	eax, msg1	; print msg1
	call	print_string
	call	print_nl

	call	read_char	; user entered char - stored in EAX
	mov	[chartr], eax	; store in mem
	;mov	eax, [chartr]
	;call	print_char
	;call	print_nl

	mov	eax, msg2	; print msg2
	call	print_string
	call	print_nl

	mov	eax, msg3	; print msg3
	call	print_string
	call	print_nl

	mov	eax, msg4	; print msg4
	call	print_string
	call	print_nl

; end
	popa
	mov	eax, 0
	leave
	ret

