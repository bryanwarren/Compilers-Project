 .data
 printstr: .asciz "%d\n"
 .text
 .globl Main_main
 classA_f0:
 push %ebp
 mov %esp, %ebp
  sub $4, %esp
  push 16(%ebp)
  pop %edx
  cmp $0, %edx
  je skip_if_0
  push 12(%ebp)
  push 12(%ebp)
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  pop %eax
  mov %eax, -4(%ebp)
  jmp skip_else_0
  skip_if_0:
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
  skip_else_0:
  push -4(%ebp)
  pop %eax
  add $4, %esp
  leave
  ret
 classA_doAll:
 push %ebp
 mov %esp, %ebp
  push $1
  push $5
  push 8(%ebp)
  call classA_f0
  add $4, %esp
  add $8, %esp
  push %eax
  push $printstr
  call printf
  add $4, %esp
  push $0
  push $6
  push 8(%ebp)
  call classA_f0
  add $4, %esp
  add $8, %esp
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
