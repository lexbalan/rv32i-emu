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
    uint32_t interrupt;
    uint32_t cnt;
} Core;


#define opLUI  0x37
#define opAUI_PC  0x17
#define opJAL  0x6F
#define opJALR  0x67
#define opL  0x03// load
#define opI  0x13// immediate
#define opS  0x23// store
#define opR  0x33// reg
#define opB  0x63// branch
#define opSYSTEM  0x73
#define opFENCE  0x0F

#define instrECALL  (opSYSTEM | 0x00000000)
#define instrEBREAK  (opSYSTEM | 0x00100000)
#define instrPAUSE  (opFENCE | 0x01000000)


#define funct3_CSRRW  1
#define funct3_CSRRS  2
#define funct3_CSRRC  3
#define funct3_CSRRWI  4
#define funct3_CSRRSI  5
#define funct3_CSRRCI  6

void core_init(Core *core, MemoryInterface *memctl);
void core_irq(Core *core, uint32_t irq);
bool core_tick(Core *core);


#define intSysCall  0x08
#define intMemViolation  0x0B

#endif /* CORE_H */
