#
# C > O > ELF > BIN
#


TARGET=main

OBJECTS = vect.o startup.o main.o system.o console.o printf.o muldivmod.o base.o

CFLAGS = --target=riscv32 -march=rv32i
LINKERSCRIPT = mem.ld


.PHONY: objects


all: $(TARGET).bin


objects:
	clang $(CFLAGS) vect.S -c -o vect.o
	clang $(CFLAGS) main.c -c -o main.o
	clang $(CFLAGS) startup.c -c -o startup.o
	clang $(CFLAGS) system.c -c -o system.o
	clang $(CFLAGS) console.c -c -o console.o
	clang $(CFLAGS) printf.c -c -o printf.o
	clang $(CFLAGS) muldivmod.c -c -o muldivmod.o
	clang $(CFLAGS) base.S -c -o base.o


# link OBJects to ELF
$(TARGET).elf: objects
	ld.lld -T $(LINKERSCRIPT) -o $(TARGET).elf $(OBJECTS)
	

# extract sections from ELF to BIN file
$(TARGET).bin: $(TARGET).elf
	llvm-objcopy -Iriscv32 $(TARGET).elf --only-section=.boot --only-section=.text --only-section=.data -Obinary ../$(TARGET).bin


clean:
	rm *.o


objdump: $(TARGET).elf
	# make ELF dump
	llvm-objdump -d ./$(TARGET).elf > ./$(TARGET)_dump.txt


# show ELF content
dump: $(TARGET).elf
	objdump --full-contents $(TARGET).elf


# show ELF sections
sections: $(TARGET).elf
	objdump -h $(TARGET).elf


# show ELF symbols
symbols: $(TARGET).elf
	objdump -t $(TARGET).elf



# translate C to ASM
#clang $(CFLAGS) -S main.c
#clang $(CFLAGS) -S printf.c
# translate ASM to OBJ
#clang $(CFLAGS) main.s -c -o main.o

