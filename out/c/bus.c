//
//

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "bus.h"


// see mem.ld

#define mmioSize  (65535)
#define mmioStart  (4027318272UL)
#define mmioEnd  (mmioStart + mmioSize)

static uint8_t rom[bus_romSize];
static uint8_t ram[bus_ramSize];


static inline bool isAdressInRange(uint32_t x, uint32_t a, uint32_t b);
static void memoryViolation(char rw, uint32_t adr);

uint32_t bus_read(uint32_t adr, uint8_t size) {
	if (isAdressInRange(adr, bus_ramStart, bus_ramEnd)) {
		if (size == 1) {
			uint8_t *const ptr = (uint8_t *)&ram[adr - bus_ramStart];
			return (uint32_t)*ptr;
		} else if (size == 2) {
			uint16_t *const ptr = (uint16_t *)&ram[adr - bus_ramStart];
			return (uint32_t)*ptr;
		} else if (size == 4) {
			uint32_t *const ptr = (uint32_t *)&ram[adr - bus_ramStart];
			return *ptr;
		}
	} else if (isAdressInRange(adr, bus_romStart, bus_romEnd)) {
		if (size == 1) {
			uint8_t *const ptr = (uint8_t *)&rom[adr - bus_romStart];
			return (uint32_t)*ptr;
		} else if (size == 2) {
			uint16_t *const ptr = (uint16_t *)&rom[adr - bus_romStart];
			return (uint32_t)*ptr;
		} else if (size == 4) {
			uint32_t *const ptr = (uint32_t *)&rom[adr - bus_romStart];
			return *ptr;
		}
	} else if (isAdressInRange(adr, mmioStart, mmioEnd)) {
		// MMIO Read
	} else {
		memoryViolation('r', adr);
	}

	return 0x0;
}

void bus_write(uint32_t adr, uint32_t value, uint8_t size) {
	if (isAdressInRange(adr, bus_ramStart, bus_ramEnd)) {
		if (size == 1) {
			uint8_t *const ptr = (uint8_t *)&ram[adr - bus_ramStart];
			*ptr = (uint8_t)value;
		} else if (size == 2) {
			uint16_t *const ptr = (uint16_t *)&ram[adr - bus_ramStart];
			*ptr = (uint16_t)value;
		} else if (size == 4) {
			uint32_t *const ptr = (uint32_t *)&ram[adr - bus_ramStart];
			*ptr = value;
		}
	} else if (isAdressInRange(adr, mmioStart, mmioEnd)) {
		if (size == 1) {
			mmio_write8(adr - mmioStart, (uint8_t)value);
		} else if (size == 2) {
			mmio_write16(adr - mmioStart, (uint16_t)value);
		} else if (size == 4) {
			mmio_write32(adr - mmioStart, value);
		}
	} else if (isAdressInRange(adr, bus_romStart, bus_romEnd)) {
		memoryViolation('w', adr);
	} else {
		memoryViolation('w', adr);
	}
}

static inline bool isAdressInRange(uint32_t x, uint32_t a, uint32_t b) {
	return x >= a && x < b;
}

uint8_t *bus_get_ram_ptr() {
	return (uint8_t *)&ram;
}

uint8_t *bus_get_rom_ptr() {
	return (uint8_t *)&rom;
}

static uint32_t memviolationCnt = 0;
static void memoryViolation(char rw, uint32_t adr) {
	printf("*** MEMORY VIOLATION '%c' 0x%08x ***\n", rw, adr);
	if (memviolationCnt > 10) {
		exit(1);
	}
	memviolationCnt = memviolationCnt + 1;
	//	memoryViolation_event(0x55) // !
}

