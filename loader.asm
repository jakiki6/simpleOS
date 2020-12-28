	org 0x7c00
	bits 16

conf: equ 0xa000
conf.start: equ conf
conf.lba_offset: equ conf.start - 8
conf.drive: equ conf.lba_offset - 1

stage1:
	xor ax, ax
	xor bx, bx
	xor cx, cx
	mov byte [conf.drive], dl
	xor dx, dx
	xor si, si
	xor di, di

	push 0x2000
	pop ss
	mov esp, 0xffff
	
	push cs
	pop ds
	push cs
	pop es

	sti

.load_all:
	mov si, DAP.lba_lower
	mov di, conf.lba_offset
	mov cl, 8
	rep movsb

	mov ah, 0x42
	mov dl, byte [conf.drive]
	mov si, DAP

	clc
	int 0x13
	jc .load_all

setup:
        xor ax, ax
        cli
        push ds

        lgdt [gdtinfo]

        mov eax, cr0
        or al, 1
        mov cr0, eax

        jmp $+2

        mov bx, 0x08
        mov ds, bx

        mov  cr0, eax

        jmp 0x08:.pmode
.pmode: mov bx, 0x10
        mov ds, bx
        mov es, bx
        mov ss, bx
        mov fs, bx
        mov gs, bx

        and al, 0xfe
        mov cr0, eax
.huge_unreal:
        pop ds
        sti

	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	xor si, si
	xor di, di
	xor bp, bp

	push 0x2000
	pop ss
	mov sp, 0xffff

	push 0x1000
	pop ds
	push ds
	pop es

        push 0x1000
	push 0x0000
	retf

gdtinfo:
        dw gdt_end - gdt - 1   ;last byte in table
        dd gdt                 ;start of table

gdt:    dd 0,0        ; entry 0 is always unused
flatcode:
        db 0xff, 0xff, 0, 0, 0, 10011010b, 10001111b, 0
flatdata:
        db 0xff, 0xff, 0, 0, 0, 10010010b, 11001111b, 0
gdt_end:


DAP:
.header:
    db 0x10	; header
.unused:
    db 0x00     ; unused
.count:  
    dw 0x0080   ; number of sectors
.offset_offset:
    dw 0x0000	; offset
.offset_segment:
    dw 0x1000   ; offset
.lba_lower:
    dq 1        ; lba
.lba_upper:
    dq 0        ; lba  
.end:

db 0x13, 0x37

times 510 - ($ - $$) nop
dw 0xaa55
