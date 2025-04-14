[org 0x7E00]
[bits 16]

start:
    mov si, hello_msg
    call print_string
    jmp $

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

hello_msg db "hi", 0

times 512 db 0