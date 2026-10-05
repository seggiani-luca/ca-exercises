.section .data
v3:    .byte 1, 2, 3
flag2: .byte 0
flag3: .byte 0

# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:
    li x13, 1 # one
    
    # flag addr.s
    la x14, flag2
    la x15, flag3
    
    # flags 2, 3 already reset, set them
    sb x13, 0(x14)
    sb x13, 0(x15)
    
    la x9, v3 # v3 addr
    li x16, 1 # new v3 index
    li x10, 3 # v3 size
        
    # read v3[0]
    lb x18, 0(x9)   # v3[0], prev
    
Loop_flags:
    # read v3[index]
    add x17, x9, x16
    lb x19, 0(x17)   # v3[index], next
    
    beq x18, x19, Loop_flags_eq  # not decreasing OR increasing
    blt x18, x19, Loop_flags_incr # not decreasing
    blt x19, x18, Loop_flags_decr # not increasing

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
