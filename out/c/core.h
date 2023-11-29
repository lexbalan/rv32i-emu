
#ifndef CORE_H
#define CORE_H

#include <stdint.h>
#include <string.h>
#include <stdbool.h>


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
    uint32_t sp;

    MemoryInterface *memctl;

    uint32_t *text;
    uint32_t textlen;
} Core;


#define OP_NOP  0

#define OPCODE_LUI  0x37
#define OPCODE_AUI_PC  0x17
#define OPCODE_JAL  0x6F
#define OPCODE_JALR  0x67
#define OP_B  0x63// branch
#define OP_L  0x03// load
#define OP_S  0x23// store
#define OP_I  0x13
#define OP_R  0x33


#define OP_STOP  0


void core_init(Core *core, MemoryInterface *memctl, uint32_t *text, uint32_t textlen);
bool core_tick(Core *core);

#endif  /* CORE_H */
