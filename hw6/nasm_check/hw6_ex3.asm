; briceorbryce
; ICS 312
; Ex. 3
; Finding a pattern

%include "asm_io.inc"

segment .data
	msg1	db	"Enter an integer: ", 0x0
	msg2	db	"binary representation: ", 0x0
	msg3	db	"# patterns: ", 0x0
	binRep	times 32 db	"0"	; binary representatin of 4 bytes
	end	db	0x0
	countPat	dd	0	; index @ pattern
	
segment .bss

segment .txt
global asm_main
asm_main:
	enter 0,0
	pusha
; prologue
; push ebp
; mov ebp, esp
; sub esp, 0x4
; start
	ask_loop:
	mov	ebx, binRep		; save addr of the last byte
					; represents 32nd bit in 4 byte
	
	mov	eax, msg1		; print "enter int"
	call	print_string
	call	read_int
	
	cmp	eax, 0			; user == 0 ?
	jz	exit_loop		; jmp if true
	
	loop_bits:
	shl	eax, 1			; left shift
	jnc	not_one			; carry bit == 1 ? jmp if false
	mov	BYTE [ebx], 0x31	; move 1 into representation at that bit
	
	not_one:
	cmp	ebx, binRep + 31	; at the addr of binRep ?
	jz	print_binary
	inc	ebx
	jmp	loop_bits
	
	
	print_binary:
	mov	eax, msg2
	call	print_string
	
	mov	eax, binRep
	call	print_string
	call	print_nl
	
	
	mov	eax, binRep		; pattern checking
	pattern_check:
	cmp	WORD [eax], 0x3031	; "10" ?
	jnz	next_bit		; jmp if false
	jmp	check_pattern
	
	
	next_bit:			; "must be "01"
	inc	eax			; inc eax
	jmp	pattern_check		; jmp
	
	
	check_pattern:			; "10*"
	add	eax, 2
	
	cmp	eax, binRep + 31
	jz	check_bit1
	
	
	find_1:
	cmp	BYTE [eax], 0x30
	jz	increment_1
	
	jmp	find_0
	
	increment_1:
	inc eax
	jmp find_1
	
	
	find_0:
	inc	eax
	cmp	eax, binRep +31
	jge	print_pattern
	
	cmp	BYTE [eax], 0x30
	jz	find_0
	
	inc	DWORD [countPat]
	
	cmp	eax, binRep +31
	jge	print_pattern
	
	inc	eax
	jmp	pattern_check
	
	check_bit1:
	cmp	BYTE [eax], 0x31
	jnz	print_pattern
	
	inc	DWORD [countPat]
	
	print_pattern:
	mov	eax, msg3
	call	print_string
	
	mov	eax, DWORD [countPat]
	call	print_int
	call	print_nl
	mov	DWORD [countPat], 0
	
	
	call	func_reset_bits
	jmp 	ask_loop
	
	
	exit_loop:
; epilogue
; mov esp, ebp
; pop ebp
; end
	popa
	mov eax, 0
	leave
	ret

	; resets the bits in binRep
	func_reset_bits:
	push	ebp
	mov	ebp, esp
	
	mov	ebx, binRep
	
	do:
	mov	BYTE [ebx], 0x30
	
	while:
	cmp 	ebx, binRep + 31
	jz	end_loop
	inc	ebx
	jmp	do
	
	end_loop:
	pop	ebp
	ret
