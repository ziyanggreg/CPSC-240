#!/bin/bash

#Author: Greg Z
#Title: BASH compile for C++

rm *.o
rm *.out

nasm -f elf64 -o compute_fall_time.o compute_fall_time.asm

g++ -g -c -m64 -std=c++17 -fno-pie -no-pie -o driver.o driver.cpp

g++ -g -m64 -std=c++17 -fno-pie -no-pie -o compute_fall_time.out compute_fall_time.o driver.o

echo "Compilation success!"

./compute_fall_time.out
