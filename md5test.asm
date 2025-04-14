section .rodata
msg: db ""
msg_len: dq 0

msg2: db 1, 2, 3, 4, 5, 6
msg2_len: dq $-msg2

section .text
extern md5
global _start

_start:
m1:
mov rdi, msg
mov rsi, [msg_len]
call md5

m2:
mov rdi, msg2
mov rsi, [msg2_len]
call md5

m3:

mov rax, 60
mov rdi, 0
syscall
