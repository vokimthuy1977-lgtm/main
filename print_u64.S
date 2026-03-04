.section .bss, "aw", @nobits
    .balign 64
    .type buffer, %object
buffer:
    .skip 24
    .size buffer, .-buffer
.section .text, "ax", @progbits
    .balign 64
    .global print_u64
    .type print_u64, %function
print_u64:
    stp x19, x20, [sp, #-32]!
    stp x21, x22, [sp, #16]
    adrp x21, buffer
    add x21, x21, #:lo12:buffer
    add x21, x21, #23
    mov x19, x0
    mov x20, #10
    mov x9, xzr
    mov x22, xzr
loop:
    udiv x9, x19, x20
    msub x10, x9, x20, x19
    mov x19, x9
    add w10, w10, #48
    strb w10, [x21]
    add x22, x22, #1
    cbz w9, next
    sub x21, x21, #1
    b loop
next:
    movz x0, #1
    mov x1, x21
    mov x2, x22
    movz x8, #64
    svc #0
end:
    ldp x19, x20, [sp], #16
    ldp x21, x22, [sp], #16
    mov x0, xzr
    ret
    .size print_u64, .-print_u64
