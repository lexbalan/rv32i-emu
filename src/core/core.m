
include "libc/ctypes"
include "libc/stdio"

include "decode"


public const nRegs = 32

const debug = false


public type BusInterface record {
	read8: *(adr: Nat32) -> Word8
	read16: *(adr: Nat32) -> Word16
	read32: *(adr: Nat32) -> Word32

	write8: *(adr: Nat32, value: Word8) -> Unit
	write16: *(adr: Nat32, value: Word16) -> Unit
	write32: *(adr: Nat32, value: Word32) -> Unit
}


public type Core record {
	reg: [nRegs]Word32
	pc: Nat32
	
	nexpc: Nat32

	bus: *BusInterface

	end: Bool

	interrupt: Nat32
	cnt: Nat32
}


const opL = 0x03  // load
const opI = 0x13  // immediate
const opS = 0x23  // store
const opR = 0x33  // reg
const opB = 0x63  // branch

const opLUI = 0x37	  // load upper immediate
const opAUIPC = 0x17  // add upper immediate to PC
const opJAL = 0x6F	  // jump and link
const opJALR = 0x67   // jump and link by register

const opSYSTEM = 0x73
const opFENCE = 0x0F


const instrECALL = opSYSTEM or 0x00000000
const instrEBREAK = opSYSTEM or 0x00100000
const instrPAUSE = opFENCE or 0x01000000


// funct3 for CSR
const funct3_CSRRW = 1
const funct3_CSRRS = 2
const funct3_CSRRC = 3
const funct3_CSRRWI = 4
const funct3_CSRRSI = 5
const funct3_CSRRCI = 6


public const intSysCall = 0x08
public const intMemViolation = 0x0B



public func init(core: *Core, bus: *BusInterface) {
	// clear all fields & setup Core#bus
	*core = Core {bus=bus}
}


func fetch(core: *Core) -> Word32 {
	return core.bus.read32(core.pc)
}


public func tick(core: *Core) {
	if core.interrupt > 0 {
		if debug {
			printf("\nINT #%02X\n", core.interrupt)
		}
		let vect_offset = core.interrupt * 4
		core.pc = vect_offset
		core.interrupt = 0
	}

	let instr = fetch(core)
	let op = extract_op(instr)
	let funct3 = extract_funct3(instr)

	if op == opI {
		doOpI(core, instr)
	} else if op == opR {
		doOpR(core, instr)
	} else if op == opLUI {
		doOpLUI(core, instr)
	} else if op == opAUIPC {
		doOpAUIPC(core, instr)
	} else if op == opJAL {
		doOpJAL(core, instr)
	} else if op == opJALR and funct3 == 0 {
		doOpJALR(core, instr)
	} else if op == opB {
		doOpB(core, instr)
	} else if op == opL {
		doOpL(core, instr)
	} else if op == opS {
		doOpS(core, instr)
	} else if op == opSYSTEM {
		doOpSystem(core, instr)
	} else if op == opFENCE {
		doOpFence(core, instr)
	} else {
		if debug {
			printf("UNKNOWN OPCODE: %08X\n", op)
		}
	}

	core.pc = core.nexpc
	core.nexpc = core.pc + 4
	++core.cnt
}


func doOpI(core: *Core, instr: Word32) {
	let funct3 = extract_funct3(instr)
	let funct7 = extract_funct7(instr)
	let imm12 = extract_imm12(instr)
	let imm = expand12(imm12)
	let rd = extract_rd(instr)
	let rs1 = extract_rs1(instr)

	if rd == 0 {return}

	if funct3 == 0 {
		if debug {
			printf("addi x%d, x%d, %d\n", rd, rs1, imm)
		}
		core.reg[rd] = Word32 (Int32 core.reg[rs1] + imm)

	} else if funct3 == 1 and funct7 == 0 {
		/* SLLI is a logical left shift (zeros are shifted
		into the lower bits); SRLI is a logical right shift (zeros are shifted into the upper bits); and SRAI
		is an arithmetic right shift (the original sign bit is copied into the vacated upper bits). */
		if debug {
			printf("slli x%d, x%d, %d\n", rd, rs1, imm)
		}
		core.reg[rd] = core.reg[rs1] << imm
	} else if funct3 == 2 {
		// SLTI - set [1 to rd if rs1] less than immediate
		if debug {
			printf("slti x%d, x%d, %d\n", rd, rs1, imm)
		}
		core.reg[rd] = Word32 (Int32 core.reg[rs1] < imm)
	} else if funct3 == 3 {
		if debug {
			printf("sltiu x%d, x%d, %d\n", rd, rs1, imm)
		}
		core.reg[rd] = Word32 (Nat32 core.reg[rs1] < Nat32 imm)
	} else if funct3 == 4 {
		if debug {
			printf("xori x%d, x%d, %d\n", rd, rs1, imm)
		}
		core.reg[rd] = core.reg[rs1] xor Word32 imm
	} else if funct3 == 5 and funct7 == 0 {
		if debug {
			printf("srli x%d, x%d, %d\n", rd, rs1, imm)
		}
		core.reg[rd] = (core.reg[rs1] >> imm)
	} else if funct3 == 5 and funct7 == 0x20 {
		if debug {
			printf("srai x%d, x%d, %d\n", rd, rs1, imm)
		}
		core.reg[rd] = core.reg[rs1] >> imm
	} else if funct3 == 6 {
		if debug {
			printf("ori x%d, x%d, %d\n", rd, rs1, imm)
		}
		core.reg[rd] = core.reg[rs1] or Word32 imm
	} else if funct3 == 7 {
		if debug {
			printf("andi x%d, x%d, %d\n", rd, rs1, imm)
		}
		core.reg[rd] = core.reg[rs1] and Word32 imm
	}
}


func doOpR(core: *Core, instr: Word32) {
	let funct3 = extract_funct3(instr)
	let funct7 = extract_funct7(instr)
	let imm = expand12(extract_imm12(instr))
	let rd = extract_rd(instr)
	let rs1 = extract_rs1(instr)
	let rs2 = extract_rs2(instr)

	if rd == 0 {return}

	let v1 = core.reg[rs1]
	let v2 = core.reg[rs2]

	if funct3 == 0 and funct7 == 0x00 {
		if debug {
			printf("add x%d, x%d, x%d\n", rd, rs1, rs2)
		}
		core.reg[rd] = Word32 (Int32 v1 + Int32 v2)
	} else if funct3 == 0 and funct7 == 0x20 {
		if debug {
			printf("sub x%d, x%d, x%d\n", rd, rs1, rs2)
		}
		core.reg[rd] = Word32 (Int32 v1 - Int32 v2)
	} else if funct3 == 1 {
		// shift left logical
		if debug {
			printf("sll x%d, x%d, x%d\n", rd, rs1, rs2)
		}
		core.reg[rd] = v1 << Int32 v2
	} else if funct3 == 2 {
		// set less than
		if debug {
			printf("slt x%d, x%d, x%d\n", rd, rs1, rs2)
		}
		core.reg[rd] = Word32 (Int32 v1 < Int32 v2)
	} else if funct3 == 3 {
		// set less than unsigned
		if debug {
			printf("sltu x%d, x%d, x%d\n", rd, rs1, rs2)
		}
		core.reg[rd] = Word32 (Nat32 v1 < Nat32 v2)
	} else if funct3 == 4 {
		if debug {
			printf("xor x%d, x%d, x%d\n", rd, rs1, rs2)
		}
		core.reg[rd] = v1 xor v2
	} else if funct3 == 5 and funct7 == 0 {
		// shift right logical
		if debug {
			printf("srl x%d, x%d, x%d\n", rd, rs1, rs2)
		}
		core.reg[rd] = v1 >> Int32 v2
	} else if funct3 == 5 and funct7 == 0x20 {
		// shift right arithmetical
		if debug {
			printf("sra x%d, x%d, x%d\n", rd, rs1, rs2)
		}
		// ERROR: не реализовано арифм сдвиг
		//core.reg[rd] = v1 >> Int32 v2
	} else if funct3 == 6 {
		if debug {
			printf("or x%d, x%d, x%d\n", rd, rs1, rs2)
		}
		core.reg[rd] = v1 or v2
	} else if funct3 == 7 {
		if debug {
			printf("and x%d, x%d, x%d\n", rd, rs1, rs2)
		}
		core.reg[rd] = v1 and v2
	}
}


func doOpLUI(core: *Core, instr: Word32) {
	// U-type
	let imm = expand12(extract_imm31_12(instr))
	let rd = extract_rd(instr)
	if debug {
		printf("lui x%d, 0x%X\n", rd, imm)
	}
	if rd == 0 {return}
	// CHECKIT
	core.reg[rd] = Word32 imm << 12
}


func doOpAUIPC(core: *Core, instr: Word32) {
	// U-type
	let imm = expand12(extract_imm31_12(instr))
	let x = core.pc + Nat32 (Word32 imm << 12)
	let rd = extract_rd(instr)
	if debug {
		printf("auipc x%d, 0x%X\n", rd, imm)
	}
	if rd == 0 {return}
	core.reg[rd] = Word32 x
}


func doOpJAL(core: *Core, instr: Word32) {
	// U-type
	let rd = extract_rd(instr)
	let raw_imm = extract_jal_imm(instr)
	let imm = expand20(raw_imm)
	if debug {
		printf("jal x%d, %d\n", rd, imm)
	}

	if rd != 0 {
		core.reg[rd] = Word32 (core.pc + 4)
	}

	core.nexpc = Nat32 (Int32 core.pc + imm)
}


func doOpJALR(core: *Core, instr: Word32) {
	let rs1 = extract_rs1(instr)
	let rd = extract_rd(instr)
	let imm = expand12(extract_imm12(instr))
	if debug {
		printf("jalr %d(x%d)\n", imm, rs1)
	}
	// rd <- pc + 4
	// pc <- (rs1 + imm) & ~1

	let next_instr_ptr = Int32 (core.pc + 4)
	let jump_to = Word32 (Int32 core.reg[rs1] + imm) and 0xFFFFFFFE

	if rd != 0 {
		core.reg[rd] = Word32 next_instr_ptr
	}

	core.nexpc = Nat32 jump_to
}


func doOpB(core: *Core, instr: Word32) {
	let funct3 = extract_funct3(instr)
	let imm12_10to5 = extract_funct7(instr)
	let imm4to1_11 = Word16 extract_rd(instr)
	let rs1 = extract_rs1(instr)
	let rs2 = extract_rs2(instr)

	let bit4to1 = imm4to1_11 and 0x1E
	let bit10to5 = Word16 (imm12_10to5 and 0x3F) << 5
	let bit11 = (imm4to1_11 and 0x1) << 11
	let bit12 = Word16 (imm12_10to5 and 0x40) << 6

	var bits = (bit12 or bit11 or bit10to5 or bit4to1)

	// распространяем знак, если он есть
	if (bits and (Word16 1 << 12)) != 0 {
		bits = 0xF000 or bits
	}

	let imm = Int16 bits

	if funct3 == 0 {
		//beq
		if debug {
			printf("beq x%d, x%d, %d\n", rs1, rs2, imm)
		}
		if core.reg[rs1] == core.reg[rs2] {
			core.nexpc = Nat32 (Int32 core.pc + Int32 imm)
		}

	} else if funct3 == 1 {
		//bne
		if debug {
			printf("bne x%d, x%d, %d\n", rs1, rs2, imm)
		}
		if core.reg[rs1] != core.reg[rs2] {
			core.nexpc = Nat32 (Int32 core.pc + Int32 imm)
		}

	} else if funct3 == 4 {
		//blt
		if debug {
			printf("blt x%d, x%d, %d\n", rs1, rs2, imm)
		}
		if Int32 core.reg[rs1] < Int32 core.reg[rs2] {
			core.nexpc = Nat32 (Int32 core.pc + Int32 imm)
		}

	} else if funct3 == 5 {
		//bge
		if debug {
			printf("bge x%d, x%d, %d\n", rs1, rs2, imm)
		}
		if Int32 core.reg[rs1] >= Int32 core.reg[rs2] {
			core.nexpc = Nat32 (Int32 core.pc + Int32 imm)
		}

	} else if funct3 == 6 {
		//bltu
		if debug {
			printf("bltu x%d, x%d, %d\n", rs1, rs2, imm)
		}
		if Nat32 core.reg[rs1] < Nat32 core.reg[rs2] {
			core.nexpc = Nat32 (Int32 core.pc + Int32 imm)
		}

	} else if funct3 == 7 {
		//bgeu
		if debug {
			printf("bgeu x%d, x%d, %d\n", rs1, rs2, imm)
		}

		if Nat32 core.reg[rs1] >= Nat32 core.reg[rs2] {
			core.nexpc = Nat32 (Int32 core.pc + Int32 imm)
		}
	}
}


func doOpL(core: *Core, instr: Word32) {
	let funct3 = extract_funct3(instr)
	let funct7 = extract_funct7(instr)
	let imm12 = extract_imm12(instr)
	let imm = expand12(imm12)
	let rd = extract_rd(instr)
	let rs1 = extract_rs1(instr)
	let rs2 = extract_rs2(instr)

	let adr = Nat32 (Int32 core.reg[rs1] + imm)

	if funct3 == 0 {
		// lb
		if debug {
			printf("lb x%d, %d(x%d)\n", rd, imm, rs1)
		}
		let val = core.bus.read8(adr)
		if rd != 0 {
			core.reg[rd] = Word32 val
		}
	} else if funct3 == 1 {
		// lh
		if debug {
			printf("lh x%d, %d(x%d)\n", rd, imm, rs1)
		}
		let val = core.bus.read16(adr)
		if rd != 0 {
			core.reg[rd] = Word32 val
		}
	} else if funct3 == 2 {
		// lw
		if debug {
			printf("lw x%d, %d(x%d)\n", rd, imm, rs1)
		}
		let val = core.bus.read32(adr)
		if debug {
			printf("LW [0x%x] (0x%x)\n", adr, val)
		}
		if rd != 0 {
			core.reg[rd] = val
		}
	} else if funct3 == 4 {
		// lbu
		if debug {
			printf("lbu x%d, %d(x%d)\n", rd, imm, rs1)
		}
		let val = Nat32 core.bus.read8(adr)
		if debug {
			printf("LBU[0x%x] (0x%x)\n", adr, val)
		}
		if rd != 0 {
			core.reg[rd] = Word32 val
		}
	} else if funct3 == 5 {
		// lhu
		if debug {
			printf("lhu x%d, %d(x%d)\n", rd, imm, rs1)
		}
		let val = Nat32 core.bus.read16(adr)
		if rd != 0 {
			core.reg[rd] = Word32 val
		}
	}
}


func doOpS(core: *Core, instr: Word32) {
	let funct3 = extract_funct3(instr)
	let funct7 = extract_funct7(instr)
	let rd = extract_rd(instr)
	let rs1 = extract_rs1(instr)
	let rs2 = extract_rs2(instr)

	let imm4to0 = Nat32 rd
	let imm11to5 = Nat32 funct7
	let _imm = (unsafe Word32 imm11to5 << 5) or unsafe Word32 imm4to0
	let imm = expand12(_imm)

	let adr = Nat32 (Int32 core.reg[rs1] + imm)
	let val = core.reg[rs2]

	if funct3 == 0 {
		// sb <source:reg>, <offset:12bit_imm>(<address:reg>)
		if debug {
			printf("sb x%d, %d(x%d)\n", rs2, imm, rs1)
		}
		core.bus.write8(adr, unsafe Word8 val)
	} else if funct3 == 1 {
		// sh <source:reg>, <offset:12bit_imm>(<address:reg>)
		if debug {
			printf("sh x%d, %d(x%d)\n", rs2, imm, rs1)
		}
		core.bus.write16(adr, unsafe Word16 val)
	} else if funct3 == 2 {
		// sw <source:reg>, <offset:12bit_imm>(<address:reg>)
		if debug {
			printf("sw x%d, %d(x%d)\n", rs2, imm, rs1)
		}
		core.bus.write32(adr, val)
	}
}


func doOpSystem(core: *Core, instr: Word32) {
	let funct3 = extract_funct3(instr)
	let funct7 = extract_funct7(instr)
	let imm12 = extract_imm12(instr)
	let imm = expand12(imm12)
	let rd = extract_rd(instr)
	let rs1 = extract_rs1(instr)

	let csr = unsafe Nat16 imm12

	if instr == instrECALL {
		if debug {
			printf("ECALL\n")
		}
		irq(core, intSysCall)

	} else if instr == instrEBREAK {
		if debug {
			printf("EBREAK\n")
		}
		core.end = true

	// CSR instructions
	} else if funct3 == funct3_CSRRW {
		// CSR read & write
		csr_rw(core, csr, rd, rs1)
	} else if funct3 == funct3_CSRRS {
		// CSR read & set bit
		let msk_reg = rs1
		csr_rs(core, csr, rd, msk_reg)
	} else if funct3 == funct3_CSRRC {
		// CSR read & clear bit
		let msk_reg = rs1
		csr_rc(core, csr, rd, msk_reg)
	} else if funct3 == funct3_CSRRWI {
		let imm = rs1
		csr_rwi(core, csr, rd, imm)
	} else if funct3 == funct3_CSRRSI {
		let imm = rs1
		csr_rsi(core, csr, rd, imm)
	} else if funct3 == funct3_CSRRCI {
		let imm = rs1
		csr_rci(core, csr, rd, imm)
	} else {
		if debug {
			printf("UNKNOWN SYSTEM INSTRUCTION: 0x%x\n", instr)
		}
		if debug {
			printf("funct3 = %x\n", funct3)
		}
		core.end = true
	}
}


func doOpFence(core: *Core, instr: Word32) {
	if instr == instrPAUSE {
		if debug {
			printf("PAUSE\n")
		}
	}
}


public func irq(core: *Core, irq: Nat32) {
	if core.interrupt == 0 {
		core.interrupt = irq
	}
}





//
// CSR's
//https://five-embeddev.com/riscv-isa-manual/latest/priv-csrs.html
//


/*
The CSRRW (Atomic Read/Write CSR) instruction atomically swaps values in the CSRs and integer registers. CSRRW reads the old value of the CSR, zero-extends the value to XLEN bits, then writes it to integer register rd. The initial value in rs1 is written to the CSR. If rd=x0, then the instruction shall not read the CSR and shall not cause any of the side effects that might occur on a CSR read.
*/
func csr_rw(core: *Core, csr: Nat16, rd: Nat8, rs1: Nat8) {
	let nv = core.reg[rs1]
	if csr == 0x340 {
		// mscratch
	} else if csr == 0x341 {
		// mepc
	} else if csr == 0x342 {
		// mcause
	} else if csr == 0x343 {
		// mbadaddr
	} else if csr == 0x344 {
		// mip (machine interrupt pending)
	}
}


/*
The CSRRS (Atomic Read and Set Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be set in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be set in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
*/
func csr_rs(core: *Core, csr: Nat16, rd: Nat8, rs1: Nat8) {
	//TODO
}

/*
The CSRRC (Atomic Read and Clear Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be cleared in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be cleared in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
*/
func csr_rc(core: *Core, csr: Nat16, rd: Nat8, rs1: Nat8) {
	//TODO
}


// -


func csr_rwi(core: *Core, csr: Nat16, rd: Nat8, imm: Nat8) {
	//TODO
}


// read+clear immediate(5-bit)
func csr_rsi(core: *Core, csr: Nat16, rd: Nat8, imm: Nat8) {
	//TODO
}


// read+clear immediate(5-bit)
func csr_rci(core: *Core, csr: Nat16, rd: Nat8, imm: Nat8) {
	//TODO
}


