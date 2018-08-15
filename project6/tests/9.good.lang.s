 .data
 printstr: .asciz "%d\n"
 .text
 .globl Main_main
 Main_main:
 push %ebp
 mov %esp, %ebp
  sub $12, %esp
  push $0
  pop %eax
  mov %eax, -4(%ebp)
  push $1
  pop %eax
  mov %eax, -8(%ebp)
  push $0
  pop %eax
  mov %eax, -12(%ebp)
  while_start_0:
  push $8
  push -4(%ebp)
  pop %ebx
  pop %eax
  cmp %ebx, %eax
  jge greatequal_1
  push $0
  jmp notgreatequal_1
  greatequal_1:
  push $1
  notgreatequal_1:
  pop %edx
  cmp $0, %edx
  je end_while0
  push -4(%ebp)
  push -4(%ebp)
  push $2
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  push $2
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  push $0
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_2
  push $0
  jmp notgreater_2
  greater_2:
  push $1
  notgreater_2:
  pop %eax
  mov %eax, -12(%ebp)
  push -4(%ebp)
  push $1
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov %eax, -4(%ebp)
  push -12(%ebp)
  pop %edx
  cmp $0, %edx
  je skip_if_3
  push -8(%ebp)
  push $2
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  jmp skip_else_3
  skip_if_3:
  push -8(%ebp)
  push $1
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  skip_else_3:
  push -8(%ebp)
  push $printstr
  call printf
  add $4, %esp
  jmp while_start_0
  end_while0:
  add $12, %esp
  leave
  ret
