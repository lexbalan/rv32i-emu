
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#include <stdlib.h>

#include <stdio.h>





#define main_text_filename  "./image.bin"

#define main_showText  false


static core_Core main_core;


//public func mem_violation_event(reason: Nat32) {
//	core.irq(&core, riscvCore.intMemViolation)
//}



static uint32_t main_loader(char *filename, uint8_t *bufptr, uint32_t buf_size);
static void main_show_mem();
int main()
{
	printf("RISC-V VM\n");

	core_BusInterface memctl = (core_BusInterface){
		.read8 = &mem_read8,
		.read16 = &mem_read16,
		.read32 = &mem_read32,
		.write8 = &mem_write8,
		.write16 = &mem_write16,
		.write32 = &mem_write32
	};

	uint8_t *romptr = mem_get_rom_ptr();
	uint32_t nbytes = main_loader(main_text_filename, romptr, mem_romSize);

	if (nbytes <= 0) {
		exit(1);
	}

	core_init(&main_core, &memctl);

	printf("~~~ START ~~~\n");

	while (!main_core.end) {
		core_tick(&main_core);
	}

	printf("core.cnt = %u\n", main_core.cnt);

	printf("\nCore dump:\n");
	core_show_regs(&main_core);
	printf("\n");
	main_show_mem();

	return 0;
}


static uint32_t main_loader(char *filename, uint8_t *bufptr, uint32_t buf_size)
{
	printf("LOAD: %s\n", filename);

	FILE *fp = fopen(filename, "rb");

	if (fp == NULL) {
		printf("error: cannot open file '%s'", filename);
		return 0;
	}

	size_t n = fread(bufptr, 1, (size_t)buf_size, fp);

	printf("LOADED: %zu bytes\n", n);

	if (main_showText) {
		size_t i = 0;
		while (i < n / 4) {
			printf("%08zx: 0x%08x\n", i, ((uint32_t *)bufptr)[i]);
			i = i + 4;
		}

		printf("-----------\n");
	}

	fclose(fp);

	return (uint32_t)n;
}


static void main_show_mem()
{
	int32_t i = 0;
	uint8_t *ramptr = mem_get_ram_ptr();
	while (i < 256) {
		printf("%08X", i * 16);

		int32_t j = 0;
		while (j < 16) {
			printf(" %02X", ramptr[i + j]);
			j = j + 1;
		}

		printf("\n");

		i = i + 16;
	}
}

