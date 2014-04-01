; briceorbryce
; ICS 312
; Ex. 2
; Printing Hex Representation

%include "asm_io.inc"

segment .data
	msg1	db	"Enter an integer: ", 0x0
	msg2	db	"Hex representation: ", 0x0
	binRep	times 32 db	"0"	; binary representatin of 4 bytes
	hexRep	times 8	db	"0"	; hex rep of 4 bytes
	end	db	0x0

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
	jz	print			; jmp and print
	inc	ebx			; add one to addr
	jmp	loop_bits
	
	
	print:
	mov	eax, msg2		; print "hex represe..:"
	call	print_string
	
	call	func_calc_hex		; calc 32 bits to hex bytes
	
	mov	eax, hexRep		; print the hex bytes
	call	print_string
	call	print_nl
	
	call	func_reset_bits		; rst bits to 0
	call	func_reset_hex		; rst hex bytes to 0
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
	
	; computes the hex digits
	func_calc_hex:
	push	ebp
	mov	ebp, esp
; prologue
	sub	esp, 0x3		; create 3 local variables
	mov	BYTE [ebp-1], 0x20	; bitCount = 32
	mov	BYTE [ebp-2], 0		; currentHalfByte = 0
	mov	BYTE [ebp-3], 0		; hexRepOffset = 0
	
	mov	ebx, binRep 
	
	reset:				; new set of 4 bites to parse
	mov	BYTE [ebp-2], 0		; currentHalfByte = 0
	
	
	current_halfbyte:
	cmp 	BYTE [ebx], 0x31	; cmp each bit to "1"
	jnz	increment_bit
	
	
	xor	eax, eax		; call calc_bit
	mov	al, BYTE [ebp-1]	; param 1: bitCount
	push	eax
	call	calc_bit		; ret bitCount
	add	esp, 4			; reset the stack
					; eax: new currentHalfByte
	mov	BYTE [ebp-2], al	; 
	
	increment_bit:
	inc	ebx
	dec	BYTE [ebp-2]		; currentHalfByte--
	cmp	BYTE [ebp-2], 0		; currentHalfByte == 0 ?
;	jz	fin_4bytes		; jmp if true
	
		
; epilogue
	mov	esp, ebp	
	pop	ebp
	ret
	
	
	
;; This function calculates what multiple of two should be returned
;; 8, 4, 2, 1, 0
;; Depending on where it is in the bit count
;; return eax
;; arg1: bitCount
	
	calc_bit:	
; prologue
	push	ebp
	mov	ebp, esp
	
	; bitCount -> BYTE [ebp + 8] 
	xor	eax, eax
	xor	edx, edx
	mov	edx, 4
	mov	al, BYTE [ebp + 8]
	div	edx
	
	cmp	edx, 3
	jz	return_3
	
	cmp	edx, 2
	jz	return_2
	
	cmp	edx, 1
	jz	return_1
	
	; return 0
	mov	eax, 0
	jmp	exit
	
	return_3:
	mov	eax, 3
	jmp	exit
	
	return_2:
	mov	eax, 2
	jmp	exit
	
	return_1:
	mov	eax, 1
	jmp	exit
	
	
	exit:
	; return eax
	
; epilogue
	mov	esp, ebp
	pop	ebp
	ret
	
	
	
	; resets the bits in binRep
	func_reset_bits:
	push	ebp
	mov	ebp, esp
	
	mov	ebx, binRep
	
	do_bits:
	mov	BYTE [ebx], 0x30
	
	while_bits:
	cmp 	ebx, binRep + 31
	jz	end_loop_bits
	inc	ebx
	jmp	do_bits
	
	end_loop_bits:
	pop	ebp
	ret
	
	; reset the bytes in hexRep
	func_reset_hex:
	push	ebp
	mov	ebp, esp
	
	mov ebx, hexRep
	
	do_hex:
	mov	BYTE [ebx], 0x30
	
	while_hex:
	cmp	ebx, hexRep + 8
	jz	end_loop_hex
	inc ebx
	jmp	do_hex
	
	end_loop_hex:
	pop	ebp
	ret	
