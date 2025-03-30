//
//

#ifndef HART_H
#define HART_H

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
	uint32_t nexpc;

	hart_BusInterface *bus;

	uint32_t interrupt;

	uint32_t cnt;
	bool end;
};
typedef struct hart_Hart hart_Hart;

struct hart_BusInterface {
	uint8_t(*read8)(uint32_t adr);
	uint16_t(*read16)(uint32_t adr);
	uint32_t(*read32)(uint32_t adr);

	void(*write8)(uint32_t adr, uint8_t value);
	void(*write16)(uint32_t adr, uint16_t value);
	void(*write32)(uint32_t adr, uint32_t value);
};

#define hart_intSysCall  0x08
#define hart_intMemViolation  0x0B

void hart_init(hart_Hart *hart, hart_BusInterface *bus);

void hart_tick(hart_Hart *hart);

void hart_irq(hart_Hart *hart, uint32_t irq);

void hart_show_regs(hart_Hart *hart);

#endif /* HART_H */
