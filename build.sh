#!/bin/bash

set -e

mkdir -p dist

nasm -f elf64 -o ./dist/md5.o md5.asm
nasm -f elf64 -o ./dist/md5test.o md5test.asm

ld -o ./dist/md5test ./dist/md5.o ./dist/md5test.o
