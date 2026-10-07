[ORG 0x7E00]
[Bits 16] ; 16 Bits :D
;This archive is Just 16 to 32 bits, if you want 64bits you can fork to make transition :D
call main ;Call Main Function
get_a20_state:
	pushf
	push si
	push di
	push ds
	push es
	cli

	mov ax, 0x0000					;	0x0000:0x0500(0x00000500) -> ds:si
	mov ds, ax
	mov si, 0x0500

	not ax						    ;	0xffff:0x0510(0x00100500) -> es:di
	mov es, ax
	mov di, 0x0510

	mov al, [ds:si]					;	save old values
	mov byte [.BufferBelowMB], al
	mov al, [es:di]
	mov byte [.BufferOverMB], al

	mov ah, 1
	mov byte [ds:si], 0
	mov byte [es:di], 1
	mov al, [ds:si]
	cmp al, [es:di]					;	check byte at address 0x0500 != byte at address 0x100500
	jne .exit
	dec ah
.exit:
	mov al, [.BufferBelowMB]
	mov [ds:si], al
	mov al, [.BufferOverMB]
	mov [es:di], al
	shr ax, 8					    ;	move result from ah to al register and clear ah
	pop es
	pop ds
	pop di
	pop si
	popf
	ret
	
	.BufferBelowMB:	db 0
	.BufferOverMB	db 0

;NMIs HERE 
TurnOffNMI:
    ; Disable NMI
    mov   al,80h
    out   70h,al
    ret
TurnOnNMI:
    ; Enable NMI -> Use in 32 Bits
    xor   al,al
    ret


gdtr:
    dw gdt_end - gdt_start -1

gdt_start:
    ;null segment
    dq 0x0000000000000000
    ;code segment
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00

    ;data segment
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00


gdt_end:



main:
    ;16 bits Main funcion
    ;Disable ALL INTERRUPTS in cli and  TurnOFFNMI
    cli
    call TurnOffNMI
    lgdt [gdtr] ;Load initial gdt
    or al,1
    mov cr0,eax
    call get_a20_state

    jmp 08h:ModeMain ;Go to 32 bits







;Bits 32 Finally Bro :)
[BITS 32]

enable_A20: ; from https://wiki.osdev.org/A20_Line
        cli                     ; disable interrupts

        call    a20wait
        mov     al,0xAD
        out     0x64,al         ; disable keyboard

        call    a20wait
        mov     al,0xD0
        out     0x64,al         ; read controller output port

        call    a20wait2
        in      al,0x60         ; save response byte
        push    eax

        call    a20wait
        mov     al,0xD1
        out     0x64,al         ; write next byte into controller output port

        call    a20wait
        pop     eax
        or      al,2            ; set controller output bit for A20 on
        out     0x60,al         ; activate A20

        call    a20wait
        mov     al,0xAE
        out     0x64,al         ; reactivate keyboard

        call    a20wait
        sti                     ; reactivate interrupts
        ret

a20wait:                        ; wait until input buffer is clear
        in      al,0x64
        test    al,2
        jnz     a20wait
        ret


a20wait2:                       ; wait until response byte has arrived
        in      al,0x64
        test    al,1
        jz      a20wait2
        ret

ModeMain:
    ;Load Segments
    mov ax, 0x8
    mov cs,ax
    mov ax,0x10
    mov ds,ax
    mov ss,ax
    mov es,ax
    mov fs,ax
    mov gs,ax
    mov esp,0x900000 ; UPD stack poiter to secure area!!!
    jmp Main32 ;Go to Main Function 32 bits
Main32:
    ;MAIN FUNCTION 32 BITS HERE
    sti
    call  TurnOnNMI


;Use iret to interrupts!!!
;0x08 to load cs
;0x10 to load ds,ss,es,fs,gs

