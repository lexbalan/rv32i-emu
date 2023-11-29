
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm/
CPREFIX=$(OUTDIR)/c/
LLVMPREFIX = $(OUTDIR)/llvm/


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.cm


LLVM:
	mcc -o $(LLVMPREFIX)/main -funsafe -mbackend=llvm $(INDIR)/main.cm
	mcc -o $(LLVMPREFIX)/core -mbackend=llvm $(INDIR)/core.cm
	mcc -o $(LLVMPREFIX)/mem -mbackend=llvm $(INDIR)/mem.cm
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/core.ll $(LLVMPREFIX)/mem.ll


C:	
	mcc -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.cm
	mcc -o $(CPREFIX)/core -mbackend=c $(INDIR)/core.hm
	mcc -o $(CPREFIX)/core -mbackend=c $(INDIR)/core.cm
	mcc -o $(CPREFIX)/mem -mbackend=c $(INDIR)/mem.cm
	mcc -o $(CPREFIX)/mem -mbackend=c $(INDIR)/mem.hm
	CC $(CPREFIX)/main.c $(CPREFIX)/core.c $(CPREFIX)/mem.c


clean:
	rm *.o
