#!/bin/bash
#Author: Greg Z
#Email: ziyangz@csu.fullerton.edu
#Title: BASH compile for C++

rm *.o
rm *.out

nasm -f elf64 -o volume.o volume.asm

g++ -g -c -m64 -std=c++17 -fno-pie -no-pie -o cube.o cube.cpp

g++ -g -m64 -std=c++17 -fno-pie -no-pie -o volume.out volume.o cube.o

echo "Compilation success!"

./volume.out

rm *.o
rm *.out
