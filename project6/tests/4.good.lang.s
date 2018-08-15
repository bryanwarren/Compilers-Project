 .data
 printstr: .asciz "%d\n"
 .text
 .globl Main_main
 Main_main:
 push %ebp
 mov %esp, %ebp
  sub $8, %esp
  push $6
  push $4
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov %eax, -4(%ebp)
  push -4(%ebp)
  push $4
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  push $1
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  push -4(%ebp)
  push -8(%ebp)
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
  push $printstr
  call printf
  add $4, %esp
  add $8, %esp
  leave
  ret
