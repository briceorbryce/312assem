; briceorbryce
; ics 312
; hw9
; ex1
; Computing a function

%include "asm_io.inc"

%define x dword [EBP+8]
%define y dword [EBP+12]

segment .bss

segment .text
global compute_f

compute_f:
enter 0,0
pusha

	fld	y		; stack = y
	fld1			; stack = y; 1
	faddp	ST1, ST0	; stack = (y+1) 
	
	fld	x		; stack = (y+1); x
	fsqrt			; stack = (y+1); sqrt(x)
	fdivp	ST1, ST0	; stack = ( (y+1)/sqrt(x) )
	
	fld	x		; stack = (y+1/sqrt(x); x
	fmul	ST0		; stack = (y+1/sqrt(x); (x*x)
	fadd	ST1

popa
mov eax, 0
leave
ret
