 .data
 printstr: .asciz "%d\n"
 .text
 .globl Main_main
 classA_f0:
 push %ebp
 mov %esp, %ebp
  sub $8, %esp
  push 12(%ebp)
  push 12(%ebp)
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
  pop %eax
  mov %eax, -8(%ebp)
  push -8(%ebp)
  push $1
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
  push 12(%ebp)
  push 12(%ebp)
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
  mov %eax, -4(%ebp)
  jmp skip_else_1
  skip_if_1:
  push 12(%ebp)
  push $2
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  pop %eax
  mov %eax, -4(%ebp)
  skip_else_1:
  push -4(%ebp)
  pop %eax
  add $8, %esp
  leave
  ret
 classA_doAll:
 push %ebp
 mov %esp, %ebp
  push $5
  push 8(%ebp)
  call classA_f0
  add $4, %esp
  add $4, %esp
  push %eax
  push 8(%ebp)
  call classA_f0
  add $4, %esp
  add $4, %esp
  push %eax
  push 8(%ebp)
  call classA_f0
  add $4, %esp
  add $4, %esp
  push %eax
  push 8(%ebp)
  call classA_f0
  add $4, %esp
  add $4, %esp
  push %eax
  push 8(%ebp)
  call classA_f0
  add $4, %esp
  add $4, %esp
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
