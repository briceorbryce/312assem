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
	amtOfInts	dd	0	; amt of ints user entered
	pound		db	"#", 0x0
	line		db	"-", 0x0
	space		db	" ", 0x0
	
segment .bss
	usrEnt		resd	1
	list		resd	50

segment .text
global asm_main ; Default entry for ELF linking
asm_main:
	enter 0,0
	pusha
; prologue
      push ebp
      mov ebp, esp
      sub esp, 0x2
      mov BYTE [ebp-1], 0x0	; i = 0
      mov BYTE [ebp-2], 0x1	; j = 1
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
	
	
	ask_int_end:
	mov	eax, [list]		; eax list[0]
	mov	DWORD [amtOfInts], eax	; save amt of rows to print
	
	
	loop_row:			; start of the row
	mov	eax, pound
	call	print_string
	mov	BYTE [ebp-2], 1
	
	
		check_can_print:
		xor	ecx, ecx
		mov 	cl, BYTE [ebp-2]	; list[j * 4]
		imul	ecx, 4
		mov	edx, ecx
		mov	ecx, [list+ecx]
		cmp	DWORD [amtOfInts], ecx
		jnz	no_pound
		
		
		print_pound:
		mov	eax, pound
		call	print_string
		dec	DWORD [list+edx]
		jmp	doWhile
		
		no_pound:
		mov	eax, space		; print space
		call	print_string
		
		doWhile:			
		inc	BYTE [ebp-2]		; j++
		cmp	BYTE [ebp-2], 50	; j < 49 ?
		jnz	check_can_print		; loop if true
		
		
	vertical_loop:			; loops according to how many ints user enters
	call	print_nl
	dec	DWORD [amtOfInts]
	cmp	DWORD [amtOfInts], 0	; if == 0 ?
	jz	print_last_lines	; stop looping if true 
	jmp	loop_row
	
	print_last_lines:		; printing the "---"
	mov	BYTE [ebp-1], 0x0	; i = 0
	
	print_lines:
	mov	eax, line
	call	print_string
	inc	BYTE [ebp-1]
	cmp 	BYTE [ebp-1], 50	; i < 50 ?
	jnz	print_lines		; jmp if true
	
	exit_loop:
	call	print_nl
	
;epilogue
      mov esp, ebp
      pop ebp
; end
	popa
	mov eax, 0
	leave
	ret
