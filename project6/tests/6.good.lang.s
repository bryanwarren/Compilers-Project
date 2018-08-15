 .data
 printstr: .asciz "%d\n"
 .text
 .globl Main_main
 Main_main:
 push %ebp
 mov %esp, %ebp
  sub $8, %esp
  push $1
  pop %eax
  mov %eax, -4(%ebp)
  push -4(%ebp)
  push $1
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  push -8(%ebp)
  push $2
  pop %edx
  pop %eax
  cmp %edx, %eax
  je equal_0
  push $0
  jmp notequal_0
  equal_0:
  push $1
  notequal_0:
  pop %edx
  cmp $0, %edx
  je skip_if_1
  push $1
  push $printstr
  call printf
  add $4, %esp
  jmp skip_else_1
  skip_if_1:
  skip_else_1:
  push $0
  push $printstr
  call printf
  add $4, %esp
  add $8, %esp
  leave
  ret
