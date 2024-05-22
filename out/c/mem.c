//

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




#include "mem.h"


static uint8_t rom[romSize];
static uint8_t ram[ramSize];

uint8_t *get_ram_ptr()
{
	return (uint8_t *)&ram;
}

uint8_t *get_rom_ptr()
{
	return (uint8_t *)&rom;
}


void mem_violation_event(uint32_t reason);


void mem_violation(char rw, uint32_t adr)
{
	printf("MEMORY VIOLATION '%c' 0x%08x\n", rw, adr);
	mem_violation_event(0x55);
}


uint8_t vm_mem_read8(uint32_t adr)
{
	uint8_t x;
	x = 0;

	if ((adr >= ramStart) && (adr <= ramEnd)) {
		uint8_t *const p = (uint8_t *)(void *)&ram[adr - ramStart];
		x = *p;
	} else if ((adr >= mmioStart) && (adr <= mmioEnd)) {
		//
	} else if ((adr >= romStart) && (adr <= romEnd)) {
		uint8_t *const p = (uint8_t *)(void *)&rom[adr - romStart];
		x = *p;
	} else {
		mem_violation('r', adr);
		x = 0;
	}

	//printf("MEM_READ_8[%x] = 0x%x\n", adr, x to Nat32)

	return x;
}


uint16_t vm_mem_read16(uint32_t adr)
{
	uint16_t x;
	x = 0;

	if ((adr >= ramStart) && (adr <= ramEnd)) {
		uint16_t *const p = (uint16_t *)(void *)&ram[adr - ramStart];
		x = *p;
	} else if ((adr >= mmioStart) && (adr <= mmioEnd)) {
		//
	} else if ((adr >= romStart) && (adr <= romEnd)) {
		uint16_t *const p = (uint16_t *)(void *)&rom[adr - romStart];
		x = *p;
	} else {
		mem_violation('r', adr);
		x = 0;
	}

	//printf("MEM_READ_16[%x] = 0x%x\n", adr, x to Nat32)

	return x;
}


uint32_t vm_mem_read32(uint32_t adr)
{
	uint32_t x;
	x = 0;

	if ((adr >= romStart) && (adr <= romEnd)) {
		uint32_t *const p = (uint32_t *)(void *)&rom[adr - romStart];
		x = *p;
	} else if ((adr >= ramStart) && (adr <= ramEnd)) {
		uint32_t *const p = (uint32_t *)(void *)&ram[adr - ramStart];
		x = *p;
	} else if ((adr >= mmioStart) && (adr <= mmioEnd)) {
		x = 0;
	} else {
		mem_violation('r', adr);
	}

	//printf("MEM_READ_32[%x] = 0x%x\n", adr, x)

	return x;
}



void vm_mem_write8(uint32_t adr, uint8_t value)
{
	if ((adr >= ramStart) && (adr <= ramEnd)) {
		uint8_t *const p = (uint8_t *)(void *)&ram[adr - ramStart];
		*p = value;
	} else if ((adr >= mmioStart) && (adr <= mmioEnd)) {
		if (adr == consolePutAdr) {
			const char v = (char)value;
			printf("%c", v);
			return;
		}
	} else {
		mem_violation('w', adr);
	}
}


void vm_mem_write16(uint32_t adr, uint16_t value)
{
	if ((adr >= ramStart) && (adr <= ramEnd)) {
		uint16_t *const p = (uint16_t *)(void *)&ram[adr - ramStart];
		*p = value;
	} else if ((adr >= mmioStart) && (adr <= mmioEnd)) {
		if (adr == consolePutAdr) {
			putchar((int)value);
			return;
		}
	} else {
		mem_violation('w', adr);
	}
}


void vm_mem_write32(uint32_t adr, uint32_t value)
{
	if ((adr >= ramStart) && (adr <= ramEnd)) {
		uint32_t *const p = (uint32_t *)(void *)&ram[adr - ramStart];
		*p = value;
	} else if ((adr >= mmioStart) && (adr <= mmioEnd)) {
		if (adr == consolePutAdr) {
			putchar((int)value);
			return;
		} else if (adr == consolePrintInt32Adr) {
			printf("%u", value);
			return;
		} else if (adr == consolePrintUInt32Adr) {
			printf("%u", value);
			return;
		} else if (adr == consolePrintInt32HexAdr) {
			printf("%x", value);
			return;
		} else if (adr == consolePrintUInt32HexAdr) {
			printf("%x", value);
			return;
		}

	} else {
		mem_violation('w', adr);
	}

	//printf("MEM_WRITE_32[%x] = 0x%x\n", adr, value)
}

