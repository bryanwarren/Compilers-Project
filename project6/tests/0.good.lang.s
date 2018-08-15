 .data
 printstr: .asciz "%d\n"
 .text
 .globl Main_main
 Main_main:
 push %ebp
 mov %esp, %ebp
  push $6
  push $printstr
  call printf
  add $4, %esp
  leave
  ret
