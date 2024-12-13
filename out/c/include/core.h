
#ifndef CORE_H
#define CORE_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "decode.h"


#define core_nRegs  32
struct core_BusInterface;
typedef struct core_BusInterface core_BusInterface;


struct core_Core {
	uint32_t reg[core_nRegs];
	uint32_t pc;

	uint32_t nexpc;

	core_BusInterface *bus;

	uint32_t interrupt;

	uint32_t cnt;
	bool end;
};
typedef struct core_Core core_Core;


struct core_BusInterface {
	void *read8;
	void *read16;
	void *read32;

	void *write8;
	void *write16;
	void *write32;
};
#define core_intSysCall  0x08
#define core_intMemViolation  0x0B
void core_init(core_Core *core, core_BusInterface *bus);
void core_tick(core_Core *core);
void core_irq(core_Core *core, uint32_t irq);
void core_show_regs(core_Core *core);

#endif /* CORE_H */
