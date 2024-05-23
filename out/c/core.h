// CSR's
//https://five-embeddev.com/riscv-isa-manual/latest/priv-csrs.html

#ifndef CORE_H
#define CORE_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>



#define nRegs  32


typedef struct {
	void *read8;
	void *read16;
	void *read32;

	void *write8;
	void *write16;
	void *write32;
} MemoryInterface;

typedef struct {
	int32_t reg[nRegs];
	uint32_t ip;

	MemoryInterface *memctl;

	bool need_step;
	bool end;

	uint32_t interrupt;
	uint32_t cnt;
} Core;


#define opL  0x03// load
#define opI  0x13// immediate
#define opS  0x23// store
#define opR  0x33// reg
#define opB  0x63// branch

#define opLUI  0x37// load upper immediate
#define opAUIPC  0x17// add upper immediate to PC
#define opJAL  0x6F// jump and link
#define opJALR  0x67// jump and link by register

#define opSYSTEM  0x73
#define opFENCE  0x0F


#define instrECALL  (opSYSTEM | 0x00000000)
#define instrEBREAK  (opSYSTEM | 0x00100000)
#define instrPAUSE  (opFENCE | 0x01000000)


// funct3 for CSR
#define funct3_CSRRW  1
#define funct3_CSRRS  2
#define funct3_CSRRC  3
#define funct3_CSRRWI  4
#define funct3_CSRRSI  5
#define funct3_CSRRCI  6


void core_init(Core *core, MemoryInterface *memctl);
void core_irq(Core *core, uint32_t irq);
void core_tick(Core *core);


#define intSysCall  0x08
#define intMemViolation  0x0B

#endif /* CORE_H */
