
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "decode.h"


uint8_t decode_extract_op(uint32_t instr)
{
	return (uint8_t)(instr & 0x7F);
}

uint8_t decode_extract_funct2(uint32_t instr)
{
	return (uint8_t)((instr >> 25) & 0x03);
}

uint8_t decode_extract_funct3(uint32_t instr)
{
	return (uint8_t)((instr >> 12) & 0x07);
}

uint8_t decode_extract_funct5(uint32_t instr)
{
	return (uint8_t)((instr >> 27) & 0x01F);
}

uint8_t decode_extract_rd(uint32_t instr)
{
	return (uint8_t)((instr >> 7) & 0x1F);
}

uint8_t decode_extract_rs1(uint32_t instr)
{
	return (uint8_t)((instr >> 15) & 0x1F);
}

uint8_t decode_extract_rs2(uint32_t instr)
{
	return (uint8_t)((instr >> 20) & 0x1F);
}

uint8_t decode_extract_funct7(uint32_t instr)
{
	return (uint8_t)((instr >> 25) & 0x7F);
}
uint32_t decode_extract_imm12(uint32_t instr)
{
	return (instr >> 20) & 0xFFF;
}

uint32_t decode_extract_imm31_12(uint32_t instr)
{
	return (instr >> 12) & 0xFFFFF;
}

uint32_t decode_extract_jal_imm(uint32_t instr)
{
	const uint32_t imm = decode_extract_imm31_12(instr);
	const uint32_t bit19to12_msk = ((imm >> 0) & 0xFF) << 12;
	const uint32_t bit11_msk = ((imm >> 8) & 0x1) << 11;
	const uint32_t bit10to1 = ((imm >> 9) & 0x3FF) << 1;
	const uint32_t bit20_msk = ((imm >> 20) & 0x1) << 20;
	return bit20_msk | bit19to12_msk | bit11_msk | bit10to1;
}
int32_t decode_expand12(uint32_t val_12bit)
{
	uint32_t v = val_12bit;
	if ((v & 0x800) != 0) {
		v = v | 0xFFFFF000;
	}
	return (int32_t)v;
}
int32_t decode_expand20(uint32_t val_20bit)
{
	uint32_t v = val_20bit;
	if ((v & 0x80000) != 0) {
		v = v | 0xFFF00000;
	}
	return (int32_t)v;
}

