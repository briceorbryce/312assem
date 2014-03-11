; briceorbryce
; ICS 312
; Ex. 2
; Identifying More Divisors

%include "asm_io.inc"
segment .data   ; data segment
	msg1		db      "Enter an integer: ", 0x0
        msg2		db      "The number of integers divisible by ", 0x0
	msg2_1		db	" is ", 0x0
	divby		db	1	; the number to divide by
	indexlist	db	0	; index of place in list

segment .bss
	usrEnt		resd	1
	list		resd	50

segment .text   ; Text segment
global asm_main ; Default entry for ELF linking
asm_main:
	enter 0,0
	pusha
; prologue
;       push ebp
;       mov ebp, esp
;       sub esp, 0x4
;       mov DWORD [ebp-4], 0x0
; start
	ask_int_start:

jmp ask_int_end

	mov	eax, msg1	; print: enter an int
	call	print_string
	call	read_int
	
	mov DWORD [usrEnt], eax
	
	cmp DWORD [usrEnt], 0		; user entered 0 ?
	jl	ask_int_end		; jmp if true
	
	divide_all:
	mov	eax, DWORD [usrEnt]	; reset eax and edx
	xor	edx, edx
	
	mov	ecx, divby	; divide by counter from 1 - 50
	div	ecx		; check remainder
	cmp	edx, 0		; edx == 0 ?
	jz	can_divide
	jmp	not_divisible
	
	can_divide:
	mov	eax, indexlist		; get the index of where
	imul	eax, 4			;  we are in the list (for dwords)
	inc 	DWORD [list+eax]	; inc at that point
	
	mov	eax, indexlist		; inc the index
	inc	DWORD [eax]
	
	mov	eax, divby		; inc what we're dividing by
	inc	DWORD [eax]
	jmp	check_loop
	
	
	not_divisible:
	mov	eax, indexlist		; inc the index
	inc	DWORD [eax]
	
	mov	eax, divby		; inc what we're dividing by
	inc	DWORD [eax]
	
	
	; check if divby < 50
	check_loop:
	cmp	DWORD [eax], 50
	jg	divide_all
	jmp	ask_int_start
	
	ask_int_end:			; okay now we print 50 lines
	mov	BYTE [divby], 1		; set the number to divide by 
	mov	BYTE [indexlist], 0	; set i to point to list[0]

	; print_list:
	
	mov	eax, msg2		; print "the number of ints div by "
	call	print_string
	mov	eax, [divby]		; print "X"
	movzx	eax, al
	call	print_int
	mov	eax, msg2_1		; print " is "
	call	print_string
	
	mov	ecx, list		; print list
	add	cl, BYTE [indexlist]	;  at index indexlist
	mov	eax, [ecx]
	call	print_int
	
	
	call	print_nl
	
	
	exit_loop:
	
	
; epilogue
;       mov esp, ebp
;       pop ebp
; end
	popa
	mov eax, 0
	leave
	ret
