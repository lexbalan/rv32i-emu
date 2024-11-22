// ./out/c//mem.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "mem.h"



#define mem_mmioSize  0xFFFF
#define mem_mmioStart  0xF00C0000
#define mem_mmioEnd  (mem_mmioStart + mem_mmioSize)
void memoryViolation(char rw, uint32_t adr);
bool isAdressInRange(uint32_t x, uint32_t a, uint32_t b);



static uint8_t rom[mem_romSize];
static uint8_t ram[mem_ramSize];

void memoryViolation(char rw, uint32_t adr)
{
	printf("*** MEMORY VIOLATION '%c' 0x%08x ***\n", rw, adr);
	//	memoryViolation_event(0x55) // !
}

bool isAdressInRange(uint32_t x, uint32_t a, uint32_t b)
{
	return (x >= a) && (x < b);
}

uint8_t *mem_get_ram_ptr()
{
	return (uint8_t *)&ram;
}

uint8_t *mem_get_rom_ptr()
{
	return (uint8_t *)&rom;
}

uint8_t mem_read8(uint32_t adr)
{
	uint8_t x;
	x = 0;

	if (isAdressInRange(adr, mem_ramStart, mem_ramEnd)) {
		uint8_t *const ptr = (uint8_t *)(void *)&ram[adr - mem_ramStart];
		x = *ptr;
	} else if (isAdressInRange(adr, mem_mmioStart, mem_mmioEnd)) {
		//
	} else if (isAdressInRange(adr, mem_romStart, mem_romEnd)) {
		uint8_t *const ptr = (uint8_t *)(void *)&rom[adr - mem_romStart];
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
	uint16_t x;
	x = 0;

	if (isAdressInRange(adr, mem_ramStart, mem_ramEnd)) {
		uint16_t *const ptr = (uint16_t *)(void *)&ram[adr - mem_ramStart];
		x = *ptr;
	} else if (isAdressInRange(adr, mem_mmioStart, mem_mmioEnd)) {
		//
	} else if (isAdressInRange(adr, mem_romStart, mem_romEnd)) {
		uint16_t *const ptr = (uint16_t *)(void *)&rom[adr - mem_romStart];
		x = *ptr;
	} else {
		memoryViolation('r', adr);
	}

	//printf("MEM_READ_16[%x] = 0x%x\n", adr, x to Nat32)
	return x;
}

uint32_t mem_read32(uint32_t adr)
{
	uint32_t x;
	x = 0;

	if (isAdressInRange(adr, mem_romStart, mem_romEnd)) {
		uint32_t *const ptr = (uint32_t *)(void *)&rom[adr - mem_romStart];
		x = *ptr;
	} else if (isAdressInRange(adr, mem_ramStart, mem_ramEnd)) {
		uint32_t *const ptr = (uint32_t *)(void *)&ram[adr - mem_ramStart];
		x = *ptr;
	} else if (isAdressInRange(adr, mem_mmioStart, mem_mmioEnd)) {
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
		uint8_t *const ptr = (uint8_t *)(void *)&ram[adr - mem_ramStart];
		*ptr = value;
	} else if (isAdressInRange(adr, mem_mmioStart, mem_mmioEnd)) {
		mmio_write8(adr - mem_mmioStart, value);
	} else {
		memoryViolation('w', adr);
	}
}

void mem_write16(uint32_t adr, uint16_t value)
{
	if (isAdressInRange(adr, mem_ramStart, mem_ramEnd)) {
		uint16_t *const ptr = (uint16_t *)(void *)&ram[adr - mem_ramStart];
		*ptr = value;
	} else if (isAdressInRange(adr, mem_mmioStart, mem_mmioEnd)) {
		mmio_write16(adr - mem_mmioStart, value);
	} else {
		memoryViolation('w', adr);
	}
}

void mem_write32(uint32_t adr, uint32_t value)
{
	if (isAdressInRange(adr, mem_ramStart, mem_ramEnd)) {
		uint32_t *const ptr = (uint32_t *)(void *)&ram[adr - mem_ramStart];
		*ptr = value;
	} else if (isAdressInRange(adr, mem_mmioStart, mem_mmioEnd)) {
		mmio_write32(adr - mem_mmioStart, value);
	} else {
		memoryViolation('w', adr);
	}

	//printf("MEM_WRITE_32[%x] = 0x%x\n", adr, value)
}

