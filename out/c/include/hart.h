//
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
	uint32_t nexpc;

	hart_BusInterface *bus;

	uint32_t irq;

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
};// load// immediate// store// reg// branch// load upper immediate// add upper immediate to PC// jump and link// jump and link by register////

// funct3 for CSR

#define hart_intSysCall  0x08
#define hart_intMemViolation  0x0B

void hart_init(hart_Hart *hart, hart_BusInterface *bus);

void hart_tick(hart_Hart *hart);

//
// CSR's
// see: https://five-embeddev.com/riscv-isa-manual/latest/priv-csrs.html
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

void hart_show_regs(hart_Hart *hart);

#endif /* HART_H */
