.global _boot
.global _start

.text

_boot:                    /* x0  = 0    0x000 */
_start:
    
    li t1, 0x20
    li t2, 0x30
    li t3, 0xF00C0010
    li t4, 0x0A
loop:
    sb t1, 0(t3)
    #sb t4, 0(t3)
    addi t1, t1, 1
    blt t1, t2, loop
    
    la    a1, helloworld
    
    ebreak
    
	/*lb x10, 24(x2)
    lh x14, 24(x2)
    lw x18, 24(x2)
	lbu x18, 24(x2)
	lhu x18, 24(x2)
    sb x1, 12(x2)
    sh x1, 22(x8)
    sw x1, 32(x30)*/
    
    #li x3, 0xF00C0010
    #li x4, 0x23
    #sb x4, 0(x3)
    
    /*sll x1, x2, x3
    slt x1, x2, x3
	sltu x1, x2, x3
    srl x1, x2, x3
    sra x1, x2, x3*/
    /*slli x1, x2, 39
    srli x1, x2, 39
    srai x1, x2, 39*/
	/* Test ADDI */
    /*addi x1 , x0,   1000
    addi x2 , x1,   2000
    addi x3 , x2,  -1000
    addi x4 , x3,  -2000
    addi x5 , x4,   1000
    add x1, x2, x3

    la x6, variable
    addi x6, x6, 4*/


.rodata
helloworld:
    .ascii "Hello World!\n"

.data
variable:
	.word 0xdeadbeef



