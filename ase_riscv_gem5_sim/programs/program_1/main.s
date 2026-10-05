
# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:

    li x1, 0  # a
    li x2, 1  # b
    li x3, 21 # count
    li x4, 1  # i

Loop:

    beq x4, x3, End # exit condition

    add x5, x1, x2  # fib. step
    mv x1, x2
    mv x2, x5

    addi x4, x4, 1   # loop iteration
    j Loop

# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
