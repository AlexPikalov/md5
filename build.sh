#!/bin/bash

set -e

mkdir -p dist

nasm -f elf64 -o ./dist/md5.o md5.asm
nasm -f elf64 -o ./dist/md5cli.o md5cli.asm

ld -o ./dist/md5cli ./dist/md5.o ./dist/md5cli.o
