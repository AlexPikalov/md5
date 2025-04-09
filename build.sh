#!/bin/bash

set -e

mkdir -p dist

nasm -f elf64 string_utils.asm -o dist/string_utils.o
nasm -f elf64 md5.asm -o dist/md5.o

ld -o dist/md5 dist/string_utils.o dist/md5.o 
