// ./out/c//main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"








#define text_filename  "./image.bin"
#define showText  false
static core_Core core;
//public func mem_violation_event(reason: Nat32) {
//	core.irq(&core, riscvCore.intMemViolation)
//}

static uint32_t loader(char *filename, uint8_t *bufptr, uint32_t buf_size);
static void show_mem();

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

	uint8_t *const romptr = mem_get_rom_ptr();
	const uint32_t nbytes = loader(text_filename, romptr, mem_romSize);

	if (nbytes <= 0) {
		exit(1);
	}

	core_init((core_Core *)&core, (core_BusInterface *)&memctl);

	printf("~~~ START ~~~\n");

	while (!core.end) {
		core_tick((core_Core *)&core);
	}

	printf("core.cnt = %u\n", core.cnt);

	printf("\nCore dump:\n");
	core_show_regs((core_Core *)&core);
	printf("\n");
	show_mem();

	return 0;
}

static uint32_t loader(char *filename, uint8_t *bufptr, uint32_t buf_size)
{
	printf("LOAD: %s\n", filename);

	FILE *const fp = fopen(filename, "rb");

	if (fp == NULL) {
		printf("error: cannot open file '%s'", filename);
		return 0;
	}

	const size_t n = fread(bufptr, 1, (size_t)buf_size, fp);

	printf("LOADED: %zu bytes\n", n);

	if (showText) {
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

static void show_mem()
{
	int32_t i = 0;
	uint8_t *const ramptr = mem_get_ram_ptr();
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

