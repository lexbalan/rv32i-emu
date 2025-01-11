
.global vectors
.global _stack_start
.global _stack_end
.global main
.global __mem_violation
.global trap_empty
.global system
.global _start


.section .isr_vector
.align 8

vectors:
	jr zero, %lo(_start)
	
	jr zero, %lo(trap_empty)
	
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
	lui sp, %hi(_stack_start)
	addi sp, sp, %lo(_stack_start)
	
	jr zero, %lo(startup)
	
	ebreak


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

