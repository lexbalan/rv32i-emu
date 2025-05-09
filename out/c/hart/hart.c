
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "hart.h"

#define ABS(x) ((x) < 0 ? -(x) : (x))


#define traceMode  false

#define opL  0x03
#define opI  0x13
#define opS  0x23
#define opR  0x33
#define opB  0x63

#define opLUI  0x37
#define opAUIPC  0x17
#define opJAL  0x6F
#define opJALR  0x67

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

void hart_init(hart_Hart *hart, hart_BusInterface *bus)
{
	*hart = (hart_Hart){
		.bus = bus
	};
}

static inline uint32_t fetch(hart_Hart *hart)
{
	return hart->bus->read32(hart->pc);
}


static void trace(uint32_t pc, char *form, ...);
static void exec(hart_Hart *hart, uint32_t instr);
void hart_tick(hart_Hart *hart)
{
	if (hart->irq != 0) {
		trace(hart->pc, "\nINT #%02X\n", hart->irq);
		const uint32_t vect_offset = hart->irq * 4;
		hart->pc = vect_offset;
		hart->irq = 0;
	}

	const uint32_t instr = fetch(hart);
	exec(hart, instr);

	hart->pc = hart->nexpc;
	hart->nexpc = hart->pc + 4;
	hart->cnt = hart->cnt + 1;
}


static void execI(hart_Hart *hart, uint32_t instr);
static void execR(hart_Hart *hart, uint32_t instr);
static void execLUI(hart_Hart *hart, uint32_t instr);
static void execAUIPC(hart_Hart *hart, uint32_t instr);
static void execJAL(hart_Hart *hart, uint32_t instr);
static void execJALR(hart_Hart *hart, uint32_t instr);
static void execB(hart_Hart *hart, uint32_t instr);
static void execL(hart_Hart *hart, uint32_t instr);
static void execS(hart_Hart *hart, uint32_t instr);
static void execSystem(hart_Hart *hart, uint32_t instr);
static void execFence(hart_Hart *hart, uint32_t instr);
static void exec(hart_Hart *hart, uint32_t instr)
{
	const uint8_t op = decode_extract_op(instr);
	const uint8_t funct3 = decode_extract_funct3(instr);

	if (op == opI) {
		execI(hart, instr);
	} else if (op == opR) {
		execR(hart, instr);
	} else if (op == opLUI) {
		execLUI(hart, instr);
	} else if (op == opAUIPC) {
		execAUIPC(hart, instr);
	} else if (op == opJAL) {
		execJAL(hart, instr);
	} else if (op == opJALR && funct3 == 0) {
		execJALR(hart, instr);
	} else if (op == opB) {
		execB(hart, instr);
	} else if (op == opL) {
		execL(hart, instr);
	} else if (op == opS) {
		execS(hart, instr);
	} else if (op == opSYSTEM) {
		execSystem(hart, instr);
	} else if (op == opFENCE) {
		execFence(hart, instr);
	} else {
		trace(hart->pc, "UNKNOWN OPCODE: %08X\n", op);
	}
}

static void execI(hart_Hart *hart, uint32_t instr)
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

		trace(hart->pc, "addi x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->reg[rd] = (uint32_t)((int32_t)hart->reg[rs1] + imm);
	} else if (funct3 == 1 && funct7 == 0) {
		/* SLLI is a logical left shift (zeros are shifted
		into the lower bits); SRLI is a logical right shift (zeros are shifted into the upper bits); and SRAI
		is an arithmetic right shift (the original sign bit is copied into the vacated upper bits). */

		trace(hart->pc, "slli x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->reg[rd] = hart->reg[rs1] << ABS(imm);
	} else if (funct3 == 2) {
		// SLTI - set [1 to rd if rs1] less than immediate

		trace(hart->pc, "slti x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->reg[rd] = (uint32_t)((int32_t)hart->reg[rs1] < imm);
	} else if (funct3 == 3) {
		trace(hart->pc, "sltiu x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->reg[rd] = (uint32_t)(hart->reg[rs1] < ABS(imm));
	} else if (funct3 == 4) {
		trace(hart->pc, "xori x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->reg[rd] = hart->reg[rs1] ^ (uint32_t)imm;
	} else if (funct3 == 5 && funct7 == 0) {
		trace(hart->pc, "srli x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->reg[rd] = (hart->reg[rs1] >> ABS(imm));
	} else if (funct3 == 5 && funct7 == 0x20) {
		trace(hart->pc, "srai x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->reg[rd] = hart->reg[rs1] >> ABS(imm);
	} else if (funct3 == 6) {
		trace(hart->pc, "ori x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->reg[rd] = hart->reg[rs1] | (uint32_t)imm;
	} else if (funct3 == 7) {
		trace(hart->pc, "andi x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->reg[rd] = hart->reg[rs1] & (uint32_t)imm;
	}
}


static void notImplemented(char *form, ...);
static void execR(hart_Hart *hart, uint32_t instr)
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

	const uint32_t v0 = hart->reg[rs1];
	const uint32_t v1 = hart->reg[rs2];


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
			trace(hart->pc, "mul x%d, x%d, x%d\n", rd, rs1, rs2);

			hart->reg[rd] = (uint32_t)((int32_t)v0 * (int32_t)v1);
		} else if (funct3 == 1) {
			// MULH rd, rs1, rs2
			// Записывает в целевой регистр старшие биты
			// которые бы не поместились в него при обычном умножении
			trace(hart->pc, "mulh x%d, x%d, x%d\n", rd, rs1, rs2);

			hart->reg[rd] = (uint32_t)((uint64_t)((int64_t)v0 * (int64_t)v1) >> 32);
		} else if (funct3 == 2) {
			// MULHSU rd, rs1, rs2
			// mul high signed unsigned
			trace(hart->pc, "mulhsu x%d, x%d, x%d\n", rd, rs1, rs2);

			// NOT IMPLEMENTED!
			notImplemented("mulhsu x%d, x%d, x%d", rd, rs1, rs2);
			//hart.reg[rd] = unsafe Word32 (Word64 (Int64 v0 * Int64 v1) >> 32)
		} else if (funct3 == 3) {
			// MULHU rd, rs1, rs2
			trace(hart->pc, "mulhu x%d, x%d, x%d\n", rd, rs1, rs2);

			// multiply unsigned high
			notImplemented("mulhu x%d, x%d, x%d\n", rd, rs1, rs2);
			//hart.reg[rd] = unsafe Word32 (Word64 (Nat64 v0 * Nat64 v1) >> 32)
		} else if (funct3 == 4) {
			// DIV rd, rs1, rs2
			trace(hart->pc, "div x%d, x%d, x%d\n", rd, rs1, rs2);

			hart->reg[rd] = (uint32_t)((int32_t)v0 / (int32_t)v1);
		} else if (funct3 == 5) {
			// DIVU rd, rs1, rs2
			trace(hart->pc, "divu x%d, x%d, x%d\n", rd, rs1, rs2);

			hart->reg[rd] = (v0 / v1);
		} else if (funct3 == 6) {
			// REM rd, rs1, rs2
			trace(hart->pc, "rem x%d, x%d, x%d\n", rd, rs1, rs2);

			hart->reg[rd] = (uint32_t)((int32_t)v0 % (int32_t)v1);
		} else if (funct3 == 7) {
			// REMU rd, rs1, rs2
			trace(hart->pc, "remu x%d, x%d, x%d\n", rd, rs1, rs2);

			hart->reg[rd] = (v0 % v1);
		}

		return;
	}


	if (funct3 == 0 && funct7 == 0x00) {
		trace(hart->pc, "add x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->reg[rd] = (uint32_t)((int32_t)v0 + (int32_t)v1);
	} else if (funct3 == 0 && funct7 == 0x20) {
		trace(hart->pc, "sub x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->reg[rd] = (uint32_t)((int32_t)v0 - (int32_t)v1);
	} else if (funct3 == 1) {
		// shift left logical

		trace(hart->pc, "sll x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->reg[rd] = v0 << (uint8_t)v1;
	} else if (funct3 == 2) {
		// set less than

		trace(hart->pc, "slt x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->reg[rd] = (uint32_t)((int32_t)v0 < (int32_t)v1);
	} else if (funct3 == 3) {
		// set less than unsigned

		trace(hart->pc, "sltu x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->reg[rd] = (uint32_t)(v0 < v1);
	} else if (funct3 == 4) {

		trace(hart->pc, "xor x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->reg[rd] = v0 ^ v1;
	} else if (funct3 == 5 && funct7 == 0) {
		// shift right logical

		trace(hart->pc, "srl x%d, x%d, x%d\n", rd, rs1, rs2);

		hart->reg[rd] = v0 >> (uint8_t)v1;
	} else if (funct3 == 5 && funct7 == 0x20) {
		// shift right arithmetical

		trace(hart->pc, "sra x%d, x%d, x%d\n", rd, rs1, rs2);

		// ERROR: не реализован арифм сдвиг!
		//hart.reg[rd] = v0 >> Int32 v1
	} else if (funct3 == 6) {
		trace(hart->pc, "or x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->reg[rd] = v0 | v1;
	} else if (funct3 == 7) {
		trace(hart->pc, "and x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->reg[rd] = v0 & v1;
	}
}

static void execLUI(hart_Hart *hart, uint32_t instr)
{
	// load upper immediate

	const int32_t imm = decode_expand12(decode_extract_imm31_12(instr));
	const uint8_t rd = decode_extract_rd(instr);

	trace(hart->pc, "lui x%d, 0x%X\n", rd, imm);

	if (rd != 0) {
		hart->reg[rd] = (uint32_t)imm << 12;
	}
}

static void execAUIPC(hart_Hart *hart, uint32_t instr)
{
	// Add upper immediate to PC

	const int32_t imm = decode_expand12(decode_extract_imm31_12(instr));
	const uint32_t x = hart->pc + ((uint32_t)imm << 12);
	const uint8_t rd = decode_extract_rd(instr);

	trace(hart->pc, "auipc x%d, 0x%X\n", rd, imm);

	if (rd != 0) {
		hart->reg[rd] = x;
	}
}

static void execJAL(hart_Hart *hart, uint32_t instr)
{
	// Jump and link

	const uint8_t rd = decode_extract_rd(instr);
	const uint32_t raw_imm = decode_extract_jal_imm(instr);
	const int32_t imm = decode_expand20(raw_imm);

	trace(hart->pc, "jal x%d, %d\n", rd, imm);

	if (rd != 0) {
		hart->reg[rd] = (hart->pc + 4);
	}

	hart->nexpc = ABS(((int32_t)hart->pc + imm));
}

static void execJALR(hart_Hart *hart, uint32_t instr)
{
	// Jump and link (by register)

	const uint8_t rs1 = decode_extract_rs1(instr);
	const uint8_t rd = decode_extract_rd(instr);
	const int32_t imm = decode_expand12(decode_extract_imm12(instr));

	trace(hart->pc, "jalr %d(x%d)\n", imm, rs1);

	// rd <- pc + 4
	// pc <- (rs1 + imm) & ~1
	const int32_t next_instr_ptr = (int32_t)(hart->pc + 4);
	const uint32_t jump_to = (uint32_t)((int32_t)hart->reg[rs1] + imm) & 0xFFFFFFFE;

	if (rd != 0) {
		hart->reg[rd] = (uint32_t)next_instr_ptr;
	}

	hart->nexpc = jump_to;
}

static void execB(hart_Hart *hart, uint32_t instr)
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

		trace(hart->pc, "beq x%d, x%d, %d\n", rs1, rs2, imm);

		// Branch if two registers are equal
		if (hart->reg[rs1] == hart->reg[rs2]) {
			hart->nexpc = ABS(((int32_t)hart->pc + (int32_t)imm));
		}
	} else if (funct3 == 1) {
		// BNE - Branch if not equal

		trace(hart->pc, "bne x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if (hart->reg[rs1] != hart->reg[rs2]) {
			hart->nexpc = ABS(((int32_t)hart->pc + (int32_t)imm));
		}
	} else if (funct3 == 4) {
		// BLT - Branch if less than (signed)

		trace(hart->pc, "blt x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if ((int32_t)hart->reg[rs1] < (int32_t)hart->reg[rs2]) {
			hart->nexpc = ABS(((int32_t)hart->pc + (int32_t)imm));
		}
	} else if (funct3 == 5) {
		// BGE - Branch if greater or equal (signed)

		trace(hart->pc, "bge x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if ((int32_t)hart->reg[rs1] >= (int32_t)hart->reg[rs2]) {
			hart->nexpc = ABS(((int32_t)hart->pc + (int32_t)imm));
		}
	} else if (funct3 == 6) {
		// BLTU - Branch if less than (unsigned)

		trace(hart->pc, "bltu x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if (hart->reg[rs1] < hart->reg[rs2]) {
			hart->nexpc = ABS(((int32_t)hart->pc + (int32_t)imm));
		}
	} else if (funct3 == 7) {
		// BGEU - Branch if greater or equal (unsigned)

		trace(hart->pc, "bgeu x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if (hart->reg[rs1] >= hart->reg[rs2]) {
			hart->nexpc = ABS(((int32_t)hart->pc + (int32_t)imm));
		}
	}
}

static void execL(hart_Hart *hart, uint32_t instr)
{
	const uint8_t funct3 = decode_extract_funct3(instr);
	const uint8_t funct7 = decode_extract_funct7(instr);
	const uint32_t imm12 = decode_extract_imm12(instr);
	const int32_t imm = decode_expand12(imm12);
	const uint8_t rd = decode_extract_rd(instr);
	const uint8_t rs1 = decode_extract_rs1(instr);
	const uint8_t rs2 = decode_extract_rs2(instr);

	const uint32_t adr = ABS(((int32_t)hart->reg[rs1] + imm));

	if (funct3 == 0) {
		// LB (Load 8-bit signed integer value)

		trace(hart->pc, "lb x%d, %d(x%d)\n", rd, imm, rs1);

		const int32_t val = (int32_t)hart->bus->read8(adr);
		if (rd != 0) {
			hart->reg[rd] = (uint32_t)val;
		}
	} else if (funct3 == 1) {
		// LH (Load 16-bit signed integer value)

		trace(hart->pc, "lh x%d, %d(x%d)\n", rd, imm, rs1);

		const int32_t val = (int32_t)hart->bus->read16(adr);
		if (rd != 0) {
			hart->reg[rd] = (uint32_t)val;
		}
	} else if (funct3 == 2) {
		// LW (Load 32-bit signed integer value)

		trace(hart->pc, "lw x%d, %d(x%d)\n", rd, imm, rs1);

		const uint32_t val = hart->bus->read32(adr);
		if (rd != 0) {
			hart->reg[rd] = val;
		}
	} else if (funct3 == 4) {
		// LBU (Load 8-bit unsigned integer value)

		trace(hart->pc, "lbu x%d, %d(x%d)\n", rd, imm, rs1);

		const uint32_t val = (uint32_t)hart->bus->read8(adr);
		if (rd != 0) {
			hart->reg[rd] = val;
		}
	} else if (funct3 == 5) {
		// LHU (Load 16-bit unsigned integer value)

		trace(hart->pc, "lhu x%d, %d(x%d)\n", rd, imm, rs1);

		const uint32_t val = (uint32_t)hart->bus->read16(adr);
		if (rd != 0) {
			hart->reg[rd] = val;
		}
	}
}

static void execS(hart_Hart *hart, uint32_t instr)
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

	const uint32_t adr = (uint32_t)((int32_t)hart->reg[rs1] + imm);
	const uint32_t val = hart->reg[rs2];

	if (funct3 == 0) {
		// SB (save 8-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(hart->pc, "sb x%d, %d(x%d)\n", rs2, imm, rs1);

		//
		hart->bus->write8(adr, (uint8_t)val);
	} else if (funct3 == 1) {
		// SH (save 16-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(hart->pc, "sh x%d, %d(x%d)\n", rs2, imm, rs1);

		//
		hart->bus->write16(adr, (uint16_t)val);
	} else if (funct3 == 2) {
		// SW (save 32-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(hart->pc, "sw x%d, %d(x%d)\n", rs2, imm, rs1);

		//
		hart->bus->write32(adr, val);
	}
}


static void csr_rw(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t rs1);
static void csr_rs(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t rs1);
static void csr_rc(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t rs1);
static void csr_rwi(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t imm);
static void csr_rsi(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t imm);
static void csr_rci(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t imm);
static void execSystem(hart_Hart *hart, uint32_t instr)
{
	const uint8_t funct3 = decode_extract_funct3(instr);
	const uint8_t funct7 = decode_extract_funct7(instr);
	const uint32_t imm12 = decode_extract_imm12(instr);
	const int32_t imm = decode_expand12(imm12);
	const uint8_t rd = decode_extract_rd(instr);
	const uint8_t rs1 = decode_extract_rs1(instr);

	const uint16_t csr = (uint16_t)imm12;

	if (instr == instrECALL) {
		trace(hart->pc, "ecall\n");

		//
		hart->irq = hart->irq | hart_intSysCall;
	} else if (instr == instrEBREAK) {
		trace(hart->pc, "ebreak\n");

		//
		printf("END.\n");
		hart->end = true;

		// CSR instructions
	} else if (funct3 == funct3_CSRRW) {
		// CSR read & write
		csr_rw(hart, csr, rd, rs1);
	} else if (funct3 == funct3_CSRRS) {
		// CSR read & set bit
		const uint8_t mask_reg = rs1;
		csr_rs(hart, csr, rd, mask_reg);
	} else if (funct3 == funct3_CSRRC) {
		// CSR read & clear bit
		const uint8_t mask_reg = rs1;
		csr_rc(hart, csr, rd, mask_reg);
	} else if (funct3 == funct3_CSRRWI) {
		const uint8_t imm = rs1;
		csr_rwi(hart, csr, rd, imm);
	} else if (funct3 == funct3_CSRRSI) {
		const uint8_t imm = rs1;
		csr_rsi(hart, csr, rd, imm);
	} else if (funct3 == funct3_CSRRCI) {
		const uint8_t imm = rs1;
		csr_rci(hart, csr, rd, imm);
	} else {
		trace(hart->pc, "UNKNOWN SYSTEM INSTRUCTION: 0x%x\n", instr);
		hart->end = true;
	}
}

static void execFence(hart_Hart *hart, uint32_t instr)
{
	if (instr == instrPAUSE) {
		trace(hart->pc, "PAUSE\n");
	}
}

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
static void csr_rw(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t rs1)
{
	const uint32_t nv = hart->reg[rs1];

	if (csr == 0x300) {
		// mstatus (Machine status register)
	} else if (csr == 0x301) {
		// misa (ISA and extensions)
	} else if (csr == 0x302) {
		// medeleg (Machine exception delegation register)
	} else if (csr == 0x303) {
		// mideleg (Machine interrupt delegation register)
	} else if (csr == 0x304) {
		// mie (Machine interrupt-enable register)
	} else if (csr == 0x305) {
		// mtvec (Machine trap-handler base address)
	} else if (csr == 0x306) {
		// mcounteren (Machine counter enable)
	} else if (csr == 0x340) {
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
static void csr_rs(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t rs1)
{
	//TODO
}
static void csr_rc(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t rs1)
{
	//TODO
}
static void csr_rwi(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t imm)
{
	//TODO
}
static void csr_rsi(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t imm)
{
	//TODO
}
static void csr_rci(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t imm)
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

void hart_show_regs(hart_Hart *hart)
{
	int32_t i = 0;
	while (i < 16) {
		printf("x%02d = 0x%08x", i, hart->reg[i]);
		printf("    ");
		printf("x%02d = 0x%08x\n", i + 16, hart->reg[i + 16]);
		i = i + 1;
	}
}

