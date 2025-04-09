%define EOF 0x0A

section .text
global str_len

; Calculate length of string in bytes not counting terminating
; new line symbol.
; Input:
;  * rdi - string buffer pointer
; Output:
;  * rax - string len in bytes
str_len:
  xor rax, rax            ; initialise byte counter
  .counter_loop:          ; bytes counter loop
  cmp byte [rdi+rax], EOF  ; check if current byte is EOF
  je .end                 ; if EOF return from the routine
  inc rax                 ; if not EOF increment counter
  jmp .counter_loop       ; continue counting
  .end:
  ret
