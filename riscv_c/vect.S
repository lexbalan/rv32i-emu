
.section .isr_vector
.align 8


.global vectors
.global _stack_start
.global _start
.global __mem_violation
.global trap_empty
.global system
.global __boot



vectors:
	#j _start - делает короткий прыжок
	
	jr zero, %lo(__boot)
	
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
	
	lui sp, %hi(_stack_start)
	addi sp, sp, %lo(_stack_start)
	
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

