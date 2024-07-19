

CFLAGS = --target=riscv32 -march=rv32i

# compile C to BIN
all:
	# translate C to ASM
	#clang $(CFLAGS) -S main.c
	#clang $(CFLAGS) -S printf.c
	# translate ASM to OBJ
	#clang $(CFLAGS) main.s -c -o main.o
	
	clang $(CFLAGS) vect.S -c -o vect.o
	clang $(CFLAGS) main.c -c -o main.o
	clang $(CFLAGS) startup.c -c -o startup.o
	clang $(CFLAGS) system.c -c -o system.o
	clang $(CFLAGS) console.c -c -o console.o
	clang $(CFLAGS) printf.c -c -o printf.o
	clang $(CFLAGS) muldivmod.c -c -o muldivmod.o
	clang $(CFLAGS) base.S -c -o base.o

	
	# link OBJects to ELF
	ld.lld -T mem.ld -o main.elf vect.o startup.o main.o system.o console.o printf.o muldivmod.o base.o
	
	# extract sections from ELF to BIN file
	llvm-objcopy -Iriscv32 main.elf --only-section=.boot --only-section=.text --only-section=.data -Obinary ../image.bin

	# make ELF dump
	llvm-objdump -d ./main.elf > ./dump.txt


clean:
	rm *.o


# show ELF content
dump:
	objdump --full-contents main.elf


# show ELF sections
sect:
	objdump -h main.elf


# show ELF symbols
symb:
	objdump -t main.elf

