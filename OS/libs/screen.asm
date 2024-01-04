;; copied from the bootloader's screen thing

println:
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
        ret             ; return to where we got called from

print_nl:
    pusha               ; save register state
    mov ah, 0x0e        ; teletype mode
    mov al, 10          ; newline char
    int 10h             ; interupt
    mov al, 13          ; carrage return char
    int 10h             ; interupt
    popa                ; load the saved register state
    ret                 ; return to where we got called from

print:
    pusha               ; saving the register state
    mov ah, 0x0e        ; tele type mode thingy
    .start:
        lodsb           ; load the data pointed by si to al
        cmp al, 0       ; check if al = 0
        je .end         ; jump to end if yes
        int 10h         ; interupt video services
        jmp .start      ; loop

    .end:
        popa            ; loading the saved register state
        ret             ; return to where we got called from

backspace:
    pusha

    mov ax, 0x0e08      ; tty mode and backspace char
    int 10h             ; interupt
    mov al, 0           ; making the character 'disapear'
    int 10h             ; interupt
    mov al, 0x08        ; backspace char again
    int 10h             ; final interupt

    popa                ; outro
    ret