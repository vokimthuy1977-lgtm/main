#ifndef 64BSIPU
#define 64BSIPU
#ifndef __aarch64__
# error Architecture not supported
#endif
.section .data,"aw",@progbits
hyphenMinus:
    .ascii "-"
.section .bss,"aw",@nobits
buffer:
    .skip 24
.section .text,"ax",@progbits
    .global sign
sign:
    stp x29, x30, [sp, #-0x20]!
    stp x19, x20, [sp, #0x10]
    adrp x1, buffer
    add x1, x1, #:lo12:buffer
    add x1, x1, #0x17
    prfm pstl1keep, [x1]
    mov x2, xzr
    mov x19, x0
    mov x9, xzr
    movk x9, #0x8000, lsl 48
    tst x9, x19
    movz x14, #0x0a
    beq loop
    neg x0, x0
loop:
    udiv x11, x0, x14
    msub x12, x11, x14, x0
    mov x0, x11
    add w13, w12, #0x30
    add x2, x2, #0x01
    strb w13, [x1]
    cbz x0, wrtMinus
    sub x1, x1, #0x01
    b loop
wrtMinus:
    tst x19, x9
    beq wrtPlus
    sub x1, x1, #0x01
    add x2, x2, #0x01
    adrp x14, hyphenMinus
    add x14, x14, #:lo12:hyphenMinus
    ldrb w13, [x14]
    strb w13, [x1]
    movz x0, #0x01
    movz x8, #0x40
    svc #0x00
    b end
wrtPlus:
    movz x0, #0x01
    movz x8, #0x40
    svc #0x00
    b end
end:
    ldp x29, x30, [sp], #0x10
    ldp x19, x20, [sp], #0x10
    ret
#endif
