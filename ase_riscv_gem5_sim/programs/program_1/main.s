.section .data

k: .word 30 # vector length

# inputs
.align 2
i:
    .float  0.72, -0.31,  0.45,  0.18, -0.91
    .float  0.63,  0.27, -0.54,  0.82, -0.16
    .float  0.39, -0.68,  0.11,  0.57, -0.43
    .float  0.94, -0.22,  0.36, -0.77,  0.29
    .float -0.15,  0.51,  0.67, -0.38,  0.83
    .float  0.24, -0.59,  0.41,  0.08, -0.87

# weights
.align 2
w:
    .float  0.12, -0.07,  0.21, -0.15,  0.09
    .float -0.18,  0.05,  0.14, -0.11,  0.08
    .float  0.17, -0.13,  0.06,  0.19, -0.04
    .float -0.09,  0.16, -0.12,  0.07,  0.11
    .float -0.05,  0.13,  0.18, -0.10,  0.04
    .float  0.15, -0.08,  0.10, -0.14,  0.06

b: .float 0.32 # bias
x: .float 0.00 # middle output
y: .float 0.00 # output

# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:

# x = \sum_{j = 0}^{K - 1} (i_j \cdot w_j) + b
# y = f(x) with:
# f(x) = 
#        0      if (exponent_part(x) == 0x7f) or (x == 0)
#        1 / x  otherwise

Setup_loop_i:
    la t0, k
    lw t0, 0(t0) # t0 is vector length
    li t1, 0 # t1 is iteration variable
    
    la t2, i # t2 is i vector
    la t3, w # t3 is w vector
    
    fcvt.s.w ft0, x0 # ft0 is output

Loop_i:
    flw ft1, 0(t2) # ft1 is i value
    flw ft2, 0(t3) # ft2 is w value
    
    fmul.s ft3, ft1, ft2
    fadd.s ft0, ft0, ft3
    
End_loop_i:
    addi t2, t2, 4
    addi t3, t3, 4

    addi t1, t1, 1
    bne t0, t1, Loop_i
    
Bias:
    la t5, b
    flw ft4, 0(t5) # ft4 is bias
    
    fadd.s ft0, ft0, ft4
    
Writeback_x:
    la t4, x
    fsw ft0, 0(t4)

Activation:
    # x == 0 ?
    fcvt.s.w ft1, x0
    feq.s t1, ft0, ft1
    
    nop
    nop
    nop
    bne t1, x0, Activation_zero

    # exponent_part(x) == 0x7f ?
    fmv.x.w t0, ft0
    srli t0, t0, 23
    andi t0, t0, 0xff
    
    li t1, 0x7f
    beq t0, t1, Activation_eq0x7f
    
    # others
    j Activation_others

Activation_zero:
Activation_eq0x7f:
    fcvt.s.w ft0, x0
    j End_activation

Activation_others:
    li t0, 1
    fcvt.s.w ft1, t0
    fdiv.s ft0, ft1, ft0
    j End_activation
        
End_activation:

Writeback_y:
    la t4, y
    fsw ft0, 0(t4)

# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
