	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0"
	.file	"main.c"
	.globl	__boot
	.p2align	2
	.type	__boot,@function
__boot:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	call	main
	#APP
	ebreak	
	#NO_APP
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end0:
	.size	__boot, .Lfunc_end0-__boot

	.globl	some_func
	.p2align	2
	.type	some_func,@function
some_func:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sb	a0, -9(s0)
	lb	a0, -9(s0)
	addi	a0, a0, 48
	lui	a1, 983232
	sb	a0, 16(a1)
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end1:
	.size	some_func, .Lfunc_end1-some_func

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	li	a0, 0
	sw	a0, -12(s0)
	sw	a0, -16(s0)
	j	.LBB2_1
.LBB2_1:
	lw	a1, -16(s0)
	li	a0, 4
	blt	a0, a1, .LBB2_3
	j	.LBB2_2
.LBB2_2:
	lw	a0, -16(s0)
	andi	a0, a0, 255
	call	some_func
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB2_1
.LBB2_3:
	li	a0, 0
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.ident	"Homebrew clang version 14.0.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym some_func
	.addrsig_sym main
