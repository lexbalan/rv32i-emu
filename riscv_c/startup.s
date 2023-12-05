	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0"
	.file	"startup.c"
	.globl	__rt0
	.p2align	2
	.type	__rt0,@function
__rt0:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	lui	a0, %hi(_data_start)
	addi	a1, a0, %lo(_data_start)
	sw	a1, -12(s0)
	lui	a0, %hi(_data_flash_start)
	addi	a0, a0, %lo(_data_flash_start)
	sw	a0, -16(s0)
	lui	a0, %hi(_data_end)
	addi	a0, a0, %lo(_data_end)
	sub	a0, a0, a1
	sw	a0, -20(s0)
	li	a0, 0
	sw	a0, -24(s0)
	j	.LBB0_1
.LBB0_1:
	lw	a0, -24(s0)
	lw	a1, -20(s0)
	bgeu	a0, a1, .LBB0_3
	j	.LBB0_2
.LBB0_2:
	lw	a1, -24(s0)
	lui	a0, %hi(_data_flash_start)
	addi	a0, a0, %lo(_data_flash_start)
	add	a0, a1, a0
	lb	a0, 0(a0)
	lui	a2, %hi(_data_start)
	addi	a2, a2, %lo(_data_start)
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB0_1
.LBB0_3:
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	__rt0, .Lfunc_end0-__rt0

	.section	boot,"ax",@progbits
	.globl	__boot
	.p2align	2
	.type	__boot,@function
__boot:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	call	__rt0
	call	main
	#APP
	ebreak	
	#NO_APP
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end1:
	.size	__boot, .Lfunc_end1-__boot

	.ident	"Homebrew clang version 14.0.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym __rt0
	.addrsig_sym main
	.addrsig_sym _data_start
	.addrsig_sym _data_flash_start
	.addrsig_sym _data_end
