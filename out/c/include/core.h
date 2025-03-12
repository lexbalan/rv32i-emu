
#ifndef CORE_H
#define CORE_H

#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "decode.h"



struct core_BusInterface;
typedef struct core_BusInterface core_BusInterface;
struct core_Core {
	uint32_t reg[32];
	uint32_t pc;
	uint32_t nexpc;

	core_BusInterface *bus;

	uint32_t interrupt;

	uint32_t cnt;
	bool end;
};
typedef struct core_Core core_Core;

struct core_BusInterface {
	uint8_t(*read8)(uint32_t adr);
	uint16_t(*read16)(uint32_t adr);
	uint32_t(*read32)(uint32_t adr);

	void(*write8)(uint32_t adr, uint8_t value);
	void(*write16)(uint32_t adr, uint16_t value);
	void(*write32)(uint32_t adr, uint32_t value);
};

#define core_intSysCall  0x08
#define core_intMemViolation  0x0B

void core_init(core_Core *core, core_BusInterface *bus);

void core_tick(core_Core *core);

void core_irq(core_Core *core, uint32_t irq);

void core_show_regs(core_Core *core);

#endif /* CORE_H */
