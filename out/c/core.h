// CSR's
//https://five-embeddev.com/riscv-isa-manual/latest/priv-csrs.html

#ifndef CORE_H
#define CORE_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>



#define NREGS  32


typedef struct {
    void *read8;
    void *read16;
    void *read32;

    void *write8;
    void *write16;
    void *write32;
} MemoryInterface;


typedef struct {
    int32_t reg[NREGS];
    uint32_t ip;

    MemoryInterface *memctl;

    bool need_step;
    uint32_t interrupt;
    uint32_t cnt;
} Core;


#define OP_LUI  0x37
#define OP_AUI_PC  0x17
#define OP_JAL  0x6F
#define OP_JALR  0x67
#define OP_L  0x03// load
#define OP_I  0x13// immediate
#define OP_S  0x23// store
#define OP_R  0x33// reg
#define OP_B  0x63// branch
#define OP_SYSTEM  0x73
#define OP_FENCE  0x0F

#define INSTR_ECALL  (OP_SYSTEM | 0x00000000)
#define INSTR_EBREAK  (OP_SYSTEM | 0x00100000)
#define INSTR_PAUSE  (OP_FENCE | 0x01000000)


#define FUNCT3_CSRRW  1
#define FUNCT3_CSRRS  2
#define FUNCT3_CSRRC  3
#define FUNCT3_CSRRWI  4
#define FUNCT3_CSRRSI  5
#define FUNCT3_CSRRCI  6

void core_init(Core *core, MemoryInterface *memctl);
void core_irq(Core *core, uint32_t irq);
bool core_tick(Core *core);


#define INT_SYS_CALL  0x08
#define INT_MEM_VIOLATION  0x0B

#endif /* CORE_H */
