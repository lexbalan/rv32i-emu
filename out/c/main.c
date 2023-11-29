
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>



#include "./mem.h"
#include "./core.h"


MemoryInterface memctl;
Core core;


uint32_t text[4096];
uint32_t text_cnt;

#define filename  "./riscv/out.bin"


uint32_t loader(void)
{
    printf("LOAD: %s\n", filename);

    FILE *const fp = fopen((char *)filename, "rb");

    if (fp == NULL) {
        printf("error: cannot open file '%s'", filename);
        return 0;
    }

    while (true) {
        const size_t n = fread((void *)&text[text_cnt], sizeof(uint32_t), 1, (FILE *)fp);

        if (n == 0) {
            break;
        }

        text_cnt = text_cnt + 1;
    }

    printf("LOADED: %d (32)words\n", text_cnt);

    uint32_t i = 0;
    while (i < text_cnt) {
        printf("=0x%08x\n", text[i]);
        i = i + 1;
    }

    printf("-----------\n");

    fclose((FILE *)fp);

    return text_cnt;
}



int main(void)
{
    printf("Hello VM!\n");

    // memory controller initialize
    memctl.read8 = &vm_mem_read8;
    memctl.read16 = &vm_mem_read16;
    memctl.read32 = &vm_mem_read32;
    memctl.write8 = &vm_mem_write8;
    memctl.write16 = &vm_mem_write16;
    memctl.write32 = &vm_mem_write32;


    const uint32_t loaded = loader();

    core_init((Core *)&core, (MemoryInterface *)&memctl, (uint32_t *)&text[0], (uint32_t)loaded);

    printf("START\n");

    while (true) {
        const bool cont = core_tick((Core *)&core);
        if (!cont) {
            break;
        }
    }

    printf("Core:\n");

    int i = 0;
    while (i < 32) {
        printf("r%d = 0x%08x\n", i, core.reg[i]);
        i = i + 1;
    }


    return 0;
}

