; briceorbryce
; ICS 312
; Ex. 1
; Categorizing ASCII codes

%include "asm_io.inc"
section .data   ; data segment

section .text   ; Text segment
	global asm_main ; Default entry for ELF linking

asm_main:
	enter 0,0
	pusha
; start
	
; end
	popa
	mov eax, 0
	leave
	ret
