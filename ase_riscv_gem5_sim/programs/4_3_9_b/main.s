
# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:

# setup registers
    li t2, 2
    li t3, 2
    li t5, 2
    nop

# perform test a
    add t1, t2, t3
    sub t4, t5, t1

# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
