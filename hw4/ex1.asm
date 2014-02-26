section .data	; data segment
msg     db      "Hello, world!", 0x0a, 0x   ; the string and newline char
section	.text	; Text segment
global _start	; Default entry for ELF linking

_start:

; prologue
push ebp
mov ebp, esp
mov ebp, esp    ; move stack ptr to ebp

sub esp, 0x4
mov DWORD [ebp-4], 0

nop

mov ax, 0x0035
mov bl, 0x81
movsx bx, bl
add ax, bx
movzx eax, ax
mov [ebp-4], eax

mov eax, 4	; put 4 into eax since write is syscall #4
mov ebx, 1	; put 1 into ebx since stdout is 1
mov ecx, msg
mov edx, 14
int 0x80	; call the kernel to make the system call happen

mov eax, 4	; put 4 into eax since write is syscall #4
mov ebx, 1	; put 1 into ebx since stdout is 1
mov ecx, 5
mov edx, 1
int 0x80	; call the kernel to make the system call happen

; epilogue
mov esp, ebp
pop ebp

; SYSCALL: exit(0)
mov eax, 1	; put 1 into eax, since exit is syscall #1
mov ebx, 0	; exit with success
int 0x80	; do the syscall
