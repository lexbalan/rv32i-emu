
# compile C to BIN
all:
	# translate C to ASM
	clang --target=riscv32 -march=rv32i -S startup.c
	clang --target=riscv32 -march=rv32i -S main.c

	# translate ASM to OBJ
	clang --target=riscv32 -march=rv32i startup.s main.s -c # -o main.o
	
	# link OBJects to ELF
	ld.lld -T mem.ld -o main.elf startup.o main.o
	
	# extract sections from ELF to BIN file
	llvm-objcopy -Iriscv32 main.elf --only-section=.boot --only-section=.text --only-section=.data -Obinary text.bin

	# make ELF dump
	llvm-objdump -d ./main.elf > ./dump.txt


# show ELF content
dump:
	objdump --full-contents main.elf


# show ELF sections
sect:
	objdump -h main.elf


# show ELF symbols
symb:
	objdump -t main.elf


