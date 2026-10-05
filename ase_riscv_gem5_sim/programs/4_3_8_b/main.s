.section .data
    val: .word 42

# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:

# setup load
    la t0, val

# perform test a
    lw t1, 0(t0)
    add t5, t2, t1

# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
