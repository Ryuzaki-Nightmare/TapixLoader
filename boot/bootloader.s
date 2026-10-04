[org 0x7c00]
[BITS 16]
start:
    jmp main
    nop
main:
    cli


times 510 - ($ -$$) db 0
dw 0xAA55





