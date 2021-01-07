setup_threads:
	cli

	sti
	ret

; name: add_thread
; desc: Adds a thread
; input:
;	cx: cs
;	dx: ip
; output:
;	ax: pid
add_thread:
	pusha
	push ds
	push es
	mov word [savesp] , sp
	mov sp, 0x8000

	push 0x0200
	push cx
	push dx
	mov dx, cx
	mov cx, 16
	rep push 0x0000
	push dx
	push dx
	push 0x3000

	push 0x3000
        pop ds
        cs mov si, word [pid]
        shl si, 6
.loop:  mov al, byte [si+63]
        cmp al, 0
        je .found
        add si, 64
        jmp .loop
.found: shr si, 6
        mov word [pid], si

.emuirq:
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
.loop2:	lodsb 
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

	mov sp, word [savesp]
	pop es
	pop ds
	popa

	ret

savesp:
	dw 0
