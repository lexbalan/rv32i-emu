//

#ifndef MEM_H
#define MEM_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>



// see mem.ld
#define ramSize  4096
#define ramStart  0x10000000
#define ramEnd  (ramStart + ramSize)


#define romSize  0x10000
#define romStart  0x00000000
#define romEnd  (romStart + romSize)


#define mmioSize  0xFFFF
#define mmioStart  0xF00C0000
#define mmioEnd  (mmioStart + mmioSize)

#define consoleMMIOAdr  (mmioStart + 0x10)
#define consolePutAdr  (consoleMMIOAdr + 0)
#define consoleGetAdr  (consoleMMIOAdr + 1)

#define consolePrintInt32Adr  (consoleMMIOAdr + 0x10)
#define consolePrintUInt32Adr  (consoleMMIOAdr + 0x14)
#define consolePrintInt32HexAdr  (consoleMMIOAdr + 0x18)
#define consolePrintUInt32HexAdr  (consoleMMIOAdr + 0x1C)

#define consolePrintInt64Adr  (consoleMMIOAdr + 0x20)
#define consolePrintUInt64Adr  (consoleMMIOAdr + 0x28)


uint8_t *get_ram_ptr();
uint8_t *get_rom_ptr();

uint8_t vm_mem_read8(uint32_t adr);
uint16_t vm_mem_read16(uint32_t adr);
uint32_t vm_mem_read32(uint32_t adr);

void vm_mem_write8(uint32_t adr, uint8_t value);
void vm_mem_write16(uint32_t adr, uint16_t value);
void vm_mem_write32(uint32_t adr, uint32_t value);

#endif /* MEM_H */
