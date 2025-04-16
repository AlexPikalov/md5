%define MD5_LEN 32

section .rodata
; TODO: read from stdin
msg: db ""
msg_len: equ $-msg
hex_chars: db "0123456789abcdef"

; TODO: make it stack based
section .bss
md5Str: resb MD5_LEN+1

section .text
global _start
extern md5

_start:
  mov rdi, msg
  mov rsi, msg_len
  call md5

  ; prepare
  mov rsi, rax              ; move referrence to result from rax (rax will be used in div)
  mov r10, 0                ; cursor
  mov r9, 16                ; hex base
  .hex_loop:
    xor rax, rax
    xor rdx, rdx
    cmp r10, MD5_LEN
    je .hex_loop_end

    mov al, byte [rsi+r10]
    div r9
    mov al, byte [hex_chars+rax]
    mov byte [md5Str+2*r10], al
    mov al, byte [hex_chars+rdx]
    mov byte [md5Str+2*r10+1], al

    inc r10
    jmp .hex_loop
  .hex_loop_end:

  ; print result
  mov byte [md5Str+MD5_LEN], 0xA    ; new line
  mov rax, 1
  mov rdi, 1
  mov rsi, md5Str
  mov rdx, MD5_LEN+1
  syscall
  ; exit program
  mov rax, 60
  mov rdi, 0
  syscall

