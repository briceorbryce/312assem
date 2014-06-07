%include "asm_io.inc"

section .data	; data segment

section	.text	; Text segment
global asm_main	; Default entry for ELF linking

asm_main:
enter 0,0
pusha

; prologue
push ebp
mov ebp, esp
mov ebp, esp    ; move stack ptr to ebp

sub esp, 0xC
mov WORD [ebp-2], 0x8ff0
mov WORD [ebp-4], 0xa026
mov WORD [ebp-6], 0x6043
mov WORD [ebp-8], 0x7abc
mov BYTE [ebp-9], 0xF3
mov BYTE [ebp-0xa], 0x0D
mov BYTE [ebp-0xb], 0xE5
mov BYTE [ebp-0xc], 0x03

xor eax, eax
xor ebx, ebx
mov ax, [ebp-4]
mov bx, [ebp-2]
sub ax, bx


xor eax, eax
xor ebx, ebx

mov al, BYTE [ebp-0x9]
mov bl, [ebp-0xa]
add al, bl
movsx eax, al
call print_int
call print_nl

; epilogue
mov esp, ebp
pop ebp

popa
mov eax, 0
leave
ret
