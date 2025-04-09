section .data

empty_message: db '', 0x0A
empty_message_len: equ $ - empty_message - 1

non_empty_message: db "Hello world!", 0x0A
non_empty_message_len: equ $ - non_empty_message - 1

section .text
global _start
extern str_len

_start:
  mov rdi, empty_message
  call str_len
;  mov rdi, empty_message        ; first argument for .fail
  mov rsi, empty_message_len    ; second  argument for .fail
  cmp rax, empty_message_len
  jne .fail

  mov rdi, non_empty_message
  call str_len
;  mov rdi, empty_message        ; first argument for .fail
  mov rsi, non_empty_message_len    ; second  argument for .fail
  cmp rax, non_empty_message_len
  jne .fail

; end with success
  mov rax, 0x3C
  mov rdi, 1
  syscall

; Fail test execution.
; Input:
;   *   rdi - buffer point to a message for which test has failed
;   *   rsi - buffer len
; Output:
;   None. Execution ends with code 1.
.fail:
  ; print message itself
  mov rsi, rdi     ; message buffer
  mov rdx, rsi     ; buffer size
  mov rdi, 1       ; STD_OUT
  mov rax, 1       ; WRITE
  syscall

  ; exit program
  mov rax, 0x3C
  mov rdi, 1
  syscall
