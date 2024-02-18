// ./out/c//core.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h>

#include "./core.h"




void core_init(Core *core, MemoryInterface *memctl)
{
    memset((void *)core, 0, sizeof(Core));
    core->memctl = memctl;
    core->need_step = true;

    //    *core = {
    //        memctl = memctl
    //        need_step = true
    //    } to Core
}


void core_irq(Core *core, uint32_t irq)
{
    if (core->interrupt == 0) {
        core->interrupt = irq;
    }
}



int32_t expand12(uint32_t val_12bit)
{
    uint32_t v;
    v = val_12bit;
    if ((v & 0x800) != 0) {
        v = v | 0xFFFFF000;
    }
    return (int32_t)v;
}


int32_t expand20(uint32_t val_20bit)
{
    uint32_t v;
    v = val_20bit;
    if ((v & 0x80000) != 0) {
        v = v | 0xFFF00000;
    }
    return (int32_t)v;
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


uint32_t extract_imm12(uint32_t instr)
{
    return instr >> 20 & 0xFFF;
}


uint32_t extract_imm31_12(uint32_t instr)
{
    return instr >> 12 & 0xFFFFF;
}


uint32_t extract_jal_imm(uint32_t instr)
{
    const uint32_t imm = extract_imm31_12(instr);
    const uint32_t bit19to12_msk = (imm >> 0 & 0xFF) << 12;
    const uint32_t bit11_msk = (imm >> 8 & 0x1) << 11;
    const uint32_t bit10to1 = (imm >> 9 & 0x3FF) << 1;
    const uint32_t bit20_msk = (imm >> 20 & 0x1) << 20;
    return bit20_msk | bit19to12_msk | bit11_msk | bit10to1;
}




void i_type_op(Core *core, uint32_t instr)
{
    const uint8_t funct3 = extract_funct3(instr);
    const uint8_t funct7 = extract_funct7(instr);
    const uint32_t imm12 = extract_imm12(instr);
    const int32_t imm = expand12(imm12);
    const uint8_t rd = extract_rd(instr);
    const uint8_t rs1 = extract_rs1(instr);


    if (rd == 0) {return;}


    if (funct3 == 0) {
        //printf("addi x%d, x%d, %d\n", rd, rs1, imm)
        if (rd != 0) {
            core->reg[rd] = core->reg[rs1] + imm;
        }
    } else if ((funct3 == 1) && (funct7 == 0)) {
        /* SLLI is a logical left shift (zeros are shifted
        into the lower bits); SRLI is a logical right shift (zeros are shifted into the upper bits); and SRAI
        is an arithmetic right shift (the original sign bit is copied into the vacated upper bits). */
        //printf("slli x%d, x%d, %d\n", rd, rs1, imm)
        if (rd != 0) {
            core->reg[rd] = (int32_t)((uint32_t)core->reg[rs1] << imm);
        }

    } else if (funct3 == 2) {
        // SLTI - set [1 to rd if rs1] less than immediate
        //printf("slti x%d, x%d, %d\n", rd, rs1, imm)
        if (rd != 0) {
            core->reg[rd] = (int32_t)(core->reg[rs1] < imm);
        }

    } else if (funct3 == 3) {
        //printf("sltiu x%d, x%d, %d\n", rd, rs1, imm)
        if (rd != 0) {
            core->reg[rd] = (int32_t)((uint32_t)core->reg[rs1] < (uint32_t)imm);
        }

    } else if (funct3 == 4) {
        //printf("xori x%d, x%d, %d\n", rd, rs1, imm)
        if (rd != 0) {
            core->reg[rd] = core->reg[rs1] ^ imm;
        }
    } else if ((funct3 == 5) && (funct7 == 0)) {
        //printf("srli x%d, x%d, %d\n", rd, rs1, imm)
        if (rd != 0) {
            core->reg[rd] = (int32_t)((uint32_t)core->reg[rs1] >> imm);
        }
    } else if ((funct3 == 5) && (funct7 == 0x20)) {
        //printf("srai x%d, x%d, %d\n", rd, rs1, imm)
        if (rd != 0) {
            core->reg[rd] = core->reg[rs1] >> imm;
        }

    } else if (funct3 == 6) {
        //printf("ori x%d, x%d, %d\n", rd, rs1, imm)
        if (rd != 0) {
            core->reg[rd] = core->reg[rs1] | imm;
        }

    } else if (funct3 == 7) {
        //printf("andi x%d, x%d, %d\n", rd, rs1, imm)
        if (rd != 0) {
            core->reg[rd] = core->reg[rs1] & imm;
        }
    }
}


void r_type_op(Core *core, uint32_t instr)
{
    const uint8_t funct3 = extract_funct3(instr);
    const uint8_t funct7 = extract_funct7(instr);
    const uint8_t rd = extract_rd(instr);
    const uint8_t rs1 = extract_rs1(instr);
    const uint8_t rs2 = extract_rs2(instr);

    if (rd == 0) {return;}

    const int32_t v1 = core->reg[rs1];
    const int32_t v2 = core->reg[rs2];

    if ((funct3 == 0) && (funct7 == 0x00)) {
        //printf("add x%d, x%d, x%d\n", rd, rs1, rs2)
        core->reg[rd] = v1 + v2;
    } else if ((funct3 == 0) && (funct7 == 0x20)) {
        //printf("sub x%d, x%d, x%d\n", rd, rs1, rs2)
        core->reg[rd] = v1 - v2;
    } else if (funct3 == 1) {
        // shift left logical
        //printf("sll x%d, x%d, x%d\n", rd, rs1, rs2)
        core->reg[rd] = v1 << v2;
    } else if (funct3 == 2) {
        // set less than
        //printf("slt x%d, x%d, x%d\n", rd, rs1, rs2)
        core->reg[rd] = (int32_t)(v1 < v2);
    } else if (funct3 == 3) {
        // set less than unsigned
        //printf("sltu x%d, x%d, x%d\n", rd, rs1, rs2)
        core->reg[rd] = (int32_t)((uint32_t)v1 < (uint32_t)v2);
    } else if (funct3 == 4) {
        //printf("xor x%d, x%d, x%d\n", rd, rs1, rs2)
        core->reg[rd] = v1 ^ v2;
    } else if ((funct3 == 5) && (funct7 == 0)) {
        // shift right logical
        //printf("srl x%d, x%d, x%d\n", rd, rs1, rs2)
        core->reg[rd] = (int32_t)((uint32_t)v1 >> v2);
    } else if ((funct3 == 5) && (funct7 == 0x20)) {
        // shift right arithmetical
        //printf("sra x%d, x%d, x%d\n", rd, rs1, rs2)
        core->reg[rd] = v1 >> v2;
    } else if (funct3 == 6) {
        //printf("or x%d, x%d, x%d\n", rd, rs1, rs2)
        core->reg[rd] = v1 | v2;
    } else if (funct3 == 7) {
        //printf("and x%d, x%d, x%d\n", rd, rs1, rs2)
        core->reg[rd] = v1 & v2;
    }
}



void riscv_csr_rw(Core *core, uint16_t csr, uint8_t rd, uint8_t rs1)
{
    if (csr == 0x340) {
        // mscratch
    } else if (csr == 0x341) {
        // mepc
    } else if (csr == 0x342) {
        // mcause
    } else if (csr == 0x343) {
        // mbadaddr
    } else if (csr == 0x344) {
        // mip (machine interrupt pending)
    }
}

void riscv_csr_rs(Core *core, uint8_t csr, uint8_t rd, uint8_t rs1)
{
}
void riscv_csr_rc(Core *core, uint8_t csr, uint8_t rd, uint8_t rs1)
{
}



bool core_tick(Core *core)
{

    if (core->interrupt > 0) {
        //printf("\nINT #%02X\n", core.interrupt)
        const uint32_t vect_offset = core->interrupt * 4;
        core->ip = vect_offset;
        core->interrupt = 0;
    }

    // instruction fetch
    const uint32_t instr = ((uint32_t (*) (uint32_t adr))core->memctl->read32)(core->ip);

    core->cnt = core->cnt + 1;

    // assert
    if (core->reg[0] != 0) {
        printf("FATAL: x0 != 0!\n");
        exit(1);
    }

    //printf("X8 = %x\n", core.reg[8]);

    //let b3 = ((instr >> 24) to Nat8) and 0xFF
    //let b2 = ((instr >> 16) to Nat8) and 0xFF
    //let b1 = ((instr >> 8) to Nat8) and 0xFF
    //let b0 = ((instr >> 0) to Nat8) and 0xFF
    //    //printf("[%04x] %02x%02x%02x%02x ", core.ip, b0 to Nat32, b1 to Nat32, b2 to Nat32, b3 to Nat32)
    const uint8_t op = extract_op(instr);
    const uint8_t rd = extract_rd(instr);
    const uint8_t rs1 = extract_rs1(instr);
    const uint8_t rs2 = extract_rs2(instr);
    const uint8_t funct3 = extract_funct3(instr);

    if (false) {
        //printf("INSTR = 0x%x\n", instr)
        //printf("OP = 0x%x\n", op)
    }

    if (op == OP_I) {
        i_type_op(core, instr);

    } else if (op == OP_R) {
        r_type_op(core, instr);

    } else if (op == OP_LUI) {
        // U-type
        const int32_t imm = expand12(extract_imm31_12(instr));
        //printf("lui x%d, 0x%X\n", rd, imm)
        core->reg[rd] = imm << 12;

    } else if (op == OP_AUI_PC) {
        // U-type
        const int32_t imm = expand12(extract_imm31_12(instr));
        const int32_t x = (int32_t)core->ip + (imm << 12);
        core->reg[rd] = x;
        //printf("auipc x%d, 0x%X\n", rd, imm)

    } else if (op == OP_JAL) {
        // U-type
        const uint32_t raw_imm = extract_jal_imm(instr);
        const int32_t imm = expand20(raw_imm);

        //printf("jal x%d, %d\n", rd, imm)
        if (rd != 0) {
            core->reg[rd] = (int32_t)(core->ip + 4);
        }

        core->ip = (uint32_t)((int32_t)core->ip + imm);
        core->need_step = false;

    } else if ((op == OP_JALR) && (funct3 == 0)) {
        const int32_t imm = expand12(extract_imm12(instr));
        //printf("jalr %d(x%d)\n", imm, rs1)
        // rd <- pc + 4
        // pc <- (rs1 + imm) & ~1

        const int32_t next_instr_ptr = (int32_t)(core->ip + 4);
        const uint32_t jump_to = (uint32_t)(core->reg[rs1] + imm) & 0xFFFFFFFE;

        if (rd != 0) {
            core->reg[rd] = next_instr_ptr;
        }

        core->ip = jump_to;

        core->need_step = false;

    } else if (op == OP_B) {
        const uint8_t imm12_10to5 = extract_funct7(instr);
        const uint8_t imm4to1_11 = extract_rd(instr);

        const uint16_t bit4to1 = (uint16_t)(imm4to1_11 & 0x1E);
        const uint16_t bit10to5 = (uint16_t)(imm12_10to5 & 0x3F) << 5;
        const uint16_t bit11 = (uint16_t)(imm4to1_11 & 0x1) << 11;
        const uint16_t bit12 = (uint16_t)(imm12_10to5 & 0x40) << 6;

        uint16_t bits;
        bits = bit12 | bit11 | bit10to5 | bit4to1;

        // распространяем знак, если он есть
        if ((bits & 1 << 12) != 0) {
            bits = 0xF000 | bits;
        }

        const int16_t imm = (int16_t)bits;

        if (funct3 == 0) {
            //beq
            //printf("beq x%d, x%d, %d\n", rs1, rs2, imm to Int32)
            if (core->reg[rs1] == core->reg[rs2]) {
                core->ip = (uint32_t)((int32_t)core->ip + (int32_t)imm);
                core->need_step = false;
            }

        } else if (funct3 == 1) {
            //bne
            //printf("bne x%d, x%d, %d\n", rs1, rs2, imm to Int32)
            if (core->reg[rs1] != core->reg[rs2]) {
                core->ip = (uint32_t)((int32_t)core->ip + (int32_t)imm);
                core->need_step = false;
            }

        } else if (funct3 == 4) {
            //blt
            //printf("blt x%d, x%d, %d\n", rs1, rs2, imm to Int32)
            if (core->reg[rs1] < core->reg[rs2]) {
                core->ip = (uint32_t)((int32_t)core->ip + (int32_t)imm);
                core->need_step = false;
            }

        } else if (funct3 == 5) {
            //bge
            //printf("bge x%d, x%d, %d\n", rs1, rs2, imm to Int32)
            if (core->reg[rs1] >= core->reg[rs2]) {
                core->ip = (uint32_t)((int32_t)core->ip + (int32_t)imm);
                core->need_step = false;
            }

        } else if (funct3 == 6) {
            //bltu
            //printf("bltu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
            if ((uint32_t)core->reg[rs1] < (uint32_t)core->reg[rs2]) {
                core->ip = (uint32_t)((int32_t)core->ip + (int32_t)imm);
                core->need_step = false;
            }

        } else if (funct3 == 7) {
            //bgeu
            //printf("bgeu x%d, x%d, %d\n", rs1, rs2, imm to Int32)

            if ((uint32_t)core->reg[rs1] >= (uint32_t)core->reg[rs2]) {
                core->ip = (uint32_t)((int32_t)core->ip + (int32_t)imm);
                core->need_step = false;
            } else {
            }
        }

    } else if (op == OP_L) {
        const int32_t imm = expand12(extract_imm12(instr));

        const uint32_t adr = (uint32_t)(core->reg[rs1] + imm);

        if (funct3 == 0) {
            // lb
            //printf("lb x%d, %d(x%d)\n", rd, imm, rs1)
            const int32_t val = (int32_t)((uint8_t (*) (uint32_t adr))core->memctl->read8)(adr);
            if (rd != 0) {
                core->reg[rd] = val;
            }
        } else if (funct3 == 1) {
            // lh
            //printf("lh x%d, %d(x%d)\n", rd, imm, rs1)
            const int32_t val = (int32_t)((uint16_t (*) (uint32_t adr))core->memctl->read16)(adr);
            if (rd != 0) {
                core->reg[rd] = val;
            }
        } else if (funct3 == 2) {
            // lw
            //printf("lw x%d, %d(x%d)\n", rd, imm, rs1)
            const int32_t val = (int32_t)((uint32_t (*) (uint32_t adr))core->memctl->read32)(adr);
            //printf("LW [0x%x] (0x%x)\n", adr, val)
            if (rd != 0) {
                core->reg[rd] = val;
            }
        } else if (funct3 == 4) {
            // lbu
            //printf("lbu x%d, %d(x%d)\n", rd, imm, rs1)
            const int32_t val = (int32_t)(uint32_t)((uint8_t (*) (uint32_t adr))core->memctl->read8)(adr);
            //printf("LBU[0x%x] (0x%x)\n", adr, val)
            if (rd != 0) {
                core->reg[rd] = val;
            }
        } else if (funct3 == 5) {
            // lhu
            //printf("lhu x%d, %d(x%d)\n", rd, imm, rs1)
            const int32_t val = (int32_t)(uint32_t)((uint16_t (*) (uint32_t adr))core->memctl->read16)(adr);
            if (rd != 0) {
                core->reg[rd] = val;
            }
        }

    } else if (op == OP_S) {
        const uint8_t imm4to0 = rd;
        const uint8_t imm11to5 = extract_funct7(instr);

        const uint32_t i = (uint32_t)imm11to5 << 5 | (uint32_t)imm4to0;
        const int32_t imm = expand12(i);

        const uint32_t adr = (uint32_t)(core->reg[rs1] + imm);
        const int32_t val = core->reg[rs2];

        if (funct3 == 0) {
            // sb
            //printf("sb x%d, %d(x%d)\n", rs2, imm, rs1)
            ((void (*) (uint32_t adr, uint8_t value))core->memctl->write8)(adr, (uint8_t)val);
        } else if (funct3 == 1) {
            // sh
            //printf("sh x%d, %d(x%d)\n", rs2, imm, rs1)
            ((void (*) (uint32_t adr, uint16_t value))core->memctl->write16)(adr, (uint16_t)val);
        } else if (funct3 == 2) {
            // sw
            //printf("sw x%d, %d(x%d)\n", rs2, imm, rs1)
            ((void (*) (uint32_t adr, uint32_t value))core->memctl->write32)(adr, (uint32_t)val);
        }

    } else if (op == OP_SYSTEM) {
        if (instr == INSTR_ECALL) {
            printf("ECALL\n");
            core_irq(core, INT_SYS_CALL);

        } else if (instr == INSTR_EBREAK) {
            printf("EBREAK\n");
            return false;

            // CSR instructions
        } else if (funct3 == FUNCT3_CSRRW) {
            //riscv_csr_rw(core, csr, rd, rs1)
        } else if (funct3 == FUNCT3_CSRRS) {
            //riscv_csr_rs(core, csr, rd, rs1)
        } else if (funct3 == FUNCT3_CSRRC) {
            //riscv_csr_rc(core, csr, rd, rs1)

        } else if (funct3 == FUNCT3_CSRRWI) {
        } else if (funct3 == FUNCT3_CSRRSI) {
        } else if (funct3 == FUNCT3_CSRRCI) {

        } else {
            printf("UNKNOWN SYSTEM INSTRUCTION: 0x%x\n", instr);
            printf("funct3 = %x\n", funct3);
            return false;
        }

    } else if (op == OP_FENCE) {
        if (instr == INSTR_PAUSE) {
            //printf("PAUSE\n")
        }
    } else {
        //printf("UNKNOWN OPCODE: %08X\n", op)
    }

    if (core->need_step) {
        core->ip = core->ip + 4;
    } else {
        core->need_step = true;
    }

    return true;
}

