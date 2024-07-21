
.section .isr_vector
.align 8


.global vectors
.global _start
.global __mem_violation
.global trap_empty
.global _sstack
.global system



vectors:
	#j _start - делает короткий прыжок
	
	jr zero, %lo(_start)
	
	jr zero, %lo(trap_empty)
	
	jr zero, %lo(trap_empty)
	
	jr zero, %lo(trap_empty)
	
	jr zero, %lo(trap_empty)
	
	jr zero, %lo(trap_empty)
	
	jr zero, %lo(trap_empty)
	
	jr zero, %lo(trap_empty)
	
	jr zero, %lo(system)
	
	jr zero, %lo(trap_empty)
	
	jr zero, %lo(trap_empty)
	
	jr zero, %lo(__mem_violation)
	
	jr zero, %lo(trap_empty)
	
	jr zero, %lo(trap_empty)



_start:
	# setup stack pointer
	#lui sp, 0x10000
	#addi sp, sp, 2047
	
	lui sp, %hi(_sstack)
	addi sp, sp, %lo(_sstack)
	
	jr zero, %lo(__boot)


trap_empty:
	#j trap_empty
	ebreak


__mem_violation:
	#j __mem_violation
	ebreak


system:
	ebreak
	mret
	#j system

