#!/bin/bash

set -e

mkdir -p dist

nasm -f elf64 -g -F dwarf string_utils.asm -o dist/string_utils.o
nasm -f elf64 -g -F dwarf string_utils_test.asm -o dist/string_utils_test.o

ld -o dist/string_utils_test dist/string_utils_test.o dist/string_utils.o

dist/string_utils_test
