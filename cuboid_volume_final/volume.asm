; CONTACT INFO:
; AUTHOR: Greg Zhang
; Email: ziyangz@csu.fullerton.edu

extern printf
extern scanf
extern cos
extern sin

;; constants (EQU)

global cube_volume

segment .data
intro_prompt: db `\nHere at Cuboid Inc. we know your volume.\n`, 0
name_prompt: db "Please enter your name: ", 0
form3: db "%lf %lf %lf", 0
int_form: db "%ld", 0
time_message: db `\nThe time is now %ld tics\n`, 0
total_time_message: db `\nThe run time was %ld tics.\n`, 0
input_prompt: db `\nPlease enter length, width, and height as float numbers separated by ws:\n`, 0
strf_answers: db `\nThank you. Your volume is %.2lf square units\n`, 0

segment .bss
volume: resq 1

segment .text
cube_volume:
    ; 16 pushes
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

    ; Get tics at start
    cpuid
    rdtsc
    shl rax, 32
    add rdx, rax
    mov r14, rdx ; stored in r14

    ; Print tics at start
    push qword 0
    mov rax, 0
    mov rdi, time_message
    mov rsi, r14
    call printf
    pop rax

    ; print input prompt
    mov rdi, input_prompt
    call printf

    ; get user 3 inputs (floats)
    push qword 0
    push qword 0
    push qword 0
    push qword 0
    mov rdi, form3
    ; length
    mov rsi, rsp
    ; width
    mov rdx, rsp
    add rdx, 8
    ; height
    mov rcx, rsp
    add rcx, 16
    call scanf

    ; Place values into XMM registers
    ; length
    movsd xmm15, [rsp]
    pop rax
    ; width
    movsd xmm14, [rsp]
    pop rax
    ; height
    movsd xmm13, [rsp]
    pop rax
    pop rax

    ; Calculate volume
    ; volume = length x width x height
    ; volume = xmm13 x xmm14 x xmm15
    movsd xmm0, xmm13
    movsd xmm12, xmm0
    mulsd xmm12, xmm15
    mulsd xmm12, xmm14
    mov rax, 2
    cvtsi2sd xmm11, rax
    movsd [volume], xmm12

    ; Print volume
    movsd xmm0, [volume]
    mov rdi, strf_answers
    mov rax, 1
    call printf

    ; Get tics at end
    cpuid
    rdtsc
    shl rax, 32
    add rdx, rax
    mov r13, rdx ; stored in r13

    ; Print tics at end
    push qword 0
    mov rax, 0
    mov rdi, time_message
    mov rsi, r13
    call printf
    pop rax

    ; Calculate total run time
    ; r13 (end) - r14 (start)
    sub r13, r14
    ; Print run time in tics
    push qword 0
    mov rax, 0
    mov rdi, total_time_message
    mov rsi, r13
    call printf
    pop rax

    ; return volume to cube.cpp
    movsd xmm0, [volume]

    ;16 pops
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
    ret
