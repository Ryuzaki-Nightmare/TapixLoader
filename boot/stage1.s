[BITS 16]; We are in 16 bits on this Moment :D
[org 0x7c00] ;Boot sector endress
;This Archive is just Stage 1 Bootloader
;Start Main funcion
start:
    mov ah, 0x02        ; função: ler setor
    mov al, 4           ; quantos setores ler (ajusta conforme tamanho do stage2)
    mov ch, 0           ; cilindro
    mov cl, 2           ; setor (começa no 2, setor 1 é o stage1)
    mov dh, 0           ; cabeça
    mov bx, 0x7E00      ; onde colocar na memória
    int 0x13

    jmp 0x7E00  
   
times 510 - ($ -$$) db 0
dw 0xAA55   
