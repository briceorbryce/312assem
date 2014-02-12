; template assem file

%include "asm_io.inc"

segment .data	
; bytes	dd	06C697665h	; "live"
; end	db	0	       	; null

segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha
; start



; end
;	pusha
	popa
	mov	eax, 0
	leave
	ret

