setup_check:
	mov al, 0x06
	mov cx, 0x1000
	mov dx, .err
	call register_interrupt

	mov eax, 0
	cpuid
	jmp short .s1
.err:	mov si, errors.cpuid
	call print_string
	call panic
.s1:	lgdt [gdtinfo]
	ret

gdtinfo:
        dw gdt_end - gdt - 1   ;last byte in table
        dd gdt                 ;start of table

gdt:    dd 0,0        ; entry 0 is always unused
flatcode:
        db 0xff, 0xff, 0, 0, 0, 10011010b, 10001111b, 0
flatdata:
        db 0xff, 0xff, 0, 0, 0, 10010010b, 11001111b, 0
gdt_end:
