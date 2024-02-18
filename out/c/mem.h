//

#ifndef MEM_H
#define MEM_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


// see mem.ld
#define RAM_START  0x10000000
#define RAM_SIZE  4096
#define RAM_END  (RAM_START + RAM_SIZE)


#define ROM_START  0x00000000
#define ROM_SIZE  0x10000
#define ROM_END  (ROM_START + ROM_SIZE)


#define MMIO_START  0xF00C0000
#define MMMIO_SIZE  0xFFFF
#define MMIO_END  (MMIO_START + MMMIO_SIZE)

#define CONSOLE_MMIO_ADR  (MMIO_START + 0x10)
#define CONSOLE_PUT_ADR  (CONSOLE_MMIO_ADR + 0)
#define CONSOLE_GET_ADR  (CONSOLE_MMIO_ADR + 1)

#define CONSOLE_PRINT_INT32_ADR  (CONSOLE_MMIO_ADR + 0x10)
#define CONSOLE_PRINT_UINT32_ADR  (CONSOLE_MMIO_ADR + 0x14)
#define CONSOLE_PRINT_INT32_HEX_ADR  (CONSOLE_MMIO_ADR + 0x18)
#define CONSOLE_PRINT_UINT32_HEX_ADR  (CONSOLE_MMIO_ADR + 0x1C)

#define CONSOLE_PRINT_INT64_ADR  (CONSOLE_MMIO_ADR + 0x20)
#define CONSOLE_PRINT_UINT64_ADR  (CONSOLE_MMIO_ADR + 0x28)


uint8_t *get_ram_ptr();
uint8_t *get_rom_ptr();

uint8_t vm_mem_read8(uint32_t adr);
uint16_t vm_mem_read16(uint32_t adr);
uint32_t vm_mem_read32(uint32_t adr);

void vm_mem_write8(uint32_t adr, uint8_t value);
void vm_mem_write16(uint32_t adr, uint16_t value);
void vm_mem_write32(uint32_t adr, uint32_t value);

#endif /* MEM_H */
