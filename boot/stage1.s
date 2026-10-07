[BITS 16]; We are in 16 bits on this Moment :D
[org 0x7c00] ;Boot sector endress
;This Archive is just Stage 1 Bootloader
clear:
    ;This function clear Screen
    mov ah,00h
    mov al,03h
    int 10h
    ret ; Use iret to interrupt bios
;Start Main funcion
start:
    call clear
    mov ah, 0x02        ; function, read sector
    mov al, 4           ; How much sectors to read
    mov ch, 0           ; cylinder
    mov cl, 2           ; sector, start in 2 ( first sector is this function)
    mov dh, 0           ; cabeça
    mov bx, 0x7E00      ; Where put in the memory (Ram)
    int 0x13
    jmp 0x7E00  
   
times 510 - ($ -$$) db 0
dw 0xAA55   
