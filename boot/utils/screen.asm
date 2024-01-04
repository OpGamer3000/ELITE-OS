BOOT_println:
    pusha               ; saving the register state
    mov ah, 0x0e        ; tele type mode thingy
    .start:
        lodsb           ; load the data pointed by si to al
        cmp al, 0       ; check if al = 0
        je .end         ; jump to end if yes
        int 10h         ; interupt video services
        jmp .start      ; loop

    .end:
        mov al, 10      ; newline
        int 10h
        mov al, 13      ; carrage return
        int 10h
        popa            ; loading the saved register state
        ret             ; return to wehre we got called from
