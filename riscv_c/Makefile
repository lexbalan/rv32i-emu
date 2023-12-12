

# compile C to BIN
all:
	# translate C to ASM
	clang --target=riscv32 -march=rv32i -S main.c
	# translate ASM to OBJ
	#clang --target=riscv32 -march=rv32i main.s -c -o main.o
	
	clang --target=riscv32 -march=rv32i vect.S -c -o vect.o
	clang --target=riscv32 -march=rv32i main.c -c -o main.o
	clang --target=riscv32 -march=rv32i startup.c -c -o startup.o
	clang --target=riscv32 -march=rv32i system.c -c -o system.o
	clang --target=riscv32 -march=rv32i console.c -c -o console.o
	clang --target=riscv32 -march=rv32i printf.c -c -o printf.o

	
	# link OBJects to ELF
	ld.lld -T mem.ld -o main.elf vect.o startup.o main.o system.o console.o printf.o
	
	rm *.o
	
	# extract sections from ELF to BIN file
	llvm-objcopy -Iriscv32 main.elf --only-section=.boot --only-section=.text --only-section=.data -Obinary ../image.bin

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


