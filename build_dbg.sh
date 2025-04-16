#!/bin/bash

set -e

mkdir -p dist

nasm -f elf64 -g -F dwarf -o ./dist/md5_d.o md5.asm
nasm -f elf64 -g -F dwarf -o ./dist/md5cli_d.o md5cli.asm

ld -o ./dist/md5clidbg ./dist/md5_d.o ./dist/md5cli_d.o
