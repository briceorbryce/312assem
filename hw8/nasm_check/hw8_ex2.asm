; briceorbryce
; ics 312
; hw8
; ex1
; Implementing and using a findValue function

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
	sub esp, 0x8
	mov DWORD [ebp-4], 0		; count = 0
	mov DWORD [ebp-8], 0		; userInput = 0
	
	lea	ebx, [Array]		; mov the addr of array into ebx
	
	do:
	mov	eax, prompt		; print enter an int
	call	print_string
	call	read_int
	mov	[ebp-8], eax		; userInput = eax
	
;call findValue
	push	DWORD [eax]		; psh user input
	push	DWORD [ebp-4]		; psh count
	push	DWORD [ebp+8]		; psh Array
	add	esp, 12			; rst stack
	
	cmp	eax, 0			; user entered a dup?
	jnz	do			; ask again
	
	mov	eax, DWORD [ebp-8]	; eax = userInput
	
	mov	[ebx], eax		; mov user input to Array
	inc	DWORD [ebp-4]		; count++
	
	while:
	add	ebx, 4			; add 4 to get to next index
	xor	ecx, ecx
	mov	ecx, [ebp + 12]
	imul	ecx, 4
	lea	ecx, [Array + ecx]	; get addr of last 4 byte index
	cmp	ebx, ecx
	
	jnz	do			; loop if <10 ints
	
; epilogue
	mov esp, ebp
	pop ebp
	ret
	
	
;; Implementation of findValue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; if a duplicate is found
; mov eax, 1

; int findValue (Array, count, userInput)
; array = ebp+8
; count = ebp+12
; userInput = ebp+16
segment .data
        tryAgain        db      "Value already entered, try again!", 0x0A, 0x0
segment .bss

segment .text

findValue:

; prologue
        push ebp
        mov ebp, esp
; sub esp, 0x4
	push	ebx
	
	
	do_count:
	
	

        mov     eax, tryAgain
        call    print_string

; epilogue
	pop ebx
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
	
; prologue
        push ebp
        mov ebp, esp
; sub esp, 0x4
	
	print_start:
	lea	ebx, [Array]
	
	mov	eax, list
	call	print_string
	
	print:
	mov	eax, [ebx]
	call	print_int
	
	print_while:
	add	ebx, 4
	xor	ecx, ecx
	mov	ecx, [ebp + 12]
	imul	ecx, 4
	lea	ecx, [Array + ecx]
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

; epilogue
        mov esp, ebp
        pop ebp
	ret
