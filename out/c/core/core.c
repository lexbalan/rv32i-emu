
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>

#include "core.h"

#include <stdio.h>

#include <unistd.h>

#include <stdlib.h>



#define core_debugMode  false








#define core_opL  0x03// load
#define core_opI  0x13// immediate
#define core_opS  0x23// store
#define core_opR  0x33// reg
#define core_opB  0x63// branch

#define core_opLUI  0x37// load upper immediate
#define core_opAUIPC  0x17// add upper immediate to PC
#define core_opJAL  0x6F// jump and link
#define core_opJALR  0x67// jump and link by register

#define core_opSYSTEM  0x73//
#define core_opFENCE  0x0F//


#define core_instrECALL  (core_opSYSTEM | 0x00000000)
#define core_instrEBREAK  (core_opSYSTEM | 0x00100000)
#define core_instrPAUSE  (core_opFENCE | 0x01000000)


// funct3 for CSR
#define core_funct3_CSRRW  1
#define core_funct3_CSRRS  2
#define core_funct3_CSRRC  3
#define core_funct3_CSRRWI  4
#define core_funct3_CSRRSI  5
#define core_funct3_CSRRCI  6







void core_init(core_Core *core, core_BusInterface *bus)
{
	*core = (core_Core){
		.bus = bus
	};
}


static uint32_t core_fetch(core_Core *core)
{
	return core->bus->read32(core->pc);
}



static void core_debug(char *form, ...);
static void core_doOpI(core_Core *core, uint32_t instr);
static void core_doOpR(core_Core *core, uint32_t instr);
static void core_doOpLUI(core_Core *core, uint32_t instr);
static void core_doOpAUIPC(core_Core *core, uint32_t instr);
static void core_doOpJAL(core_Core *core, uint32_t instr);
static void core_doOpJALR(core_Core *core, uint32_t instr);
static void core_doOpB(core_Core *core, uint32_t instr);
static void core_doOpL(core_Core *core, uint32_t instr);
static void core_doOpS(core_Core *core, uint32_t instr);
static void core_doOpSystem(core_Core *core, uint32_t instr);
static void core_doOpFence(core_Core *core, uint32_t instr);
void core_tick(core_Core *core)
{
	if (core->interrupt > 0) {
		core_debug("\nINT #%02X\n", core->interrupt);
		uint32_t vect_offset = core->interrupt * 4;
		core->pc = vect_offset;
		core->interrupt = 0;
	}

	uint32_t instr = core_fetch(core);
	uint8_t op = decode_extract_op(instr);
	uint8_t funct3 = decode_extract_funct3(instr);

	if (op == core_opI) {
		core_doOpI(core, instr);
	} else if (op == core_opR) {
		core_doOpR(core, instr);
	} else if (op == core_opLUI) {
		core_doOpLUI(core, instr);
	} else if (op == core_opAUIPC) {
		core_doOpAUIPC(core, instr);
	} else if (op == core_opJAL) {
		core_doOpJAL(core, instr);
	} else if (op == core_opJALR && funct3 == 0) {
		core_doOpJALR(core, instr);
	} else if (op == core_opB) {
		core_doOpB(core, instr);
	} else if (op == core_opL) {
		core_doOpL(core, instr);
	} else if (op == core_opS) {
		core_doOpS(core, instr);
	} else if (op == core_opSYSTEM) {
		core_doOpSystem(core, instr);
	} else if (op == core_opFENCE) {
		core_doOpFence(core, instr);
	} else {
		core_debug("UNKNOWN OPCODE: %08X\n", op);
	}

	core->pc = core->nexpc;
	core->nexpc = core->pc + 4;
	core->cnt = core->cnt + 1;
}


static void core_doOpI(core_Core *core, uint32_t instr)
{
	uint8_t funct3 = decode_extract_funct3(instr);
	uint8_t funct7 = decode_extract_funct7(instr);
	uint32_t imm12 = decode_extract_imm12(instr);
	int32_t imm = decode_expand12(imm12);
	uint8_t rd = decode_extract_rd(instr);
	uint8_t rs1 = decode_extract_rs1(instr);

	if (rd == 0) {
		return;
	}

	if (funct3 == 0) {
		// Add immediate

		core_debug("addi x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = (uint32_t)((int32_t)core->reg[rs1] + imm);

	} else if (funct3 == 1 && funct7 == 0) {
		/* SLLI is a logical left shift (zeros are shifted
		into the lower bits); SRLI is a logical right shift (zeros are shifted into the upper bits); and SRAI
		is an arithmetic right shift (the original sign bit is copied into the vacated upper bits). */

		core_debug("slli x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = core->reg[rs1] << ((uint8_t)imm);

	} else if (funct3 == 2) {
		// SLTI - set [1 to rd if rs1] less than immediate

		core_debug("slti x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = (uint32_t)((int32_t)core->reg[rs1] < imm);

	} else if (funct3 == 3) {
		core_debug("sltiu x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = (uint32_t)((uint32_t)core->reg[rs1] < (uint32_t)imm);

	} else if (funct3 == 4) {
		core_debug("xori x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = core->reg[rs1] ^ (uint32_t)imm;

	} else if (funct3 == 5 && funct7 == 0) {
		core_debug("srli x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = core->reg[rs1] >> ((uint8_t)imm);

	} else if (funct3 == 5 && funct7 == 0x20) {
		core_debug("srai x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = core->reg[rs1] >> ((uint8_t)imm);

	} else if (funct3 == 6) {
		core_debug("ori x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = core->reg[rs1] | (uint32_t)imm;

	} else if (funct3 == 7) {
		core_debug("andi x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = core->reg[rs1] & (uint32_t)imm;
	}
}



static void core_notImplemented(char *form, ...);
static void core_doOpR(core_Core *core, uint32_t instr)
{
	uint8_t funct3 = decode_extract_funct3(instr);
	uint8_t funct7 = decode_extract_funct7(instr);
	int32_t imm = decode_expand12(decode_extract_imm12(instr));
	uint8_t rd = decode_extract_rd(instr);
	uint8_t rs1 = decode_extract_rs1(instr);
	uint8_t rs2 = decode_extract_rs2(instr);

	if (rd == 0) {
		return;
	}

	uint32_t v0 = core->reg[rs1];
	uint32_t v1 = core->reg[rs2];


	uint8_t f7 = decode_extract_funct7(instr);
	//let f5 = extract_funct5(instr)
	//let f2 = extract_funct2(instr)
	//if f5 == 0 and f2 == 1 {
	if (f7 == 1) {
		//printf("MUL(%i)\n", Int32 funct3)

		//
		// "M" extension
		//

		if (funct3 == 0) {
			// MUL rd, rs1, rs2
			core_debug("mul x%d, x%d, x%d\n", rd, rs1, rs2);

			core->reg[rd] = (uint32_t)((int32_t)v0 * (int32_t)v1);

		} else if (funct3 == 1) {
			// MULH rd, rs1, rs2
			// Записывает в целевой регистр старшие биты
			// которые бы не поместились в него при обычном умножении
			core_debug("mulh x%d, x%d, x%d\n", rd, rs1, rs2);

			core->reg[rd] = (uint32_t)((uint64_t)((int64_t)v0 * (int64_t)v1) >> 32);

		} else if (funct3 == 2) {
			// MULHSU rd, rs1, rs2
			// mul high signed unsigned
			core_debug("mulhsu x%d, x%d, x%d\n", rd, rs1, rs2);

			// NOT IMPLEMENTED!
			core_notImplemented("mulhsu x%d, x%d, x%d", rd, rs1, rs2);

		} else if (funct3 == 3) {
			// MULHU rd, rs1, rs2
			core_debug("mulhu x%d, x%d, x%d\n", rd, rs1, rs2);

			// NOT IMPLEMENTED!
			core_notImplemented("mulhsu x%d, x%d, x%d\n", rd, rs1, rs2);

		} else if (funct3 == 4) {
			// DIV rd, rs1, rs2
			core_debug("div x%d, x%d, x%d\n", rd, rs1, rs2);

			core->reg[rd] = (uint32_t)((int32_t)v0 / (int32_t)v1);

		} else if (funct3 == 5) {
			// DIVU rd, rs1, rs2
			core_debug("divu x%d, x%d, x%d\n", rd, rs1, rs2);

			core->reg[rd] = (uint32_t)((uint32_t)v0 / (uint32_t)v1);

		} else if (funct3 == 6) {
			// REM rd, rs1, rs2
			core_debug("rem x%d, x%d, x%d\n", rd, rs1, rs2);

			core->reg[rd] = (uint32_t)((int32_t)v0 % (int32_t)v1);

		} else if (funct3 == 7) {
			// REMU rd, rs1, rs2
			core_debug("remu x%d, x%d, x%d\n", rd, rs1, rs2);

			core->reg[rd] = (uint32_t)((uint32_t)v0 % (uint32_t)v1);
		}

		return;
	}


	if (funct3 == 0 && funct7 == 0x00) {
		core_debug("add x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = (uint32_t)((int32_t)v0 + (int32_t)v1);

	} else if (funct3 == 0 && funct7 == 0x20) {
		core_debug("sub x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = (uint32_t)((int32_t)v0 - (int32_t)v1);

	} else if (funct3 == 1) {
		// shift left logical

		core_debug("sll x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = v0 << ((uint8_t)v1);

	} else if (funct3 == 2) {
		// set less than

		core_debug("slt x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = (uint32_t)((int32_t)v0 < (int32_t)v1);

	} else if (funct3 == 3) {
		// set less than unsigned

		core_debug("sltu x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = (uint32_t)((uint32_t)v0 < (uint32_t)v1);

	} else if (funct3 == 4) {

		core_debug("xor x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = v0 ^ v1;

	} else if (funct3 == 5 && funct7 == 0) {
		// shift right logical

		core_debug("srl x%d, x%d, x%d\n", rd, rs1, rs2);

		core->reg[rd] = v0 >> ((uint8_t)v1);

	} else if (funct3 == 5 && funct7 == 0x20) {
		// shift right arithmetical

		core_debug("sra x%d, x%d, x%d\n", rd, rs1, rs2);

		// ERROR: не реализован арифм сдвиг!
		//core.reg[rd] = v0 >> Int32 v1

	} else if (funct3 == 6) {
		core_debug("or x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = v0 | v1;

	} else if (funct3 == 7) {
		core_debug("and x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = v0 & v1;
	}
}


static void core_doOpLUI(core_Core *core, uint32_t instr)
{
	// load upper immediate

	int32_t imm = decode_expand12(decode_extract_imm31_12(instr));
	uint8_t rd = decode_extract_rd(instr);

	core_debug("lui x%d, 0x%X\n", rd, imm);

	if (rd != 0) {
		core->reg[rd] = (uint32_t)imm << 12;
	}
}


static void core_doOpAUIPC(core_Core *core, uint32_t instr)
{
	// Add upper immediate to PC

	int32_t imm = decode_expand12(decode_extract_imm31_12(instr));
	uint32_t x = core->pc + (uint32_t)((uint32_t)imm << 12);
	uint8_t rd = decode_extract_rd(instr);

	core_debug("auipc x%d, 0x%X\n", rd, imm);

	if (rd != 0) {
		core->reg[rd] = (uint32_t)x;
	}
}


static void core_doOpJAL(core_Core *core, uint32_t instr)
{
	// Jump and link

	uint8_t rd = decode_extract_rd(instr);
	uint32_t raw_imm = decode_extract_jal_imm(instr);
	int32_t imm = decode_expand20(raw_imm);

	core_debug("jal x%d, %d\n", rd, imm);

	if (rd != 0) {
		core->reg[rd] = (uint32_t)(core->pc + 4);
	}

	core->nexpc = (uint32_t)((int32_t)core->pc + imm);
}


static void core_doOpJALR(core_Core *core, uint32_t instr)
{
	// Jump and link (by register)

	uint8_t rs1 = decode_extract_rs1(instr);
	uint8_t rd = decode_extract_rd(instr);
	int32_t imm = decode_expand12(decode_extract_imm12(instr));

	core_debug("jalr %d(x%d)\n", imm, rs1);

	// rd <- pc + 4
	// pc <- (rs1 + imm) & ~1
	int32_t next_instr_ptr = (int32_t)(core->pc + 4);
	uint32_t jump_to = (uint32_t)((int32_t)core->reg[rs1] + imm) & 0xFFFFFFFEU;

	if (rd != 0) {
		core->reg[rd] = (uint32_t)next_instr_ptr;
	}

	core->nexpc = (uint32_t)jump_to;
}


static void core_doOpB(core_Core *core, uint32_t instr)
{
	uint8_t funct3 = decode_extract_funct3(instr);
	uint8_t imm12_10to5 = decode_extract_funct7(instr);
	uint16_t imm4to1_11 = (uint16_t)decode_extract_rd(instr);
	uint8_t rs1 = decode_extract_rs1(instr);
	uint8_t rs2 = decode_extract_rs2(instr);

	uint16_t bit4to1 = imm4to1_11 & 0x1E;
	uint16_t bit10to5 = (uint16_t)(imm12_10to5 & 0x3F) << 5;
	uint16_t bit11 = (imm4to1_11 & 0x1) << 11;
	uint16_t bit12 = (uint16_t)(imm12_10to5 & 0x40) << 6;

	uint16_t bits = bit12 | bit11 | bit10to5 | bit4to1;

	// распространяем знак, если он есть
	if ((bits & 1 << 12) != 0) {
		bits = 0xF000 | bits;
	}

	int16_t imm = (int16_t)bits;

	if (funct3 == 0) {
		// BEQ - Branch if equal

		core_debug("beq x%d, x%d, %d\n", rs1, rs2, imm);

		// Branch if two registers are equal
		if (core->reg[rs1] == core->reg[rs2]) {
			core->nexpc = (uint32_t)((int32_t)core->pc + (int32_t)imm);
		}

	} else if (funct3 == 1) {
		// BNE - Branch if not equal

		core_debug("bne x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if (core->reg[rs1] != core->reg[rs2]) {
			core->nexpc = (uint32_t)((int32_t)core->pc + (int32_t)imm);
		}

	} else if (funct3 == 4) {
		// BLT - Branch if less than (signed)

		core_debug("blt x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if ((int32_t)core->reg[rs1] < (int32_t)core->reg[rs2]) {
			core->nexpc = (uint32_t)((int32_t)core->pc + (int32_t)imm);
		}

	} else if (funct3 == 5) {
		// BGE - Branch if greater or equal (signed)

		core_debug("bge x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if ((int32_t)core->reg[rs1] >= (int32_t)core->reg[rs2]) {
			core->nexpc = (uint32_t)((int32_t)core->pc + (int32_t)imm);
		}

	} else if (funct3 == 6) {
		// BLTU - Branch if less than (unsigned)

		core_debug("bltu x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if ((uint32_t)core->reg[rs1] < (uint32_t)core->reg[rs2]) {
			core->nexpc = (uint32_t)((int32_t)core->pc + (int32_t)imm);
		}

	} else if (funct3 == 7) {
		// BGEU - Branch if greater or equal (unsigned)

		core_debug("bgeu x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if ((uint32_t)core->reg[rs1] >= (uint32_t)core->reg[rs2]) {
			core->nexpc = (uint32_t)((int32_t)core->pc + (int32_t)imm);
		}
	}
}


static void core_doOpL(core_Core *core, uint32_t instr)
{
	uint8_t funct3 = decode_extract_funct3(instr);
	uint8_t funct7 = decode_extract_funct7(instr);
	uint32_t imm12 = decode_extract_imm12(instr);
	int32_t imm = decode_expand12(imm12);
	uint8_t rd = decode_extract_rd(instr);
	uint8_t rs1 = decode_extract_rs1(instr);
	uint8_t rs2 = decode_extract_rs2(instr);

	uint32_t adr = (uint32_t)((int32_t)core->reg[rs1] + imm);

	if (funct3 == 0) {
		// LB (Load 8-bit signed integer value)

		core_debug("lb x%d, %d(x%d)\n", rd, imm, rs1);

		int32_t val = (int32_t)core->bus->read8(adr);
		if (rd != 0) {
			core->reg[rd] = (uint32_t)val;
		}

	} else if (funct3 == 1) {
		// LH (Load 16-bit signed integer value)

		core_debug("lh x%d, %d(x%d)\n", rd, imm, rs1);

		int32_t val = (int32_t)core->bus->read16(adr);
		if (rd != 0) {
			core->reg[rd] = (uint32_t)val;
		}

	} else if (funct3 == 2) {
		// LW (Load 32-bit signed integer value)

		core_debug("lw x%d, %d(x%d)\n", rd, imm, rs1);

		uint32_t val = core->bus->read32(adr);
		if (rd != 0) {
			core->reg[rd] = val;
		}

	} else if (funct3 == 4) {
		// LBU (Load 8-bit unsigned integer value)

		core_debug("lbu x%d, %d(x%d)\n", rd, imm, rs1);

		uint32_t val = (uint32_t)core->bus->read8(adr);
		if (rd != 0) {
			core->reg[rd] = (uint32_t)val;
		}

	} else if (funct3 == 5) {
		// LHU (Load 16-bit unsigned integer value)

		core_debug("lhu x%d, %d(x%d)\n", rd, imm, rs1);

		uint32_t val = (uint32_t)core->bus->read16(adr);
		if (rd != 0) {
			core->reg[rd] = (uint32_t)val;
		}
	}
}


static void core_doOpS(core_Core *core, uint32_t instr)
{
	uint8_t funct3 = decode_extract_funct3(instr);
	uint8_t funct7 = decode_extract_funct7(instr);
	uint8_t rd = decode_extract_rd(instr);
	uint8_t rs1 = decode_extract_rs1(instr);
	uint8_t rs2 = decode_extract_rs2(instr);

	uint32_t imm4to0 = (uint32_t)rd;
	uint32_t imm11to5 = (uint32_t)funct7;
	uint32_t _imm = (uint32_t)imm11to5 << 5 | (uint32_t)imm4to0;
	int32_t imm = decode_expand12(_imm);

	uint32_t adr = (uint32_t)((int32_t)core->reg[rs1] + imm);
	uint32_t val = core->reg[rs2];

	if (funct3 == 0) {
		// SB (save 8-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		core_debug("sb x%d, %d(x%d)\n", rs2, imm, rs1);

		//
		core->bus->write8(adr, (uint8_t)val);

	} else if (funct3 == 1) {
		// SH (save 16-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		core_debug("sh x%d, %d(x%d)\n", rs2, imm, rs1);

		//
		core->bus->write16(adr, (uint16_t)val);

	} else if (funct3 == 2) {
		// SW (save 32-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		core_debug("sw x%d, %d(x%d)\n", rs2, imm, rs1);

		//
		core->bus->write32(adr, val);
	}
}



void core_irq(core_Core *core, uint32_t irq);
static void core_csr_rw(core_Core *core, uint16_t csr, uint8_t rd, uint8_t rs1);
static void core_csr_rs(core_Core *core, uint16_t csr, uint8_t rd, uint8_t rs1);
static void core_csr_rc(core_Core *core, uint16_t csr, uint8_t rd, uint8_t rs1);
static void core_csr_rwi(core_Core *core, uint16_t csr, uint8_t rd, uint8_t imm);
static void core_csr_rsi(core_Core *core, uint16_t csr, uint8_t rd, uint8_t imm);
static void core_csr_rci(core_Core *core, uint16_t csr, uint8_t rd, uint8_t imm);
static void core_doOpSystem(core_Core *core, uint32_t instr)
{
	uint8_t funct3 = decode_extract_funct3(instr);
	uint8_t funct7 = decode_extract_funct7(instr);
	uint32_t imm12 = decode_extract_imm12(instr);
	int32_t imm = decode_expand12(imm12);
	uint8_t rd = decode_extract_rd(instr);
	uint8_t rs1 = decode_extract_rs1(instr);

	uint16_t csr = (uint16_t)imm12;

	if (instr == core_instrECALL) {
		core_debug("ECALL\n");

		//
		core_irq(core, core_intSysCall);

	} else if (instr == core_instrEBREAK) {
		core_debug("EBREAK\n");

		//
		printf("END.\n");
		core->end = true;

		// CSR instructions
	} else if (funct3 == core_funct3_CSRRW) {
		// CSR read & write
		core_csr_rw(core, csr, rd, rs1);
	} else if (funct3 == core_funct3_CSRRS) {
		// CSR read & set bit
		uint8_t mask_reg = rs1;
		core_csr_rs(core, csr, rd, mask_reg);
	} else if (funct3 == core_funct3_CSRRC) {
		// CSR read & clear bit
		uint8_t mask_reg = rs1;
		core_csr_rc(core, csr, rd, mask_reg);
	} else if (funct3 == core_funct3_CSRRWI) {
		uint8_t imm = rs1;
		core_csr_rwi(core, csr, rd, imm);
	} else if (funct3 == core_funct3_CSRRSI) {
		uint8_t imm = rs1;
		core_csr_rsi(core, csr, rd, imm);
	} else if (funct3 == core_funct3_CSRRCI) {
		uint8_t imm = rs1;
		core_csr_rci(core, csr, rd, imm);
	} else {
		core_debug("UNKNOWN SYSTEM INSTRUCTION: 0x%x\n", instr);
		core->end = true;
	}
}


static void core_doOpFence(core_Core *core, uint32_t instr)
{
	if (instr == core_instrPAUSE) {
		core_debug("PAUSE\n");
	}
}


void core_irq(core_Core *core, uint32_t irq)
{
	if (core->interrupt == 0) {
		core->interrupt = irq;
	}
}





//
// CSR's
//https://five-embeddev.com/riscv-isa-manual/latest/priv-csrs.html
//



#define core_mstatus_adr  0x300
#define core_misa_adr  0x301
#define core_mie_adr  0x304
#define core_mtvec_adr  0x305
#define core_mcause_adr  0x342
#define core_mtval_adr  0x343
#define core_mip_adr  0x344


#define core_satp_adr  0x180

#define core_sstatus_adr  0x100
#define core_sie_adr  0x104
#define core_stvec_adr  0x105
#define core_scause_adr  0x142
#define core_stval_adr  0x143
#define core_sip_adr  0x144


/*
The CSRRW (Atomic Read/Write CSR) instruction atomically swaps values in the CSRs and integer registers. CSRRW reads the old value of the CSR, zero-extends the value to XLEN bits, then writes it to integer register rd. The initial value in rs1 is written to the CSR. If rd=x0, then the instruction shall not read the CSR and shall not cause any of the side effects that might occur on a CSR read.
*/
static void core_csr_rw(core_Core *core, uint16_t csr, uint8_t rd, uint8_t rs1)
{
	uint32_t nv = core->reg[rs1];
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


/*
The CSRRS (Atomic Read and Set Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be set in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be set in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
*/
static void core_csr_rs(core_Core *core, uint16_t csr, uint8_t rd, uint8_t rs1)
{
	//TODO
}

/*
The CSRRC (Atomic Read and Clear Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be cleared in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be cleared in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
*/
static void core_csr_rc(core_Core *core, uint16_t csr, uint8_t rd, uint8_t rs1)
{
	//TODO
}


// -


static void core_csr_rwi(core_Core *core, uint16_t csr, uint8_t rd, uint8_t imm)
{
	//TODO
}


// read+clear immediate(5-bit)
static void core_csr_rsi(core_Core *core, uint16_t csr, uint8_t rd, uint8_t imm)
{
	//TODO
}


// read+clear immediate(5-bit)
static void core_csr_rci(core_Core *core, uint16_t csr, uint8_t rd, uint8_t imm)
{
	//TODO
}



static void core_debug(char *form, ...)
{
	va_list va;
	va_start(va, form);
	if (core_debugMode) {
		vprintf(form, va);
	}
	va_end(va);
}


static void core_notImplemented(char *form, ...)
{
	va_list va;
	va_start(va, form);
	printf("\n\nINSTRUCTION_NOT_IMPLEMENTED: \"");
	vprintf(form, va);
	va_end(va);
	puts("\"\n");
	exit(-1);
}


void core_show_regs(core_Core *core)
{
	int32_t i = 0;
	while (i < 16) {
		printf("x%02d = 0x%08x", i, core->reg[i]);
		printf("    ");
		printf("x%02d = 0x%08x\n", i + 16, core->reg[i + 16]);
		i = i + 1;
	}
}

