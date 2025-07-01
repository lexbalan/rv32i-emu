
#include <stdint.h>
#include <stdarg.h>

#include "../sys/printf.h"
#include "../sys/console.h"
#include "../sys/system.h"
#include "../sys/base.h"
#include "../sys/vm_sys.h"


static inline uint32_t read_misa();
static inline uint64_t read_mcycle();
static inline uint32_t read_mhartid();

void print_misa2(uint32_t misa);

int main() {
	printf("Hello World!\n");

	uint32_t misa = read_misa();
	printf("misa = 0x%x\n", misa);
	print_misa2(misa);

	uint32_t mhartid = read_mhartid();
	printf("mhartid = %d\n", mhartid);

	uint64_t mcycle = read_mcycle();
	// TODO: не умеет печатать uint64_t (!)
	printf("mcycle = %d\n", (uint32_t)mcycle);

	asm("ecall");
	asm("ebreak");

	return 0;
}



#define __riscv_xlen  32

static inline uint64_t read_mcycle() {
#if __riscv_xlen == 32
    uint32_t hi, lo, hi2;

    do {
        asm volatile ("csrr %0, mcycleh" : "=r"(hi));
        asm volatile ("csrr %0, mcycle"  : "=r"(lo));
        asm volatile ("csrr %0, mcycleh" : "=r"(hi2));
    } while (hi != hi2);

    return ((uint64_t)hi << 32) | (uint64_t)lo;

#elif __riscv_xlen == 64
    uint64_t val;
    asm volatile ("csrr %0, mcycle" : "=r"(val));
    return val;

#else
#error "Unsupported RISC-V XLEN"
#endif
}


static inline uint32_t read_mhartid() {
    uint32_t hart;
    asm volatile ("csrr %0, mhartid" : "=r"(hart));
    return hart;
}


static inline uint32_t read_misa() {
    uint32_t misa;
    asm volatile ("csrr %0, misa" : "=r"(misa));
    return misa;
}


void print_misa2(uint32_t misa) {
    // Определение xlen (биты 30-31)
    const char *xlen_str = "";
    uint32_t xlen_bits = misa >> 30;
    if (xlen_bits == 1) xlen_str = "32";
    else if (xlen_bits == 2) xlen_str = "64";
    else if (xlen_bits == 3) xlen_str = "128";
    else xlen_str = "_unknown_";

    printf("rv%s", xlen_str);

    // Буквы расширений идут по стандарту в алфавитном порядке
    const char *exts = "abcdefghijklmnopqrstuvwxyz";
    for (int i = 0; i < 26; i++) {
        if (misa & (1 << i)) {
            printf("%c", exts[i]);
        }
    }

    printf("\n");
}


