	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0"
	.file	"printf.c"
	.globl	sum64
	.p2align	2
	.type	sum64,@function
sum64:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	lw	a1, -12(s0)
	lw	a0, -16(s0)
	add	a0, a1, a0
	sltu	a1, a0, a1
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end0:
	.size	sum64, .Lfunc_end0-sum64

	.globl	putchar
	.p2align	2
	.type	putchar,@function
putchar:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sb	a0, -9(s0)
	li	a0, 0
	addi	a1, s0, -9
	li	a2, 1
	call	write
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end1:
	.size	putchar, .Lfunc_end1-putchar

	.globl	put_str8
	.p2align	2
	.type	put_str8,@function
put_str8:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	j	.LBB2_1
.LBB2_1:
	lw	a0, -12(s0)
	lb	a0, 0(a0)
	sb	a0, -13(s0)
	lbu	a0, -13(s0)
	li	a1, 0
	bne	a0, a1, .LBB2_3
	j	.LBB2_2
.LBB2_2:
	j	.LBB2_4
.LBB2_3:
	lbu	a0, -13(s0)
	call	putchar
	lw	a0, -12(s0)
	addi	a0, a0, 1
	sw	a0, -12(s0)
	j	.LBB2_1
.LBB2_4:
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end2:
	.size	put_str8, .Lfunc_end2-put_str8

	.globl	printf
	.p2align	2
	.type	printf,@function
printf:
	addi	sp, sp, -96
	sw	ra, 60(sp)
	sw	s0, 56(sp)
	addi	s0, sp, 64
	sw	a7, 28(s0)
	sw	a6, 24(s0)
	sw	a5, 20(s0)
	sw	a4, 16(s0)
	sw	a3, 12(s0)
	sw	a2, 8(s0)
	sw	a1, 4(s0)
	sw	a0, -12(s0)
	addi	a0, s0, 4
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	sw	a0, -20(s0)
	li	a0, 0
	sw	a0, -28(s0)
	j	.LBB3_1
.LBB3_1:
	lw	a0, -12(s0)
	lw	a1, -28(s0)
	add	a0, a0, a1
	lb	a0, 0(a0)
	sb	a0, -21(s0)
	lbu	a0, -21(s0)
	li	a1, 0
	bne	a0, a1, .LBB3_3
	j	.LBB3_2
.LBB3_2:
	j	.LBB3_21
.LBB3_3:
	lbu	a0, -21(s0)
	li	a1, 37
	bne	a0, a1, .LBB3_19
	j	.LBB3_4
.LBB3_4:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	lw	a0, -12(s0)
	lw	a1, -28(s0)
	add	a0, a0, a1
	lb	a0, 0(a0)
	sb	a0, -21(s0)
	addi	a0, s0, -39
	sw	a0, -44(s0)
	lbu	a0, -21(s0)
	li	a1, 100
	bne	a0, a1, .LBB3_6
	j	.LBB3_5
.LBB3_5:
	lw	a0, -16(s0)
	addi	a1, a0, 4
	sw	a1, -16(s0)
	lw	a0, 0(a0)
	sw	a0, -48(s0)
	lw	a0, -44(s0)
	lw	a1, -48(s0)
	call	sprintf_dec32
	j	.LBB3_18
.LBB3_6:
	lbu	a0, -21(s0)
	li	a1, 120
	bne	a0, a1, .LBB3_8
	j	.LBB3_7
.LBB3_7:
	lw	a0, -16(s0)
	addi	a1, a0, 4
	sw	a1, -16(s0)
	lw	a0, 0(a0)
	sw	a0, -52(s0)
	lw	a0, -44(s0)
	lw	a1, -52(s0)
	call	sprintf_hex32
	j	.LBB3_17
.LBB3_8:
	lbu	a0, -21(s0)
	li	a1, 115
	bne	a0, a1, .LBB3_10
	j	.LBB3_9
.LBB3_9:
	lw	a0, -16(s0)
	addi	a1, a0, 4
	sw	a1, -16(s0)
	lw	a0, 0(a0)
	sw	a0, -56(s0)
	lw	a0, -56(s0)
	sw	a0, -44(s0)
	j	.LBB3_16
.LBB3_10:
	lbu	a0, -21(s0)
	li	a1, 99
	bne	a0, a1, .LBB3_12
	j	.LBB3_11
.LBB3_11:
	lw	a0, -16(s0)
	addi	a1, a0, 4
	sw	a1, -16(s0)
	lb	a0, 0(a0)
	sb	a0, -57(s0)
	lb	a0, -57(s0)
	lw	a1, -44(s0)
	sb	a0, 0(a1)
	lw	a1, -44(s0)
	li	a0, 0
	sb	a0, 1(a1)
	j	.LBB3_15
.LBB3_12:
	lbu	a0, -21(s0)
	li	a1, 37
	bne	a0, a1, .LBB3_14
	j	.LBB3_13
.LBB3_13:
	lui	a0, %hi(.L.str)
	addi	a0, a0, %lo(.L.str)
	sw	a0, -44(s0)
	j	.LBB3_14
.LBB3_14:
	j	.LBB3_15
.LBB3_15:
	j	.LBB3_16
.LBB3_16:
	j	.LBB3_17
.LBB3_17:
	j	.LBB3_18
.LBB3_18:
	lw	a0, -44(s0)
	call	put_str8
	j	.LBB3_20
.LBB3_19:
	lbu	a0, -21(s0)
	call	putchar
	j	.LBB3_20
.LBB3_20:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB3_1
.LBB3_21:
	li	a0, 0
	lw	ra, 60(sp)
	lw	s0, 56(sp)
	addi	sp, sp, 96
	ret
.Lfunc_end3:
	.size	printf, .Lfunc_end3-printf

	.globl	sprintf_dec32
	.p2align	2
	.type	sprintf_dec32,@function
sprintf_dec32:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	li	a1, 0
	sb	a1, -18(s0)
	sh	a1, -20(s0)
	sw	a1, -24(s0)
	sw	a1, -28(s0)
	lw	a0, -16(s0)
	srli	a0, a0, 31
	sw	a0, -32(s0)
	lw	a0, -32(s0)
	beq	a0, a1, .LBB4_2
	j	.LBB4_1
.LBB4_1:
	lw	a1, -16(s0)
	li	a0, 0
	sub	a0, a0, a1
	sw	a0, -16(s0)
	j	.LBB4_2
.LBB4_2:
	li	a0, 0
	sw	a0, -36(s0)
	j	.LBB4_3
.LBB4_3:
	lw	a0, -16(s0)
	li	a1, 10
	sw	a1, -48(s0)
	call	__modsi3@plt
	lw	a1, -48(s0)
	sw	a0, -40(s0)
	lw	a0, -16(s0)
	call	__divsi3@plt
	sw	a0, -16(s0)
	lw	a0, -40(s0)
	addi	a0, a0, 48
	lw	a2, -36(s0)
	addi	a1, s0, -28
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -36(s0)
	addi	a0, a0, 1
	sw	a0, -36(s0)
	j	.LBB4_4
.LBB4_4:
	lw	a0, -16(s0)
	li	a1, 0
	bne	a0, a1, .LBB4_3
	j	.LBB4_5
.LBB4_5:
	li	a1, 0
	sw	a1, -44(s0)
	lw	a0, -32(s0)
	beq	a0, a1, .LBB4_7
	j	.LBB4_6
.LBB4_6:
	lw	a1, -12(s0)
	li	a0, 45
	sb	a0, 0(a1)
	lw	a0, -44(s0)
	addi	a0, a0, 1
	sw	a0, -44(s0)
	j	.LBB4_7
.LBB4_7:
	j	.LBB4_8
.LBB4_8:
	lw	a0, -36(s0)
	li	a1, 0
	beq	a0, a1, .LBB4_10
	j	.LBB4_9
.LBB4_9:
	lw	a0, -36(s0)
	addi	a0, a0, -1
	sw	a0, -36(s0)
	lw	a1, -36(s0)
	addi	a0, s0, -28
	add	a0, a0, a1
	lb	a0, 0(a0)
	lw	a1, -12(s0)
	lw	a2, -44(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -44(s0)
	addi	a0, a0, 1
	sw	a0, -44(s0)
	j	.LBB4_8
.LBB4_10:
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	add	a1, a0, a1
	li	a0, 0
	sb	a0, 0(a1)
	lw	a0, -12(s0)
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end4:
	.size	sprintf_dec32, .Lfunc_end4-sprintf_dec32

	.globl	sprintf_hex32
	.p2align	2
	.type	sprintf_hex32,@function
sprintf_hex32:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	li	a0, 0
	sw	a0, -20(s0)
	sw	a0, -24(s0)
	li	a1, 8
	sw	a1, -28(s0)
	sw	a0, -32(s0)
	j	.LBB5_1
.LBB5_1:
	lw	a0, -16(s0)
	srai	a1, a0, 31
	srli	a1, a1, 28
	add	a1, a0, a1
	andi	a1, a1, -16
	sub	a0, a0, a1
	sw	a0, -36(s0)
	lw	a0, -16(s0)
	srai	a1, a0, 31
	srli	a1, a1, 28
	add	a0, a0, a1
	srai	a0, a0, 4
	sw	a0, -16(s0)
	lw	a1, -36(s0)
	li	a0, 9
	blt	a0, a1, .LBB5_3
	j	.LBB5_2
.LBB5_2:
	lw	a0, -36(s0)
	addi	a0, a0, 48
	sb	a0, -37(s0)
	j	.LBB5_4
.LBB5_3:
	lw	a0, -36(s0)
	addi	a0, a0, 55
	sb	a0, -37(s0)
	j	.LBB5_4
.LBB5_4:
	lb	a0, -37(s0)
	lw	a2, -32(s0)
	addi	a1, s0, -24
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -32(s0)
	addi	a0, a0, 1
	sw	a0, -32(s0)
	j	.LBB5_5
.LBB5_5:
	lw	a0, -16(s0)
	li	a1, 0
	bne	a0, a1, .LBB5_1
	j	.LBB5_6
.LBB5_6:
	li	a0, 0
	sw	a0, -44(s0)
	j	.LBB5_7
.LBB5_7:
	lw	a0, -32(s0)
	li	a1, 0
	beq	a0, a1, .LBB5_9
	j	.LBB5_8
.LBB5_8:
	lw	a0, -32(s0)
	addi	a0, a0, -1
	sw	a0, -32(s0)
	lw	a1, -32(s0)
	addi	a0, s0, -24
	add	a0, a0, a1
	lb	a0, 0(a0)
	lw	a1, -12(s0)
	lw	a2, -44(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -44(s0)
	addi	a0, a0, 1
	sw	a0, -44(s0)
	j	.LBB5_7
.LBB5_9:
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	add	a1, a0, a1
	li	a0, 0
	sb	a0, 0(a1)
	lw	a0, -12(s0)
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end5:
	.size	sprintf_hex32, .Lfunc_end5-sprintf_hex32

	.type	.L.str,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%"
	.size	.L.str, 2

	.ident	"Homebrew clang version 14.0.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym putchar
	.addrsig_sym write
	.addrsig_sym put_str8
	.addrsig_sym sprintf_dec32
	.addrsig_sym sprintf_hex32
