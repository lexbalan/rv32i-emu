	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0"
	.file	"main.c"
	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	li	a0, 0
	sw	a0, -40(s0)
	sw	a0, -12(s0)
	li	a0, 10
	sw	a0, -16(s0)
	li	a0, 5
	sw	a0, -20(s0)
	lw	a0, -20(s0)
	lw	a1, -16(s0)
	sub	a0, a0, a1
	sw	a0, -24(s0)
	lui	a0, %hi(.L.str.1)
	addi	a0, a0, %lo(.L.str.1)
	call	printf
	lui	a0, %hi(.L.str.2)
	addi	a0, a0, %lo(.L.str.2)
	call	printf
	lui	a0, %hi(.L.str.3)
	addi	a0, a0, %lo(.L.str.3)
	li	a1, 36
	call	printf
	lui	a0, %hi(.L.str.4)
	addi	a0, a0, %lo(.L.str.4)
	lui	a1, %hi(.L.str.5)
	addi	a1, a1, %lo(.L.str.5)
	call	printf
	lui	a0, %hi(.L.str.6)
	addi	a0, a0, %lo(.L.str.6)
	li	a1, 123
	call	printf
	lui	a0, %hi(.L.str.7)
	addi	a0, a0, %lo(.L.str.7)
	li	a1, -103
	call	printf
	lui	a0, %hi(.L.str.8)
	addi	a0, a0, %lo(.L.str.8)
	lui	a1, 74565
	addi	a1, a1, 1663
	call	printf
	lui	a0, %hi(j)
	addi	a0, a0, %lo(j)
	lui	a1, %hi(k)
	addi	a1, a1, %lo(k)
	sw	a1, -48(s0)
	li	a2, 8
	sw	a2, -44(s0)
	call	mcpy
	lw	a0, -48(s0)
	lw	a1, -44(s0)
	call	zset
	lw	a0, -40(s0)
	sw	a0, -28(s0)
	j	.LBB0_1
.LBB0_1:
	lw	a1, -28(s0)
	li	a0, 7
	blt	a0, a1, .LBB0_3
	j	.LBB0_2
.LBB0_2:
	lw	a1, -28(s0)
	lui	a0, %hi(k)
	addi	a0, a0, %lo(k)
	add	a0, a1, a0
	lbu	a2, 0(a0)
	lui	a0, %hi(.L.str.9)
	addi	a0, a0, %lo(.L.str.9)
	call	printf
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB0_1
.LBB0_3:
	li	a0, 0
	sw	a0, -28(s0)
	j	.LBB0_4
.LBB0_4:
	lw	a1, -28(s0)
	li	a0, 7
	blt	a0, a1, .LBB0_6
	j	.LBB0_5
.LBB0_5:
	lw	a1, -28(s0)
	lui	a0, %hi(j)
	addi	a0, a0, %lo(j)
	add	a0, a1, a0
	lbu	a2, 0(a0)
	lui	a0, %hi(.L.str.10)
	addi	a0, a0, %lo(.L.str.10)
	call	printf
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB0_4
.LBB0_6:
	li	a0, 1
	sw	a0, -36(s0)
	lw	a0, -36(s0)
	#APP
	csrrw	a0, misa, a0
	#NO_APP
	sw	a0, -32(s0)
	li	a0, 0
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

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

	.type	k,@object
	.globl	k
k:
	.ascii	"\001\002\003\004\005\006\007\b"
	.size	k, 8

	.type	.L.str.1,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.1:
	.asciz	"Hello World!\n"
	.size	.L.str.1, 14

	.type	.L.str.2,@object
.L.str.2:
	.asciz	"%% = '%%'\n"
	.size	.L.str.2, 11

	.type	.L.str.3,@object
.L.str.3:
	.asciz	"c = '%c'\n"
	.size	.L.str.3, 10

	.type	.L.str.4,@object
.L.str.4:
	.asciz	"s = \"%s\"\n"
	.size	.L.str.4, 10

	.type	.L.str.5,@object
.L.str.5:
	.asciz	"Hi!"
	.size	.L.str.5, 4

	.type	.L.str.6,@object
.L.str.6:
	.asciz	"d = %d\n"
	.size	.L.str.6, 8

	.type	.L.str.7,@object
.L.str.7:
	.asciz	"-d = %d\n"
	.size	.L.str.7, 9

	.type	.L.str.8,@object
.L.str.8:
	.asciz	"x = 0x%x\n"
	.size	.L.str.8, 10

	.type	j,@object
	.section	.sbss,"aw",@nobits
	.globl	j
j:
	.zero	8
	.size	j, 8

	.type	.L.str.9,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.9:
	.asciz	"k[%d] = %d\n"
	.size	.L.str.9, 12

	.type	.L.str.10,@object
.L.str.10:
	.asciz	"j[%d] = %d\n"
	.size	.L.str.10, 12

	.type	buf1,@object
	.bss
	.globl	buf1
buf1:
	.zero	1024
	.size	buf1, 1024

	.type	buf2,@object
	.globl	buf2
buf2:
	.zero	1024
	.size	buf2, 1024

	.ident	"Homebrew clang version 14.0.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym printf
	.addrsig_sym mcpy
	.addrsig_sym zset
	.addrsig_sym k
	.addrsig_sym j
