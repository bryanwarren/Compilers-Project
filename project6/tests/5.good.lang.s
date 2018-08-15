 .data
 printstr: .asciz "%d\n"
 .text
 .globl Main_main
 Main_main:
 push %ebp
 mov %esp, %ebp
  sub $12, %esp
  push $1
  push $2
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  push $3
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  push $4
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  push $5
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov %eax, -4(%ebp)
  push -4(%ebp)
  push -4(%ebp)
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  push -4(%ebp)
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  push $5
  push -4(%ebp)
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  push $5
  push -4(%ebp)
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov %eax, -12(%ebp)
  push -12(%ebp)
  push $1
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  push -12(%ebp)
  push $1
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  push $2
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  pop %eax
  mov %eax, -4(%ebp)
  push -4(%ebp)
  push -4(%ebp)
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  push $100
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  push -8(%ebp)
  push -4(%ebp)
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  push -8(%ebp)
  push -4(%ebp)
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  pop %eax
  mov %eax, -12(%ebp)
  push -4(%ebp)
  push $printstr
  call printf
  add $4, %esp
  push -8(%ebp)
  push $printstr
  call printf
  add $4, %esp
  push -12(%ebp)
  push $printstr
  call printf
  add $4, %esp
  add $12, %esp
  leave
  ret
