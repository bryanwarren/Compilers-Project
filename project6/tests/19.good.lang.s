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
  push 16(%ebp)
  pop %eax
  mov 8(%ebp), %edx
  mov %eax, 4(%edx)
  leave
  ret
 classA_inc:
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
  mov 8(%ebp), %edx
  push 4(%edx)
  push $1
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov 8(%ebp), %edx
  mov %eax, 4(%edx)
  leave
  ret
 Main_main:
 push %ebp
 mov %esp, %ebp
  sub $8, %esp
  push $8
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $4
  push $3
  push %ecx
  call classA_classA
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
  call classA_inc
  add $4, %esp
  add $0, %esp
  push %eax
  mov -4(%ebp), %edx
  push 0(%edx)
  mov -4(%ebp), %edx
  push 4(%edx)
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  push $printstr
  call printf
  add $4, %esp
  add $8, %esp
  leave
  ret
