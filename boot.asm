[org 0x7C00]
[bits 16]

boot_start:
    ; حفظ محرك الأقراص الأصلي من DL
    mov [boot_drive], dl

    ; تهيئة السجلات والمكدس
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7BFC  ; المكدس ينمو للأسفل بعيدًا عن البوت لودر

    ; إعادة ضبط محرك الأقراص
    mov ah, 0x00
    int 0x13
    jc disk_error

    ; قراءة النواة من القرص
    mov ah, 0x02
    mov al, 1        ; عدد القطاعات (1 = 512 بايت)
    mov ch, 0        ; الأسطوانة 0
    mov cl, 2        ; القطاع 2 (بعد البوت لودر)
    mov dh, 0        ; الرأس 0
    mov dl, [boot_drive] ; استخدام محرك الأقراص المحفوظ
    mov bx, 0x7E00   ; ES:BX = 0x0000:0x7E00
    int 0x13
    jc disk_error    ; خطأ إذا كان Carry Flag = 1
    cmp al, 1        ; تأكد من قراءة قطاع واحد
    jne disk_error

    ; القفز إلى النواة
    jmp 0x0000:0x7E00

disk_error:
    mov si, error_msg
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

boot_drive db 0
error_msg db "Disk Error!", 0

times 510-($-$$) db 0
dw 0xAA55