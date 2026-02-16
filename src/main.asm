; Denemelik Assembly Kodu - 1
; x86 mimarisi için yazılmıştır

section .data
    msg db "Hello, Assemblyx86", 0

section .text
    global _start

_start:
    ; Write the message to stdout
    mov eax, 4          ; sys_write
    mov ebx, 1          ; file descriptor (stdout)
    mov ecx, msg        ; pointer to message
    mov edx, 18         ; message length
    int 0x80            ; call kernel

    ; Exit the program

    nop
    ret
