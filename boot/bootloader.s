[org 0x7c00] ;Boot sector endress
[BITS 16]
start:
    jmp main
    nop
main:
    cli
    mov ax,0
    mov cs,ax
    mov ss,ax
    mov es,ax
    mov fs,es
    mov gs,ax


;Use iret to interrupts!!!
;To call interrupts use int number in IVT (interrupt vector table)
times 510 - ($ -$$) db 0
dw 0xAA55




    
