;Author information
;  Author name: Greg Zhang
;  Author email: ziyangz@csu.fullerton.edu
;
;Program information
;  Program name: Amazing Triangles
;  Programming languages: One module in C++, one module in X86
;  Date program began: 2022 Feb 15
;  Date of last update: 2022 Mar 31
;  Date of reorganization of comments: 2022 Mar 31
;  Files in this program: triangle.asm, driver.cpp, r.sh
;  Status: Finished.
;
;Purpose: Assembly file that defines the function triangle_area which is used in the driver.cpp
;
;This file
;   File name: traingle.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -o triangle.o triangle.asm
;   Link: g++ -g -m64 -std=c++17 -fno-pie -no-pie -o triangle.out triangle.o driver.o

;===== Begin code area ================================================================================================
extern printf
extern scanf
extern cos
extern sin

;; constants (EQU)

global triangle_area

segment .data
intro_prompt: db `\nWe take care of all your triangles.\n`, 0
name_prompt: db "Please enter your name: ", 0
string_format: db `%s`, 0
form3: db "%lf %lf %lf", 0
pi: dq 0x400921FB54442D18
input_sides_prompt: db `\nGood morning %s, please enter two sides and an angle:\n`, 0
strf_user_values: db `\nThank you %s. You entered %.6lf and %.6lf with angle %.6lf°\n`, 0
invalid_input: db `\nUnfortunately, one of your inputs is invalid. Please run this program again.\n`, 0
strf_answers: db `\nThe area of your triangle is %lf square units\nThe perimeter is %lf linear units\n`, 0

segment .bss
user_name resb 64
perimeter: resq 1 ; resq = reserve n qwords (here, n = 1)
area: resq 1

segment .text
triangle_area:
    push rbp
    mov rbp, rsp
    push rdi
    push rsi
    push rdx
    push rcx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    push rbx
    pushf

    ; Print intro_prompt
    mov rdi, intro_prompt
    call printf

    ; Print name prompt
    mov rdi, name_prompt
    call printf

    ; Input customer name
    mov rdi, string_format
    mov rsi, user_name
    call scanf

    ; print Good Morning prompt
    mov rdi, input_sides_prompt
    mov rsi, user_name
    call printf

    ;; --- GET DOUBLE VALUES FROM USER ---
    push qword 0 ; rsp lineup for scanf call quirk
                 ; --> WILL SEG-FAULT WITHOUT THIS!! <--
    ; make room for 3 doubles
    push qword 0
    push qword 0
    push qword 0
    mov rdi, form3 ; address to format str
    mov rsi, rsp ; rsi = rsp = side A
    mov rdx, rsp
    add rdx, 8 ; rdx = rsp+8 = side B
    mov rcx, rsp
    add rcx, 16 ; rcx = rsp+16 = angle (deg)
    call scanf

    ; put received values into XMM registers for calculations
    movsd xmm15, [rsp] ; side A
    pop rax
    movsd xmm14, [rsp] ; side B
    pop rax
    movsd xmm13, [rsp] ; angle (deg)
    pop rax
    pop rax ; undo rsp line up

    ;; --- PRINT USER'S INPUTED VALUES ---
    mov rsi, user_name
    mov rdi, strf_user_values
    mov rax, 3
    movsd xmm0, xmm15
    movsd xmm1, xmm14
    movsd xmm2, xmm13
    call printf

    ; Validate inputs
    ; xmm7 = 0.0
    xorpd xmm7, xmm7 ; Put 0 in xmm7
    ucomisd xmm7, xmm15 ; Compare side 1 to 0.0
    ja negative_side; Jump to negative_side
    ucomisd xmm7, xmm14 ; Compare side 2 to 0.0
    ja negative_side ; Jump to negative_side
    ucomisd xmm7, xmm13 ; Compare angle to 0.0
    ja negative_side ; Jump to negative_side

    ; convert xmm13 into radians
    movsd xmm12, [pi] ; xmm12 = pi (numerator)
    mov rax, 180
    cvtsi2sd xmm11, rax ; xmm11 = 180 (denominator)
    divsd xmm12, xmm11 ; xmm12 = pi/180
    mulsd xmm13, xmm12 ; -- xmm13 = rad angle --

    ;; -- PERIMETER CALCULATION --
    ; missing side (C) = sqrt(A^2 + B^2 - 2AB*cos(x))

    ; xmm15 = A
    ; xmm14 = B
    ; xmm13 = angle (rad)
    mov rax, 2
    cvtsi2sd xmm12, rax
    mulsd xmm12, xmm15
    mulsd xmm12, xmm14 ; xmm12 = 2AB

    movsd xmm11, xmm15
    mulsd xmm11, xmm11 ; xmm11 = A^2

    movsd xmm10, xmm14
    mulsd xmm10, xmm10 ; xmm10 = B^2

    ; cos(x)
    movsd xmm0, xmm13
    call cos ; xmm0 = cos(x)

    mov rax, -1
    cvtsi2sd xmm9, rax
    mulsd xmm9, xmm12 ; xmm9 = -2AB
    mulsd xmm9, xmm0 ; xmm9 = -2AB*cos(x)
    addsd xmm9, xmm10
    addsd xmm9, xmm11 ; xmm9 = A^2 + B^2 - 2AB*cos(x)
    sqrtsd xmm9, xmm9 ; xmm9 = missing side (C)

    ;; add our sides!
    addsd xmm9, xmm15
    addsd xmm9, xmm14; --- xmm9 = perimeter ---

    movsd [perimeter], xmm9 ; store for later

    ;; -- AREA CALCULATION --
    ; area = [A*B*sin(x)]/2

    ; xmm15 = A
    ; xmm14 = B
    ; xmm13 = angle (rad)
    movsd xmm0, xmm13
    call sin ; xmm0 = sin(x)

    ; run our values through the formula
    movsd xmm12, xmm0
    mulsd xmm12, xmm15
    mulsd xmm12, xmm14
    mov rax, 2
    cvtsi2sd xmm11, rax
    divsd xmm12, xmm11 ; -- xmm12 = area --
    movsd [area], xmm12

    ;; There was no need for me to store the 'area' and 'perimeter' into
    ;; variables, since the registers holding those values are not being
    ;; reused. I just did it for organizational reasons.

    ;; -- PRINTING FINAL RESULT --
    movsd xmm0, [area]
    movsd xmm1, [perimeter]
    mov rdi, strf_answers
    mov rax, 2
    call printf

    movsd xmm0, [area] ; Returns area to driver
    jmp exit ; Jumps to exit

    ; Entering a negative input will jump to here
    negative_side:
    mov rdi, invalid_input
    call printf
    movsd xmm0, xmm7 ; Put 0 for to return to driver
    jmp exit ; Jumps to exit

    exit:

    popf
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rbp
    ret ;  return
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
