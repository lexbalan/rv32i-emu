// RISC-V hart implementation
//

#ifndef HART_H
#define HART_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "decode.h"



struct hart_BusInterface;
typedef struct hart_BusInterface hart_BusInterface;
struct hart_Hart {
	uint32_t reg[32];
	uint32_t pc;

	hart_BusInterface *bus;

	uint32_t irq;

	uint32_t cnt;
	bool end;
};
typedef struct hart_Hart hart_Hart;

struct hart_BusInterface {
	uint32_t(*read)(uint32_t adr, uint8_t size);
	void(*write)(uint32_t adr, uint32_t value, uint8_t size);
};

#define hart_intSysCall  0x8
#define hart_intMemViolation  0xB
void hart_init(hart_Hart *hart, hart_BusInterface *bus);
void hart_tick(hart_Hart *hart);
void hart_show_regs(hart_Hart *hart);

#endif /* HART_H */
