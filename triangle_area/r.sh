#!/bin/bash

#Author: Greg Z
#Title: BASH compile for C++

rm *.o
rm *.out

nasm -f elf64 -o triangle.o triangle.asm

g++ -g -c -m64 -std=c++17 -fno-pie -no-pie -o driver.o driver.cpp

g++ -g -m64 -std=c++17 -fno-pie -no-pie -o triangle.out triangle.o driver.o

echo "Compilation success!"

./triangle.out
