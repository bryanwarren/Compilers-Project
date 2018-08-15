 .data
 printstr: .asciz "%d\n"
 .text
 .globl Main_main
 classA_classA:
 push %ebp
 mov %esp, %ebp
  push $0
  pop %eax
  mov 8(%ebp), %edx
  mov %eax, 0(%edx)
  push $0
  pop %eax
  mov 8(%ebp), %edx
  mov %eax, 4(%edx)
  leave
  ret
 classB_classB:
 push %ebp
 mov %esp, %ebp
  push 12(%ebp)
  pop %eax
  mov 8(%ebp), %edx
  mov %eax, 0(%edx)
  push 16(%ebp)
  pop %eax
  mov 8(%ebp), %edx
  mov %eax, 4(%edx)
  leave
  ret
 classB_makeA:
 push %ebp
 mov %esp, %ebp
  sub $4, %esp
  push $8
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push %ecx
  call classA_classA
  add $4, %esp
  pop %eax
  mov %eax, -4(%ebp)
  mov 12(%ebp), %edx
  push 0(%edx)
  mov 8(%ebp), %edx
  push 0(%edx)
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 0(%edx)
  mov 12(%ebp), %edx
  push 4(%edx)
  mov 8(%ebp), %edx
  push 4(%edx)
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 4(%edx)
  push -4(%ebp)
  pop %eax
  add $4, %esp
  leave
  ret
 Main_main:
 push %ebp
 mov %esp, %ebp
  sub $12, %esp
  push $8
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push %ecx
  call classA_classA
  add $4, %esp
  pop %eax
  mov %eax, -4(%ebp)
  push $7
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 0(%edx)
  push $8
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 4(%edx)
  push $8
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $22
  push $16
  push %ecx
  call classB_classB
  add $4, %esp
  add $8, %esp
  pop %eax
  mov %eax, -12(%ebp)
  push -4(%ebp)
  push -12(%ebp)
  call classB_makeA
  add $4, %esp
  add $4, %esp
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
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
  mov -12(%ebp), %edx
  push 0(%edx)
  push $printstr
  call printf
  add $4, %esp
  mov -12(%ebp), %edx
  push 4(%edx)
  push $printstr
  call printf
  add $4, %esp
  mov -8(%ebp), %edx
  push 0(%edx)
  push $printstr
  call printf
  add $4, %esp
  mov -8(%ebp), %edx
  push 4(%edx)
  push $printstr
  call printf
  add $4, %esp
  add $12, %esp
  leave
  ret
