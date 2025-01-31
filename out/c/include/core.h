
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


// load
// immediate
// store
// reg
// branch

// load upper immediate
// add upper immediate to PC
// jump and link
// jump and link by register

//
//







// funct3 for CSR








#define core_intSysCall  0x08
#define core_intMemViolation  0x0B



void core_init(core_Core *core, core_BusInterface *bus);





void core_tick(core_Core *core);



































void core_irq(core_Core *core, uint32_t irq);





//
// CSR's
//https://five-embeddev.com/riscv-isa-manual/latest/priv-csrs.html
//






















/*
The CSRRW (Atomic Read/Write CSR) instruction atomically swaps values in the CSRs and integer registers. CSRRW reads the old value of the CSR, zero-extends the value to XLEN bits, then writes it to integer register rd. The initial value in rs1 is written to the CSR. If rd=x0, then the instruction shall not read the CSR and shall not cause any of the side effects that might occur on a CSR read.
*/



/*
The CSRRS (Atomic Read and Set Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be set in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be set in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
*/


/*
The CSRRC (Atomic Read and Clear Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be cleared in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be cleared in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
*/



// -





// read+clear immediate(5-bit)



// read+clear immediate(5-bit)










void core_show_regs(core_Core *core);

#endif /* CORE_H */
