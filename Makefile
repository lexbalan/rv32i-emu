
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm/
CPREFIX=$(OUTDIR)/c/
LLVMPREFIX = $(OUTDIR)/llvm/

COPTIONS = --include=$(CPREFIX)/include

all: LLVM

CM_OPTS = -funsafe  # -fparanoid

LLVM:
	mcc -o $(LLVMPREFIX)/main $(CM_OPTS) -mbackend=llvm $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/core/core $(CM_OPTS) -mbackend=llvm $(INDIR)/core/core.m
	mcc -o $(LLVMPREFIX)/core/decode $(CM_OPTS) -mbackend=llvm $(INDIR)/core/decode.m
	mcc -o $(LLVMPREFIX)/mem $(CM_OPTS) -mbackend=llvm $(INDIR)/mem.m
	mcc -o $(LLVMPREFIX)/mmio $(CM_OPTS) -mbackend=llvm $(INDIR)/mmio.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/core/core.ll $(LLVMPREFIX)/core/decode.ll $(LLVMPREFIX)/mem.ll $(LLVMPREFIX)/mmio.ll


CM:
	mcc -o $(CMPREFIX)/main $(CM_OPTS) -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/core/core $(CM_OPTS) -mbackend=cm $(INDIR)/core/core.m
	mcc -o $(CMPREFIX)/core/decode $(CM_OPTS) -mbackend=cm $(INDIR)/core/decode.m
	mcc -o $(CMPREFIX)/mem $(CM_OPTS) -mbackend=cm $(INDIR)/mem.m
	mcc -o $(CMPREFIX)/mmio $(CM_OPTS) -mbackend=cm $(INDIR)/mmio.m


C:
	mcc -o $(CPREFIX)/main $(COPTIONS) $(CM_OPTS) -mbackend=c $(INDIR)/main.m
	mcc -o $(CPREFIX)/core/core $(COPTIONS) -mbackend=c $(CM_OPTS) $(INDIR)/core/core.m
	mcc -o $(CPREFIX)/core/decode $(COPTIONS) -mbackend=c $(CM_OPTS) $(INDIR)/core/decode.m
	mcc -o $(CPREFIX)/mem $(CM_OPTS) $(COPTIONS) -mbackend=c $(INDIR)/mem.m
	mcc -o $(CPREFIX)/mmio $(CM_OPTS) $(COPTIONS) -mbackend=c $(INDIR)/mmio.m
	CC -I$(CPREFIX)/include $(CPREFIX)/main.c $(CPREFIX)/core/core.c $(CPREFIX)/core/decode.c $(CPREFIX)/mem.c $(CPREFIX)/mmio.c


clean:
	rm *.o
