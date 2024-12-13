
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm/
CPREFIX=$(OUTDIR)/c/
LLVMPREFIX = $(OUTDIR)/llvm/

COPTIONS = --include=$(CPREFIX)/include

all: LLVM

LLVM:
	mcc -o $(LLVMPREFIX)/main -funsafe -mbackend=llvm $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/core/core -funsafe -mbackend=llvm $(INDIR)/core/core.m
	mcc -o $(LLVMPREFIX)/core/decode -funsafe -mbackend=llvm $(INDIR)/core/decode.m
	mcc -o $(LLVMPREFIX)/mem -funsafe -mbackend=llvm $(INDIR)/mem.m
	mcc -o $(LLVMPREFIX)/mmio -funsafe -mbackend=llvm $(INDIR)/mmio.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/core/core.ll $(LLVMPREFIX)/core/decode.ll $(LLVMPREFIX)/mem.ll $(LLVMPREFIX)/mmio.ll


CM:
	mcc -o $(CMPREFIX)/main -funsafe -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/core/core -funsafe -mbackend=cm $(INDIR)/core/core.m
	mcc -o $(CMPREFIX)/core/decode -funsafe -mbackend=cm $(INDIR)/core/decode.m
	mcc -o $(CMPREFIX)/mem -funsafe -mbackend=cm $(INDIR)/mem.m
	mcc -o $(CMPREFIX)/mmio -funsafe -mbackend=cm $(INDIR)/mmio.m


C:
	mcc -o $(CPREFIX)/main $(COPTIONS) -funsafe -mbackend=c $(INDIR)/main.m
	mcc -o $(CPREFIX)/core/core $(COPTIONS) -mbackend=c -funsafe $(INDIR)/core/core.m
	mcc -o $(CPREFIX)/core/decode $(COPTIONS) -mbackend=c -funsafe $(INDIR)/core/decode.m
	mcc -o $(CPREFIX)/mem -funsafe $(COPTIONS) -mbackend=c $(INDIR)/mem.m
	mcc -o $(CPREFIX)/mmio -funsafe $(COPTIONS) -mbackend=c $(INDIR)/mmio.m
	CC -I$(CPREFIX)/include $(CPREFIX)/main.c $(CPREFIX)/core/core.c $(CPREFIX)/core/decode.c $(CPREFIX)/mem.c $(CPREFIX)/mmio.c


clean:
	rm *.o
