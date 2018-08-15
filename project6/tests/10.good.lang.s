 .data
 printstr: .asciz "%d\n"
 .text
 .globl Main_main
 classA_doAll:
 push %ebp
 mov %esp, %ebp
  push $5
  push $6
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  push $printstr
  call printf
  add $4, %esp
  leave
  ret
 Main_main:
 push %ebp
 mov %esp, %ebp
  sub $4, %esp
  push -4(%ebp)
  call classA_doAll
  add $4, %esp
  add $0, %esp
  push %eax
  add $4, %esp
  leave
  ret
