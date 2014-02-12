; ex1
; briceorbryce

%include "asm_io.inc"

segment .data	

segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha
; start



; end
	popa
	mov	eax, 0
	leave
	ret

