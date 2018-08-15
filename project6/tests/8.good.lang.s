 .data
 printstr: .asciz "%d\n"
 .text
 .globl Main_main
 Main_main:
 push %ebp
 mov %esp, %ebp
  sub $8, %esp
  push $0
  pop %eax
  mov %eax, -4(%ebp)
  push $0
  pop %eax
  mov %eax, -8(%ebp)
  while_start_0:
  push $5
  push -4(%ebp)
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_1
  push $0
  jmp notgreater_1
  greater_1:
  push $1
  notgreater_1:
  pop %edx
  cmp $0, %edx
  je end_while0
  push -8(%ebp)
  push -4(%ebp)
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  push $2
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  push -4(%ebp)
  push $1
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov %eax, -4(%ebp)
  push -8(%ebp)
  push $printstr
  call printf
  add $4, %esp
  jmp while_start_0
  end_while0:
  add $8, %esp
  leave
  ret
