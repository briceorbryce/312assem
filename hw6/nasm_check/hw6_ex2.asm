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
	sub	esp, 0x1
	
	xor	ecx, ecx
	mov	ecx, 0
	
	mov	ebx, [binRep + ecx]
	//TODO
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
