
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>



#include "./core.h"

/*
    0x00828103
    0x3e800093
    0x7d008113
    0xc1810193
    0x83018213
    0x3e820293
    0x003100b3
    0xfffff337
    0xfffff317
    0xfe5ff36f
    0x0ff100e7
    0xfe8086e3
    0xfe8094e3
    0xfe80c2e3
    0xfe80d0e3
    0xfc80eee3
    0xfc80fce3
    0x003110b3
    0x403100b3
    0x003120b3
    0x003130b3
    0x003150b3
    0x403150b3
    
*/

uint32_t instructions[32] = {
    0x000041B7,
    0xC031819B,
    0x01219193,
    OP_STOP
};

void core_init(Core *core, MemoryInterface *memctl, uint32_t *text, uint32_t textlen)
{
    memset((void *)core, 0, sizeof(Core));
    core->memctl = (MemoryInterface *)memctl;
    core->text = text;
    core->textlen = textlen;
}


uint8_t extract_op(uint32_t instr)
{
    return (uint8_t)(instr & 0x7F);
}

uint8_t extract_funct3(uint32_t instr)
{
    return (uint8_t)(instr >> 12 & 0x07);
}

uint8_t extract_rd(uint32_t instr)
{
    return (uint8_t)(instr >> 7 & 0x1F);
}

uint8_t extract_rs1(uint32_t instr)
{
    return (uint8_t)(instr >> 15 & 0x1F);
}

uint8_t extract_rs2(uint32_t instr)
{
    return (uint8_t)(instr >> 20 & 0x1F);
}

uint8_t extract_funct7(uint32_t instr)
{
    return (uint8_t)(instr >> 25 & 0x7F);
}

int16_t extract_imm12(uint32_t instr)
{
    int16_t imm = (int16_t)(instr >> 20 & 0xFFF);

    // распространяем знак
    if ((imm & 0x800) == 0x800) {
        imm = imm | 0xF000;
    }

    return imm;
}

int32_t extract_imm31_12(uint32_t instr)
{
    int32_t imm = (int32_t)(instr >> 12 & 0xFFFFF);
    return imm;
}



void i_type_op(Core *core, uint32_t instr)
{
    const uint8_t funct3 = extract_funct3(instr);
    const uint8_t funct7 = extract_funct7(instr);
    const int32_t imm = (const int32_t)extract_imm12(instr);
    const uint8_t rd = extract_rd(instr);
    const uint8_t rs1 = extract_rs1(instr);

    //printf("funct7 = %x\n", instr and 0xff000000)

    if (rd == 0) {return;}

    //printf("RRI: funct7 = %d\n", funct7)

    if (funct3 == 0) {
        printf("addi x%d, x%d, %d\n", rd, rs1, imm);
        core->reg[rd] = core->reg[rs1] + imm;

    } else if ((funct3 == 1) && (funct7 == 0)) {
        /* SLLI is a logical left shift (zeros are shifted
into the lower bits); SRLI is a logical right shift (zeros are shifted into the upper bits); and SRAI
is an arithmetic right shift (the original sign bit is copied into the vacated upper bits). */
        // TODO
        printf("slli x%d, x%d, %d\n", rd, rs1, imm);

    } else if (funct3 == 2) {
        // SLTI - set [1 to rd if rs1] less than immediate
        printf("slti x%d, x%d, %d\n", rd, rs1, imm);

    } else if (funct3 == 3) {
        printf("sltiu x%d, x%d, %d\n", rd, rs1, imm);

    } else if (funct3 == 4) {
        printf("xori x%d, x%d, %d\n", rd, rs1, imm);
        core->reg[rd] = core->reg[rs1] - imm;

    } else if ((funct3 == 5) && (funct7 == 0)) {
        // TODO
        printf("srli x%d, x%d, %d\n", rd, rs1, imm);

    } else if ((funct3 == 5) && (funct7 == 0x20)) {
        // TODO
        printf("srai x%d, x%d, %d\n", rd, rs1, imm);

    } else if (funct3 == 6) {
        printf("ori x%d, x%d, %d\n", rd, rs1, imm);
        core->reg[rd] = core->reg[rs1] | imm;

    } else if (funct3 == 7) {
        printf("andi x%d, x%d, %d\n", rd, rs1, imm);
        core->reg[rd] = core->reg[rs1] ^ imm;
    }
}


void r_type_op(Core *core, uint32_t instr)
{
    const uint8_t funct3 = extract_funct3(instr);
    const uint8_t funct7 = extract_funct7(instr);
    const int16_t imm = extract_imm12(instr);
    const uint8_t rd = extract_rd(instr);
    const uint8_t rs1 = extract_rs1(instr);
    const uint8_t rs2 = extract_rs2(instr);

    //printf("funct7 = %x\n", funct7)

    if (rd == 0) {return;}

    const int32_t v1 = core->reg[rs1];
    const int32_t v2 = core->reg[rs2];

    if ((funct3 == 0) && (funct7 == 0x00)) {
        printf("add x%d, x%d, x%d\n", rd, rs1, rs2);
        core->reg[rd] = v1 + v2;
    } else if ((funct3 == 0) && (funct7 == 0x20)) {
        printf("sub x%d, x%d, x%d\n", rd, rs1, rs2);
        core->reg[rd] = v1 - v2;
    } else if (funct3 == 1) {
        // shift left logical
        printf("sll x%d, x%d, x%d\n", rd, rs1, rs2);
        core->reg[rd] = v1 << v2;
    } else if (funct3 == 2) {
        // set less than
        printf("slt x%d, x%d, x%d\n", rd, rs1, rs2);
        core->reg[rd] = (int32_t)(v1 < v2);
    } else if (funct3 == 3) {
        // set less than unsigned
        printf("sltu x%d, x%d, x%d\n", rd, rs1, rs2);
        core->reg[rd] = (int32_t)((uint32_t)v1 < (uint32_t)v2);
    } else if (funct3 == 4) {
        printf("xor x%d, x%d, x%d\n", rd, rs1, rs2);
        core->reg[rd] = v1 ^ v2;
    } else if ((funct3 == 5) && (funct7 == 0)) {
        // shift right logical
        printf("srl x%d, x%d, x%d\n", rd, rs1, rs2);
        core->reg[rd] = v1 >> v2;
    } else if ((funct3 == 5) && (funct7 == 0x20)) {
        // TODO: shift right arithmetical
        printf("sra x%d, x%d, x%d\n", rd, rs1, rs2);
        core->reg[rd] = v1 >> v2;
    } else if (funct3 == 6) {
        printf("or x%d, x%d, x%d\n", rd, rs1, rs2);
        core->reg[rd] = v1 | v2;
    } else if (funct3 == 7) {
        printf("and x%d, x%d, x%d\n", rd, rs1, rs2);
        core->reg[rd] = v1 & v2;
    }
}



uint32_t fetch(Core *core)
{
    const uint32_t instr_adr = core->ip;
    const uint32_t instr = core->text[instr_adr];
    return instr;
}

bool core_tick(Core *core)
{
    const uint32_t instr = fetch((Core *)core);
    const uint8_t op = extract_op((uint32_t)instr);
    const uint8_t rd = extract_rd((uint32_t)instr);
    const uint8_t rs1 = extract_rs1((uint32_t)instr);
    const uint8_t rs2 = extract_rs2((uint32_t)instr);
    const uint8_t funct3 = extract_funct3((uint32_t)instr);

    if (false) {
        printf("INSTR = 0x%x\n", instr);
        printf("OP = 0x%x\n", op);
    }

    if (op == OP_I) {
        i_type_op((Core *)core, (uint32_t)instr);

    } else if (op == OP_R) {
        r_type_op((Core *)core, (uint32_t)instr);

    } else if (op == OPCODE_LUI) {
        // U-type
        const int32_t imm = extract_imm31_12((uint32_t)instr);
        printf("lui x%d, 0x%X\n", rd, imm);
        core->reg[rd] = imm << 12;

    } else if (op == OPCODE_AUI_PC) {
        // U-type
        const int32_t imm = extract_imm31_12((uint32_t)instr);
        printf("auipc x%d, 0x%X\n", rd, imm);

    } else if (op == OPCODE_JAL) {
        // U-type
        const int32_t imm = extract_imm31_12((uint32_t)instr);
        printf("auipc x%d, 0x%X\n", rd, imm);

    } else if ((op == OPCODE_JALR) && (funct3 == 0)) {
        const int16_t imm = extract_imm12((uint32_t)instr);
        printf("jalr x%d, x%d, 0x%X\n", rd, rs1, imm);


    } else if (op == OP_B) {
        const uint8_t imm12_10to5 = extract_funct7((uint32_t)instr);
        const uint8_t imm4to1_11 = extract_rd((uint32_t)instr);

        const uint16_t bit4to1 = ((const uint16_t)(uint8_t)(imm4to1_11 & 0x1E));
        const uint16_t bit10to5 = ((uint16_t)(uint8_t)(imm12_10to5 & 0x3F)) << 5;
        const uint16_t bit11 = ((uint16_t)(uint8_t)(imm4to1_11 & 0x1)) << 11;
        const uint16_t bit12 = ((uint16_t)(uint8_t)(imm12_10to5 & 0x40)) << 6;

        const uint16_t bits = bit12 | bit11 | bit10to5 | bit4to1;

        // распространяем знак, если он есть
        if ((bits & 1 << 12) != 0) {
            bits = 0xF000 | bits;
        }

        const int16_t imm = (const int16_t)bits;

        if (funct3 == 0) {
            //beq
            printf("beq x%d, x%d, %d\n", rs1, rs2, (int32_t)imm);
        } else if (funct3 == 1) {
            //bne
            printf("bne x%d, x%d, %d\n", rs1, rs2, (int32_t)imm);
        } else if (funct3 == 4) {
            //blt
            printf("blt x%d, x%d, %d\n", rs1, rs2, (int32_t)imm);
        } else if (funct3 == 5) {
            //bge
            printf("bge x%d, x%d, %d\n", rs1, rs2, (int32_t)imm);
        } else if (funct3 == 6) {
            //bltu
            printf("bltu x%d, x%d, %d\n", rs1, rs2, (int32_t)imm);
        } else if (funct3 == 7) {
            //bgeu
            printf("bgeu x%d, x%d, %d\n", rs1, rs2, (int32_t)imm);
        }

    } else if (op == OP_L) {
        const int16_t imm = extract_imm12((uint32_t)instr);
        if (funct3 == 0) {
            // lb
            printf("lb x%d, %d(x%d)\n", rd, imm, rs1);
            const uint32_t adr = (uint32_t)core->reg[rs1] + ((uint32_t)(uint16_t)imm);
            const int32_t val = (const int32_t)((uint8_t(*)(uint32_t adr))core->memctl->read8)((uint32_t)adr);
            core->reg[rs2] = val;

        } else if (funct3 == 1) {
            // lh
            printf("lh x%d, %d(x%d)\n", rd, imm, rs1);
            const uint32_t adr = (uint32_t)core->reg[rs1] + ((uint32_t)(uint16_t)imm);
            const int32_t val = (const int32_t)((uint16_t(*)(uint32_t adr))core->memctl->read16)((uint32_t)adr);
            core->reg[rs2] = val;

        } else if (funct3 == 2) {
            // lw
            printf("lw x%d, %d(x%d)\n", rd, imm, rs1);
            const uint32_t adr = (uint32_t)core->reg[rs1] + ((uint32_t)(uint16_t)imm);
            const int32_t val = (const int32_t)((uint32_t(*)(uint32_t adr))core->memctl->read32)((uint32_t)adr);
            core->reg[rs2] = val;

        } else if (funct3 == 4) {
            // lbu
            printf("lbu x%d, %d(x%d)\n", rd, imm, rs1);
            const uint32_t adr = (uint32_t)core->reg[rs1] + ((uint32_t)(uint16_t)imm);
            const int32_t val = (const int32_t)((uint8_t(*)(uint32_t adr))core->memctl->read8)((uint32_t)adr);
            core->reg[rs2] = val;
        } else if (funct3 == 5) {
            // lhu
            printf("lhu x%d, %d(x%d)\n", rd, imm, rs1);
            const uint32_t adr = (uint32_t)core->reg[rs1] + ((uint32_t)(uint16_t)imm);
            const int32_t val = (const int32_t)((uint16_t(*)(uint32_t adr))core->memctl->read16)((uint32_t)adr);
            core->reg[rs2] = val;
        }

    } else if (op == OP_S) {
        const uint8_t imm4to0 = rd;
        const uint8_t imm11to5 = extract_funct7((uint32_t)instr);

        const uint16_t imm = ((uint16_t)(uint8_t)imm11to5) << 5 | ((uint16_t)(uint8_t)imm4to0);

        if (funct3 == 0) {
            // sb
            printf("sb x%d, %d(x%d)\n", rs2, imm, rs1);
            const uint32_t adr = (uint32_t)core->reg[rs1] + ((uint32_t)(uint16_t)imm);
            const uint8_t val = (const uint8_t)core->reg[rs2];
            ((void(*)(uint32_t adr, uint8_t value))core->memctl->write8)((uint32_t)adr, (uint8_t)val);
        } else if (funct3 == 1) {
            // sh
            printf("sh x%d, %d(x%d)\n", rs2, imm, rs1);
            const uint32_t adr = (uint32_t)core->reg[rs1] + ((uint32_t)(uint16_t)imm);
            const uint16_t val = (const uint16_t)core->reg[rs2];
            ((void(*)(uint32_t adr, uint16_t value))core->memctl->write16)((uint32_t)adr, (uint16_t)val);
        } else if (funct3 == 2) {
            // sw
            printf("sw x%d, %d(x%d)\n", rs2, imm, rs1);
            const uint32_t adr = (uint32_t)core->reg[rs1] + ((uint32_t)(uint16_t)imm);
            const uint32_t val = (const uint32_t)core->reg[rs2];
            ((void(*)(uint32_t adr, uint32_t value))core->memctl->write32)((uint32_t)adr, (uint32_t)val);
        }

    } else if (instr == OP_STOP) {
        printf("\n\n* * * STOP\n");
        return false;

    } else {
        printf("UNKNOWN OPCODE: %08X\n", op);
    }

    core->ip = core->ip + 1;

    return true;
}

