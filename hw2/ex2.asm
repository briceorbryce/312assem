section .data	; data segment
msg	db	"Hello, world!", 0x0a	; the string and newline char
;mlen	equ	$-message

A 		dw	011FAh
B		db	043h, 0BBh, 0CEh
C times 3	dw	21
D		dd	178
E		db	"a", 54, "b", 0
F times 2	dw	-8
G 		dw	009h

section	.text	; Text segment

global _start	; Default entry for ELF linking

_start:
nop

; ex is the return number
; echo $? - echos back the thing

; SYSCALL: exit(0)
mov eax, 1	; put 1 into eax, since exit is syscall #1
mov ebx, 0	; exit with success
int 0x80	; do the syscall
