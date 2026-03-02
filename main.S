.section .data, "aw", @progbits
    .balign 4
    .type val, %object
val:
    .word 0x000A6425
    .word 0xA9BE7BFD
    .word 0xA8C17BFD
    .word 0xA9015BF5
    .word 0xAA3F03F5
    .word 0xD341FEB5
    .word 0xAA1F03F4
    .word 0xEB15029F
    .word 0xAA1403E1
    .word 0x91000694
    .word 0xA8C15BF5
    .word 0xD61F03C0
    .word 0x540000e0
    .word 0x17fffff9
    .word 0x9100e000
    .word 0x90000100
    .size val, .-val
.section .text, "ax", @progbits
    .balign 4
    .global main
    .extern mprotect
    .type main, %function
    .type ZXN1, %function
    .type ZXN2, %function
    .type ZXN3, %function
main:
    stp x29, x30, [sp, #-0x20]!
    stp x19, x20, [sp, #0x10]
    adrp x19, ZXN1
    add x19, x19, #:lo12:ZXN1
    mov x0, x19
    bic x0, x0, #0x0fff
    movz x1, #0x0fff
    movz x2, #0x07
    bl mprotect
    adrp x9, val
    add x9, x9, #:lo12:val
    ldr w10, [x9, #0x04]
    str w10, [x19]
    ldr w10, [x9, #0x08]
    str w10, [x19, #0x34]
    ldr w10, [x9, #0x0c]
    str w10, [x19, #0x04]
    ldr w10, [x9, #0x10]
    str w10, [x19, #0x08]
    ldr w10, [x9, #0x14]
    str w10, [x19, #0x0c]
    ldr w10, [x9, #0x18]
    str w10, [x19, #0x10]
    ldr w10, [x9, #0x1c]
    str w10, [x19, #0x14]
    ldr w10, [x9, #0x20]
    str w10, [x19, #0x24]
    ldr w10, [x9, #0x24]
    str w10, [x19, #0x2c]
    ldr w10, [x9, #0x28]
    str w10, [x19, #0x38]
    ldr w10, [x9, #0x2c]
    str w10, [x19, #0x3c]
    ldr w10, [x9, #0x30]
    str w10, [x19, #0x18]
    ldr w10, [x9, #0x34]
    str w10, [x19, #0x30]
    ldr w10, [x9, #0x38]
    str w10, [x19, #0x20]
    ldr w10, [x9, #0x3c]
    str w10, [x19, #0x1c]
    dc cvau, x19
    dsb ish
    ic ivau, x19
    isb
    bl ZXN1
    ldp x29, x30, [sp], #0x10
    ldp x19, x20, [sp], #0x10
    ret
    .balign 64
ZXN1:
    yield
    yield
    yield
    yield
    yield
ZXN2:
    yield
    yield
    yield
    yield
    yield
    bl printf
    yield
    yield
ZXN3:
    yield
    yield
    yield
    .size main, .-main
.section .note.GNU-stack, "x", @progbits
.section .note.ABI-tag, "a", @note
    .balign 4
    .long 4, 16, 1
    .asciz "GNU"
    .long 0, 3, 7, 0
.ident "GCC: (GNU) 15.2.1 20260103"
.ident "GCC: (crosstool-NG 1.28.0.3_a3fef85) 15.2.1 20260103"
.section .note.gnu.build-id,"a",@note
    .balign 4
    .long 4, 20, 3
    .asciz "GNU"
    .byte 0x39, 0xe7, 0x8f, 0x79, 0xa9, 0xc1, 0xe1, 0x10, 0x50, 0x16
    .byte 0xe4, 0x1a, 0x60, 0x57, 0x2f, 0x42, 0x73, 0x9d, 0xdc, 0x63
