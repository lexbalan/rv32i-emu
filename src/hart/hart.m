//
//

include "libc/ctypes"
include "libc/stdio"
include "libc/unistd"
include "libc/stdlib"

include "decode"


const traceMode = false


public type Hart record {
	reg: [32]Word32
	pc, nexpc: Nat32

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


const opL = 0x03      // load
const opI = 0x13      // immediate
const opS = 0x23      // store
const opR = 0x33      // reg
const opB = 0x63      // branch

const opLUI = 0x37	  // load upper immediate
const opAUIPC = 0x17  // add upper immediate to PC
const opJAL = 0x6F	  // jump and link
const opJALR = 0x67   // jump and link by register

const opSYSTEM = 0x73 //
const opFENCE = 0x0F  //


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



public func init(hart: *Hart, bus: *BusInterface) {
	*hart = Hart {
		bus=bus
	}
}


func fetch(hart: *Hart) -> Word32 {
	return hart.bus.read32(hart.pc)
}


public func tick(hart: *Hart) {
	if hart.interrupt != 0 {
		trace(hart.pc, "\nINT #%02X\n", hart.interrupt)
		let vect_offset = Nat32 hart.interrupt * 4
		hart.pc = vect_offset
		hart.interrupt = 0
	}

	let instr = fetch(hart)
	exec(hart, instr)

	hart.pc = hart.nexpc
	hart.nexpc = hart.pc + 4
	++hart.cnt
}


func exec(hart: *Hart, instr: Word32) {
	let op = extract_op(instr)
	let funct3 = extract_funct3(instr)

	if op == opI {
		execI(hart, instr)
	} else if op == opR {
		execR(hart, instr)
	} else if op == opLUI {
		execLUI(hart, instr)
	} else if op == opAUIPC {
		execAUIPC(hart, instr)
	} else if op == opJAL {
		execJAL(hart, instr)
	} else if op == opJALR and funct3 == 0 {
		execJALR(hart, instr)
	} else if op == opB {
		execB(hart, instr)
	} else if op == opL {
		execL(hart, instr)
	} else if op == opS {
		execS(hart, instr)
	} else if op == opSYSTEM {
		execSystem(hart, instr)
	} else if op == opFENCE {
		execFence(hart, instr)
	} else {
		trace(hart.pc, "UNKNOWN OPCODE: %08X\n", op)
	}
}


func execI(hart: *Hart, instr: Word32) {
	let funct3 = extract_funct3(instr)
	let funct7 = extract_funct7(instr)
	let imm12 = extract_imm12(instr)
	let imm = expand12(imm12)
	let rd = extract_rd(instr)
	let rs1 = extract_rs1(instr)

	if rd == 0 {
		return
	}

	if funct3 == 0 {
		// Add immediate

		trace(hart.pc, "addi x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.reg[rd] = Word32 (Int32 hart.reg[rs1] + imm)

	} else if funct3 == 1 and funct7 == 0 {
		/* SLLI is a logical left shift (zeros are shifted
		into the lower bits); SRLI is a logical right shift (zeros are shifted into the upper bits); and SRAI
		is an arithmetic right shift (the original sign bit is copied into the vacated upper bits). */

		trace(hart.pc, "slli x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.reg[rd] = hart.reg[rs1] << unsafe Nat8 imm

	} else if funct3 == 2 {
		// SLTI - set [1 to rd if rs1] less than immediate

		trace(hart.pc, "slti x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.reg[rd] = Word32 (Int32 hart.reg[rs1] < imm)

	} else if funct3 == 3 {
		trace(hart.pc, "sltiu x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.reg[rd] = Word32 (Nat32 hart.reg[rs1] < Nat32 imm)

	} else if funct3 == 4 {
		trace(hart.pc, "xori x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.reg[rd] = hart.reg[rs1] xor Word32 imm

	} else if funct3 == 5 and funct7 == 0 {
		trace(hart.pc, "srli x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.reg[rd] = (hart.reg[rs1] >> unsafe Nat8 imm)

	} else if funct3 == 5 and funct7 == 0x20 {
		trace(hart.pc, "srai x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.reg[rd] = hart.reg[rs1] >> unsafe Nat8 imm

	} else if funct3 == 6 {
		trace(hart.pc, "ori x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.reg[rd] = hart.reg[rs1] or Word32 imm

	} else if funct3 == 7 {
		trace(hart.pc, "andi x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.reg[rd] = hart.reg[rs1] and Word32 imm
	}
}


func execR(hart: *Hart, instr: Word32) {
	let funct3 = extract_funct3(instr)
	let funct7 = extract_funct7(instr)
	let imm = expand12(extract_imm12(instr))
	let rd = extract_rd(instr)
	let rs1 = extract_rs1(instr)
	let rs2 = extract_rs2(instr)

	if rd == 0 {
		return
	}

	let v0 = hart.reg[rs1]
	let v1 = hart.reg[rs2]


	let f7 = extract_funct7(instr)
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
			trace(hart.pc, "mul x%d, x%d, x%d\n", rd, rs1, rs2)

			hart.reg[rd] = Word32 (Int32 v0 * Int32 v1)

		} else if funct3 == 1 {
			// MULH rd, rs1, rs2
			// Записывает в целевой регистр старшие биты
			// которые бы не поместились в него при обычном умножении
			trace(hart.pc, "mulh x%d, x%d, x%d\n", rd, rs1, rs2)

			hart.reg[rd] = unsafe Word32 (Word64 (Int64 v0 * Int64 v1) >> 32)

		} else if funct3 == 2 {
			// MULHSU rd, rs1, rs2
			// mul high signed unsigned
			trace(hart.pc, "mulhsu x%d, x%d, x%d\n", rd, rs1, rs2)

			// NOT IMPLEMENTED!
			notImplemented("mulhsu x%d, x%d, x%d", rd, rs1, rs2)
			//hart.reg[rd] = unsafe Word32 (Word64 (Int64 v0 * Int64 v1) >> 32)

		} else if funct3 == 3 {
			// MULHU rd, rs1, rs2
			trace(hart.pc, "mulhu x%d, x%d, x%d\n", rd, rs1, rs2)

			// multiply unsigned high
			notImplemented("mulhsu x%d, x%d, x%d\n", rd, rs1, rs2)
			//hart.reg[rd] = unsafe Word32 (Word64 (Nat64 v0 * Nat64 v1) >> 32)

		} else if funct3 == 4 {
			// DIV rd, rs1, rs2
			trace(hart.pc, "div x%d, x%d, x%d\n", rd, rs1, rs2)

			hart.reg[rd] = Word32 (Int32 v0 / Int32 v1)

		} else if funct3 == 5 {
			// DIVU rd, rs1, rs2
			trace(hart.pc, "divu x%d, x%d, x%d\n", rd, rs1, rs2)

			hart.reg[rd] = Word32 (Nat32 v0 / Nat32 v1)

		} else if funct3 == 6 {
			// REM rd, rs1, rs2
			trace(hart.pc, "rem x%d, x%d, x%d\n", rd, rs1, rs2)

			hart.reg[rd] = Word32 (Int32 v0 % Int32 v1)

		} else if funct3 == 7 {
			// REMU rd, rs1, rs2
			trace(hart.pc, "remu x%d, x%d, x%d\n", rd, rs1, rs2)

			hart.reg[rd] = Word32 (Nat32 v0 % Nat32 v1)
		}

		return
	}


	if funct3 == 0 and funct7 == 0x00 {
		trace(hart.pc, "add x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.reg[rd] = Word32 (Int32 v0 + Int32 v1)

	} else if funct3 == 0 and funct7 == 0x20 {
		trace(hart.pc, "sub x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.reg[rd] = Word32 (Int32 v0 - Int32 v1)

	} else if funct3 == 1 {
		// shift left logical

		trace(hart.pc, "sll x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.reg[rd] = v0 << unsafe Nat8 v1

	} else if funct3 == 2 {
		// set less than

		trace(hart.pc, "slt x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.reg[rd] = Word32 (Int32 v0 < Int32 v1)

	} else if funct3 == 3 {
		// set less than unsigned

		trace(hart.pc, "sltu x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.reg[rd] = Word32 (Nat32 v0 < Nat32 v1)

	} else if funct3 == 4 {

		trace(hart.pc, "xor x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.reg[rd] = v0 xor v1

	} else if funct3 == 5 and funct7 == 0 {
		// shift right logical

		trace(hart.pc, "srl x%d, x%d, x%d\n", rd, rs1, rs2)

		hart.reg[rd] = v0 >> unsafe Nat8 v1

	} else if funct3 == 5 and funct7 == 0x20 {
		// shift right arithmetical

		trace(hart.pc, "sra x%d, x%d, x%d\n", rd, rs1, rs2)

		// ERROR: не реализован арифм сдвиг!
		//hart.reg[rd] = v0 >> Int32 v1

	} else if funct3 == 6 {
		trace(hart.pc, "or x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.reg[rd] = v0 or v1

	} else if funct3 == 7 {
		trace(hart.pc, "and x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.reg[rd] = v0 and v1
	}
}


func execLUI(hart: *Hart, instr: Word32) {
	// load upper immediate

	let imm = expand12(extract_imm31_12(instr))
	let rd = extract_rd(instr)

	trace(hart.pc, "lui x%d, 0x%X\n", rd, imm)

	if rd != 0 {
		hart.reg[rd] = Word32 imm << 12
	}
}


func execAUIPC(hart: *Hart, instr: Word32) {
	// Add upper immediate to PC

	let imm = expand12(extract_imm31_12(instr))
	let x = hart.pc + Nat32 (Word32 imm << 12)
	let rd = extract_rd(instr)

	trace(hart.pc, "auipc x%d, 0x%X\n", rd, imm)

	if rd != 0 {
		hart.reg[rd] = Word32 x
	}
}


func execJAL(hart: *Hart, instr: Word32) {
	// Jump and link

	let rd = extract_rd(instr)
	let raw_imm = extract_jal_imm(instr)
	let imm = expand20(raw_imm)

	trace(hart.pc, "jal x%d, %d\n", rd, imm)

	if rd != 0 {
		hart.reg[rd] = Word32 (hart.pc + 4)
	}

	hart.nexpc = Nat32 (Int32 hart.pc + imm)
}


func execJALR(hart: *Hart, instr: Word32) {
	// Jump and link (by register)

	let rs1 = extract_rs1(instr)
	let rd = extract_rd(instr)
	let imm = expand12(extract_imm12(instr))

	trace(hart.pc, "jalr %d(x%d)\n", imm, rs1)

	// rd <- pc + 4
	// pc <- (rs1 + imm) & ~1
	let next_instr_ptr = Int32 (hart.pc + 4)
	let jump_to = Word32 (Int32 hart.reg[rs1] + imm) and 0xFFFFFFFE

	if rd != 0 {
		hart.reg[rd] = Word32 next_instr_ptr
	}

	hart.nexpc = Nat32 jump_to
}


func execB(hart: *Hart, instr: Word32) {
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
		// BEQ - Branch if equal

		trace(hart.pc, "beq x%d, x%d, %d\n", rs1, rs2, imm)

		// Branch if two registers are equal
		if hart.reg[rs1] == hart.reg[rs2] {
			hart.nexpc = Nat32 (Int32 hart.pc + Int32 imm)
		}

	} else if funct3 == 1 {
		// BNE - Branch if not equal

		trace(hart.pc, "bne x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if hart.reg[rs1] != hart.reg[rs2] {
			hart.nexpc = Nat32 (Int32 hart.pc + Int32 imm)
		}

	} else if funct3 == 4 {
		// BLT - Branch if less than (signed)

		trace(hart.pc, "blt x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if Int32 hart.reg[rs1] < Int32 hart.reg[rs2] {
			hart.nexpc = Nat32 (Int32 hart.pc + Int32 imm)
		}

	} else if funct3 == 5 {
		// BGE - Branch if greater or equal (signed)

		trace(hart.pc, "bge x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if Int32 hart.reg[rs1] >= Int32 hart.reg[rs2] {
			hart.nexpc = Nat32 (Int32 hart.pc + Int32 imm)
		}

	} else if funct3 == 6 {
		// BLTU - Branch if less than (unsigned)

		trace(hart.pc, "bltu x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if Nat32 hart.reg[rs1] < Nat32 hart.reg[rs2] {
			hart.nexpc = Nat32 (Int32 hart.pc + Int32 imm)
		}

	} else if funct3 == 7 {
		// BGEU - Branch if greater or equal (unsigned)

		trace(hart.pc, "bgeu x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if Nat32 hart.reg[rs1] >= Nat32 hart.reg[rs2] {
			hart.nexpc = Nat32 (Int32 hart.pc + Int32 imm)
		}
	}
}


func execL(hart: *Hart, instr: Word32) {
	let funct3 = extract_funct3(instr)
	let funct7 = extract_funct7(instr)
	let imm12 = extract_imm12(instr)
	let imm = expand12(imm12)
	let rd = extract_rd(instr)
	let rs1 = extract_rs1(instr)
	let rs2 = extract_rs2(instr)

	let adr = Nat32 (Int32 hart.reg[rs1] + imm)

	if funct3 == 0 {
		// LB (Load 8-bit signed integer value)

		trace(hart.pc, "lb x%d, %d(x%d)\n", rd, imm, rs1)

		let val = Int32 hart.bus.read8(adr)
		if rd != 0 {
			hart.reg[rd] = Word32 val
		}

	} else if funct3 == 1 {
		// LH (Load 16-bit signed integer value)

		trace(hart.pc, "lh x%d, %d(x%d)\n", rd, imm, rs1)

		let val = Int32 hart.bus.read16(adr)
		if rd != 0 {
			hart.reg[rd] = Word32 val
		}

	} else if funct3 == 2 {
		// LW (Load 32-bit signed integer value)

		trace(hart.pc, "lw x%d, %d(x%d)\n", rd, imm, rs1)

		let val = hart.bus.read32(adr)
		if rd != 0 {
			hart.reg[rd] = val
		}

	} else if funct3 == 4 {
		// LBU (Load 8-bit unsigned integer value)

		trace(hart.pc, "lbu x%d, %d(x%d)\n", rd, imm, rs1)

		let val = Nat32 hart.bus.read8(adr)
		if rd != 0 {
			hart.reg[rd] = Word32 val
		}

	} else if funct3 == 5 {
		// LHU (Load 16-bit unsigned integer value)

		trace(hart.pc, "lhu x%d, %d(x%d)\n", rd, imm, rs1)

		let val = Nat32 hart.bus.read16(adr)
		if rd != 0 {
			hart.reg[rd] = Word32 val
		}
	}
}


func execS(hart: *Hart, instr: Word32) {
	let funct3 = extract_funct3(instr)
	let funct7 = extract_funct7(instr)
	let rd = extract_rd(instr)
	let rs1 = extract_rs1(instr)
	let rs2 = extract_rs2(instr)

	let imm4to0 = Nat32 rd
	let imm11to5 = Nat32 funct7
	let _imm = (unsafe Word32 imm11to5 << 5) or unsafe Word32 imm4to0
	let imm = expand12(_imm)

	let adr = Nat32 Word32 (Int32 hart.reg[rs1] + imm)
	let val = hart.reg[rs2]

	if funct3 == 0 {
		// SB (save 8-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(hart.pc, "sb x%d, %d(x%d)\n", rs2, imm, rs1)

		//
		hart.bus.write8(adr, unsafe Word8 val)

	} else if funct3 == 1 {
		// SH (save 16-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(hart.pc, "sh x%d, %d(x%d)\n", rs2, imm, rs1)

		//
		hart.bus.write16(adr, unsafe Word16 val)

	} else if funct3 == 2 {
		// SW (save 32-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(hart.pc, "sw x%d, %d(x%d)\n", rs2, imm, rs1)

		//
		hart.bus.write32(adr, val)
	}
}


func execSystem(hart: *Hart, instr: Word32) {
	let funct3 = extract_funct3(instr)
	let funct7 = extract_funct7(instr)
	let imm12 = extract_imm12(instr)
	let imm = expand12(imm12)
	let rd = extract_rd(instr)
	let rs1 = extract_rs1(instr)

	let csr = unsafe Nat16 imm12

	if instr == instrECALL {
		trace(hart.pc, "ECALL\n")

		//
		irq(hart, intSysCall)

	} else if instr == instrEBREAK {
		trace(hart.pc, "EBREAK\n")

		//
		printf("END.\n")
		hart.end = true

	// CSR instructions
	} else if funct3 == funct3_CSRRW {
		// CSR read & write
		csr_rw(hart, csr, rd, rs1)
	} else if funct3 == funct3_CSRRS {
		// CSR read & set bit
		let mask_reg = rs1
		csr_rs(hart, csr, rd, mask_reg)
	} else if funct3 == funct3_CSRRC {
		// CSR read & clear bit
		let mask_reg = rs1
		csr_rc(hart, csr, rd, mask_reg)
	} else if funct3 == funct3_CSRRWI {
		let imm = rs1
		csr_rwi(hart, csr, rd, imm)
	} else if funct3 == funct3_CSRRSI {
		let imm = rs1
		csr_rsi(hart, csr, rd, imm)
	} else if funct3 == funct3_CSRRCI {
		let imm = rs1
		csr_rci(hart, csr, rd, imm)
	} else {
		trace(hart.pc, "UNKNOWN SYSTEM INSTRUCTION: 0x%x\n", instr)
		hart.end = true
	}
}


func execFence(hart: *Hart, instr: Word32) {
	if instr == instrPAUSE {
		trace(hart.pc, "PAUSE\n")
	}
}


public func irq(hart: *Hart, irq: Word32) {
	if hart.interrupt == 0 {
		hart.interrupt = irq
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
func csr_rw(hart: *Hart, csr: Nat16, rd: Nat8, rs1: Nat8) {
	let nv = hart.reg[rs1]
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
func csr_rs(hart: *Hart, csr: Nat16, rd: Nat8, rs1: Nat8) {
	//TODO
}

/*
The CSRRC (Atomic Read and Clear Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be cleared in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be cleared in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
*/
func csr_rc(hart: *Hart, csr: Nat16, rd: Nat8, rs1: Nat8) {
	//TODO
}


// -


func csr_rwi(hart: *Hart, csr: Nat16, rd: Nat8, imm: Nat8) {
	//TODO
}


// read+clear immediate(5-bit)
func csr_rsi(hart: *Hart, csr: Nat16, rd: Nat8, imm: Nat8) {
	//TODO
}


// read+clear immediate(5-bit)
func csr_rci(hart: *Hart, csr: Nat16, rd: Nat8, imm: Nat8) {
	//TODO
}



func trace(pc: Nat32, form: *Str8, ...) -> Unit {
	var va: __VA_List
	__va_start(va, form)
	if traceMode {
		printf("[%08X] ", pc)
		vprintf(form, va)
	}
	__va_end(va)
}


func notImplemented(form: *Str8, ...) -> Unit {
	var va: __VA_List
	__va_start(va, form)
	printf("\n\nINSTRUCTION_NOT_IMPLEMENTED: \"")
	vprintf(form, va)
	__va_end(va)
	puts("\"\n")
	exit(-1)
}


public func show_regs(hart: *Hart) {
	var i = 0
	while i < 16 {
	printf("x%02d = 0x%08x", i, hart.reg[i])
	printf("    ")
	printf("x%02d = 0x%08x\n", i + 16, hart.reg[i + 16])
		i = i + 1
	}
}

