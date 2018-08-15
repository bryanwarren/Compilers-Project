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
 classB_classB:
 push %ebp
 mov %esp, %ebp
  push $1
  pop %eax
  mov 8(%ebp), %edx
  mov %eax, 0(%edx)
  leave
  ret
 classB_fib:
 push %ebp
 mov %esp, %ebp
  sub $4, %esp
  mov 8(%ebp), %edx
  push 0(%edx)
  pop %eax
  mov %eax, -4(%ebp)
  mov 8(%ebp), %edx
  push 0(%edx)
  mov 12(%ebp), %edx
  push 0(%edx)
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov 8(%ebp), %edx
  mov %eax, 0(%edx)
  mov 8(%ebp), %edx
  push 0(%edx)
  push $printstr
  call printf
  add $4, %esp
  push $4
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push -4(%ebp)
  push %ecx
  call classA_classA
  add $4, %esp
  add $4, %esp
  pop %eax
  add $4, %esp
  leave
  ret
 classB_dofib:
 push %ebp
 mov %esp, %ebp
  push $1
  push $printstr
  call printf
  add $4, %esp
  push $1
  push $printstr
  call printf
  add $4, %esp
  push $4
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $1
  push %ecx
  call classA_classA
  add $4, %esp
  add $4, %esp
  push 8(%ebp)
  call classB_fib
  add $4, %esp
  add $4, %esp
  push %eax
  push 8(%ebp)
  call classB_fib
  add $4, %esp
  add $4, %esp
  push %eax
  push 8(%ebp)
  call classB_fib
  add $4, %esp
  add $4, %esp
  push %eax
  push 8(%ebp)
  call classB_fib
  add $4, %esp
  add $4, %esp
  push %eax
  push 8(%ebp)
  call classB_fib
  add $4, %esp
  add $4, %esp
  push %eax
  push 8(%ebp)
  call classB_fib
  add $4, %esp
  add $4, %esp
  push %eax
  push 8(%ebp)
  call classB_fib
  add $4, %esp
  add $4, %esp
  push %eax
  push 8(%ebp)
  call classB_fib
  add $4, %esp
  add $4, %esp
  push %eax
  leave
  ret
 Main_main:
 push %ebp
 mov %esp, %ebp
  sub $4, %esp
  push $4
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push %ecx
  call classB_classB
  add $4, %esp
  pop %eax
  mov %eax, -4(%ebp)
  push -4(%ebp)
  call classB_dofib
  add $4, %esp
  add $0, %esp
  push %eax
  add $4, %esp
  leave
  ret
