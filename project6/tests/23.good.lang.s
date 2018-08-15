 .data
 printstr: .asciz "%d\n"
 .text
 .globl Main_main
 classA_classA:
 push %ebp
 mov %esp, %ebp
  push 12(%ebp)
  pop %eax
  mov 8(%ebp), %edx
  mov %eax, 0(%edx)
  leave
  ret
 classA_f0:
 push %ebp
 mov %esp, %ebp
  mov 8(%ebp), %edx
  push 0(%edx)
  push $2
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  pop %eax
  mov 8(%ebp), %edx
  mov %eax, 0(%edx)
  leave
  ret
 classB_classB:
 push %ebp
 mov %esp, %ebp
  push 12(%ebp)
  push 8(%ebp)
  call classA_classA
  add $4, %esp
  add $4, %esp
  push %eax
  push 16(%ebp)
  pop %eax
  mov 8(%ebp), %edx
  mov %eax, 4(%edx)
  leave
  ret
 Main_main:
 push %ebp
 mov %esp, %ebp
  sub $4, %esp
  push $8
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $1
  push $12
  push %ecx
  call classB_classB
  add $4, %esp
  add $8, %esp
  pop %eax
  mov %eax, -4(%ebp)
  mov -4(%ebp), %edx
  push 0(%edx)
  push $printstr
  call printf
  add $4, %esp
  mov -4(%ebp), %edx
  push 4(%edx)
  push $printstr
  call printf
  add $4, %esp
  push -4(%ebp)
  call classA_f0
  add $4, %esp
  add $0, %esp
  push %eax
  mov -4(%ebp), %edx
  push 0(%edx)
  push $printstr
  call printf
  add $4, %esp
  mov -4(%ebp), %edx
  push 4(%edx)
  push $printstr
  call printf
  add $4, %esp
  add $4, %esp
  leave
  ret
