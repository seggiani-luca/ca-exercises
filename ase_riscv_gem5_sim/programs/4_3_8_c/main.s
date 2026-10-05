.section .data
val:  .byte 42
addr: .word val

# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:

# setup load
    la t1, addr

# perform test c
    lw t2, 0(t1)
    lb t3, 0(t2)

# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
