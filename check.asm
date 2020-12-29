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
	call halt
.s1:	ret
