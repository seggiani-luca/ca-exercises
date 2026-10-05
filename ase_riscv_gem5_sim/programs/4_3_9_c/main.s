.section .data
val: .byte 3

# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:

# setup load
    la t0, val
    li t6, 2
    nop

# perform test c
    lb t1, 0(t0)
    nop # or anything else that doesn't touch t1
    add t5, t1, t6

# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
