
.text

# void zset(void *mem, uint32_t len);
.global zset
zset:
	add t0, a0, a1		 # t0 = mem + len
zset_loop:
	sb zero, 0(a0)		 # *mem = 0
	addi a0, a0, 1		 # mem = mem + 1
	blt a0, t0, zset_loop  # if (a0 < t0) goto zset_loop
	ret



# t0 - temp reg
# t1 - mcpy_4 lim adr
# t2 - mcpy_1 lim adr

# void mcpy(void *dst, void *src, uint32_t len);
.global mcpy
mcpy:
	# вычисляю предельные адреса для mcpy_4 & mcpy_1
	li t0, 0xFFFFFFFC
	and t0, a2, t0		  # t0 = len & 0xFFFFFFFC; // n words
	add t1, t0, a0		  # t1 = t0 + dst; // lim adr4
	sub t0, a2, t0		  # t0 = len - t1; // rest (n bytes)
	add t2, t1, t0		  # t2 = t1 + t0;  // lim adr1
	
mcpy_4:

	beq t1, a0, mcpy_1	  # if (t1 == dst) goto mcpy_1;
	
mcpy_loop4:
	lw t0, 0(a1)			# t1 = *((uint32_t *)src)
	sw t0, 0(a0)			# *((uint32_t *)dst) = t1
	addi a0, a0, 4		    # src = src + 4
	addi a1, a1, 4		    # dst = dst + 4
	blt a0, t1, mcpy_loop4  # if (dst < t1) goto mcpy_loop4

mcpy_1:

	beq t2, a0, mcpy_exit   # if (t2 == dst) goto mcpy_exit;

mcpy_loop1:
	lb t0, 0(a1)			# t1 = *src
	sb t0, 0(a0)			# *dst = t1
	addi a0, a0, 1		  # ++src
	addi a1, a1, 1		  # ++dst
	blt a0, t2, mcpy_loop1  # if (dst < t2) goto mcpy_loop1
	
mcpy_exit:
	ret
	
	

