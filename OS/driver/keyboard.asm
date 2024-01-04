;; keyboard driver for ELITE-OS (FIXED)

;; Usage:-
;; getInput(si*);

getInput:
    pusha
    mov dx, si

    .start:
    mov ah, 0
    int 16h

    cmp al, 0x08
    je .backspace

    cmp al, 0x0d
    je .sel

    mov byte [si], al
    inc si
    mov ah, 0x0e
    int 10h
    jmp .start

    .sel:
        mov byte [si], 0
        popa
        ret

    .backspace:
        cmp si, dx
        je .start

        call backspace

        dec si
        jmp .start
