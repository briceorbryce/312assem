%include "asm_io.inc"

section .data	; data segment

section	.text	; Text segment
global asm_main	; Default entry for ELF linking

asm_main:
enter 0,0
pusha
call print_nl

; prologue
;push ebp
;mov ebp, esp
;mov ebp, esp    ; move stack ptr to ebp

;sub esp, 0xC
;mov WORD [ebp-2], 0x8FF0
;mov WORD [ebp-4], 0xA026
;mov WORD [ebp-6], 0x6043
;mov WORD [ebp-8], 0x7ABC
;mov BYTE [ebp-9], 0xF3
;mov BYTE [ebp-0xa], 0x0D
;mov BYTE [ebp-0xb], 0xE5
;mov BYTE [ebp-0xc], 0x03

;mov eax, [ebp-2]
;mov ebx, [ebp-4]
;add eax, ebx
;call print_int
;call print_nl

xor eax, eax
xor ebx, ebx
mov ax, 0x8ff0
mov bx, 0xa026
add ax, bx
call print_int
call print_nl

xor eax, eax
xor ebx, ebx
mov ax, 0x6043
mov bx, 0x7ABC
add ax, bx
call print_int
call print_nl


xor eax, eax
xor ebx, ebx
mov al, 0xF3
mov bl, 0x0D
add al, bl
call print_int
call print_nl

mov al, 0xE5
mov bl, 0x03
add al, bl
call print_int
call print_nl


; epilogue
;mov esp, ebp
;pop ebp

popa
mov eax, 0
leave
ret
