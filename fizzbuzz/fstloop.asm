%include "asm_io.inc"

segment .data
	mess	db	"Hello, world!", 0xa , 0
	final	db	"End loop", 0xa, 0
segment .bss

segment .text
	global asm_main
asm_main:
	enter 0,0
	pusha
; start
	; prologue
	push ebp
	mov ebp, esp
	mov ebp, esp
	
	sub esp, 0x4		; make a local 4 byte int
	mov DWORD [ebp-4], 0
	
	start_main_loop:
	  cmp DWORD [ebp-4], 5 	; 
	  JAE break 		; i < 5 ? true->nojmp
	  mov eax, mess
	  call print_string
	  inc BYTE [ebp-4]
	  jmp start_main_loop
	  
	break:
	  mov eax, final
	  call print_string
	  
	; epilogue
	mov esp, ebp
	pop ebp
; end
	popa
	mov	eax, 0
	leave
	ret

