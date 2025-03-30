//
//

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "mem.h"


// see mem.ld

#define mmioSize  (0xFFFF)
#define mmioStart  (0xF00C0000)
#define mmioEnd  (mmioStart + mmioSize)

static uint8_t rom[mem_romSize];
static uint8_t ram[mem_ramSize];

uint8_t *mem_get_ram_ptr()
{
	return (uint8_t *)&ram;
}

uint8_t *mem_get_rom_ptr()
{
	return (uint8_t *)&rom;
}

static uint32_t memviolationCnt = 0;
static void memoryViolation(char rw, uint32_t adr)
{
	printf("*** MEMORY VIOLATION '%c' 0x%08x ***\n", rw, adr);
	if (memviolationCnt > 10) {
		exit(1);
	}
	memviolationCnt = memviolationCnt + 1;
	//	memoryViolation_event(0x55) // !
}

static bool isAdressInRange(uint32_t x, uint32_t a, uint32_t b)
{
	return x >= a && x < b;
}

uint8_t mem_read8(uint32_t adr)
{
	uint8_t x = 0;

	if (isAdressInRange(adr, mem_ramStart, mem_ramEnd)) {
		uint8_t *const ptr = (uint8_t *)&ram[adr - mem_ramStart];
		x = *ptr;
	} else if (isAdressInRange(adr, mmioStart, mmioEnd)) {
		//
	} else if (isAdressInRange(adr, mem_romStart, mem_romEnd)) {
		uint8_t *const ptr = (uint8_t *)&rom[adr - mem_romStart];
		x = *ptr;
	} else {
		memoryViolation('r', adr);
		x = 0;
	}

	//printf("MEM_READ_8[%x] = 0x%x\n", adr, x to Nat32)

	return x;
}

uint16_t mem_read16(uint32_t adr)
{
	uint16_t x = 0;

	if (isAdressInRange(adr, mem_ramStart, mem_ramEnd)) {
		uint16_t *const ptr = (uint16_t *)&ram[adr - mem_ramStart];
		x = *ptr;
	} else if (isAdressInRange(adr, mmioStart, mmioEnd)) {
		//
	} else if (isAdressInRange(adr, mem_romStart, mem_romEnd)) {
		uint16_t *const ptr = (uint16_t *)&rom[adr - mem_romStart];
		x = *ptr;
	} else {
		memoryViolation('r', adr);
	}

	//printf("MEM_READ_16[%x] = 0x%x\n", adr, x to Nat32)
	return x;
}

uint32_t mem_read32(uint32_t adr)
{
	uint32_t x = 0;

	if (isAdressInRange(adr, mem_romStart, mem_romEnd)) {
		uint32_t *const ptr = (uint32_t *)&rom[adr - mem_romStart];
		x = *ptr;
	} else if (isAdressInRange(adr, mem_ramStart, mem_ramEnd)) {
		uint32_t *const ptr = (uint32_t *)&ram[adr - mem_ramStart];
		x = *ptr;
	} else if (isAdressInRange(adr, mmioStart, mmioEnd)) {
		//TODO
	} else {
		memoryViolation('r', adr);
	}

	//printf("MEM_READ_32[%x] = 0x%x\n", adr, x)

	return x;
}

void mem_write8(uint32_t adr, uint8_t value)
{
	if (isAdressInRange(adr, mem_ramStart, mem_ramEnd)) {
		uint8_t *const ptr = (uint8_t *)&ram[adr - mem_ramStart];
		*ptr = value;
	} else if (isAdressInRange(adr, mmioStart, mmioEnd)) {
		mmio_write8(adr - mmioStart, value);
	} else {
		memoryViolation('w', adr);
	}
}

void mem_write16(uint32_t adr, uint16_t value)
{
	if (isAdressInRange(adr, mem_ramStart, mem_ramEnd)) {
		uint16_t *const ptr = (uint16_t *)&ram[adr - mem_ramStart];
		*ptr = value;
	} else if (isAdressInRange(adr, mmioStart, mmioEnd)) {
		mmio_write16(adr - mmioStart, value);
	} else {
		memoryViolation('w', adr);
	}
}

void mem_write32(uint32_t adr, uint32_t value)
{
	if (isAdressInRange(adr, mem_ramStart, mem_ramEnd)) {
		uint32_t *const ptr = (uint32_t *)&ram[adr - mem_ramStart];
		*ptr = value;
	} else if (isAdressInRange(adr, mmioStart, mmioEnd)) {
		mmio_write32(adr - mmioStart, value);
	} else {
		memoryViolation('w', adr);
	}

	//printf("MEM_WRITE_32[%x] = 0x%x\n", adr, value)
}

