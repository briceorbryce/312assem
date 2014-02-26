section .data	; data segment
msg     db      "Hello, world!", 0x0a, 0x   ; the string and newline char
section	.text	; Text segment
global _start	; Default entry for ELF linking

_start:

; prologue
push ebp
mov ebp, esp
mov ebp, esp    ; move stack ptr to ebp

sub esp, 0xC
mov DWORD [ebp-2], 0x8FF0
mov DWORD [ebp-2], 0xA026
mov DWORD [ebp-2], 0x6043
mov DWORD [ebp-2], 0x7ABC
mov DWORD [ebp-1], 0xF3
mov DWORD [ebp-1], 0x0D
mov DWORD [ebp-1], 0xE5
mov DWORD [ebp-1], 0x03


mov eax, 4	; put 4 into eax since write is syscall #4
mov ebx, 1	; put 1 into ebx since stdout is 1
mov ecx, msg
mov edx, 14
int 0x80	; call the kernel to make the system call happen

; epilogue
mov esp, ebp
pop ebp

; SYSCALL: exit(0)
mov eax, 1	; put 1 into eax, since exit is syscall #1
mov ebx, 0	; exit with success
int 0x80	; do the syscall
