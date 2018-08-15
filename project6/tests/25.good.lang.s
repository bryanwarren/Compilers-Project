 .data
 printstr: .asciz "%d\n"
 .text
 .globl Main_main
 Float_Float:
 push %ebp
 mov %esp, %ebp
  push 12(%ebp)
  pop %eax
  mov 8(%ebp), %edx
  mov %eax, 0(%edx)
  push 16(%ebp)
  push $127
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov 8(%ebp), %edx
  mov %eax, 4(%edx)
  push 20(%ebp)
  pop %eax
  mov 8(%ebp), %edx
  mov %eax, 8(%edx)
  leave
  ret
 Float_printval:
 push %ebp
 mov %esp, %ebp
  mov 8(%ebp), %edx
  push 0(%edx)
  push $printstr
  call printf
  add $4, %esp
  mov 8(%ebp), %edx
  push 4(%edx)
  push $127
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  push $printstr
  call printf
  add $4, %esp
  mov 8(%ebp), %edx
  push 8(%edx)
  push $printstr
  call printf
  add $4, %esp
  leave
  ret
 Float_copy:
 push %ebp
 mov %esp, %ebp
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  mov 8(%ebp), %edx
  push 8(%edx)
  mov 8(%ebp), %edx
  push 4(%edx)
  push $127
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  mov 8(%ebp), %edx
  push 0(%edx)
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  leave
  ret
 FloatOps_add:
 push %ebp
 mov %esp, %ebp
  sub $20, %esp
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $0
  push $0
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -12(%ebp)
  mov 16(%ebp), %edx
  push 4(%edx)
  mov 12(%ebp), %edx
  push 4(%edx)
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_0
  push $0
  jmp notgreater_0
  greater_0:
  push $1
  notgreater_0:
  pop %edx
  cmp $0, %edx
  je skip_if_1
  push 16(%ebp)
  call Float_copy
  add $4, %esp
  add $0, %esp
  push %eax
  pop %eax
  mov %eax, -4(%ebp)
  push 12(%ebp)
  call Float_copy
  add $4, %esp
  add $0, %esp
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  jmp skip_else_1
  skip_if_1:
  push 12(%ebp)
  call Float_copy
  add $4, %esp
  add $0, %esp
  push %eax
  pop %eax
  mov %eax, -4(%ebp)
  push 16(%ebp)
  call Float_copy
  add $4, %esp
  add $0, %esp
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  skip_else_1:
  mov -4(%ebp), %edx
  push 4(%edx)
  mov -8(%ebp), %edx
  push 4(%edx)
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov %eax, -16(%ebp)
  push $8388608
  mov -4(%ebp), %edx
  push 8(%edx)
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 8(%edx)
  push $8388608
  mov -8(%ebp), %edx
  push 8(%edx)
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov -8(%ebp), %edx
  mov %eax, 8(%edx)
  mov -4(%ebp), %edx
  push 0(%edx)
  pop %edx
  cmp $0, %edx
  je skip_if_2
  push $1
  pop %eax
  neg %eax
  push %eax
  mov -4(%ebp), %edx
  push 8(%edx)
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 8(%edx)
  jmp skip_else_2
  skip_if_2:
  skip_else_2:
  mov -8(%ebp), %edx
  push 0(%edx)
  pop %edx
  cmp $0, %edx
  je skip_if_3
  push $1
  pop %eax
  neg %eax
  push %eax
  mov -8(%ebp), %edx
  push 8(%edx)
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  pop %eax
  mov -8(%ebp), %edx
  mov %eax, 8(%edx)
  jmp skip_else_3
  skip_if_3:
  skip_else_3:
  push -16(%ebp)
  pop %eax
  mov %eax, -20(%ebp)
  while_start_4:
  push -20(%ebp)
  push $0
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_5
  push $0
  jmp notgreater_5
  greater_5:
  push $1
  notgreater_5:
  pop %edx
  cmp $0, %edx
  je end_while4
  push -20(%ebp)
  push $1
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov %eax, -20(%ebp)
  mov -8(%ebp), %edx
  push 8(%edx)
  push $2
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  pop %eax
  mov -8(%ebp), %edx
  mov %eax, 8(%edx)
  jmp while_start_4
  end_while4:
  mov -4(%ebp), %edx
  push 8(%edx)
  mov -8(%ebp), %edx
  push 8(%edx)
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov -12(%ebp), %edx
  mov %eax, 8(%edx)
  mov -4(%ebp), %edx
  push 4(%edx)
  pop %eax
  mov -12(%ebp), %edx
  mov %eax, 4(%edx)
  push $0
  mov -12(%ebp), %edx
  push 8(%edx)
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_6
  push $0
  jmp notgreater_6
  greater_6:
  push $1
  notgreater_6:
  pop %edx
  cmp $0, %edx
  je skip_if_7
  push $1
  pop %eax
  neg %eax
  push %eax
  mov -12(%ebp), %edx
  push 8(%edx)
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  pop %eax
  mov -12(%ebp), %edx
  mov %eax, 8(%edx)
  push $1
  pop %eax
  mov -12(%ebp), %edx
  mov %eax, 0(%edx)
  jmp skip_else_7
  skip_if_7:
  push $0
  pop %eax
  mov -12(%ebp), %edx
  mov %eax, 0(%edx)
  skip_else_7:
  mov -12(%ebp), %edx
  push 8(%edx)
  push $0
  pop %edx
  pop %eax
  cmp %edx, %eax
  je equal_8
  push $0
  jmp notequal_8
  equal_8:
  push $1
  notequal_8:
  pop %eax
  xor $1, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_9
  while_start_10:
  push $8388608
  mov -12(%ebp), %edx
  push 8(%edx)
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_11
  push $0
  jmp notgreater_11
  greater_11:
  push $1
  notgreater_11:
  pop %edx
  cmp $0, %edx
  je end_while10
  mov -12(%ebp), %edx
  push 8(%edx)
  push $2
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  pop %eax
  mov -12(%ebp), %edx
  mov %eax, 8(%edx)
  mov -12(%ebp), %edx
  push 4(%edx)
  push $1
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov -12(%ebp), %edx
  mov %eax, 4(%edx)
  jmp while_start_10
  end_while10:
  while_start_12:
  mov -12(%ebp), %edx
  push 8(%edx)
  push $16777216
  pop %ebx
  pop %eax
  cmp %ebx, %eax
  jge greatequal_13
  push $0
  jmp notgreatequal_13
  greatequal_13:
  push $1
  notgreatequal_13:
  pop %edx
  cmp $0, %edx
  je end_while12
  mov -12(%ebp), %edx
  push 8(%edx)
  push $2
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  pop %eax
  mov -12(%ebp), %edx
  mov %eax, 8(%edx)
  mov -12(%ebp), %edx
  push 4(%edx)
  push $1
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov -12(%ebp), %edx
  mov %eax, 4(%edx)
  jmp while_start_12
  end_while12:
  mov -12(%ebp), %edx
  push 8(%edx)
  push $8388608
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov -12(%ebp), %edx
  mov %eax, 8(%edx)
  jmp skip_else_9
  skip_if_9:
  push $0
  pop %eax
  mov -12(%ebp), %edx
  mov %eax, 4(%edx)
  skip_else_9:
  push -12(%ebp)
  pop %eax
  add $20, %esp
  leave
  ret
 FloatOps_sub:
 push %ebp
 mov %esp, %ebp
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  mov 16(%ebp), %edx
  push 8(%edx)
  mov 16(%ebp), %edx
  push 4(%edx)
  push $127
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  mov 16(%ebp), %edx
  push 0(%edx)
  pop %eax
  xor $1, %eax
  push %eax
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  push 12(%ebp)
  push 8(%ebp)
  call FloatOps_add
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  leave
  ret
 FloatOps_mult:
 push %ebp
 mov %esp, %ebp
  sub $32, %esp
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $0
  push $0
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -4(%ebp)
  mov 12(%ebp), %edx
  push 4(%edx)
  push $0
  pop %edx
  pop %eax
  cmp %edx, %eax
  je equal_14
  push $0
  jmp notequal_14
  equal_14:
  push $1
  notequal_14:
  mov 12(%ebp), %edx
  push 8(%edx)
  push $0
  pop %edx
  pop %eax
  cmp %edx, %eax
  je equal_15
  push $0
  jmp notequal_15
  equal_15:
  push $1
  notequal_15:
  pop %edx
  pop %eax
  and %edx, %eax
  push %eax
  mov 16(%ebp), %edx
  push 4(%edx)
  push $0
  pop %edx
  pop %eax
  cmp %edx, %eax
  je equal_16
  push $0
  jmp notequal_16
  equal_16:
  push $1
  notequal_16:
  mov 16(%ebp), %edx
  push 8(%edx)
  push $0
  pop %edx
  pop %eax
  cmp %edx, %eax
  je equal_17
  push $0
  jmp notequal_17
  equal_17:
  push $1
  notequal_17:
  pop %edx
  pop %eax
  and %edx, %eax
  push %eax
  pop %edx
  pop %eax
  or %edx, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_18
  push $0
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 0(%edx)
  push $0
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 4(%edx)
  push $0
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 8(%edx)
  jmp skip_else_18
  skip_if_18:
  mov 12(%ebp), %edx
  push 0(%edx)
  mov 16(%ebp), %edx
  push 0(%edx)
  pop %edx
  pop %eax
  or %edx, %eax
  push %eax
  mov 12(%ebp), %edx
  push 0(%edx)
  mov 16(%ebp), %edx
  push 0(%edx)
  pop %edx
  pop %eax
  and %edx, %eax
  push %eax
  pop %eax
  xor $1, %eax
  push %eax
  pop %edx
  pop %eax
  and %edx, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_19
  push $1
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 0(%edx)
  jmp skip_else_19
  skip_if_19:
  push $0
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 0(%edx)
  skip_else_19:
  mov 12(%ebp), %edx
  push 4(%edx)
  mov 16(%ebp), %edx
  push 4(%edx)
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  push $127
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 4(%edx)
  mov 12(%ebp), %edx
  push 8(%edx)
  push $8388608
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov 12(%ebp), %edx
  mov %eax, 8(%edx)
  mov 16(%ebp), %edx
  push 8(%edx)
  push $8388608
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov 16(%ebp), %edx
  mov %eax, 8(%edx)
  mov 12(%ebp), %edx
  push 8(%edx)
  push $4096
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  pop %eax
  mov %eax, -12(%ebp)
  mov 12(%ebp), %edx
  push 8(%edx)
  push -12(%ebp)
  push $4096
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
  mov %eax, -24(%ebp)
  mov 16(%ebp), %edx
  push 8(%edx)
  push $4096
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  pop %eax
  mov %eax, -16(%ebp)
  mov 16(%ebp), %edx
  push 8(%edx)
  push -16(%ebp)
  push $4096
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
  mov %eax, -28(%ebp)
  push -12(%ebp)
  push -16(%ebp)
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  push -12(%ebp)
  push -28(%ebp)
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  push -16(%ebp)
  push -24(%ebp)
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
  mov %eax, -20(%ebp)
  push -8(%ebp)
  push -20(%ebp)
  push $4096
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  push -20(%ebp)
  push -20(%ebp)
  push $4096
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov %eax, -20(%ebp)
  push -8(%ebp)
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 8(%edx)
  mov -4(%ebp), %edx
  push 4(%edx)
  push $1
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 4(%edx)
  mov -4(%ebp), %edx
  push 8(%edx)
  push $0
  pop %edx
  pop %eax
  cmp %edx, %eax
  je equal_20
  push $0
  jmp notequal_20
  equal_20:
  push $1
  notequal_20:
  pop %eax
  xor $1, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_21
  while_start_22:
  push $8388608
  mov -4(%ebp), %edx
  push 8(%edx)
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_23
  push $0
  jmp notgreater_23
  greater_23:
  push $1
  notgreater_23:
  pop %edx
  cmp $0, %edx
  je end_while22
  mov -4(%ebp), %edx
  push 8(%edx)
  push $2
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 8(%edx)
  mov -4(%ebp), %edx
  push 4(%edx)
  push $1
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 4(%edx)
  mov -4(%ebp), %edx
  push 8(%edx)
  push -20(%ebp)
  push $1024
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 8(%edx)
  push -20(%ebp)
  push -20(%ebp)
  push $1024
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov %eax, -20(%ebp)
  push -20(%ebp)
  push $2
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  pop %eax
  mov %eax, -20(%ebp)
  jmp while_start_22
  end_while22:
  while_start_24:
  mov -4(%ebp), %edx
  push 8(%edx)
  push $16777216
  pop %ebx
  pop %eax
  cmp %ebx, %eax
  jge greatequal_25
  push $0
  jmp notgreatequal_25
  greatequal_25:
  push $1
  notgreatequal_25:
  pop %edx
  cmp $0, %edx
  je end_while24
  mov -4(%ebp), %edx
  push 8(%edx)
  push $2
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 8(%edx)
  mov -4(%ebp), %edx
  push 4(%edx)
  push $1
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 4(%edx)
  jmp while_start_24
  end_while24:
  jmp skip_else_21
  skip_if_21:
  skip_else_21:
  mov -4(%ebp), %edx
  push 8(%edx)
  push $8388608
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 8(%edx)
  mov 12(%ebp), %edx
  push 8(%edx)
  push $8388608
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov 12(%ebp), %edx
  mov %eax, 8(%edx)
  mov 16(%ebp), %edx
  push 8(%edx)
  push $8388608
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov 16(%ebp), %edx
  mov %eax, 8(%edx)
  skip_else_18:
  push -4(%ebp)
  pop %eax
  add $32, %esp
  leave
  ret
 FloatOps_div:
 push %ebp
 mov %esp, %ebp
  sub $4, %esp
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $0
  push $0
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -4(%ebp)
  mov 12(%ebp), %edx
  push 0(%edx)
  mov 16(%ebp), %edx
  push 0(%edx)
  pop %edx
  pop %eax
  or %edx, %eax
  push %eax
  mov 12(%ebp), %edx
  push 0(%edx)
  mov 16(%ebp), %edx
  push 0(%edx)
  pop %edx
  pop %eax
  and %edx, %eax
  push %eax
  pop %eax
  xor $1, %eax
  push %eax
  pop %edx
  pop %eax
  and %edx, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_26
  push $1
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 0(%edx)
  jmp skip_else_26
  skip_if_26:
  push $0
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 0(%edx)
  skip_else_26:
  mov 12(%ebp), %edx
  push 4(%edx)
  mov 16(%ebp), %edx
  push 4(%edx)
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  push $127
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 4(%edx)
  mov 12(%ebp), %edx
  push 8(%edx)
  push $8388608
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov 12(%ebp), %edx
  mov %eax, 8(%edx)
  mov 16(%ebp), %edx
  push 8(%edx)
  push $8388608
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov 16(%ebp), %edx
  mov %eax, 8(%edx)
  mov 12(%ebp), %edx
  push 8(%edx)
  push $128
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  pop %eax
  mov 12(%ebp), %edx
  mov %eax, 8(%edx)
  mov 12(%ebp), %edx
  push 8(%edx)
  mov 16(%ebp), %edx
  push 8(%edx)
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 8(%edx)
  mov -4(%ebp), %edx
  push 4(%edx)
  push $16
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 4(%edx)
  mov 12(%ebp), %edx
  push 8(%edx)
  push $128
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  pop %eax
  mov 12(%ebp), %edx
  mov %eax, 8(%edx)
  mov 12(%ebp), %edx
  push 8(%edx)
  push $8388608
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov 12(%ebp), %edx
  mov %eax, 8(%edx)
  mov 16(%ebp), %edx
  push 8(%edx)
  push $8388608
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov 16(%ebp), %edx
  mov %eax, 8(%edx)
  mov -4(%ebp), %edx
  push 8(%edx)
  push $0
  pop %edx
  pop %eax
  cmp %edx, %eax
  je equal_27
  push $0
  jmp notequal_27
  equal_27:
  push $1
  notequal_27:
  pop %eax
  xor $1, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_28
  while_start_29:
  push $8388608
  mov -4(%ebp), %edx
  push 8(%edx)
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_30
  push $0
  jmp notgreater_30
  greater_30:
  push $1
  notgreater_30:
  pop %edx
  cmp $0, %edx
  je end_while29
  mov -4(%ebp), %edx
  push 8(%edx)
  push $2
  # Times
  pop %edx
  pop %eax
  imul %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 8(%edx)
  mov -4(%ebp), %edx
  push 4(%edx)
  push $1
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 4(%edx)
  jmp while_start_29
  end_while29:
  while_start_31:
  mov -4(%ebp), %edx
  push 8(%edx)
  push $16777216
  pop %ebx
  pop %eax
  cmp %ebx, %eax
  jge greatequal_32
  push $0
  jmp notgreatequal_32
  greatequal_32:
  push $1
  notgreatequal_32:
  pop %edx
  cmp $0, %edx
  je end_while31
  mov -4(%ebp), %edx
  push 8(%edx)
  push $2
  # Divide
  pop %ebx
  pop %eax
  cdq
  idiv %ebx
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 8(%edx)
  mov -4(%ebp), %edx
  push 4(%edx)
  push $1
  # Plus
  pop %edx
  pop %eax
  add %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 4(%edx)
  jmp while_start_31
  end_while31:
  jmp skip_else_28
  skip_if_28:
  skip_else_28:
  mov -4(%ebp), %edx
  push 8(%edx)
  push $8388608
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov -4(%ebp), %edx
  mov %eax, 8(%edx)
  push -4(%ebp)
  pop %eax
  add $4, %esp
  leave
  ret
 FloatOps_lt:
 push %ebp
 mov %esp, %ebp
  sub $8, %esp
  push $0
  pop %eax
  mov %eax, -4(%ebp)
  push $0
  pop %eax
  mov %eax, -8(%ebp)
  mov 12(%ebp), %edx
  push 0(%edx)
  mov 16(%ebp), %edx
  push 0(%edx)
  pop %eax
  xor $1, %eax
  push %eax
  pop %edx
  pop %eax
  and %edx, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_33
  push $1
  pop %eax
  mov %eax, -8(%ebp)
  push $1
  pop %eax
  mov %eax, -4(%ebp)
  jmp skip_else_33
  skip_if_33:
  skip_else_33:
  mov 12(%ebp), %edx
  push 0(%edx)
  pop %eax
  xor $1, %eax
  push %eax
  mov 16(%ebp), %edx
  push 0(%edx)
  pop %edx
  pop %eax
  and %edx, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_34
  push $0
  pop %eax
  mov %eax, -8(%ebp)
  push $1
  pop %eax
  mov %eax, -4(%ebp)
  jmp skip_else_34
  skip_if_34:
  skip_else_34:
  push -4(%ebp)
  pop %eax
  xor $1, %eax
  push %eax
  mov 16(%ebp), %edx
  push 4(%edx)
  mov 12(%ebp), %edx
  push 4(%edx)
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_35
  push $0
  jmp notgreater_35
  greater_35:
  push $1
  notgreater_35:
  pop %edx
  pop %eax
  and %edx, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_36
  push $1
  pop %eax
  mov %eax, -8(%ebp)
  push $1
  pop %eax
  mov %eax, -4(%ebp)
  jmp skip_else_36
  skip_if_36:
  skip_else_36:
  push -4(%ebp)
  pop %eax
  xor $1, %eax
  push %eax
  mov 12(%ebp), %edx
  push 4(%edx)
  mov 16(%ebp), %edx
  push 4(%edx)
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_37
  push $0
  jmp notgreater_37
  greater_37:
  push $1
  notgreater_37:
  pop %edx
  pop %eax
  and %edx, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_38
  push $0
  pop %eax
  mov %eax, -8(%ebp)
  push $1
  pop %eax
  mov %eax, -4(%ebp)
  jmp skip_else_38
  skip_if_38:
  skip_else_38:
  push -4(%ebp)
  pop %eax
  xor $1, %eax
  push %eax
  mov 16(%ebp), %edx
  push 8(%edx)
  mov 12(%ebp), %edx
  push 8(%edx)
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_39
  push $0
  jmp notgreater_39
  greater_39:
  push $1
  notgreater_39:
  pop %edx
  pop %eax
  and %edx, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_40
  push $1
  pop %eax
  mov %eax, -8(%ebp)
  jmp skip_else_40
  skip_if_40:
  skip_else_40:
  push -4(%ebp)
  pop %eax
  xor $1, %eax
  push %eax
  mov 12(%ebp), %edx
  push 8(%edx)
  mov 16(%ebp), %edx
  push 8(%edx)
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_41
  push $0
  jmp notgreater_41
  greater_41:
  push $1
  notgreater_41:
  pop %edx
  pop %eax
  and %edx, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_42
  push $0
  pop %eax
  mov %eax, -8(%ebp)
  jmp skip_else_42
  skip_if_42:
  skip_else_42:
  mov 12(%ebp), %edx
  push 0(%edx)
  mov 16(%ebp), %edx
  push 0(%edx)
  pop %edx
  pop %eax
  and %edx, %eax
  push %eax
  pop %edx
  cmp $0, %edx
  je skip_if_43
  push -8(%ebp)
  pop %eax
  xor $1, %eax
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  jmp skip_else_43
  skip_if_43:
  skip_else_43:
  push -8(%ebp)
  pop %eax
  add $8, %esp
  leave
  ret
 FloatOps_exp:
 push %ebp
 mov %esp, %ebp
  sub $48, %esp
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $3012692
  push $1
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -12(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $0
  push $0
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -16(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $0
  push $0
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -20(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $0
  push $0
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -28(%ebp)
  push 12(%ebp)
  call Float_copy
  add $4, %esp
  add $0, %esp
  push %eax
  pop %eax
  mov %eax, -24(%ebp)
  mov -24(%ebp), %edx
  push 0(%edx)
  pop %edx
  cmp $0, %edx
  je skip_if_44
  push $0
  pop %eax
  mov -24(%ebp), %edx
  mov %eax, 0(%edx)
  jmp skip_else_44
  skip_if_44:
  skip_else_44:
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $0
  push $1
  pop %eax
  neg %eax
  push %eax
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -32(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $2796203
  push $2
  pop %eax
  neg %eax
  push %eax
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -36(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $0
  push $2
  pop %eax
  neg %eax
  push %eax
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -40(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $5033165
  push $3
  pop %eax
  neg %eax
  push %eax
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -44(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $2796203
  push $3
  pop %eax
  neg %eax
  push %eax
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -48(%ebp)
  while_start_45:
  push -24(%ebp)
  push -16(%ebp)
  push 8(%ebp)
  call FloatOps_lt
  add $4, %esp
  add $8, %esp
  push %eax
  pop %edx
  cmp $0, %edx
  je end_while45
  push -12(%ebp)
  push -20(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -20(%ebp)
  push -16(%ebp)
  push -24(%ebp)
  push 8(%ebp)
  call FloatOps_sub
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -24(%ebp)
  jmp while_start_45
  end_while45:
  push -24(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -48(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -16(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_add
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -24(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -44(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -16(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_add
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -24(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -40(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -16(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_add
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -24(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -36(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -16(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_add
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -24(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -32(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -16(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_add
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -24(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -16(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_add
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  push -20(%ebp)
  push -28(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  mov 12(%ebp), %edx
  push 0(%edx)
  pop %edx
  cmp $0, %edx
  je skip_if_46
  push -28(%ebp)
  push -16(%ebp)
  push 8(%ebp)
  call FloatOps_div
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -28(%ebp)
  jmp skip_else_46
  skip_if_46:
  skip_else_46:
  push -28(%ebp)
  pop %eax
  add $48, %esp
  leave
  ret
 FloatOps_ln:
 push %ebp
 mov %esp, %ebp
  sub $40, %esp
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $3240472
  push $1
  pop %eax
  neg %eax
  push %eax
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -4(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $0
  push $0
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -36(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $0
  push $1
  pop %eax
  neg %eax
  push %eax
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -20(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $2796203
  push $1
  pop %eax
  neg %eax
  push %eax
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -24(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $4194304
  push $1
  pop %eax
  neg %eax
  push %eax
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -28(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $5033165
  push $1
  pop %eax
  neg %eax
  push %eax
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -32(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $0
  push $127
  pop %eax
  neg %eax
  push %eax
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -12(%ebp)
  mov 12(%ebp), %edx
  push 4(%edx)
  push $127
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov %eax, -40(%ebp)
  while_start_47:
  push -40(%ebp)
  push $0
  pop %edx
  pop %eax
  cmp %edx, %eax
  jg greater_48
  push $0
  jmp notgreater_48
  greater_48:
  push $1
  notgreater_48:
  pop %edx
  cmp $0, %edx
  je end_while47
  push -36(%ebp)
  push -12(%ebp)
  push 8(%ebp)
  call FloatOps_add
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -12(%ebp)
  push -40(%ebp)
  push $1
  # Minus
  pop %edx
  pop %eax
  sub %edx, %eax
  push %eax
  pop %eax
  mov %eax, -40(%ebp)
  jmp while_start_47
  end_while47:
  push -4(%ebp)
  push -12(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -12(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  mov 12(%ebp), %edx
  push 8(%edx)
  push $0
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -8(%ebp)
  push -36(%ebp)
  push -8(%ebp)
  push 8(%ebp)
  call FloatOps_sub
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -8(%ebp)
  push -32(%ebp)
  push -8(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -16(%ebp)
  push -16(%ebp)
  push -36(%ebp)
  push 8(%ebp)
  call FloatOps_add
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -16(%ebp)
  push -8(%ebp)
  push -16(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -16(%ebp)
  push -28(%ebp)
  push -16(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -16(%ebp)
  push -16(%ebp)
  push -36(%ebp)
  push 8(%ebp)
  call FloatOps_sub
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -16(%ebp)
  push -8(%ebp)
  push -16(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -16(%ebp)
  push -24(%ebp)
  push -16(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -16(%ebp)
  push -16(%ebp)
  push -36(%ebp)
  push 8(%ebp)
  call FloatOps_add
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -16(%ebp)
  push -8(%ebp)
  push -16(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -16(%ebp)
  push -20(%ebp)
  push -16(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -16(%ebp)
  push -16(%ebp)
  push -36(%ebp)
  push 8(%ebp)
  call FloatOps_sub
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -16(%ebp)
  push -8(%ebp)
  push -16(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -16(%ebp)
  push -16(%ebp)
  push -12(%ebp)
  push 8(%ebp)
  call FloatOps_add
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  add $40, %esp
  leave
  ret
 FloatOps_pow:
 push %ebp
 mov %esp, %ebp
  push 12(%ebp)
  push 8(%ebp)
  call FloatOps_ln
  add $4, %esp
  add $4, %esp
  push %eax
  push 16(%ebp)
  push 8(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  push 8(%ebp)
  call FloatOps_exp
  add $4, %esp
  add $4, %esp
  push %eax
  pop %eax
  leave
  ret
 Main_main:
 push %ebp
 mov %esp, %ebp
  sub $36, %esp
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $4194304
  push $0
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -4(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $4613734
  push $2
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -8(%ebp)
  push -8(%ebp)
  push -4(%ebp)
  push -16(%ebp)
  call FloatOps_add
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -12(%ebp)
  push -12(%ebp)
  call Float_printval
  add $4, %esp
  add $0, %esp
  push %eax
  push -8(%ebp)
  push -4(%ebp)
  push -16(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -12(%ebp)
  push -12(%ebp)
  call Float_printval
  add $4, %esp
  add $0, %esp
  push %eax
  push -8(%ebp)
  push -4(%ebp)
  push -16(%ebp)
  call FloatOps_div
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -12(%ebp)
  push -12(%ebp)
  call Float_printval
  add $4, %esp
  add $0, %esp
  push %eax
  push -8(%ebp)
  push -16(%ebp)
  call FloatOps_exp
  add $4, %esp
  add $4, %esp
  push %eax
  pop %eax
  mov %eax, -12(%ebp)
  push -12(%ebp)
  call Float_printval
  add $4, %esp
  add $0, %esp
  push %eax
  push -8(%ebp)
  push -16(%ebp)
  call FloatOps_ln
  add $4, %esp
  add $4, %esp
  push %eax
  pop %eax
  mov %eax, -12(%ebp)
  push -12(%ebp)
  call Float_printval
  add $4, %esp
  add $0, %esp
  push %eax
  push -8(%ebp)
  push -4(%ebp)
  push -16(%ebp)
  call FloatOps_pow
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -12(%ebp)
  push -12(%ebp)
  call Float_printval
  add $4, %esp
  add $0, %esp
  push %eax
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $0
  push $0
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -20(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $754975
  push $0
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -24(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $786432
  push $5
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -28(%ebp)
  push $12
  call malloc
  add $4, %esp
  push %eax
  mov %eax, %ecx
  push $1851392
  push $12
  push $0
  push %ecx
  call Float_Float
  add $4, %esp
  add $12, %esp
  pop %eax
  mov %eax, -32(%ebp)
  push -24(%ebp)
  push -20(%ebp)
  push -16(%ebp)
  call FloatOps_sub
  add $4, %esp
  add $8, %esp
  push %eax
  push -28(%ebp)
  push -24(%ebp)
  push -16(%ebp)
  call FloatOps_pow
  add $4, %esp
  add $8, %esp
  push %eax
  push -20(%ebp)
  push -16(%ebp)
  call FloatOps_sub
  add $4, %esp
  add $8, %esp
  push %eax
  push -16(%ebp)
  call FloatOps_div
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -36(%ebp)
  push -32(%ebp)
  push -36(%ebp)
  push -16(%ebp)
  call FloatOps_mult
  add $4, %esp
  add $8, %esp
  push %eax
  pop %eax
  mov %eax, -36(%ebp)
  push -36(%ebp)
  call Float_printval
  add $4, %esp
  add $0, %esp
  push %eax
  add $36, %esp
  leave
  ret
