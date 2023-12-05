	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0"
	.file	"main.c"
	.globl	console_print_char8
	.p2align	2
	.type	console_print_char8,@function
console_print_char8:
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
.Lfunc_end0:
	.size	console_print_char8, .Lfunc_end0-console_print_char8

	.globl	console_print_int
	.p2align	2
	.type	console_print_int,@function
console_print_int:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	lui	a1, 983232
	sw	a0, 32(a1)
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end1:
	.size	console_print_int, .Lfunc_end1-console_print_int

	.globl	console_print_uint
	.p2align	2
	.type	console_print_uint,@function
console_print_uint:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	lui	a1, 983232
	sw	a0, 32(a1)
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end2:
	.size	console_print_uint, .Lfunc_end2-console_print_uint

	.globl	console_print_uint_hex
	.p2align	2
	.type	console_print_uint_hex,@function
console_print_uint_hex:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	lui	a1, 983232
	sw	a0, 44(a1)
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end3:
	.size	console_print_uint_hex, .Lfunc_end3-console_print_uint_hex

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
	j	.LBB4_1
.LBB4_1:
	lw	a0, -24(s0)
	lw	a1, -20(s0)
	bge	a0, a1, .LBB4_3
	j	.LBB4_2
.LBB4_2:
	lw	a0, -16(s0)
	lw	a1, -24(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	call	console_print_char8
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB4_1
.LBB4_3:
	lw	a0, -24(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end4:
	.size	write, .Lfunc_end4-write

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	li	a0, 0
	sw	a0, -20(s0)
	sw	a0, -12(s0)
	lui	a1, %hi(str)
	lw	a1, %lo(str)(a1)
	li	a2, 12
	call	write
	lui	a0, 524289
	addi	a0, a0, 512
	sw	a0, -16(s0)
	li	a0, 10
	sw	a0, -24(s0)
	call	console_print_char8
	li	a0, -123
	call	console_print_int
	lw	a0, -24(s0)
	call	console_print_char8
	li	a0, 123
	call	console_print_uint
	lw	a0, -24(s0)
	call	console_print_char8
	lw	a0, -16(s0)
	srli	a0, a0, 8
	call	console_print_uint_hex
	lw	a0, -20(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end5:
	.size	main, .Lfunc_end5-main

	.type	a,@object
	.section	.sdata,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.word	305419896
	.size	a, 4

	.type	b,@object
	.globl	b
	.p2align	2
b:
	.word	2779096485
	.size	b, 4

	.type	.L.str,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Hello world!"
	.size	.L.str, 13

	.type	str,@object
	.section	.sdata,"aw",@progbits
	.globl	str
	.p2align	2
str:
	.word	.L.str
	.size	str, 4

	.ident	"Homebrew clang version 14.0.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym console_print_char8
	.addrsig_sym console_print_int
	.addrsig_sym console_print_uint
	.addrsig_sym console_print_uint_hex
	.addrsig_sym write
	.addrsig_sym str
