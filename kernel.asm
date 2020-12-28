org 0x0000

start:
	call setup_sched

	mov si, strings.welcome
	call print_string

	call halt

strings:
.welcome:
	db "Kernel loaded!", 0x0a, 0x0d, 0x00

%include "lib.asm"
%include "sched.asm"

times 65536 - ($ - $$) nop
