; name: print_string
; desc: Prints a string terminated by 0x00
; input:
;	si: pointer to string
; output:
;	none
print_string:
	pusha

.loop:	lodsb
	cmp al, 0
	je .end
	call print_char
	jmp .loop

.end:	popa
	ret

read_key:
	push bx
	mov bh, ah
        mov ah,0x00
        int 0x16
	mov ah, bh
	pop bx

; name: print_char
; desc: Prints character
; input:
;	al: character
; output:
;	none
print_char:
	pusha
	mov ah, 0x0e
	mov bx, 0x0007
	int 0x10
	popa
	ret

; name: halt
; desc: Halts the system
; input:
;	none
; ouput:
;	none
halt:
	hlt
	jmp halt

; name: input_line
; desc: Reads a line
; input:
;	al: promt char
;	si: buffer to write to
; output:
;	cx: number of bytes read
input_line:
	pusha
	call print_char ; Output prompt character
	mov di, si      ; Target for writing line
	xchg ax, dx
.s1:	cmp al,0x08     ; Backspace?
	jne .s2
	dec di          ; Undo the backspace write
	cmp si, di
	je .s4
	dec di          ; Erase a character
	mov al, " "
	call print_char
	mov al, 0x08
	call print_char
	mov al, dl
.s2:	call read_key   ; Read keyboard
	cmp al,0x0d     ; CR pressed?
	jne .s3
	mov al,0x00
.s3:	stosb           ; Save key in buffer
	jne .s1         ; No, wait another key
	mov word [.tmp1], di
	popa
	mov cx, word [.tmp1]
	sub cx, si
	ret             ; Yes, return
.s4:	mov al, dl
	call print_char
	jmp .s2
.tmp1:	dw 0
