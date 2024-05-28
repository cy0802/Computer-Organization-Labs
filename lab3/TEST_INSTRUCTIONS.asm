addi x1, x0, 0x100
addi x2, x0, 0x20
sw   x2, 0(x1)
lw   x3, 0(x1)
beq  x2, x3, 0x4    
addi x4, x0, 0x1
and x5 x2 x4
ori x6 x5 32