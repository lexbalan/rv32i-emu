
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm/
CPREFIX=$(OUTDIR)/c/
LLVMPREFIX = $(OUTDIR)/llvm/


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -funsafe -mbackend=cm $(INDIR)/main.cm
	mcc -o $(CMPREFIX)/core -funsafe -mbackend=cm $(INDIR)/core.hm
	mcc -o $(CMPREFIX)/core -funsafe -mbackend=cm $(INDIR)/core.cm
	mcc -o $(CMPREFIX)/mem -funsafe -mbackend=cm $(INDIR)/mem.hm
	mcc -o $(CMPREFIX)/mem -funsafe -mbackend=cm $(INDIR)/mem.cm


LLVM:
	mcc -o $(LLVMPREFIX)/main -funsafe -mbackend=llvm $(INDIR)/main.cm
	mcc -o $(LLVMPREFIX)/core -funsafe -mbackend=llvm $(INDIR)/core.cm
	mcc -o $(LLVMPREFIX)/mem -funsafe -mbackend=llvm $(INDIR)/mem.cm
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/core.ll $(LLVMPREFIX)/mem.ll


C:	
	mcc -o $(CPREFIX)/main -funsafe -mbackend=c $(INDIR)/main.cm
	mcc -o $(CPREFIX)/core -mbackend=c $(INDIR)/core.hm
	mcc -o $(CPREFIX)/core -funsafe -mbackend=c $(INDIR)/core.cm
	mcc -o $(CPREFIX)/mem -mbackend=c $(INDIR)/mem.hm
	mcc -o $(CPREFIX)/mem -funsafe -mbackend=c $(INDIR)/mem.cm
	CC $(CPREFIX)/main.c $(CPREFIX)/core.c $(CPREFIX)/mem.c


clean:
	rm *.o
