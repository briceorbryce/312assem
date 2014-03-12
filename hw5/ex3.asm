; briceorbryce
; ICS 312
; Ex. 3
; Identifying More Divisors

%include "asm_io.inc"
segment .data   
	msg1		db      "Enter an integer: ", 0x0
        msg2		db      "The number of integers divisible by ", 0x0
	msg2_1		db	" is ", 0x0
	divby		db	1	; the number to divide by
	indexlist	db	0	; index of place in list

segment .bss
	usrEnt		resd	1
	list		resd	50

segment .text
global asm_main ; Default entry for ELF linking
asm_main:
	enter 0,0
	pusha
; prologue
;      push ebp
;      mov ebp, esp
;      sub esp, 0x1
;      mov BYTE [ebp-1], 0x1
; start
	ask_int_start:
	mov	eax, msg1		; print: "enter an int"
	call	print_string
	call	read_int
	
	mov DWORD [usrEnt], eax
	
	cmp DWORD [usrEnt], 0		; usrEnt < 0 ?
	jl	ask_int_end		; jmp if true
	
	divide_all:
	mov	eax, DWORD [usrEnt]	; reset eax and edx and divby
	xor	edx, edx
	xor	ecx, ecx
	mov	cl, BYTE [divby]	; divide by counter from 1 - 50
	div	ecx			; eax / ecx -check remainder
	cmp	edx, 0			; edx == 0 ?
	jz	can_divide		; jmp if true
	jmp	not_divisible
	
	
	can_divide:
	mov	eax, list		; get beginning of the list
	xor	ebx, ebx,
	mov	bl, BYTE [indexlist]	; get which spot in list (i)
	imul	ebx, 4
	inc 	BYTE [eax + ebx]	; inc at that point
	
	
	not_divisible:
	mov	eax, indexlist		; inc the index
	inc	DWORD [eax]
	mov	eax, divby		; inc what we're dividing by
	inc	DWORD [eax]
	
	
	; check if divby < 50
	check_loop:
	cmp	BYTE [eax], 50		; divby < 50 ?
	jle	divide_all		; jmp if true
	mov	BYTE [indexlist], 0	; reset i=0
	mov	BYTE [divby], 1		; divby=1
	jmp	ask_int_start
	
	
	ask_int_end:			; okay now we print 50 lines
	mov	BYTE [divby], 1		; set the number to divide by 
	mov	BYTE [indexlist], 0	; set i to point to list[0]
	
	
	print_list:
	mov	eax, msg2		; print "the number of ints div by "
	call	print_string
	xor	eax, eax
	mov	al, [divby]		; print "X"
	call	print_int
	mov	eax, msg2_1		; print " is "
	call	print_string
	
	mov	ecx, list		; get list addr
	xor	ebx, ebx		
	mov	bl, BYTE [indexlist]	; get index
	add	ecx, ebx		; add to get list[indexlist]
	mov	eax, [ecx]
	call	print_int
	call	print_nl
	
	mov	eax, 0x32		; if divby <= 50
	xor	ebx, ebx
	mov	bl, BYTE [divby]
	cmp	ebx, eax
	jge	exit_loop		; jmp if false
	
	xor	ecx, ecx
	mov	ecx, divby		; add 1 to divby
	inc	BYTE [ecx]
	
	xor	ecx, ecx
	mov	cl, [indexlist]		; add 4 to indexlist
	add	cl, 4			; to inc to the next index
	mov	BYTE [indexlist], cl
	
	jmp	print_list		; loop again
	
	exit_loop:
	
	
; epilogue
;       mov esp, ebp
;       pop ebp
; end
	popa
	mov eax, 0
	leave
	ret
