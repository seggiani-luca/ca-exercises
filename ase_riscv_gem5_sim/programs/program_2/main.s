.section .data
v1: .byte  2, 6, -3, 11, 9, 18, -13, 16, 5, 1
v2: .byte  2, 6, 2, 11, 2, 2, 2, 2, 2, 2
v3: .byte  0, 0, 0, 0, 0, 0, 0, 0, 0, 0

flag1: .word 0
flag2: .word 0
flag3: .word 0

# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:

    li x11, 10 # constant

    la x1, v1  # v1 addr.
    li x3, 0   # v1 index

    la x2, v2  # v2 addr.
    
    la x9, v3  # v3 addr.
    li x10, 0  # v3 index

Loop_v1:
    # read v1[index]
    add x5, x1, x3
    lb x6, 0(x5)   # v1[index]
    
    li x4, 0  # v2 index
    
Loop_v2:
    # read v2[index]
    add x7, x2, x4
    lb x8, 0(x7)   # v2[index]
    
    # compare
    beq x6, x8, Loop_v2_add
    j Loop_v2_end
        
Loop_v2_add:
    # write v3[index]
    add x12, x9, x10
    sb x6, 0(x12)
    
    # increment
    addi x10, x10, 1
    
    # early return
    j Loop_v1_end

Loop_v2_end:
    addi x4, x4, 1
    bne x4, x11, Loop_v2
    
Loop_v1_end:
    addi x3, x3, 1
    bne x3, x11, Loop_v1

    li x13, 1 # need a one somewhere

    # reset flags 2, 3 early
    la x14, flag2
    la x15, flag3
    sb x0, 0(x14)
    sb x0, 0(x15)

    # reset flag 1
    la x20, flag1
    sb x0, 0(x20)
    bne x10, x0, Flag_1_end 
    
    # empty
    sb x13, 0(x20)
    j End
Flag_1_end: # not empty

    # flags 2, 3 already reset, set them
    sb x13, 0(x14)
    sb x13, 0(x15)
    
    # early exit on single element
    beq x10, x13, End
    
    li x16, 1 # new v3 index
        
    # read v3[0]
    lb x18, 0(x9)   # v3[0], prev
    
Loop_flags:
    # read v3[index]
    add x17, x9, x16
    lb x19, 0(x17)   # v3[index], next
    
    beq x18, x19, Loop_flags_eq   # not decreasing OR increasing
    blt x18, x19, Loop_flags_incr # not decreasing
    j Loop_flags_decr             # not increasing

Loop_flags_eq:
    sb x0, 0(x14)
    sb x0, 0(x15)
    
    j Loop_flags_end

Loop_flags_incr:
    sb x0, 0(x15)
    j Loop_flags_end
    
Loop_flags_decr:
    sb x0, 0(x14)
    j Loop_flags_end

Loop_flags_end:
    mv x18, x19
    
    addi x16, x16, 1
    bne x16, x10, Loop_flags

# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
