 .data
 printstr: .asciz "%d\n"
 .text
 .globl Main_main
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
  pop %eax
  mov %eax, -4(%ebp)
  push $2
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 0(%edx)
  push $3
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 4(%edx)
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
  push $0
  pop %eax
  mov %eax, -8(%ebp)
 do_while_start_0:
  push -4(%ebp)
  call classA_inc
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
  push -8(%ebp)
  push $1
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  push $5
  push -8(%ebp)
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
 je end_dowhile0
 jmp do_while_start_0
 end_dowhile0:
  add $8, %esp
  leave
  ret
