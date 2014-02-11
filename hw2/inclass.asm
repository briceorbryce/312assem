section .data	; data segment
var1	dd	179
var2	db	0xA3, 0x17, 0x12
var3	db	"bca"


section	.text	; Text segment

global _start	; Default entry for ELF linking

_start:
; SYSCALL: write (1, msg, 14)
nop
mov eax, var1
add eax, 3
mov ebx, [eax]
add ebx, 5
mov [var1], ebx


; SYSCALL: exit(0)
mov eax, 1	; put 1 into eax, since exit is syscall #1
mov ebx, 0	; exit with success
int 0x80	; do the syscall
