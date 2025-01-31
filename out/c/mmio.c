
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "mmio.h"

#include <stdio.h>



#define mmio_consoleMMIOAdr  0x10
#define mmio_consolePutAdr  (mmio_consoleMMIOAdr + 0)
#define mmio_consoleGetAdr  (mmio_consoleMMIOAdr + 1)

#define mmio_consolePrintInt32Adr  (mmio_consoleMMIOAdr + 0x10)
#define mmio_consolePrintUInt32Adr  (mmio_consoleMMIOAdr + 0x14)
#define mmio_consolePrintInt32HexAdr  (mmio_consoleMMIOAdr + 0x18)
#define mmio_consolePrintUInt32HexAdr  (mmio_consoleMMIOAdr + 0x1C)

#define mmio_consolePrintInt64Adr  (mmio_consoleMMIOAdr + 0x20)
#define mmio_consolePrintUInt64Adr  (mmio_consoleMMIOAdr + 0x28)



void mmio_write8(uint32_t adr, uint8_t value)
{
	if (adr == mmio_consolePutAdr) {
		putchar((int)value);
		return;
	}
}


void mmio_write16(uint32_t adr, uint16_t value)
{
	if (adr == mmio_consolePutAdr) {
		putchar((int)value);
		return;
	}
}


void mmio_write32(uint32_t adr, uint32_t value)
{
	if (adr == mmio_consolePutAdr) {
		putchar((int)value);
		return;
	} else if (adr == mmio_consolePrintInt32Adr) {
		printf("%u", value);
		return;
	} else if (adr == mmio_consolePrintUInt32Adr) {
		printf("%u", value);
		return;
	} else if (adr == mmio_consolePrintInt32HexAdr) {
		printf("%x", value);
		return;
	} else if (adr == mmio_consolePrintUInt32HexAdr) {
		printf("%ux", value);
		return;
	}
}


uint8_t mmio_read8(uint32_t adr)
{
	return 0;
}

uint16_t mmio_read16(uint32_t adr)
{
	return 0;
}

uint32_t mmio_read32(uint32_t adr)
{
	return 0;
}

