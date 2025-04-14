section .rodata
msg: db ""
msg_len: dw 0

section .text
extern md5
global _start

_start:
mov rdi, msg
mov rsi, [msg_len]
call md5


mov rax, 60
mov rdi, 0
syscall
