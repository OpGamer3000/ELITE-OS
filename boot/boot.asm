;; definations
target equ 0x7e01

;; super init
org 0x7c00
jmp 0:start

start:
    mov bp, 0x7bff      ; setting up stack
    mov sp, bp
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov [DISK], dl      ; SAVE DISK NUMBER (which we booted from)!

    mov ax, 0x0003      ; 00-vid mode sel || 03-mode (clears the screen too :O)
    int 10h             ; video services

    mov si, msg_init
    call BOOT_println

    mov ah, 0x02        ; mode - read
    mov al, 125         ; sectors to read | too lazy to calculate the usable sectors xd
    mov ch, 0           ; cylinder - 0
    mov cl, 2           ; sector - 2 (sector 1 is our bootloader)
    mov dh, 0           ; null
    mov dl, [DISK]      ; drive number
    mov bx, target      ; where to load

    int 13h             ; disk interupt

    mov si, msg_disk_done
    call BOOT_println

    jmp 0:target

;; other things
DISK db 0

msg_init db "loading disk sector thingy now . . .", 0
msg_disk_done db "DISK LOAD COMPLETE!", 0

;; includes
include './utils/screen.asm'

times 510-($-$$) db 0
dw 0xaa55

include "../OS/os.asm"