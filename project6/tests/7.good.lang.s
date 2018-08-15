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
  push $1
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov %eax, -4(%ebp)
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
  push $0
  push $printstr
  call printf
  add $4, %esp
  jmp skip_else_1
  skip_if_1:
  push $1
  push $printstr
  call printf
  add $4, %esp
  skip_else_1:
  push -4(%ebp)
  push $2
  pop %edx
  pop %eax
  cmp %edx, %eax
  je equal_2
  push $0
  jmp notequal_2
  equal_2:
  push $1
  notequal_2:
  pop %edx
  cmp $0, %edx
  je skip_if_3
  push $2
  push $printstr
  call printf
  add $4, %esp
  jmp skip_else_3
  skip_if_3:
  push $3
  push $printstr
  call printf
  add $4, %esp
  skip_else_3:
  push $3
  push -4(%ebp)
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_4
  push $0
  jmp notgreater_4
  greater_4:
  push $1
  notgreater_4:
  push $3
  push -8(%ebp)
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_5
  push $0
  jmp notgreater_5
  greater_5:
  push $1
  notgreater_5:
  pop %edx
  pop %eax
  and %edx, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_6
  push $4
  push $printstr
  call printf
  add $4, %esp
  jmp skip_else_6
  skip_if_6:
  push $5
  push $printstr
  call printf
  add $4, %esp
  skip_else_6:
  push $3
  push -4(%ebp)
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_7
  push $0
  jmp notgreater_7
  greater_7:
  push $1
  notgreater_7:
  push $3
  push -8(%ebp)
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_8
  push $0
  jmp notgreater_8
  greater_8:
  push $1
  notgreater_8:
  pop %edx
  pop %eax
  or %edx, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_9
  push $6
  push $printstr
  call printf
  add $4, %esp
  jmp skip_else_9
  skip_if_9:
  push $7
  push $printstr
  call printf
  add $4, %esp
  skip_else_9:
  add $8, %esp
  leave
  ret
