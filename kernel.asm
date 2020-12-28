org 0x0000

start:
	mov si, strings.welcome
	call print_string
	call halt

strings:
.welcome:
	db "Welcome to simpleOS!", 0x0a, 0x0d, 0x00

%include "lib.asm"

times 65536 - ($ - $$) nop
