# the purpose of this is to demonstrate a (presumed) error in this specific gem5 version
# with forwarding ON, the code runs correctly (following the comments)
# with forwarding OFF, the branch at line 33 is (incorrectly) taken

# 0xFA is a byte stored in memory
.section .data
val: .byte 0xFA

# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:

    # prepare 0 in x10
    li x10, 0

    # load val register in x1
    la x1, val

    # load immediate 0xD7 into both x3 and x2
    li x3, 0xD7
    mv x2, x3

# at this point x2 = 0xD7, x3 = 0xD7

    # load val into x2
    lb x2, 0(x1)

# at this point x2 = 0xFA, x3 = 0xD7
   
    # branch to Test on x2 = x3 (should never branch)
    beq x2, x3, Test

    # jump to end
    j End

Test:
    # test just sets x10 to 20 as a flag
    li x10, 20

# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
