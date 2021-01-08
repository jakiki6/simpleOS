; https://stackoverflow.com/questions/54280828/making-a-mouse-handler-in-x86-assembly

driver_mouse_setup:
	push es
	push bx

	int 0x11
	test ax, 4
	jz .no_mouse

	mov ax, 0xc205
	mov bh, 3
	int 0x15
	jc .no_mouse

	push cs
	pop es

	mov bx, .mouse_callback_dummy
	mov ax, 0xc207
	int 0x15
	jc .no_mouse
	pop bx
	pop es

.enable:
	push es
	push bx

	mov ax, 0xc200
	xor bx, bx
	int 0x15

	push cs
	pop es
	mov bx, .mouse_callback
	mov ax, 0xc207
	int 0x15

	mov ax, 0xc200
	mov bh, 1
	int 0x15

	pop bx
	pop es

.no_mouse:
	ret

.mouse_callback:
	push bp
	mov bp, sp
	push ds
	push ax
	push bx
	push cx
	push dx

	push cs
	pop ds

	mov al, [bp+12]
	mov bl, al
	mov cl, 3
	shl al, cl

	sbb dh, dh
	cbw
	mov dl, [bp+8]
	mov al, [bp+10]

	neg dx
	mov cx, [mouseY]
	add dx, cx
	mov cx, [mouseX]
	add ax, cx

	mov [mouseStatus], bl
	mov [mouseX], ax
	mov [mouseY], dx

	pop dx
	pop cx
	pop bx
	pop ax
	pop ds
	pop bp

.mouse_callback_dummy:
	retf

mouseX:	dw 0
mouseY:	dw 0
mouseStatus:
	dw 0
