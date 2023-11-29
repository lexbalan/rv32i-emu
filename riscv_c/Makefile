

all:
	clang --target=riscv32 -march=rv32i -S main.c
	clang --target=riscv32 -march=rv32i main.s -c -o main.o
	ld.lld -T mem.ld -o main.elf main.o
	llvm-objcopy -Iriscv32 main.elf --only-section=.text -Obinary text.bin
	llvm-objcopy -Iriscv32 main.elf --only-section=.data -Obinary data.bin
    
    #llvm-objcopy -Iriscv32 main.elf --only-section=.text --only-section=.data -Obinary out.bin
	#llvm-objcopy -Iriscv32 main.o --only-section=.text -Obinary out.bin


elfdump:
	objdump --full-contents main.elf
