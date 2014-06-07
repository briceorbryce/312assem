section .data   ; data segment
	fizz	db	"fizz", 0x0
	fizzlen	 equ    $-fizz
	buzz	db	"buzz", 0x0
	buzzlen	equ	$-buzz

section .text
 global _start
  _start:
	push	BYTE 0x31
	call	print_char
	add	esp, 1
	
	push	BYTE 0x30
	call	print_char
	add	esp, 1
	
	call	print_nl
	
; SYSCALL: exit(0)
	mov	eax, 1      ; put 1 into eax, since exit is syscall #1
	mov	ebx, 0      ; exit with success
	int	0x80        ; do the syscall



; prints a character 
print_char:

; prologue
	push ebp
	mov ebp, esp
	;sub esp, 1
	
; syscall: write(2)
	mov	eax, 4      ; put 4 into eax since write is syscall #4
	mov	ebx, 1      ; put 1 into ebx since stdout is 1
	lea	ecx, [ebp+8] ; move 1st arg to print
	mov	edx, 1      ; char len
	int	0x80        ; call the kernel to make the system call happen
	
; epilogue
	mov esp, ebp
	pop ebp
	ret


; prints a new line
print_nl:
; prologue
	push ebp
	mov ebp, esp
	sub esp, 1
	mov BYTE[ebp-1], 0xA
	
; syscall: write(2)
	mov	eax, 4      ; put 4 into eax since write is syscall #4
	mov	ebx, 1      ; put 1 into ebx since stdout is 1
	lea	ecx, [ebp-1]
	mov	edx, 1      ; char len
	int	0x80        ; call the kernel to make the system call happen
	
; epilogue
	mov esp, ebp
	pop ebp
	ret
