strings:
.welcome:
        db "Kernel loaded!", 0x0a, 0x0d, 0x00
errors:
.panic:	db "System paniced!", 0x0a, 0x0d, "Press any key to reboot.", 0x0a, 0x0d, 0x00
.div_int:
	db "Division error!", 0x0a, 0x0d, 0x00
.nmi_int:
	db "NMI", 0x0a, 0x0d, 0x00
.ill_opcode:
	db "Invalid opcode!", 0x0a, 0x0d, 0x00
.cpuid:
	db "No cpuid detected!", 0x0a, 0x0d, 0x00
