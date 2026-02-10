; sample x86 assembly entry
; Assemble and link with your preferred toolchain

section .data
    msg db "Hello, Assemblyx86",0

section .text
    global _start
_start:
    ; platform-specific syscalls would go here
    nop
    ret
