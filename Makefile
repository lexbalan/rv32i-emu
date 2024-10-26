
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm/
CPREFIX=$(OUTDIR)/c/
LLVMPREFIX = $(OUTDIR)/llvm/


all: LLVM

LLVM:
	mcc -o $(LLVMPREFIX)/main -funsafe -mbackend=llvm $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/core/core -funsafe -mbackend=llvm $(INDIR)/core/core.m
	mcc -o $(LLVMPREFIX)/core/decode -funsafe -mbackend=llvm $(INDIR)/core/decode.m
	mcc -o $(LLVMPREFIX)/mem -funsafe -mbackend=llvm $(INDIR)/mem.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/core/core.ll $(LLVMPREFIX)/mem.ll $(LLVMPREFIX)/core/decode.ll


CM:
	mcc -o $(CMPREFIX)/main -funsafe -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/core/core -funsafe -mbackend=cm $(INDIR)/core/core.m
	mcc -o $(CMPREFIX)/core/decode -funsafe -mbackend=cm $(INDIR)/core/decode.m
	mcc -o $(CMPREFIX)/mem -funsafe -mbackend=cm $(INDIR)/mem.m


C:	
	mcc -o $(CPREFIX)/main -funsafe -mbackend=c $(INDIR)/main.m
	mcc -o $(CPREFIX)/core/core -funsafe -mbackend=c $(INDIR)/core/core.m
	mcc -o $(CPREFIX)/core/decode -funsafe -mbackend=c $(INDIR)/core/decode.m
	mcc -o $(CPREFIX)/mem -funsafe -mbackend=c $(INDIR)/mem.m
	CC $(CPREFIX)/main.c $(CPREFIX)/core/core.c $(CPREFIX)/mem.c $(CPREFIX)/core/decode.c


clean:
	rm *.o
