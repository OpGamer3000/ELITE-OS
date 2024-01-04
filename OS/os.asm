VERSION equ "1.0.0"

;; entry
org target
jmp 0:OS_main

;; data
msg_OS_intro: db "ELITE-OS (v", VERSION, ")", 10, 13, "Type help for a list of commands", 10, 13, 0
key_buffer: times 100 db 0
user: db "ELITE-OS> ", 0

OS_main:
    ;; intro
    call print_nl
    call print_nl
    mov si, msg_OS_intro        ; print intro msg
    call print                  ; call the routine

    .start:
        call print_nl
        mov si, user
        call print

        mov si, key_buffer
        call getInput
        call print_nl

        call inter_cmd

        jmp .start

;; end of code (safe guard)
cli
hlt
jmp $

;; libs
include "./libs/utils.asm"
include "./libs/screen.asm"
include "./driver/keyboard.asm"
include "./driver/inter.asm"