
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "core.h"

#define ABS(x) ((x) < 0 ? -(x) : (x))


#define traceMode  false





#define opL  0x03
// load
#define opI  0x13
// immediate
#define opS  0x23
// store
#define opR  0x33
// reg
#define opB  0x63
// branch

#define opLUI  0x37
// load upper immediate
#define opAUIPC  0x17
// add upper immediate to PC
#define opJAL  0x6F
// jump and link
#define opJALR  0x67
// jump and link by register

#define opSYSTEM  0x73
//
#define opFENCE  0x0F
//

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




void core_init(core_Core *core, core_BusInterface *bus)
{
	*core = (core_Core){
		.bus = bus
	};
}

static uint32_t fetch(core_Core *core)
{
	return core->bus->read32(core->pc);
}


static void trace(uint32_t pc, char *form, ...);
static void doOpI(core_Core *core, uint32_t instr);
static void doOpR(core_Core *core, uint32_t instr);
static void doOpLUI(core_Core *core, uint32_t instr);
static void doOpAUIPC(core_Core *core, uint32_t instr);
static void doOpJAL(core_Core *core, uint32_t instr);
static void doOpJALR(core_Core *core, uint32_t instr);
static void doOpB(core_Core *core, uint32_t instr);
static void doOpL(core_Core *core, uint32_t instr);
static void doOpS(core_Core *core, uint32_t instr);
static void doOpSystem(core_Core *core, uint32_t instr);
static void doOpFence(core_Core *core, uint32_t instr);
void core_tick(core_Core *core)
{
	if (core->interrupt != 0) {
		trace(core->pc, "\nINT #%02X\n", core->interrupt);
		const uint32_t vect_offset = core->interrupt * 4;
		core->pc = vect_offset;
		core->interrupt = 0;
	}

	const uint32_t instr = fetch(core);
	const uint8_t op = decode_extract_op(instr);
	const uint8_t funct3 = decode_extract_funct3(instr);

	if (op == opI) {
		doOpI(core, instr);
	} else if (op == opR) {
		doOpR(core, instr);
	} else if (op == opLUI) {
		doOpLUI(core, instr);
	} else if (op == opAUIPC) {
		doOpAUIPC(core, instr);
	} else if (op == opJAL) {
		doOpJAL(core, instr);
	} else if (op == opJALR && funct3 == 0) {
		doOpJALR(core, instr);
	} else if (op == opB) {
		doOpB(core, instr);
	} else if (op == opL) {
		doOpL(core, instr);
	} else if (op == opS) {
		doOpS(core, instr);
	} else if (op == opSYSTEM) {
		doOpSystem(core, instr);
	} else if (op == opFENCE) {
		doOpFence(core, instr);
	} else {
		trace(core->pc, "UNKNOWN OPCODE: %08X\n", op);
	}

	core->pc = core->nexpc;
	core->nexpc = core->pc + 4;
	core->cnt = core->cnt + 1;
}

static void doOpI(core_Core *core, uint32_t instr)
{
	const uint8_t funct3 = decode_extract_funct3(instr);
	const uint8_t funct7 = decode_extract_funct7(instr);
	const uint32_t imm12 = decode_extract_imm12(instr);
	const int32_t imm = decode_expand12(imm12);
	const uint8_t rd = decode_extract_rd(instr);
	const uint8_t rs1 = decode_extract_rs1(instr);

	if (rd == 0) {
		return;
	}

	if (funct3 == 0) {
		// Add immediate

		trace(core->pc, "addi x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = (uint32_t)((int32_t)core->reg[rs1] + imm);

	} else if (funct3 == 1 && funct7 == 0) {
		/* SLLI is a logical left shift (zeros are shifted
		into the lower bits); SRLI is a logical right shift (zeros are shifted into the upper bits); and SRAI
		is an arithmetic right shift (the original sign bit is copied into the vacated upper bits). */

		trace(core->pc, "slli x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = core->reg[rs1] << (ABS(imm));

	} else if (funct3 == 2) {
		// SLTI - set [1 to rd if rs1] less than immediate

		trace(core->pc, "slti x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = (uint32_t)((int32_t)core->reg[rs1] < imm);

	} else if (funct3 == 3) {
		trace(core->pc, "sltiu x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = (uint32_t)(core->reg[rs1] < ABS(imm));

	} else if (funct3 == 4) {
		trace(core->pc, "xori x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = core->reg[rs1] ^ (uint32_t)imm;

	} else if (funct3 == 5 && funct7 == 0) {
		trace(core->pc, "srli x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = (core->reg[rs1] >> (ABS(imm)));

	} else if (funct3 == 5 && funct7 == 0x20) {
		trace(core->pc, "srai x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = core->reg[rs1] >> (ABS(imm));

	} else if (funct3 == 6) {
		trace(core->pc, "ori x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = core->reg[rs1] | (uint32_t)imm;

	} else if (funct3 == 7) {
		trace(core->pc, "andi x%d, x%d, %d\n", rd, rs1, imm);

		//
		core->reg[rd] = core->reg[rs1] & (uint32_t)imm;
	}
}


static void notImplemented(char *form, ...);
static void doOpR(core_Core *core, uint32_t instr)
{
	const uint8_t funct3 = decode_extract_funct3(instr);
	const uint8_t funct7 = decode_extract_funct7(instr);
	const int32_t imm = decode_expand12(decode_extract_imm12(instr));
	const uint8_t rd = decode_extract_rd(instr);
	const uint8_t rs1 = decode_extract_rs1(instr);
	const uint8_t rs2 = decode_extract_rs2(instr);

	if (rd == 0) {
		return;
	}

	const uint32_t v0 = core->reg[rs1];
	const uint32_t v1 = core->reg[rs2];


	const uint8_t f7 = decode_extract_funct7(instr);
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
			trace(core->pc, "mul x%d, x%d, x%d\n", rd, rs1, rs2);

			core->reg[rd] = (uint32_t)((int32_t)v0 * (int32_t)v1);

		} else if (funct3 == 1) {
			// MULH rd, rs1, rs2
			// Записывает в целевой регистр старшие биты
			// которые бы не поместились в него при обычном умножении
			trace(core->pc, "mulh x%d, x%d, x%d\n", rd, rs1, rs2);

			core->reg[rd] = (uint32_t)((uint64_t)((int64_t)v0 * (int64_t)v1) >> 32);

		} else if (funct3 == 2) {
			// MULHSU rd, rs1, rs2
			// mul high signed unsigned
			trace(core->pc, "mulhsu x%d, x%d, x%d\n", rd, rs1, rs2);

			// NOT IMPLEMENTED!
			notImplemented("mulhsu x%d, x%d, x%d", rd, rs1, rs2);

		} else if (funct3 == 3) {
			// MULHU rd, rs1, rs2
			trace(core->pc, "mulhu x%d, x%d, x%d\n", rd, rs1, rs2);

			// NOT IMPLEMENTED!
			notImplemented("mulhsu x%d, x%d, x%d\n", rd, rs1, rs2);

		} else if (funct3 == 4) {
			// DIV rd, rs1, rs2
			trace(core->pc, "div x%d, x%d, x%d\n", rd, rs1, rs2);

			core->reg[rd] = (uint32_t)((int32_t)v0 / (int32_t)v1);

		} else if (funct3 == 5) {
			// DIVU rd, rs1, rs2
			trace(core->pc, "divu x%d, x%d, x%d\n", rd, rs1, rs2);

			core->reg[rd] = (v0 / v1);

		} else if (funct3 == 6) {
			// REM rd, rs1, rs2
			trace(core->pc, "rem x%d, x%d, x%d\n", rd, rs1, rs2);

			core->reg[rd] = (uint32_t)((int32_t)v0 % (int32_t)v1);

		} else if (funct3 == 7) {
			// REMU rd, rs1, rs2
			trace(core->pc, "remu x%d, x%d, x%d\n", rd, rs1, rs2);

			core->reg[rd] = (v0 % v1);
		}

		return;
	}


	if (funct3 == 0 && funct7 == 0x00) {
		trace(core->pc, "add x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = (uint32_t)((int32_t)v0 + (int32_t)v1);

	} else if (funct3 == 0 && funct7 == 0x20) {
		trace(core->pc, "sub x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = (uint32_t)((int32_t)v0 - (int32_t)v1);

	} else if (funct3 == 1) {
		// shift left logical

		trace(core->pc, "sll x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = v0 << ((uint8_t)v1);

	} else if (funct3 == 2) {
		// set less than

		trace(core->pc, "slt x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = (uint32_t)((int32_t)v0 < (int32_t)v1);

	} else if (funct3 == 3) {
		// set less than unsigned

		trace(core->pc, "sltu x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = (uint32_t)(v0 < v1);

	} else if (funct3 == 4) {

		trace(core->pc, "xor x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = v0 ^ v1;

	} else if (funct3 == 5 && funct7 == 0) {
		// shift right logical

		trace(core->pc, "srl x%d, x%d, x%d\n", rd, rs1, rs2);

		core->reg[rd] = v0 >> ((uint8_t)v1);

	} else if (funct3 == 5 && funct7 == 0x20) {
		// shift right arithmetical

		trace(core->pc, "sra x%d, x%d, x%d\n", rd, rs1, rs2);

		// ERROR: не реализован арифм сдвиг!
		//core.reg[rd] = v0 >> Int32 v1

	} else if (funct3 == 6) {
		trace(core->pc, "or x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = v0 | v1;

	} else if (funct3 == 7) {
		trace(core->pc, "and x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		core->reg[rd] = v0 & v1;
	}
}

static void doOpLUI(core_Core *core, uint32_t instr)
{
	// load upper immediate

	const int32_t imm = decode_expand12(decode_extract_imm31_12(instr));
	const uint8_t rd = decode_extract_rd(instr);

	trace(core->pc, "lui x%d, 0x%X\n", rd, imm);

	if (rd != 0) {
		core->reg[rd] = (uint32_t)imm << 12;
	}
}

static void doOpAUIPC(core_Core *core, uint32_t instr)
{
	// Add upper immediate to PC

	const int32_t imm = decode_expand12(decode_extract_imm31_12(instr));
	const uint32_t x = core->pc + ((uint32_t)imm << 12);
	const uint8_t rd = decode_extract_rd(instr);

	trace(core->pc, "auipc x%d, 0x%X\n", rd, imm);

	if (rd != 0) {
		core->reg[rd] = x;
	}
}

static void doOpJAL(core_Core *core, uint32_t instr)
{
	// Jump and link

	const uint8_t rd = decode_extract_rd(instr);
	const uint32_t raw_imm = decode_extract_jal_imm(instr);
	const int32_t imm = decode_expand20(raw_imm);

	trace(core->pc, "jal x%d, %d\n", rd, imm);

	if (rd != 0) {
		core->reg[rd] = (core->pc + 4);
	}

	core->nexpc = ABS(((int32_t)core->pc + imm));
}

static void doOpJALR(core_Core *core, uint32_t instr)
{
	// Jump and link (by register)

	const uint8_t rs1 = decode_extract_rs1(instr);
	const uint8_t rd = decode_extract_rd(instr);
	const int32_t imm = decode_expand12(decode_extract_imm12(instr));

	trace(core->pc, "jalr %d(x%d)\n", imm, rs1);

	// rd <- pc + 4
	// pc <- (rs1 + imm) & ~1
	const int32_t next_instr_ptr = (int32_t)(core->pc + 4);
	const uint32_t jump_to = (uint32_t)((int32_t)core->reg[rs1] + imm) & 0xFFFFFFFE;

	if (rd != 0) {
		core->reg[rd] = (uint32_t)next_instr_ptr;
	}

	core->nexpc = jump_to;
}

static void doOpB(core_Core *core, uint32_t instr)
{
	const uint8_t funct3 = decode_extract_funct3(instr);
	const uint8_t imm12_10to5 = decode_extract_funct7(instr);
	const uint16_t imm4to1_11 = (uint16_t)decode_extract_rd(instr);
	const uint8_t rs1 = decode_extract_rs1(instr);
	const uint8_t rs2 = decode_extract_rs2(instr);

	const uint16_t bit4to1 = imm4to1_11 & 0x1E;
	const uint16_t bit10to5 = (uint16_t)(imm12_10to5 & 0x3F) << 5;
	const uint16_t bit11 = (imm4to1_11 & 0x1) << 11;
	const uint16_t bit12 = (uint16_t)(imm12_10to5 & 0x40) << 6;

	uint16_t bits = (bit12 | bit11 | bit10to5 | bit4to1);

	// распространяем знак, если он есть
	if ((bits & (1 << 12)) != 0) {
		bits = 0xF000 | bits;
	}

	const int16_t imm = (int16_t)bits;

	if (funct3 == 0) {
		// BEQ - Branch if equal

		trace(core->pc, "beq x%d, x%d, %d\n", rs1, rs2, imm);

		// Branch if two registers are equal
		if (core->reg[rs1] == core->reg[rs2]) {
			core->nexpc = ABS(((int32_t)core->pc + (int32_t)imm));
		}

	} else if (funct3 == 1) {
		// BNE - Branch if not equal

		trace(core->pc, "bne x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if (core->reg[rs1] != core->reg[rs2]) {
			core->nexpc = ABS(((int32_t)core->pc + (int32_t)imm));
		}

	} else if (funct3 == 4) {
		// BLT - Branch if less than (signed)

		trace(core->pc, "blt x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if ((int32_t)core->reg[rs1] < (int32_t)core->reg[rs2]) {
			core->nexpc = ABS(((int32_t)core->pc + (int32_t)imm));
		}

	} else if (funct3 == 5) {
		// BGE - Branch if greater or equal (signed)

		trace(core->pc, "bge x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if ((int32_t)core->reg[rs1] >= (int32_t)core->reg[rs2]) {
			core->nexpc = ABS(((int32_t)core->pc + (int32_t)imm));
		}

	} else if (funct3 == 6) {
		// BLTU - Branch if less than (unsigned)

		trace(core->pc, "bltu x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if (core->reg[rs1] < core->reg[rs2]) {
			core->nexpc = ABS(((int32_t)core->pc + (int32_t)imm));
		}

	} else if (funct3 == 7) {
		// BGEU - Branch if greater or equal (unsigned)

		trace(core->pc, "bgeu x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if (core->reg[rs1] >= core->reg[rs2]) {
			core->nexpc = ABS(((int32_t)core->pc + (int32_t)imm));
		}
	}
}

static void doOpL(core_Core *core, uint32_t instr)
{
	const uint8_t funct3 = decode_extract_funct3(instr);
	const uint8_t funct7 = decode_extract_funct7(instr);
	const uint32_t imm12 = decode_extract_imm12(instr);
	const int32_t imm = decode_expand12(imm12);
	const uint8_t rd = decode_extract_rd(instr);
	const uint8_t rs1 = decode_extract_rs1(instr);
	const uint8_t rs2 = decode_extract_rs2(instr);

	const uint32_t adr = ABS(((int32_t)core->reg[rs1] + imm));

	if (funct3 == 0) {
		// LB (Load 8-bit signed integer value)

		trace(core->pc, "lb x%d, %d(x%d)\n", rd, imm, rs1);

		const int32_t val = (int32_t)core->bus->read8(adr);
		if (rd != 0) {
			core->reg[rd] = (uint32_t)val;
		}

	} else if (funct3 == 1) {
		// LH (Load 16-bit signed integer value)

		trace(core->pc, "lh x%d, %d(x%d)\n", rd, imm, rs1);

		const int32_t val = (int32_t)core->bus->read16(adr);
		if (rd != 0) {
			core->reg[rd] = (uint32_t)val;
		}

	} else if (funct3 == 2) {
		// LW (Load 32-bit signed integer value)

		trace(core->pc, "lw x%d, %d(x%d)\n", rd, imm, rs1);

		const uint32_t val = core->bus->read32(adr);
		if (rd != 0) {
			core->reg[rd] = val;
		}

	} else if (funct3 == 4) {
		// LBU (Load 8-bit unsigned integer value)

		trace(core->pc, "lbu x%d, %d(x%d)\n", rd, imm, rs1);

		const uint32_t val = (uint32_t)core->bus->read8(adr);
		if (rd != 0) {
			core->reg[rd] = val;
		}

	} else if (funct3 == 5) {
		// LHU (Load 16-bit unsigned integer value)

		trace(core->pc, "lhu x%d, %d(x%d)\n", rd, imm, rs1);

		const uint32_t val = (uint32_t)core->bus->read16(adr);
		if (rd != 0) {
			core->reg[rd] = val;
		}
	}
}

static void doOpS(core_Core *core, uint32_t instr)
{
	const uint8_t funct3 = decode_extract_funct3(instr);
	const uint8_t funct7 = decode_extract_funct7(instr);
	const uint8_t rd = decode_extract_rd(instr);
	const uint8_t rs1 = decode_extract_rs1(instr);
	const uint8_t rs2 = decode_extract_rs2(instr);

	const uint32_t imm4to0 = (uint32_t)rd;
	const uint32_t imm11to5 = (uint32_t)funct7;
	const uint32_t _imm = (imm11to5 << 5) | imm4to0;
	const int32_t imm = decode_expand12(_imm);

	const uint32_t adr = (uint32_t)((int32_t)core->reg[rs1] + imm);
	const uint32_t val = core->reg[rs2];

	if (funct3 == 0) {
		// SB (save 8-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(core->pc, "sb x%d, %d(x%d)\n", rs2, imm, rs1);

		//
		core->bus->write8(adr, (uint8_t)val);

	} else if (funct3 == 1) {
		// SH (save 16-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(core->pc, "sh x%d, %d(x%d)\n", rs2, imm, rs1);

		//
		core->bus->write16(adr, (uint16_t)val);

	} else if (funct3 == 2) {
		// SW (save 32-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(core->pc, "sw x%d, %d(x%d)\n", rs2, imm, rs1);

		//
		core->bus->write32(adr, val);
	}
}


void core_irq(core_Core *core, uint32_t irq);
static void csr_rw(core_Core *core, uint16_t csr, uint8_t rd, uint8_t rs1);
static void csr_rs(core_Core *core, uint16_t csr, uint8_t rd, uint8_t rs1);
static void csr_rc(core_Core *core, uint16_t csr, uint8_t rd, uint8_t rs1);
static void csr_rwi(core_Core *core, uint16_t csr, uint8_t rd, uint8_t imm);
static void csr_rsi(core_Core *core, uint16_t csr, uint8_t rd, uint8_t imm);
static void csr_rci(core_Core *core, uint16_t csr, uint8_t rd, uint8_t imm);
static void doOpSystem(core_Core *core, uint32_t instr)
{
	const uint8_t funct3 = decode_extract_funct3(instr);
	const uint8_t funct7 = decode_extract_funct7(instr);
	const uint32_t imm12 = decode_extract_imm12(instr);
	const int32_t imm = decode_expand12(imm12);
	const uint8_t rd = decode_extract_rd(instr);
	const uint8_t rs1 = decode_extract_rs1(instr);

	const uint16_t csr = (uint16_t)imm12;

	if (instr == instrECALL) {
		trace(core->pc, "ECALL\n");

		//
		core_irq(core, core_intSysCall);

	} else if (instr == instrEBREAK) {
		trace(core->pc, "EBREAK\n");

		//
		printf("END.\n");
		core->end = true;

		// CSR instructions
	} else if (funct3 == funct3_CSRRW) {
		// CSR read & write
		csr_rw(core, csr, rd, rs1);
	} else if (funct3 == funct3_CSRRS) {
		// CSR read & set bit
		const uint8_t mask_reg = rs1;
		csr_rs(core, csr, rd, mask_reg);
	} else if (funct3 == funct3_CSRRC) {
		// CSR read & clear bit
		const uint8_t mask_reg = rs1;
		csr_rc(core, csr, rd, mask_reg);
	} else if (funct3 == funct3_CSRRWI) {
		const uint8_t imm = rs1;
		csr_rwi(core, csr, rd, imm);
	} else if (funct3 == funct3_CSRRSI) {
		const uint8_t imm = rs1;
		csr_rsi(core, csr, rd, imm);
	} else if (funct3 == funct3_CSRRCI) {
		const uint8_t imm = rs1;
		csr_rci(core, csr, rd, imm);
	} else {
		trace(core->pc, "UNKNOWN SYSTEM INSTRUCTION: 0x%x\n", instr);
		core->end = true;
	}
}

static void doOpFence(core_Core *core, uint32_t instr)
{
	if (instr == instrPAUSE) {
		trace(core->pc, "PAUSE\n");
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

#define mstatus_adr  0x300
#define misa_adr  0x301
#define mie_adr  0x304
#define mtvec_adr  0x305
#define mcause_adr  0x342
#define mtval_adr  0x343
#define mip_adr  0x344

#define satp_adr  0x180

#define sstatus_adr  0x100
#define sie_adr  0x104
#define stvec_adr  0x105
#define scause_adr  0x142
#define stval_adr  0x143
#define sip_adr  0x144

/*
The CSRRW (Atomic Read/Write CSR) instruction atomically swaps values in the CSRs and integer registers. CSRRW reads the old value of the CSR, zero-extends the value to XLEN bits, then writes it to integer register rd. The initial value in rs1 is written to the CSR. If rd=x0, then the instruction shall not read the CSR and shall not cause any of the side effects that might occur on a CSR read.
*/
static void csr_rw(core_Core *core, uint16_t csr, uint8_t rd, uint8_t rs1)
{
	const uint32_t nv = core->reg[rs1];
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
static void csr_rs(core_Core *core, uint16_t csr, uint8_t rd, uint8_t rs1)
{
	//TODO
}

/*
The CSRRC (Atomic Read and Clear Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be cleared in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be cleared in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
*/
static void csr_rc(core_Core *core, uint16_t csr, uint8_t rd, uint8_t rs1)
{
	//TODO
}

// -

static void csr_rwi(core_Core *core, uint16_t csr, uint8_t rd, uint8_t imm)
{
	//TODO
}

// read+clear immediate(5-bit)
static void csr_rsi(core_Core *core, uint16_t csr, uint8_t rd, uint8_t imm)
{
	//TODO
}

// read+clear immediate(5-bit)
static void csr_rci(core_Core *core, uint16_t csr, uint8_t rd, uint8_t imm)
{
	//TODO
}

static void trace(uint32_t pc, char *form, ...)
{
	va_list va;
	va_start(va, form);
	if (traceMode) {
		printf("[%08X] ", pc);
		vprintf(form, va);
	}
	va_end(va);
}

static void notImplemented(char *form, ...)
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

