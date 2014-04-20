; briceorbryce
; ics 312
; hw8
; ex1
; Implementing an inputArray and a printArray function

%include "asm_io.inc"

segment .bss
	Array	resd	10

segment .text
        global  asm_main

asm_main:
	enter	0,0			; setup
	pusha				; setup

	; Call function inputArray
	push 	dword 10
	push	Array
	call	inputArray
	add	esp, 8

	; Call function printArray
	push	dword 10
	push	Array
	call	printArray
	add	esp, 8

	popa				; cleanup
	mov	eax, 0			; cleanup
	leave				; cleanup
	ret				; cleanup

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; DO NOT MODIFY ANYTHING ABOVE THIS LINE ;;;;;;;;;;;;;;;

;; To implement: function inputArray
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

segment .data
	prompt	db	"Enter an integer: ", 0x0
segment .bss

segment .text

inputArray:

; prologue
	push ebp
	mov ebp, esp
; sub esp, 0x4
	
	lea	ebx, [Array]		; mov the addr of array into ebx
	
	do:
	mov	eax, prompt		; print enter an int
	call	print_string
	call	read_int
	
	mov	[ebx], eax		; mov user input to Array
	
	while:
	add	ebx, 4			; add 4 to get to next index
	lea	ecx, [Array + 40]	; get addr of last 4 byte index
	cmp	ebx, ecx
	
	jnz	do			; loop if <10 ints
	
; epilogue
	mov esp, ebp
	pop ebp
	ret

;; To implement: function printArray
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

segment .data
	list	db	"List: ", 0x0
segment .bss

segment .text

printArray:
	
	print_start:
	lea	ebx, [Array]
	
	mov	eax, list
	call	print_string
	
	print:
	mov	eax, [ebx]
	call	print_int
	
	print_while:
	add	ebx, 4
	lea	ecx, [Array + 40]
	cmp	ebx, ecx
	
	jz	exit_print			; exit if printed 10 ints
	
	xor	eax, eax
	mov	eax, 0x2C
	call	print_char
	mov	eax, 0x20
	call	print_char
	jmp	print
	
	exit_print:
	call	print_nl
	ret
