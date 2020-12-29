setup_handler:
	xor ax, ax
	mov cx, 0x1000

	mov dx, handler_div
	call register_interrupt
	mov al, 0x02
	mov dx, handler_nmi
	call register_interrupt
	mov al, 0x06
	mov dx, handler_ill
	call register_interrupt

	ret

; name: register_interrupt
; desc: sets up interrupt
; input:
;	al: interrupt number
;	cx: cs
;	dx: ip
; output:
;	none
register_interrupt:
	push bx
	push ds
	mov bx, ax
	mov bh, 0
	shl bx, 2
	push 0x0000
	pop ds
	mov word [bx], dx
	mov word [bx + 2], cx
	pop ds
	pop bx
	ret

handler_div:
	push si
	push es
	push 0x1000
	pop es
	mov si, errors.div_int
	call print_string
	pop es
	pop si
	iret

handler_nmi:
        push si
        push es
        push 0x1000
        pop es
        mov si, errors.nmi_int
        call print_string
        pop es
        pop si
        iret

handler_ill:
	push si
        push es
        push 0x1000
        pop es 
        mov si, errors.ill_opcode
        call print_string
        pop es   
        pop si   
        iret
