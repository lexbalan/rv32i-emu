#ifndef __VM_SYS__
#define __VM_SYS__

#include <stdint.h>

#define MMIO_START  0xF00C0000
#define MMMIO_SIZE  0xFFFF
#define MMIO_END    (MMIO_START + MMMIO_SIZE)

#define CONSOLE_MMIO_ADR               (MMIO_START + 0x10)
#define CONSOLE_PRINT_CHAR8_ADR        (CONSOLE_MMIO_ADR + 0x00)
#define CONSOLE_SCAN_CHAR8_ADR         (CONSOLE_MMIO_ADR + 0x01)
#define CONSOLE_PRINT_INT32_ADR        (CONSOLE_MMIO_ADR + 0x10)
#define CONSOLE_PRINT_UINT32_ADR       (CONSOLE_MMIO_ADR + 0x14)
#define CONSOLE_PRINT_INT32_HEX_ADR    (CONSOLE_MMIO_ADR + 0x18)
#define CONSOLE_PRINT_UINT32_HEX_ADR   (CONSOLE_MMIO_ADR + 0x1C)

// not implemented
//#define CONSOLE_PRINT_INT64_ADR        (CONSOLE_MMIO_ADR + 0x20)
//#define CONSOLE_PRINT_UINT64_ADR       (CONSOLE_MMIO_ADR + 0x28)

#define CONSOLE_PUT_CHAR8  (*((volatile uint8_t *)CONSOLE_PUT_CHAR8_ADR))
#define CONSOLE_GET_CHAR8  (*((volatile uint8_t *)CONSOLE_GET_CHAR8_ADR))


#endif  /* __VM_SYS__ */

