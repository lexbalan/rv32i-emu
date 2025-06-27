
INDIR=./src
OUTDIR=./out

.PHONY: C LLVM CM clean

# output dir prefix
CMPREFIX=$(OUTDIR)/cm/
CPREFIX=$(OUTDIR)/c/
LLVMPREFIX = $(OUTDIR)/llvm/

COPTIONS = --include=$(CPREFIX)/include

all: LLVM

CM_OPTS = -funsafe  # -fparanoid

LLVM:
	mcc -o $(LLVMPREFIX)/main $(CM_OPTS) -mbackend=llvm $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/hart/hart $(CM_OPTS) -mbackend=llvm $(INDIR)/hart/hart.m
	mcc -o $(LLVMPREFIX)/hart/decode $(CM_OPTS) -mbackend=llvm $(INDIR)/hart/decode.m
	mcc -o $(LLVMPREFIX)/mem $(CM_OPTS) -mbackend=llvm $(INDIR)/mem.m
	mcc -o $(LLVMPREFIX)/mmio $(CM_OPTS) -mbackend=llvm $(INDIR)/mmio.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/hart/hart.ll $(LLVMPREFIX)/hart/decode.ll $(LLVMPREFIX)/mem.ll $(LLVMPREFIX)/mmio.ll


CM:
	mcc -o $(CMPREFIX)/main $(CM_OPTS) -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/hart/hart $(CM_OPTS) -mbackend=cm $(INDIR)/hart/hart.m
	mcc -o $(CMPREFIX)/hart/decode $(CM_OPTS) -mbackend=cm $(INDIR)/hart/decode.m
	mcc -o $(CMPREFIX)/mem $(CM_OPTS) -mbackend=cm $(INDIR)/mem.m
	mcc -o $(CMPREFIX)/mmio $(CM_OPTS) -mbackend=cm $(INDIR)/mmio.m


C:
	mcc -o $(CPREFIX)/main $(COPTIONS) $(CM_OPTS) -mbackend=c $(INDIR)/main.m
	mcc -o $(CPREFIX)/hart/hart $(COPTIONS) -mbackend=c $(CM_OPTS) $(INDIR)/hart/hart.m
	mcc -o $(CPREFIX)/hart/decode $(COPTIONS) -mbackend=c $(CM_OPTS) $(INDIR)/hart/decode.m
	mcc -o $(CPREFIX)/mem $(CM_OPTS) $(COPTIONS) -mbackend=c $(INDIR)/mem.m
	mcc -o $(CPREFIX)/mmio $(CM_OPTS) $(COPTIONS) -mbackend=c $(INDIR)/mmio.m
	CC -I$(CPREFIX)/include $(CPREFIX)/main.c $(CPREFIX)/hart/hart.c $(CPREFIX)/hart/decode.c $(CPREFIX)/mem.c $(CPREFIX)/mmio.c


clean:
	rm *.o

