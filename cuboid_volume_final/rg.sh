#!/bin/bash
#Author: Greg Z
#Email: ziyangz@csu.fullerton.edu
#Title: BASH compile for C++
rm *.o
rm *.out
rm *.lis

nasm -f elf64 -l volume.lis -o volume.o volume.asm -g -gdwarf

g++ -c -Wall -no-pie -m64 -std=c++17 -o cube.o cube.cpp -g

g++ -m64 -no-pie -o volume.out volume.o cube.o -std=c++17 -g

gdb ./volume.out


rm *.o
rm *.out
rm *.lis
