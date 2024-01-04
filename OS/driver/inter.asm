;; Command intepreter for ELITE-OS

;; Usage: inter_cmd(si*);
msg_inter_cmd_no_command_found db "No command found for: ", 0
msg_help db "Here is a list of commands: ", 0
commands db "help", 0, "reboot", 0, "shutdown", 0, "cls", 0, 1
msg_shutdown db "shutting down. . .", 0
msg_shutdown_err db "!-SHUTDOWN FAILED-!", 0
init_input_buffer dw 0

inter_cmd:
    pusha
    mov [init_input_buffer], si
    ; setup
    mov cx, 1
    mov di, commands

    .start:
    call str_cmp

    jc .next_cmd

    ; command check
    ; help
    cmp cx, 1
    je .cmd_1

    ; reboot
    cmp cx, 2
    je .cmd_2

    ; shutdown (needs rework if possible)
    cmp cx, 3
    je .cmd_3
    
    ; cls
    cmp cx, 4
    je .cmd_4

    jmp .end

    .next_cmd:
        inc cx

        .next_cmd_addr:
        cmp byte [di], 0
        je .next_cmd_done
        inc di
        jmp .next_cmd_addr

        .next_cmd_done:
            inc di
            cmp byte [di], 1
            je .command_err
            jmp .start
    
    .command_err:
        mov si, msg_inter_cmd_no_command_found
        call print
        mov si, [init_input_buffer]
        call println
        jmp .end
    
    .end:
        popa
        ret

;; COMMANDS SECTION

; help command
.cmd_1:
    mov si, msg_help
    call println
    mov si, commands
    mov ah, 0x0e
    .cmd_1_loop_one:
    mov al, '-'
    int 10h
    mov al, ' '
    int 10h
    .cmd_1_loop:
        cmp byte [si], 0
        je .cmd_1_check_eos
        mov al, [si]
        int 10h
        inc si
        jmp .cmd_1_loop
    
    .cmd_1_check_eos:
        inc si
        cmp byte [si], 1
        je .end
        call print_nl
        jmp .cmd_1_loop_one

; reboot
.cmd_2:
    mov ax, 0
    int 19h         ; warm reboot

    jmp .end

; shutdown
.cmd_3:
    mov ax, 0x0003
    int 10h

    mov si, msg_shutdown
    call println

    cli
    hlt
    sti

    mov si, msg_shutdown_err
    call println

    jmp .end

; cls
.cmd_4:
    mov ax, 0x0003      ; 00-vid mode sel || 03-mode (clears the screen too :O)
    int 10h             ; video services
    jmp .end