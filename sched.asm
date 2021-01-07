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

irq:	cli
	int backup
	jmp irq_save
.s1:	call sched
	jmp irq_load

irq_save:
        ; structure:
        ;       ss es ds regs ip cs flags
        ;        = 14 bytes            \ save
        pusha
        push ds
        push es
	push ss
        cs mov word [save_sp], sp
	cs mov word [save_ss], ss

	push 0x2000
	pop ss
        mov sp, stack
	push cs
	pop ds

	mov ax, [save_ss]
        push ax
        pop es
	mov si, word [save_sp]
	mov di, word [pid]
	shl di, 6
	push 0x3000
	pop ds
	push di

	mov cx, 32
.loop:	lodsb
	ds stosb
	loop .loop

	pop di
	cs mov ax, word [save_sp]
	mov word [di+32], ax
	cs mov ax, word [save_ss]
	mov word [di+34], ax

	push cs
	pop ds
	push cs
	pop es

        jmp irq.s1

irq_load:
	mov si, word [pid]
	shl si, 6
	push 0x3000
	pop ds

	mov ax, word [si+32]
	cs mov word [save_sp], ax
	mov ax, word [si+34]
	cs mov word [save_ss], ax

	mov di, word [save_sp]
	mov ax, word [save_ss]
	push ax
	pop es

	mov cx, 32
.loop:	ds lodsb
	stosb
	loop .loop

	push cs
	pop ds

        mov sp, word [save_sp]
	mov ss, word [save_ss]

	pop ss        
        pop es
        pop ds
        popa
        sti
        iret

; do your fancy stuff here
sched:
	push 0x3000
	pop ds
	cs mov si, word [pid]
	shl si, 6
.loop:	mov al, byte [si+63]
	cmp al, 0
	je .found
	add si, 64
	jmp .loop
.found:	shr si, 6
	mov word [pid], si
	ret

save_sp:
	dw 0
save_ss:
	dw 0
pid:
	dw 0
