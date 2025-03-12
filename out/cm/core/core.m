
@c_include "stdio.h"
@c_include "unistd.h"
@c_include "stdlib.h"


const traceMode = false


public type Core record {
	reg: [32]Word32
	pc: Nat32
	nexpc: Nat32

	bus: *BusInterface

	interrupt: Word32

	public cnt: Nat32
	public end: Bool
}


public type BusInterface record {
	public read8: *(adr: Nat32) -> Word8
	public read16: *(adr: Nat32) -> Word16
	public read32: *(adr: Nat32) -> Word32

	public write8: *(adr: Nat32, value: Word8) -> Unit
	public write16: *(adr: Nat32, value: Word16) -> Unit
	public write32: *(adr: Nat32, value: Word32) -> Unit
}


const opL = 0x03// load
const opI = 0x13// immediate
const opS = 0x23// store
const opR = 0x33// reg
const opB = 0x63// branch

const opLUI = 0x37// load upper immediate
const opAUIPC = 0x17// add upper immediate to PC
const opJAL = 0x6F// jump and link
const opJALR = 0x67// jump and link by register

const opSYSTEM = 0x73//
const opFENCE = 0x0F//


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



public func init(core: *Core, bus: *BusInterface) -> Unit {
	*core = Core {
		bus = bus
	}
}


func fetch(core: *Core) -> Word32 {
	return core.bus.read32(core.pc)
}


public func tick(core: *Core) -> Unit {
	if core.interrupt != 0 {
		trace(core.pc, "\nINT #%02X\n", core.interrupt)
		let vect_offset = Nat32 core.interrupt * 4
		core.pc = vect_offset
		core.interrupt = 0
	}

	let instr = fetch(core)
	let op = decode.extract_op(instr)
	let funct3 = decode.extract_funct3(instr)

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
		trace(core.pc, "UNKNOWN OPCODE: %08X\n", op)
	}

	core.pc = core.nexpc
	core.nexpc = core.pc + 4
	core.cnt = core.cnt + 1
}


func doOpI(core: *Core, instr: Word32) -> Unit {
	let funct3 = decode.extract_funct3(instr)
	let funct7 = decode.extract_funct7(instr)
	let imm12 = decode.extract_imm12(instr)
	let imm = decode.expand12(imm12)
	let rd = decode.extract_rd(instr)
	let rs1 = decode.extract_rs1(instr)

	if rd == 0 {
		return
	}

	if funct3 == 0 {
		// Add immediate

		trace(core.pc, "addi x%d, x%d, %d\n", rd, rs1, imm)

		//
		core.reg[rd] = Word32 (Int32 core.reg[rs1] + imm)

	} else if funct3 == 1 and funct7 == 0 {
		/* SLLI is a logical left shift (zeros are shifted
		into the lower bits); SRLI is a logical right shift (zeros are shifted into the upper bits); and SRAI
		is an arithmetic right shift (the original sign bit is copied into the vacated upper bits). */

		trace(core.pc, "slli x%d, x%d, %d\n", rd, rs1, imm)

		//
		core.reg[rd] = core.reg[rs1] << Nat8 imm

	} else if funct3 == 2 {
		// SLTI - set [1 to rd if rs1] less than immediate

		trace(core.pc, "slti x%d, x%d, %d\n", rd, rs1, imm)

		//
		core.reg[rd] = Word32 (Int32 core.reg[rs1] < imm)

	} else if funct3 == 3 {
		trace(core.pc, "sltiu x%d, x%d, %d\n", rd, rs1, imm)

		//
		core.reg[rd] = Word32 (Nat32 core.reg[rs1] < Nat32 imm)

	} else if funct3 == 4 {
		trace(core.pc, "xori x%d, x%d, %d\n", rd, rs1, imm)

		//
		core.reg[rd] = core.reg[rs1] xor Word32 imm

	} else if funct3 == 5 and funct7 == 0 {
		trace(core.pc, "srli x%d, x%d, %d\n", rd, rs1, imm)

		//
		core.reg[rd] = (core.reg[rs1] >> Nat8 imm)

	} else if funct3 == 5 and funct7 == 0x20 {
		trace(core.pc, "srai x%d, x%d, %d\n", rd, rs1, imm)

		//
		core.reg[rd] = core.reg[rs1] >> Nat8 imm

	} else if funct3 == 6 {
		trace(core.pc, "ori x%d, x%d, %d\n", rd, rs1, imm)

		//
		core.reg[rd] = core.reg[rs1] or Word32 imm

	} else if funct3 == 7 {
		trace(core.pc, "andi x%d, x%d, %d\n", rd, rs1, imm)

		//
		core.reg[rd] = core.reg[rs1] and Word32 imm
	}
}


func doOpR(core: *Core, instr: Word32) -> Unit {
	let funct3 = decode.extract_funct3(instr)
	let funct7 = decode.extract_funct7(instr)
	let imm = decode.expand12(decode.extract_imm12(instr))
	let rd = decode.extract_rd(instr)
	let rs1 = decode.extract_rs1(instr)
	let rs2 = decode.extract_rs2(instr)

	if rd == 0 {
		return
	}

	let v0 = core.reg[rs1]
	let v1 = core.reg[rs2]


	let f7 = decode.extract_funct7(instr)
	//let f5 = extract_funct5(instr)
	//let f2 = extract_funct2(instr)
	//if f5 == 0 and f2 == 1 {
	if f7 == 1 {
		//printf("MUL(%i)\n", Int32 funct3)

		//
		// "M" extension
		//

		if funct3 == 0 {
			// MUL rd, rs1, rs2
			trace(core.pc, "mul x%d, x%d, x%d\n", rd, rs1, rs2)

			core.reg[rd] = Word32 (Int32 v0 * Int32 v1)

		} else if funct3 == 1 {
			// MULH rd, rs1, rs2
			// Записывает в целевой регистр старшие биты
			// которые бы не поместились в него при обычном умножении
			trace(core.pc, "mulh x%d, x%d, x%d\n", rd, rs1, rs2)

			core.reg[rd] = Word32 (Word64 (Int64 v0 * Int64 v1) >> 32)

		} else if funct3 == 2 {
			// MULHSU rd, rs1, rs2
			// mul high signed unsigned
			trace(core.pc, "mulhsu x%d, x%d, x%d\n", rd, rs1, rs2)

			// NOT IMPLEMENTED!
			notImplemented("mulhsu x%d, x%d, x%d", rd, rs1, rs2)

		} else if funct3 == 3 {
			// MULHU rd, rs1, rs2
			trace(core.pc, "mulhu x%d, x%d, x%d\n", rd, rs1, rs2)

			// NOT IMPLEMENTED!
			notImplemented("mulhsu x%d, x%d, x%d\n", rd, rs1, rs2)

		} else if funct3 == 4 {
			// DIV rd, rs1, rs2
			trace(core.pc, "div x%d, x%d, x%d\n", rd, rs1, rs2)

			core.reg[rd] = Word32 (Int32 v0 / Int32 v1)

		} else if funct3 == 5 {
			// DIVU rd, rs1, rs2
			trace(core.pc, "divu x%d, x%d, x%d\n", rd, rs1, rs2)

			core.reg[rd] = Word32 (Nat32 v0 / Nat32 v1)

		} else if funct3 == 6 {
			// REM rd, rs1, rs2
			trace(core.pc, "rem x%d, x%d, x%d\n", rd, rs1, rs2)

			core.reg[rd] = Word32 (Int32 v0 % Int32 v1)

		} else if funct3 == 7 {
			// REMU rd, rs1, rs2
			trace(core.pc, "remu x%d, x%d, x%d\n", rd, rs1, rs2)

			core.reg[rd] = Word32 (Nat32 v0 % Nat32 v1)
		}

		return
	}


	if funct3 == 0 and funct7 == 0x00 {
		trace(core.pc, "add x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		core.reg[rd] = Word32 (Int32 v0 + Int32 v1)

	} else if funct3 == 0 and funct7 == 0x20 {
		trace(core.pc, "sub x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		core.reg[rd] = Word32 (Int32 v0 - Int32 v1)

	} else if funct3 == 1 {
		// shift left logical

		trace(core.pc, "sll x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		core.reg[rd] = v0 << Nat8 v1

	} else if funct3 == 2 {
		// set less than

		trace(core.pc, "slt x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		core.reg[rd] = Word32 (Int32 v0 < Int32 v1)

	} else if funct3 == 3 {
		// set less than unsigned

		trace(core.pc, "sltu x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		core.reg[rd] = Word32 (Nat32 v0 < Nat32 v1)

	} else if funct3 == 4 {

		trace(core.pc, "xor x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		core.reg[rd] = v0 xor v1

	} else if funct3 == 5 and funct7 == 0 {
		// shift right logical

		trace(core.pc, "srl x%d, x%d, x%d\n", rd, rs1, rs2)

		core.reg[rd] = v0 >> Nat8 v1

	} else if funct3 == 5 and funct7 == 0x20 {
		// shift right arithmetical

		trace(core.pc, "sra x%d, x%d, x%d\n", rd, rs1, rs2)

		// ERROR: не реализован арифм сдвиг!
		//core.reg[rd] = v0 >> Int32 v1

	} else if funct3 == 6 {
		trace(core.pc, "or x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		core.reg[rd] = v0 or v1

	} else if funct3 == 7 {
		trace(core.pc, "and x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		core.reg[rd] = v0 and v1
	}
}


func doOpLUI(core: *Core, instr: Word32) -> Unit {
	// load upper immediate

	let imm = decode.expand12(decode.extract_imm31_12(instr))
	let rd = decode.extract_rd(instr)

	trace(core.pc, "lui x%d, 0x%X\n", rd, imm)

	if rd != 0 {
		core.reg[rd] = Word32 imm << 12
	}
}


func doOpAUIPC(core: *Core, instr: Word32) -> Unit {
	// Add upper immediate to PC

	let imm = decode.expand12(decode.extract_imm31_12(instr))
	let x = core.pc + Nat32 (Word32 imm << 12)
	let rd = decode.extract_rd(instr)

	trace(core.pc, "auipc x%d, 0x%X\n", rd, imm)

	if rd != 0 {
		core.reg[rd] = Word32 x
	}
}


func doOpJAL(core: *Core, instr: Word32) -> Unit {
	// Jump and link

	let rd = decode.extract_rd(instr)
	let raw_imm = decode.extract_jal_imm(instr)
	let imm = decode.expand20(raw_imm)

	trace(core.pc, "jal x%d, %d\n", rd, imm)

	if rd != 0 {
		core.reg[rd] = Word32 (core.pc + 4)
	}

	core.nexpc = Nat32 (Int32 core.pc + imm)
}


func doOpJALR(core: *Core, instr: Word32) -> Unit {
	// Jump and link (by register)

	let rs1 = decode.extract_rs1(instr)
	let rd = decode.extract_rd(instr)
	let imm = decode.expand12(decode.extract_imm12(instr))

	trace(core.pc, "jalr %d(x%d)\n", imm, rs1)

	// rd <- pc + 4
	// pc <- (rs1 + imm) & ~1
	let next_instr_ptr = Int32 (core.pc + 4)
	let jump_to = Word32 (Int32 core.reg[rs1] + imm) and 0xFFFFFFFE

	if rd != 0 {
		core.reg[rd] = Word32 next_instr_ptr
	}

	core.nexpc = Nat32 jump_to
}


func doOpB(core: *Core, instr: Word32) -> Unit {
	let funct3 = decode.extract_funct3(instr)
	let imm12_10to5 = decode.extract_funct7(instr)
	let imm4to1_11 = Word16 decode.extract_rd(instr)
	let rs1 = decode.extract_rs1(instr)
	let rs2 = decode.extract_rs2(instr)

	let bit4to1 = imm4to1_11 and 0x1E
	let bit10to5 = Word16 (imm12_10to5 and 0x3F) << 5
	let bit11 = (imm4to1_11 and 0x1) << 11
	let bit12 = Word16 (imm12_10to5 and 0x40) << 6

	var bits: Word16 = (bit12 or bit11 or bit10to5 or bit4to1)

	// распространяем знак, если он есть
	if (bits and (Word16 1 << 12)) != 0 {
		bits = 0xF000 or bits
	}

	let imm = Int16 bits

	if funct3 == 0 {
		// BEQ - Branch if equal

		trace(core.pc, "beq x%d, x%d, %d\n", rs1, rs2, imm)

		// Branch if two registers are equal
		if core.reg[rs1] == core.reg[rs2] {
			core.nexpc = Nat32 (Int32 core.pc + Int32 imm)
		}

	} else if funct3 == 1 {
		// BNE - Branch if not equal

		trace(core.pc, "bne x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if core.reg[rs1] != core.reg[rs2] {
			core.nexpc = Nat32 (Int32 core.pc + Int32 imm)
		}

	} else if funct3 == 4 {
		// BLT - Branch if less than (signed)

		trace(core.pc, "blt x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if Int32 core.reg[rs1] < Int32 core.reg[rs2] {
			core.nexpc = Nat32 (Int32 core.pc + Int32 imm)
		}

	} else if funct3 == 5 {
		// BGE - Branch if greater or equal (signed)

		trace(core.pc, "bge x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if Int32 core.reg[rs1] >= Int32 core.reg[rs2] {
			core.nexpc = Nat32 (Int32 core.pc + Int32 imm)
		}

	} else if funct3 == 6 {
		// BLTU - Branch if less than (unsigned)

		trace(core.pc, "bltu x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if Nat32 core.reg[rs1] < Nat32 core.reg[rs2] {
			core.nexpc = Nat32 (Int32 core.pc + Int32 imm)
		}

	} else if funct3 == 7 {
		// BGEU - Branch if greater or equal (unsigned)

		trace(core.pc, "bgeu x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if Nat32 core.reg[rs1] >= Nat32 core.reg[rs2] {
			core.nexpc = Nat32 (Int32 core.pc + Int32 imm)
		}
	}
}


func doOpL(core: *Core, instr: Word32) -> Unit {
	let funct3 = decode.extract_funct3(instr)
	let funct7 = decode.extract_funct7(instr)
	let imm12 = decode.extract_imm12(instr)
	let imm = decode.expand12(imm12)
	let rd = decode.extract_rd(instr)
	let rs1 = decode.extract_rs1(instr)
	let rs2 = decode.extract_rs2(instr)

	let adr = Nat32 (Int32 core.reg[rs1] + imm)

	if funct3 == 0 {
		// LB (Load 8-bit signed integer value)

		trace(core.pc, "lb x%d, %d(x%d)\n", rd, imm, rs1)

		let val = Int32 core.bus.read8(adr)
		if rd != 0 {
			core.reg[rd] = Word32 val
		}

	} else if funct3 == 1 {
		// LH (Load 16-bit signed integer value)

		trace(core.pc, "lh x%d, %d(x%d)\n", rd, imm, rs1)

		let val = Int32 core.bus.read16(adr)
		if rd != 0 {
			core.reg[rd] = Word32 val
		}

	} else if funct3 == 2 {
		// LW (Load 32-bit signed integer value)

		trace(core.pc, "lw x%d, %d(x%d)\n", rd, imm, rs1)

		let val = core.bus.read32(adr)
		if rd != 0 {
			core.reg[rd] = val
		}

	} else if funct3 == 4 {
		// LBU (Load 8-bit unsigned integer value)

		trace(core.pc, "lbu x%d, %d(x%d)\n", rd, imm, rs1)

		let val = Nat32 core.bus.read8(adr)
		if rd != 0 {
			core.reg[rd] = Word32 val
		}

	} else if funct3 == 5 {
		// LHU (Load 16-bit unsigned integer value)

		trace(core.pc, "lhu x%d, %d(x%d)\n", rd, imm, rs1)

		let val = Nat32 core.bus.read16(adr)
		if rd != 0 {
			core.reg[rd] = Word32 val
		}
	}
}


func doOpS(core: *Core, instr: Word32) -> Unit {
	let funct3 = decode.extract_funct3(instr)
	let funct7 = decode.extract_funct7(instr)
	let rd = decode.extract_rd(instr)
	let rs1 = decode.extract_rs1(instr)
	let rs2 = decode.extract_rs2(instr)

	let imm4to0 = Nat32 rd
	let imm11to5 = Nat32 funct7
	let _imm = (Word32 imm11to5 << 5) or Word32 imm4to0
	let imm = decode.expand12(_imm)

	let adr = Nat32 Word32 (Int32 core.reg[rs1] + imm)
	let val = core.reg[rs2]

	if funct3 == 0 {
		// SB (save 8-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(core.pc, "sb x%d, %d(x%d)\n", rs2, imm, rs1)

		//
		core.bus.write8(adr, Word8 val)

	} else if funct3 == 1 {
		// SH (save 16-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(core.pc, "sh x%d, %d(x%d)\n", rs2, imm, rs1)

		//
		core.bus.write16(adr, Word16 val)

	} else if funct3 == 2 {
		// SW (save 32-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(core.pc, "sw x%d, %d(x%d)\n", rs2, imm, rs1)

		//
		core.bus.write32(adr, val)
	}
}


func doOpSystem(core: *Core, instr: Word32) -> Unit {
	let funct3 = decode.extract_funct3(instr)
	let funct7 = decode.extract_funct7(instr)
	let imm12 = decode.extract_imm12(instr)
	let imm = decode.expand12(imm12)
	let rd = decode.extract_rd(instr)
	let rs1 = decode.extract_rs1(instr)

	let csr = Nat16 imm12

	if instr == instrECALL {
		trace(core.pc, "ECALL\n")

		//
		irq(core, intSysCall)

	} else if instr == instrEBREAK {
		trace(core.pc, "EBREAK\n")

		//
		stdio.printf("END.\n")
		core.end = true

		// CSR instructions
	} else if funct3 == funct3_CSRRW {
		// CSR read & write
		csr_rw(core, csr, rd, rs1)
	} else if funct3 == funct3_CSRRS {
		// CSR read & set bit
		let mask_reg = rs1
		csr_rs(core, csr, rd, mask_reg)
	} else if funct3 == funct3_CSRRC {
		// CSR read & clear bit
		let mask_reg = rs1
		csr_rc(core, csr, rd, mask_reg)
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
		trace(core.pc, "UNKNOWN SYSTEM INSTRUCTION: 0x%x\n", instr)
		core.end = true
	}
}


func doOpFence(core: *Core, instr: Word32) -> Unit {
	if instr == instrPAUSE {
		trace(core.pc, "PAUSE\n")
	}
}


public func irq(core: *Core, irq: Word32) -> Unit {
	if core.interrupt == 0 {
		core.interrupt = irq
	}
}





//
// CSR's
//https://five-embeddev.com/riscv-isa-manual/latest/priv-csrs.html
//



const mstatus_adr = 0x300
const misa_adr = 0x301
const mie_adr = 0x304
const mtvec_adr = 0x305
const mcause_adr = 0x342
const mtval_adr = 0x343
const mip_adr = 0x344


const satp_adr = 0x180

const sstatus_adr = 0x100
const sie_adr = 0x104
const stvec_adr = 0x105
const scause_adr = 0x142
const stval_adr = 0x143
const sip_adr = 0x144


/*
The CSRRW (Atomic Read/Write CSR) instruction atomically swaps values in the CSRs and integer registers. CSRRW reads the old value of the CSR, zero-extends the value to XLEN bits, then writes it to integer register rd. The initial value in rs1 is written to the CSR. If rd=x0, then the instruction shall not read the CSR and shall not cause any of the side effects that might occur on a CSR read.
*/
func csr_rw(core: *Core, csr: Nat16, rd: Nat8, rs1: Nat8) -> Unit {
	let nv = core.reg[rs1]
	if csr == Nat16 0x340 {
		// mscratch
	} else if csr == Nat16 0x341 {
		// mepc
	} else if csr == Nat16 0x342 {
		// mcause
	} else if csr == Nat16 0x343 {
		// mbadaddr
	} else if csr == Nat16 0x344 {
		// mip (machine interrupt pending)
	}
}


/*
The CSRRS (Atomic Read and Set Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be set in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be set in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
*/
func csr_rs(core: *Core, csr: Nat16, rd: Nat8, rs1: Nat8) -> Unit {
	//TODO
}

/*
The CSRRC (Atomic Read and Clear Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be cleared in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be cleared in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
*/
func csr_rc(core: *Core, csr: Nat16, rd: Nat8, rs1: Nat8) -> Unit {
	//TODO
}


// -


func csr_rwi(core: *Core, csr: Nat16, rd: Nat8, imm: Nat8) -> Unit {
	//TODO
}


// read+clear immediate(5-bit)
func csr_rsi(core: *Core, csr: Nat16, rd: Nat8, imm: Nat8) -> Unit {
	//TODO
}


// read+clear immediate(5-bit)
func csr_rci(core: *Core, csr: Nat16, rd: Nat8, imm: Nat8) -> Unit {
	//TODO
}



func trace(pc: Nat32, form: *Str8, ...) -> Unit {
	var va: va_list
	__va_start(va, form)
	if traceMode {
		stdio.printf("[%08X] ", pc)
		stdio.vprintf(form, va)
	}
	__va_end(va)
}


func notImplemented(form: *Str8, ...) -> Unit {
	var va: va_list
	__va_start(va, form)
	stdio.printf("\n\nINSTRUCTION_NOT_IMPLEMENTED: \"")
	stdio.vprintf(form, va)
	__va_end(va)
	stdio.puts("\"\n")
	stdlib.exit(-1)
}


public func show_regs(core: *Core) -> Unit {
	var i: Int32 = 0
	while i < 16 {
		stdio.printf("x%02d = 0x%08x", i, core.reg[i])
		stdio.printf("    ")
		stdio.printf("x%02d = 0x%08x\n", i + 16, core.reg[i + 16])
		i = i + 1
	}
}

