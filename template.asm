; template assem file

%include "asm_io.inc"

segment .data	
; bytes	dd	06C697665h	; "live"
; end	db	0	       	; null

segment .bss
;	integer1	rsd	1	
;	integer2	rsd	1
;	result		rsd	1

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

