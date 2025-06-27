//
//

#ifndef MEM_H
#define MEM_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <stdlib.h>
#include "mmio.h"
#define mem_ramSize  (16 * 1024)
#define mem_ramStart  (268435456)
#define mem_ramEnd  (mem_ramStart + mem_ramSize)

#define mem_romSize  (1048576)
#define mem_romStart  (0)
#define mem_romEnd  (mem_romStart + mem_romSize)
uint8_t *mem_get_ram_ptr();
uint8_t *mem_get_rom_ptr();
uint8_t mem_read8(uint32_t adr);
uint16_t mem_read16(uint32_t adr);
uint32_t mem_read32(uint32_t adr);
void mem_write8(uint32_t adr, uint8_t value);
void mem_write16(uint32_t adr, uint16_t value);
void mem_write32(uint32_t adr, uint32_t value);

#endif /* MEM_H */
