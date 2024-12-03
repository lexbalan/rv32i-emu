
COMPILER_PATH=/opt/homebrew/opt/llvm@14/bin

CC=$(COMPILER_PATH)/clang
MACHINE = --target=riscv32 -march=rv32i


# only-section=.isr  не поможет - эту секцию хрен продавишь, хз почему так
ONLYSECTION=--only-section=.text --only-section=.data


# compile C to BIN
all:
	# translate C to ASM
	#$(CC) $(MACHINE) -S main.c
	
	# translate ASM to OBJ
	#$(CC) $(MACHINE) main.s -c -o main.o
	
	$(CC) $(MACHINE) vect.S -c -o vect.o
	$(CC) $(MACHINE) base.S -c -o base.o
	$(CC) $(MACHINE) startup.c -c -o startup.o
	$(CC) $(MACHINE) main.c -c -o main.o
	$(CC) $(MACHINE) system.c -c -o system.o
	$(CC) $(MACHINE) console.c -c -o console.o
	$(CC) $(MACHINE) printf.c -c -o printf.o
	$(CC) $(MACHINE) muldivmod.c -c -o muldivmod.o
	
	
	# link OBJects to ELF
	$(CC) $(MACHINE) -nostdlib -o main.elf -T mem.ld vect.o startup.o main.o system.o console.o printf.o muldivmod.o base.o
	
	rm *.o
	
	# extract sections from ELF to BIN file
	
	llvm-objcopy -Iriscv32 main.elf $(ONLYSECTION) -Obinary ../image.bin
	
	# make ELF dump
	llvm-objdump --full-contents -d ./main.elf > ./dump.txt



# show ELF content
dump:
	objdump --full-contents main.elf


# show ELF sections
sect:
	objdump -h main.elf


# show ELF symbols
symb:
	objdump -t main.elf


info:
	objdump -x main.elf

