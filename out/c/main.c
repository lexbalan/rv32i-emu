// ./out/c//main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h>

#include "./mem.h"
#include "./core.h"


#define text_filename  "./image.bin"


#define SHOW_TEXT  false


static MemoryInterface memctl;
static Core core;


#define TEXT_BUFFER_SIZE  4096
static uint32_t text[TEXT_BUFFER_SIZE];


uint32_t loader(char *filename, uint8_t *bufptr, uint32_t buf_size)
{
    printf("LOAD: %s\n", filename);

    FILE *const fp = fopen(filename, "rb");

    if (fp == NULL) {
        printf("error: cannot open file '%s'", filename);
        return 0;
    }

    const size_t n = fread((void *)bufptr, 1, (size_t)buf_size, fp);

    printf("LOADED: %zu bytes\n", n);


    if (SHOW_TEXT) {
        size_t i;
        i = 0;
        while (i < n / 4) {
            printf("%08zx: 0x%08x\n", i, ((uint32_t *)bufptr)[i]);
            i = i + 4;
        }

        printf("-----------\n");
    }

    fclose(fp);

    return (uint32_t)n;
}


void show_regs()
{
    int32_t i;
    i = 0;
    while (i < 16) {
        printf("x%02d = 0x%08x", i, core.reg[i]);
        printf("    ");
        printf("x%02d = 0x%08x\n", i + 16, core.reg[i + 16]);
        i = i + 1;
    }
}

void show_mem()
{
    int32_t i;
    i = 0;
    uint8_t *const ramptr = get_ram_ptr();
    while (i < 256) {
        printf("%08X", i * 16);

        int32_t j;
        j = 0;
        while (j < 16) {
            printf(" %02X", ramptr[i + j]);
            j = j + 1;
        }

        printf("\n");

        i = i + 16;
    }
}



void mem_violation_event(uint32_t reason)
{
    core_irq(&core, INT_MEM_VIOLATION);
}


int main()
{
    printf("RISC-V VM\n");

    // memory controller initialize
    memctl.read8 = &vm_mem_read8;
    memctl.read16 = &vm_mem_read16;
    memctl.read32 = &vm_mem_read32;

    memctl.write8 = &vm_mem_write8;
    memctl.write16 = &vm_mem_write16;
    memctl.write32 = &vm_mem_write32;


    uint8_t *const romptr = get_rom_ptr();

    core_init(&core, &memctl);

    printf("START\n");

    while (true) {
        //var cmd: [8]Char8
        //scanf("%c", &cmd[0])

        /*if strcmp(&cmd, "regs") == 0 {
			show_regs()
		} else if strcmp(&cmd, "mem") == 0{
			show_mem()
		}*/

        const bool cont = core_tick(&core);
        if (!cont) {
            break;
        }
    }

    printf("core.cnt = %d\n", core.cnt);

    printf("\nCore dump:\n");

    show_regs();

    show_mem();

    return 0;
}

