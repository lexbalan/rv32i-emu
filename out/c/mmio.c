
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "mmio.h"


#define consoleMMIOAdr  (16)
#define consolePutAdr  (consoleMMIOAdr + 0)
#define consoleGetAdr  (consoleMMIOAdr + 1)

#define consolePrintInt32Adr  (consoleMMIOAdr + 16)
#define consolePrintUInt32Adr  (consoleMMIOAdr + 20)
#define consolePrintInt32HexAdr  (consoleMMIOAdr + 24)
#define consolePrintUInt32HexAdr  (consoleMMIOAdr + 28)

#define consolePrintInt64Adr  (consoleMMIOAdr + 32)
#define consolePrintUInt64Adr  (consoleMMIOAdr + 40)

void mmio_write8(uint32_t adr, uint8_t value) {
	if (adr == consolePutAdr) {
		putchar((int)value);
		return;
	}
}

void mmio_write16(uint32_t adr, uint16_t value) {
	if (adr == consolePutAdr) {
		putchar((int)value);
		return;
	}
}

void mmio_write32(uint32_t adr, uint32_t value) {
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
		printf("%ux", value);
		return;
	}
}

uint8_t mmio_read8(uint32_t adr) {
	return 0x0;
}

uint16_t mmio_read16(uint32_t adr) {
	return 0x0;
}

uint32_t mmio_read32(uint32_t adr) {
	return 0x0;
}

