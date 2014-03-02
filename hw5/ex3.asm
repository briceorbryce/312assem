; briceorbryce
; ICS 312
; Ex. 2
; Identifying Divisors

%include "asm_io.inc"
segment .data   ; data segment

segment .text   ; Text segment
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
