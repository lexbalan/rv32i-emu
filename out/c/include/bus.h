//
//

#ifndef BUS_H
#define BUS_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <stdlib.h>
#include "mmio.h"
#define bus_ramSize  (16 * 1024)
#define bus_ramStart  (268435456)
#define bus_ramEnd  (bus_ramStart + bus_ramSize)

#define bus_romSize  (1048576)
#define bus_romStart  (0)
#define bus_romEnd  (bus_romStart + bus_romSize)
uint32_t bus_read(uint32_t adr, uint8_t size);
void bus_write(uint32_t adr, uint32_t value, uint8_t size);
uint8_t *bus_get_ram_ptr();
uint8_t *bus_get_rom_ptr();

#endif /* BUS_H */
