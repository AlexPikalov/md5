#!/bin/bash

set -e

mkdir -p dist

nasm -f elf64 -g -F dwarf -o ./dist/md5_d.o md5.asm
nasm -f elf64 -g -F dwarf -o ./dist/md5test_d.o md5test.asm

ld -o ./dist/md5testdbg ./dist/md5_d.o ./dist/md5test_d.o
