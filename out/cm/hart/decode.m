//
//


public func extract_op (instr: Word32) -> Word8 {
	return unsafe Word8 (instr and 0x7F)
}


public func extract_funct2 (instr: Word32) -> Word8 {
	return unsafe Word8 ((instr >> 25) and 0x03)
}


public func extract_funct3 (instr: Word32) -> Word8 {
	return unsafe Word8 ((instr >> 12) and 0x07)
}


public func extract_funct5 (instr: Word32) -> Word8 {
	return unsafe Word8 ((instr >> 27) and 0x01F)
}


public func extract_rd (instr: Word32) -> Nat8 {
	return unsafe Nat8 ((instr >> 7) and 0x1F)
}


public func extract_rs1 (instr: Word32) -> Nat8 {
	return unsafe Nat8 ((instr >> 15) and 0x1F)
}


public func extract_rs2 (instr: Word32) -> Nat8 {
	return unsafe Nat8 ((instr >> 20) and 0x1F)
}


public func extract_funct7 (instr: Word32) -> Word8 {
	return unsafe Word8 ((instr >> 25) and 0x7F)
}


// bits: (31 .. 20)
public func extract_imm12 (instr: Word32) -> Word32 {
	return (instr >> 20) and 0xFFF
}


public func extract_imm31_12 (instr: Word32) -> Word32 {
	return (instr >> 12) and 0xFFFFF
}


public func extract_b_imm (instr: Word32) -> Int16 {
	let imm4to1_11 = Word16 extract_rd(instr)
	let imm12_10to5: Word8 = extract_funct7(instr)
	let bit4to1: Word16 = imm4to1_11 and 0x1E
	let bit10to5: Word16 = Word16 (imm12_10to5 and 0x3F) << 5
	let bit11: Word16 = (imm4to1_11 and 0x1) << 11
	let bit12: Word16 = Word16 (imm12_10to5 and 0x40) << 6

	var imm_bits: Word16 = (bit12 or bit11 or bit10to5 or bit4to1)

	// распространяем знак (если он есть)
	if (imm_bits and (Word16 1 << 12)) != 0 {
		imm_bits = 0xF000 or imm_bits
	}

	return Int16 imm_bits
}

public func extract_jal_imm (instr: Word32) -> Word32 {
	let imm: Word32 = extract_imm31_12(instr)
	let bit19to12_msk: Word32 = ((imm >> 0) and 0xFF) << 12
	let bit11_msk: Word32 = ((imm >> 8) and 0x1) << 11
	let bit10to1: Word32 = ((imm >> 9) and 0x3FF) << 1
	let bit20_msk: Word32 = ((imm >> 20) and 0x1) << 20
	return bit20_msk or bit19to12_msk or bit11_msk or bit10to1
}


// sign expand (12bit -> 32bit)
public func expand12 (val_12bit: Word32) -> Int32 {
	var v: Word32 = val_12bit
	if (v and 0x800) != 0 {
		v = v or 0xFFFFF000
	}
	return Int32 v
}


// sign expand (20bit -> 32bit)
public func expand20 (val_20bit: Word32) -> Int32 {
	var v: Word32 = val_20bit
	if (v and 0x80000) != 0 {
		v = v or 0xFFF00000
	}
	return Int32 v
}

