org 0x0000

start:
	call setup_check
	call setup_handler
	call setup_sched

	mov si, strings.welcome
	call print_string

	call panic

%include "lib.asm"
%include "sched.asm"
%include "check.asm"
%include "handler.asm"
%include "strings.asm"

times 65536 - ($ - $$) nop
