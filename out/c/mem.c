
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

//

#include "./mem.h"


uint8_t ram[RAM_SIZE];


uint8_t vm_mem_read8(uint32_t adr)
{
    if ((adr >= RAM_START) && (adr <= RAM_END)) {
        uint8_t *const p = (uint8_t *const)(void *)&ram[adr];
        return *p;
    } else if ((adr >= MMIO_START) && (adr <= MMIO_END)) {
        return 0;
    } else {
        // memory voilation
    }

    return 0;
}

uint16_t vm_mem_read16(uint32_t adr)
{
    if ((adr >= RAM_START) && (adr <= RAM_END)) {
        uint16_t *const p = (uint16_t *const)(void *)&ram[adr];
        return *p;
    } else if ((adr >= MMIO_START) && (adr <= MMIO_END)) {
        return 0;
    } else {
        // memory voilation
    }

    return 0;
}

uint32_t vm_mem_read32(uint32_t adr)
{
    if ((adr >= RAM_START) && (adr <= RAM_END)) {
        uint32_t *const p = (uint32_t *const)(void *)&ram[adr];
        return *p;
    } else if ((adr >= MMIO_START) && (adr <= MMIO_END)) {
        return 0;
    } else {
        // memory voilation
    }

    return 0;
}



void vm_mem_write8(uint32_t adr, uint8_t value)
{
    if ((adr >= RAM_START) && (adr <= RAM_END)) {
        uint8_t *const p = (uint8_t *const)(void *)&ram[adr];
        *p = value;
    } else if ((adr >= MMIO_START) && (adr <= MMIO_END)) {
        if (adr == CONSOLE_PUT_ADR) {
            putchar((int)value);
            return;
        }
    } else {
        // memory voilation
    }
}

void vm_mem_write16(uint32_t adr, uint16_t value)
{
    if ((adr >= RAM_START) && (adr <= RAM_END)) {
        uint16_t *const p = (uint16_t *const)(void *)&ram[adr];
        *p = value;
    } else if ((adr >= MMIO_START) && (adr <= MMIO_END)) {
        if (adr == CONSOLE_PUT_ADR) {
            putchar((int)value);
            return;
        }
    } else {
        // memory voilation
    }
}

void vm_mem_write32(uint32_t adr, uint32_t value)
{
    if ((adr >= RAM_START) && (adr <= RAM_END)) {
        uint32_t *const p = (uint32_t *const)(void *)&ram[adr];
        *p = value;
    } else if ((adr >= MMIO_START) && (adr <= MMIO_END)) {
        if (adr == CONSOLE_PUT_ADR) {
            putchar((int)value);
            return;
        }
    } else {
        // memory voilation
    }
}

