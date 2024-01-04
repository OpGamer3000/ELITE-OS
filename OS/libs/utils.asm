;; utility file for ELITE-OS

;; Usage:-
;; str_cmp(si*, bx*);

;; CF = true if si* != bx*
;; CF = false if si* == bx*

str_cmp:
    pusha                   ; save register state
    clc                     ; clear carry flag

    .start:
        mov al, byte [di]   ; load thing pointed by di
        cmp [si], al        ; compare thing pointed by si and the value of al

        jne .no_match       ; if not equals then jump to .no_match (to set carry flah) || for some reason jz .zero aint working, help.
        
        cmp al, 0           ; checking if zero
        je .zero            ; yep both are zero

        inc si              ; incriment si and di
        inc di
        jmp .start          ; loop
    
    .zero:
        clc                 ; clear carry flag just in case
        jmp .end            ; end this routine
    
    .no_match:
        stc                 ; set carry flag
        jmp .end            ; end this routine

    .end:
        popa                ; load back the register state
        ret                 ; return to where we got called from
