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
 classA_double:
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
 classB_double:
 push %ebp
 mov %esp, %ebp
  mov 8(%ebp), %edx
  push 4(%edx)
  push $2
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
  mov 8(%ebp), %edx
  mov %eax, 4(%edx)
  leave
  ret
 CastClass_BtoA:
 push %ebp
 mov %esp, %ebp
  push 12(%ebp)
  pop %eax
  leave
  ret
 Main_main:
 push %ebp
 mov %esp, %ebp
  sub $12, %esp
  push $4
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $5
  push $4
  push %ecx
  call classB_classB
  add $4, %esp
  add $8, %esp
  pop %eax
  mov %eax, -4(%ebp)
  push -4(%ebp)
  push -12(%ebp)
  call CastClass_BtoA
  add $4, %esp
  add $4, %esp
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  mov -8(%ebp), %edx
  push 0(%edx)
  push $printstr
  call printf
  add $4, %esp
  mov -4(%ebp), %edx
  push 4(%edx)
  push $printstr
  call printf
  add $4, %esp
  push -8(%ebp)
  call classA_double
  add $4, %esp
  add $0, %esp
  push %eax
  mov -8(%ebp), %edx
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
  call classB_double
  add $4, %esp
  add $0, %esp
  push %eax
  mov -8(%ebp), %edx
  push 0(%edx)
  push $printstr
  call printf
  add $4, %esp
  mov -4(%ebp), %edx
  push 4(%edx)
  push $printstr
  call printf
  add $4, %esp
  add $12, %esp
  leave
  ret
