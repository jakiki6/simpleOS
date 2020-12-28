; name: print_string
; desc: Prints a string terminated by 0x00
; input:
;	si: pointer to string
; output:
;	none
print_string:
	pusha

	mov ah, 0x0e
	mov bx, 0x0007
.loop:	lodsb
	cmp al, 0
	je .end
	int 0x10
	jmp .loop

.end:	popa
	ret

; name: halt
; desc: Halts the system
; input:
;	none
; ouput:
;	none
halt:
	cli
	hlt
	jmp halt
