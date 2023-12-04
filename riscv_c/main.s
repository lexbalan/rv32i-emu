	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0"
	.file	"main.c"
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
.Lfunc_end0:
	.size	__boot, .Lfunc_end0-__boot

	.text
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
	j	.LBB1_1
.LBB1_1:
	lw	a0, -24(s0)
	lw	a1, -20(s0)
	bgeu	a0, a1, .LBB1_3
	j	.LBB1_2
.LBB1_2:
	lw	a1, -24(s0)
	lui	a0, %hi(_data_flash_start)
	addi	a0, a0, %lo(_data_flash_start)
	slli	a1, a1, 2
	add	a0, a1, a0
	lw	a0, 0(a0)
	lui	a2, %hi(_data_start)
	addi	a2, a2, %lo(_data_start)
	add	a1, a1, a2
	sw	a0, 0(a1)
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB1_1
.LBB1_3:
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	__rt0, .Lfunc_end1-__rt0

	.globl	console_putc
	.p2align	2
	.type	console_putc,@function
console_putc:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sb	a0, -9(s0)
	lb	a0, -9(s0)
	lui	a1, 983232
	sb	a0, 16(a1)
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end2:
	.size	console_putc, .Lfunc_end2-console_putc

	.globl	write
	.p2align	2
	.type	write,@function
write:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	li	a0, 0
	sw	a0, -24(s0)
	j	.LBB3_1
.LBB3_1:
	lw	a0, -24(s0)
	lw	a1, -20(s0)
	bge	a0, a1, .LBB3_3
	j	.LBB3_2
.LBB3_2:
	lw	a0, -16(s0)
	lw	a1, -24(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	call	console_putc
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB3_1
.LBB3_3:
	lw	a0, -24(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end3:
	.size	write, .Lfunc_end3-write

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	li	a0, 0
	sw	a0, -16(s0)
	sw	a0, -12(s0)
	lui	a1, %hi(hi)
	lw	a1, %lo(hi)(a1)
	li	a2, 12
	call	write
	lw	a0, -16(s0)
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.type	.L.str,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"hello world!"
	.size	.L.str, 13

	.type	hi,@object
	.section	.sdata,"aw",@progbits
	.globl	hi
	.p2align	2
hi:
	.word	.L.str
	.size	hi, 4

	.type	str,@object
	.bss
	.globl	str
str:
	.zero	13
	.size	str, 13

	.type	z,@object
	.section	.sbss,"aw",@nobits
	.globl	z
	.p2align	2
z:
	.word	0
	.size	z, 4

	.ident	"Homebrew clang version 14.0.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym __rt0
	.addrsig_sym console_putc
	.addrsig_sym write
	.addrsig_sym main
	.addrsig_sym _data_start
	.addrsig_sym _data_flash_start
	.addrsig_sym _data_end
	.addrsig_sym hi
