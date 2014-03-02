; briceorbryce
; ICS 312
; Ex. 2
; Identifying Divisors

%include "asm_io.inc"
segment .data   ; data segment
	msg1	db	"Enter an integer: ", 0x0
	msg2	db	"The number of integers divisible by 2 is ", 0x0
	msg3	db	"The number of integers divisible by 3 is ", 0x0
	msg4	db	"The number of integers divisible by 5 is ", 0x0
	
segment .bss
	usrEnt		resd	1	; user entered this
	divide2		resd	1
	divide3		resd	1
	divide5		resd	1
segment .text   ; Text segment
global asm_main ; Default entry for ELF linking
asm_main:
	enter 0,0
	pusha
; prologue
;	push ebp
;	mov ebp, esp
;	sub esp, 0x4
;	mov DWORD [ebp-4], 0x0
; start
	
	loop_start:
	mov	eax, msg1	; print enter an int
	call	print_string
	call 	read_int
	
	mov DWORD [usrEnt], eax
	cmp DWORD [usrEnt], 0	; user < 0 ?
	jl	exit_loop	; jmp if user entered neg (exit)
	
	mov	eax, DWORD [usrEnt] ; reset eax and edx
	xor	edx, edx
	
	mov	ebx, 2		; divide by 2, check remainder
	div 	ebx
	cmp	edx, 0		; edx == 0 ?
	jnz	inc_div_3	; jmp if false
	
	inc_div_2:
	mov	ebx, divide2	; user entered something
	inc	DWORD[ebx]	; divisible by 2
	
	inc_div_3:
	xor	edx, edx	; reset edx and eax
	mov	eax, DWORD [usrEnt]
	
	mov	ebx, 3		; divide by 3, check remainder
	div 	ebx
	cmp	edx, 0		; edx == 0 ?
	jnz	inc_div_5	; jmp if false
	
	mov	ebx, divide3	; user entered something
	inc	DWORD[ebx]	; divisible by 3
	
	inc_div_5:
	xor	edx, edx	; reset edx and eax
	mov	eax, DWORD [usrEnt]
	mov	ebx, 5		; divide by 5, check remainder
	div	ebx
	cmp	edx, 0		; edx == 0 ?
	jnz	loop_start	; jmp if false, loop again
	
	mov	ebx, divide5
	inc	DWORD[ebx]
	
	jmp	loop_start
	
	exit_loop:
	mov	eax, msg2
	call	print_string
	mov	eax, [divide2]
	call	print_int
	call	print_nl
	
        mov     eax, msg3
        call    print_string
	mov	eax, [divide3]
	call	print_int
        call    print_nl	
	
        mov     eax, msg4
        call    print_string
	mov	eax, [divide5]
	call	print_int
        call    print_nl

; epilogue
;	mov esp, ebp
;	pop ebp
; end
	popa
	mov eax, 0
	leave
	ret
