; ex2
; briceorbryce

%include "asm_io.inc"

segment .data	
	prompt	db	"Enter a 5-character string: ", 0
	str1	db	"String #1: ", 0
	str2	db	"String #2: ", 0

segment .bss
	userstr	resb	6	; holds the 5 bytes the user inputed
	backwrds resb	6	; holds the backwards string 

segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha
; start
	;set up memory
	mov	ebx, userstr	; mov addr of userstr to ebx
	mov	ecx, backwrds	; mov addr of backwrds to ecx
	mov	BYTE [ecx + 5], 0  ; terminate with null byte
	mov	BYTE [ebx + 5], 0  ; terminate with null byte

	mov	eax, prompt	; print "enter 5 char str"
	call	print_string
	call	read_char	; get char of user input
	mov	[ebx], al	; mov to ebx and userstr
	mov	[ecx + 4], al	; mov to ecx and 4 bytes ahead
	
	call	read_char	
	mov	[ebx + 1], al	; save char in next byte
	mov	[ecx + 3], al	; save char in previous byte
	
	call	read_char
	mov	[ebx + 2], al
	mov	[ecx + 2], al
	
	call	read_char
	mov	[ebx + 3], al
	mov	[ecx + 1], al
	
	call	read_char
	mov	[ebx + 4], al
	mov	[ecx], al

	mov	eax, str1	; print "string 1: "
	call	print_string
	mov	eax, ecx	; print that string the user entered backwards
	call	print_string
	call	print_nl
	
	sub	BYTE [ebx], 32		; subtract 32 from each char
	sub	BYTE [ebx + 1], 32
	sub	BYTE [ebx + 2], 32
	sub	BYTE [ebx + 3], 32
	sub	BYTE [ebx + 4], 32
	
	mov	eax, str2	; print "string2: "
	call	print_string
	mov	eax, ebx	; print the caps of the string the user entered
	call	print_string	
	call	print_nl
; end
	popa
	mov	eax, 0
	leave
	ret

