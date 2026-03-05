.section .text, "ax", @progbits
    .balign 64
    .bundle_align_mode 4
    .global print_string
    .type print_string, %function
print_string:
    sub sp, sp, #128
    mov x1, sp
    mov x15, x1
    mov w9, wzr
    mov x10, xzr
    .bundle_lock
loop:
    ldrb w9, [x0]
    b checkSpace
    add x10, x10, #1
    .bundle_unlock
    strb w9, [x1]
    cbz w9, write
    add x0, x0, #1
    add x1, x1, #1
    subs xzr, x1, #128
    b.gt error
    b loop
checkSpace:
    subs wzr, w9, #0x20
    adrp x11, loop
    add x11, x11, #:lo12:loop
    add x11, x11, #8
    b.eq EQ
    b nextNE
EQ:
    br x11
nextNE:
    subs wzr, w9, #0x5A
    b.gt nextNE1
    subs wzr, w9, #0x41
    b.lt nextNE1
    br x11
nextNE1:
    subs wzr, w9, #0x7A
    b.gt error
    subs wzr, w9, #0x61
    b.lt error
    br x11
write:
    movz x0, #1
    mov x1, x15
    mov x2, x10
    movz x8, #64
    svc #0
    movz w9, #0x01
error:
    subs wzr, w9, #0x00
    b.eq EQ
    mov sp, x15
    add sp, sp, #128
    movz x0, #0
    ret
    .size print_string, .-print_string
