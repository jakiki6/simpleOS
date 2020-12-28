target: equ 0x08
backup: equ 0xff
stack:  equ 0x8000


setup_sched:
	push 0x0000
        pop es

	cli
        es mov ax, word [target * 4]
        es mov word [backup * 4], ax
        es mov ax, word [target * 4 + 2]
        es mov word [backup * 4 + 2], ax
        es mov word [target * 4], irq
        es mov word [target * 4 + 2], 0x1000

	mov al, 0b00110100
        out 0x43, al

        mov ax, 0x1000
        out 0x40, al
        mov al, ah
        out 0x40, al

	push cs
	pop es

	sti
	ret

irq:	int backup
	cli
	jmp irq_save
.s1:	call sched
	jmp irq_load
	iret

irq_save:
        ; structure:
        ;       es ds regs ip cs flags
        ;        = 14 bytes            \ save
        pusha
        push ds
        push es

        cs mov word [save_sp], sp
        cs mov word [save_ss], ss

	push 0x2000
	pop ss
        mov sp, stack
        push cs
        pop ds 
        push cs
        pop es

        jmp irq.s1

irq_load:
        mov sp, word [save_sp]
        mov ss, word [save_ss]
        pop es
        pop ds
        popa
        sti
        iret

; do your fancy stuff here
sched:
	ret

save_sp:
	dw 0
save_ss:
	dw 0
