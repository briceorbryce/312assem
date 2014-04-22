; briceorbryce
; ics 312
; hw8
; ex1
; Implementing and using a findValue function

%include "asm_io.inc"
segment .data
	msg_toswap1	db	"Enter to-swap value #1: ",0
	msg_toswap2	db	"Enter to-swap value #2: ",0
	msg_novalue	db	"Value doesn't exist, try again!",0

segment .bss
	Array	resd	10
	toswap1	resd	1
	toswap2	resd	1

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
	
swap1:
	mov	eax, msg_toswap1   ; print "Enter to-swap value #1"
	call	print_string	   ;
	call	read_int	   ; get user input
	; Call function findValue
	push	dword	eax	   
	push	dword	10
	push	dword	Array
	call	findValue
	add	esp, 12
	cmp	eax, 0
	jnz	swap1_found	   ; if findValue returned non-zero then
                                   ; the value was found and jump to swap1_found
	
	mov	eax, msg_novalue   ; print "Value doesn't exist..."
	call	print_string  	   ;
	call	print_nl	   ; print a new line
	jmp	swap1	           ; re-prompt
swap1_found:
	mov	[toswap1], eax	   ; store the address of the first value
                                   ; to swap into toswap1
	
swap2:
	mov	eax, msg_toswap2   ; print "Enter to-swap value #2"
	call	print_string	   ;
	call	read_int	   ; get user input
	; Call function findValue
	push	dword	eax	   
	push	dword	10
	push	dword	Array
	call	findValue
	add	esp, 12
	cmp	eax, 0
	jnz	swap2_found	   ; if findValue returned non-zero then
                                   ; the value was found and jump to swap2_found
	
	mov	eax, msg_novalue   ; print "Value doesn't exist..."
	call	print_string  	   ;
	call	print_nl	   ; print a new line
	jmp	swap2	           ; re-prompt
swap2_found:
	mov	[toswap2], eax	   ; store the address of the first value
                                   ; to swap into toswap1
	
	; Call function swapValue
	push	dword	[toswap1]
	push	dword	[toswap2]
	call	swapValues
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
	push	eax			; psh user input
	push	DWORD [ebp-4]		; psh count
	push	DWORD [ebp+8]		; psh Array
	call	findValue
	add	esp, 12			; rst stack
	
					; eax = 0 || addr entered num
	cmp	eax, 0			; user entered a dup?
	jnz	do			; jmp if not 0
	
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
	mov	eax, [ebp+12]				; eax = count
	cmp	eax, 0					; cmp if init count == 0
	jz	return_0				; jmp if true
	
	mov	ebx, Array
	mov	edx, [ebp+16]				; edx = userInput
	
	compare_value:
	cmp	[ebx], edx				; array[i] == userInput ?
	jz	have_value				; array already has value
	jmp	loop_again
	
	have_value:
	mov     eax, tryAgain
	call    print_string
	mov	eax, ebx
	jmp	exit_findValue
	
	loop_again:
	dec	DWORD [ebp+12]				; count--
	add	ebx, 4					; array[i++]
	
	mov	eax, [ebp+12]				; count == 0 ?
	cmp	eax, 0
	jnz	compare_value
	
	
	return_0:
	xor	eax, eax				; return 0
	
	
	exit_findValue:

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


;; To implement: function swapValues
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; swaps two values, given they're addr
; swapValues (swap2, swap1)
; 

segment .data

segment .bss

segment .text

swapValues:

; prologue
	push ebp
	mov ebp, esp
	sub esp, 0x4
	
	mov	eax, [ebp+8]			; eax <- swap2
	mov 	[ebp-4], [eax]			; temp = swap2
	
	
	
; epilogue
	mov ebp, esp
	pop ebp
	ret
