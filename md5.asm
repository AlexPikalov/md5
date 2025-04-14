; MD5 implementation

%define chunkLen 512
%define chunkLenBytes chunkLen / 8
%define dwbytes 4

; F = (B and C) or ((not B) and D)
%macro call_F 0
  ; ((not B) and D)
  mov r9d, dword [cB]
  not r9d
  and r9d, dword [cD]
  ; (B and C)
  mov r10d, dword [cB]
  and r10d, dword [cC]
  or r9d, r10d
  mov dword [cF], r9d ; store in memory
%endmacro

; G = (D and B) or ((not D) and C)
%macro call_G 0
  ; ((not D) and C)
  mov r9d, dword [cD]
  not r9d
  and r9d, dword [cC]
  ; (D and B)
  mov r10d, dword [cD]
  and r10d, dword [cB]
  or r9d, r10d
  mov dword [cF], r9d ; store in memory
%endmacro

; H = B xor C xor D
%macro call_H 0
  mov r9d, dword [cB]
  xor r9d, dword [cC]
  xor r9d, dword [cD]
  mov dword [cF], r9d ; store in memory
%endmacro

; I = C xor (B or (not D))
%macro call_I 0
  mov r9d, dword [cD]
  not r9d
  or r9d, dword [cB]
  xor r9d, dword [cC]
  mov dword [cF], r9d ; store in memory
%endmacro

section .rodata
s: db \
7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22, \
5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20, \
4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23, \
6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21

K: dd \
0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee, \
0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501, \
0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be, \
0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821, \
0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa, \
0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8, \
0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed, \
0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a, \
0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c, \
0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70, \
0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05, \
0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665, \
0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039, \
0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1, \
0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1, \
0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391

section .data
; current chunk A, B, C, D, F
cA: dd 0
cB: dd 0
cC: dd 0
cD: dd 0
cF: dd 0
; result MD5 A, B, C, D
rA: dd 0x67452301
rB: dd 0xefcdab89
rC: dd 0x98badcfe
rD: dd 0x10325476

section .bss
lastChunkBuf: resb 64

section .text
global md5

; It calculates MD5 hash for the provided message
; Inputs:
; - rdi - message buffer memory address
; - rsi - message buffer length in bytes
; Outputs:
; - rax - MD5 result buffer memory address
md5:
; Calculate number of 512-bit chunks in a message
; and bytes remaining for the last chunk
mov rax, rsi
xor rdx, rdx
mov rcx, chunkLenBytes
div rcx                  ; buffer length / chunk length
push rdx                 ; keep calculated remaining number of bytes

; TODO: 1 process message chunks

; 2. create last chunk
; - copy remaining bytes
; - append "1" bit (0x80)
; - add len in bits % 2^64 to lastChunkBuf + 56
pop rcx                  ; restore remaining bytes
; copy remaining bytes to lastChunkBuf
mov rax, rdi
add rax, rsi
sub rax, rcx             ; rax - message buffer cursor
mov r10, lastChunkBuf    ; r10 - lastChunkBuf cursor
copy_loop:
jrcxz copy_loop_end      ; has more remaining bytes?

mov r9b, byte [rax]
mov byte [r10], r9b

inc rax
inc r10
dec rcx
jmp copy_loop
copy_loop_end:

mov byte [r10], 0b10000000  ; append "1" bit to lastChunkBuf

; store message length without transformation
; NOTE: it introduces limitation that max message len is 2^64 bits
mov rax, rsi
mov r10, 8                   ; length in bytes to length in bits
imul rax, r10                ; interestingly, it can be done as shr 8
mov [lastChunkBuf+56], rax   ; append len % 2^64 as last 64 bits

; chunk processing logic
; TODO: make it reusable for not last chunks processing
mov r9d, dword [rA]
mov dword [cA], r9d

mov r9d, dword [rB]
mov dword [cB], r9d

mov r9d, dword [rC]
mov dword [cC], r9d

mov r9d, dword [rD]
mov dword [cD], r9d

%assign i 0
%rep 64

%if (i >= 0) && (i <= 15)
  %assign g i
  call_F
%elif (i >= 16) && (i <= 31)
  %assign g (5*i + 1) % 16
  call_G
%elif (i >= 32) && (i <= 47)
  %assign g (3*i + 5) % 16
  call_H
%elif (i >= 48) && (i <= 63)
  %assign g (7*i) % 16
  call_I
%endif

; F := F + A + K[i] + M[g]
mov r9d, dword [cA]
add r9d, dword [K+dwbytes*i]
add r9d, dword [lastChunkBuf+dwbytes*g]
add dword [cF], r9d
; A := D
mov r9d, dword [cD]
mov dword [cA], r9d
; D := C
mov r9d, dword [cC]
mov dword [cD], r9d
; C := B
mov r9d, dword [cB]
mov dword [cC], r9d
; B := B + leftrotate(F, s[i])
mov r9d, dword [cF]
mov cl, byte [s+i]
rol r9d, cl
add dword [cB], r9d

%assign i i+1
%endrep
sum:
mov rax, rA
; Add this chunk hash to result
mov r9d, dword [cA]
add dword [rA], r9d       ; a0 := a0 + A

mov r9d, dword [cB]
add dword [rB], r9d       ; b0 := b0 + B

mov r9d, dword [cC]
add dword [rC], r9d       ; c0 := c0 + C

mov r9d, dword [cD]
add dword [rD], r9d       ; d0 := d0 + D

mov rax, rA
ret
