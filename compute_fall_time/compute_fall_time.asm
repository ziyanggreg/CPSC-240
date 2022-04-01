;Author information
;  Author name: Greg Zhang
;  Author email: ziyangz@csu.fullerton.edu
;
;Program information
;  Program name: Compute Free Fall Time
;  Programming languages: One module in C++, one module in X86
;  Date program began: 2022 Mar 28
;  Date of last update: 2022 Mar 31
;  Date of reorganization of comments: 2022 Mar 31
;  Files in this program: compute_fall_time.asm, driver.cpp, r.sh
;  Status: Finished.
;
;Purpose: Assembly file that defines the function fall_time which is used in the driver.cpp
;
;This file
;   File name: compute_fall_time.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -o compute_fall_time.o compute_fall_time.asm
;   Link: g++ -g -m64 -std=c++17 -fno-pie -no-pie -o compute_fall_time.out compute_fall_time.o driver.o

;===== Begin code area ================================================================================================
extern printf
extern scanf
extern fgets
extern stdin
extern strlen

INPUT_LEN equ 128

global fall_time

segment .data
  intro_prompt: db `\nIf errors are discovered please report them to Greg at ziyangz@csu.fullerton.edu for a rapid update.\n`, 0
  name_prompt: db `\nPlease enter your first and last names: `, 0
  job_prompt: db `\nPlease enter your job title (Nurse, Programmer, Gamer, Carpenter, Mechanic, Bus Driver, Barista, Hair Dresser, Acrobat, Farmer, Sales Clerk, etc): `, 0
  thanks_job_prompt: db `\nThank you %s, we appreciate your business.\n`, 0
  understand_prompt: db `\nWe understand that you plan to drop a marble from a high vantage point.\n`, 0
  height_prompt: db `\nPlease enter the height of the marble above ground surface in meters: `, 0
  dform: db "%lf", 0
  gravity: dq 0x402399999999999A ; 9.8
  strf_answer: db `\nThe marble you drop from that height will reach earth after %lf seconds.\n`, 0
  thanks_prompt: db `\nThank you %s for your participation. May you always reach great heights.\n`, 0
  invalid_input1: db `\nAn error was detected in the input data. You may run this program again.\n`, 0
  invalid_input2: db `\nThank you %s for your participation. May you never lose sight of the goal.\n`, 0

segment .bss
  user_name: resb INPUT_LEN
  user_job_title: resb INPUT_LEN

segment .text
fall_time:
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

  ; Print name_prompt
  mov rdi, name_prompt
  call printf

  ; Input customer's name
  mov rdi, user_name
  mov rsi, INPUT_LEN
  mov rdx, [stdin]
  call fgets
  ; Remove trailing \n in user_name from input <enter>
  mov rax, 0
  mov rdi, user_name
  call strlen ; rax = length of string in rdi
  sub rax, 1 ; index of final character (\n)
  mov byte [user_name + rax], 0

  ; Print job_prompt
  mov rdi, job_prompt
  call printf

  ; Input customer job
  mov rdi, user_job_title
  mov rsi, INPUT_LEN
  mov rdx, [stdin]
  call fgets
  ; Remove trailing \n in user_job_title from input <enter>
  mov rax, 0
  mov rdi, user_job_title
  call strlen
  sub rax, 1
  mov byte [user_job_title + rax], 0

  ; Print thanks_job_prompt
  mov rsi, user_job_title
  mov rdi, thanks_job_prompt
  call printf

  ; Print understand_prompt
  mov rdi, understand_prompt
  call printf

  ; Print prompt for customer drop height
  mov rdi, height_prompt
  call printf

  ; Input drop height
  push qword 0 ; Weird thing where you have to push qword twice for 1 input
  push qword 0
  mov rdi, dform
  mov rsi, rsp
  call scanf

  ; Validate input for everything other than negative
  mov rdi, 0
  cmp rdi, rax
  je invalid
  ; Place height in xmm15 and validate for negative
  movsd xmm15, [rsp] ; Put height into xmm15
  xorpd xmm13, xmm13 ; Put 0.0 into xmm13
  ucomisd xmm13, xmm15 ; Compare height to 0.0
  ja invalid ; Jump to invalid if height < 0.0

  ; Math
  ; -9.8t^2 + height = 0
  ; time = sqrt(2h/9.8)
  mov rax, 2
  cvtsi2sd xmm14, rax ; Convert 2 to float and place into xmm14
  mulsd xmm15, xmm14 ; Multiply 2 into xmm15
  movsd xmm14, [gravity] ; Put 9.8 into xmm14
  divsd xmm15, xmm14 ; Divide (2xHeight) by 9.8 store into xmm15
  sqrtsd xmm15, xmm15 ; xmm15 = final result ; Square root xmm15 and store into xmm15
  pop rax
  pop rax

  ; Print answer
  movsd xmm0, xmm15
  mov rdi, strf_answer
  mov rax, 1
  call printf

  ; Print thanks_prompt
  mov rax, 2
  mov rsi, user_name
  mov rdi, thanks_prompt
  call printf

  movsd xmm0, xmm15 ; returns answer to driver
  jmp exit ; Jumps to exit

  ; Block of code for invalid input
  invalid:
  mov rdi, invalid_input1 ; Print first invalid message
  call printf
  mov rax, 2
  mov rsi, user_name
  mov rdi, invalid_input2 ; Print second invalid message
  call printf
  pop rax
  pop rax
  movsd xmm0, xmm13 ; Return 0 to driver
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
  ret
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
