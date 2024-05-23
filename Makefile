
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm/
CPREFIX=$(OUTDIR)/c/
LLVMPREFIX = $(OUTDIR)/llvm/


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -funsafe -mbackend=cm $(INDIR)/main.cm
	mcc -o $(CMPREFIX)/core/core -funsafe -mbackend=cm $(INDIR)/core/core.hm
	mcc -o $(CMPREFIX)/core/core -funsafe -mbackend=cm $(INDIR)/core/core.cm
	mcc -o $(CMPREFIX)/core/decode -funsafe -mbackend=cm $(INDIR)/core/decode.hm
	mcc -o $(CMPREFIX)/core/decode -funsafe -mbackend=cm $(INDIR)/core/decode.cm
	mcc -o $(CMPREFIX)/core/csr -funsafe -mbackend=cm $(INDIR)/core/csr.hm
	mcc -o $(CMPREFIX)/core/csr -funsafe -mbackend=cm $(INDIR)/core/csr.cm
	mcc -o $(CMPREFIX)/mem -funsafe -mbackend=cm $(INDIR)/mem.hm
	mcc -o $(CMPREFIX)/mem -funsafe -mbackend=cm $(INDIR)/mem.cm


LLVM:
	mcc -o $(LLVMPREFIX)/main -funsafe -mbackend=llvm $(INDIR)/main.cm
	mcc -o $(LLVMPREFIX)/core/core -funsafe -mbackend=llvm $(INDIR)/core/core.cm
	mcc -o $(LLVMPREFIX)/core/decode -funsafe -mbackend=llvm $(INDIR)/core/decode.cm
	mcc -o $(LLVMPREFIX)/core/csr -funsafe -mbackend=llvm $(INDIR)/core/csr.cm
	mcc -o $(LLVMPREFIX)/mem -funsafe -mbackend=llvm $(INDIR)/mem.cm
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/core/core.ll $(LLVMPREFIX)/mem.ll $(LLVMPREFIX)/core/csr.ll $(LLVMPREFIX)/core/decode.ll


C:	
	mcc -o $(CPREFIX)/main -funsafe -mbackend=c $(INDIR)/main.cm
	mcc -o $(CPREFIX)/core/core -mbackend=c $(INDIR)/core/core.hm
	mcc -o $(CPREFIX)/core/core -funsafe -mbackend=c $(INDIR)/core/core.cm
	mcc -o $(CPREFIX)/core/decode -funsafe -mbackend=c $(INDIR)/core/decode.hm
	mcc -o $(CPREFIX)/core/decode -funsafe -mbackend=c $(INDIR)/core/decode.cm
	mcc -o $(CPREFIX)/core/csr -mbackend=c $(INDIR)/core/csr.hm
	mcc -o $(CPREFIX)/core/csr -funsafe -mbackend=c $(INDIR)/core/csr.cm
	mcc -o $(CPREFIX)/mem -mbackend=c $(INDIR)/mem.hm
	mcc -o $(CPREFIX)/mem -funsafe -mbackend=c $(INDIR)/mem.cm
	CC $(CPREFIX)/main.c $(CPREFIX)/core/core.c $(CPREFIX)/mem.c $(CPREFIX)/core/csr.c $(CPREFIX)/core/decode.c


clean:
	rm *.o
