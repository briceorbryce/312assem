; briceorbryce
; ICS 312
; Ex. 1
; Categorizing ASCII codes

%include "asm_io.inc"

section .data
	msg1	db	"Enter an integer: ", 0x0
	msg2	db	"It's the ASCII code for a white space.", 0x0
	msg3	db	"It's the ASCII code for a digit.", 0x0
	msg4	db	"It's some non-extended ASCII code.", 0x0
	msg5	db	"It's some extended ASCII code.", 0x0
	msg6	db	"It's not an ASCII code.", 0x0

segment .bss
	userEnt		resd	1	; user entered this

section .text   ; Text segment
global asm_main ; Default entry for ELF linking
asm_main:
	enter 0,0
	pusha
; prologe
;	push ebp
;	mov ebp, esp
;	mov ebp, esp	; move stack ptr to ebp
	
;	sub esp, 0x4	; set up stack for local variable
;	mov DWORD [ebp-4], 0x0
; start
	
	;loop_start:
	mov	eax, msg1	; print "enter int"
	call	print_string
	call	read_int
	call	print_nl
	
	mov DWORD [userEnt], eax	; save input
	cmp DWORD [userEnt], 0	; user < 0 ? jmp : go on
	jl	exit_loop	; jmp if user entered neg
	
	cmp DWORD [userEnt], 0x20
	jz	entered_space	; jmp if user entered 32(space)
	
	
	
	entered_space:
	mov	eax, msg2
	call	print_string
	call	print_nl
	;jmp	loop_start
	jmp	exit_loop
		
	entered_digit:
	mov	eax, msg3
	call	print_string
	call	print_nl
	;jmp	loop_start
	
	non_ext:
	mov	eax, msg4
	call	print_string
	call	print_nl
	;jmp	loop_start

	some_ext:
	mov	eax, msg5
	call	print_string
	call	print_nl
	;jmp	loop_start

	; jmp loop_start
	exit_loop:
; epilogue
;	mov esp, ebp
;	pop ebp 
; end
	popa
	mov eax, 0
	leave
	ret
