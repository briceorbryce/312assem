section .data	; data segment

L1 dw 435
L2 db "h","e","l","l","o",0
L3 db 0A1h, 0B2h, 0C3h
L4 dw 23o

section	.text	; Text segment

global _start	; Default entry for ELF linking

_start:
nop
mov eax, [L3]
inc eax
mov [L2], eax
mov bx, [L1]
mov eax, L3
inc eax
mov [eax], bx

; SYSCALL: exit(0)
mov eax, 1	; put 1 into eax, since exit is syscall #1
mov ebx, 0	; exit with success
int 0x80	; do the syscall
