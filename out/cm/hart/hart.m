include "ctypes"
include "stdio"
include "unistd"
include "stdlib"
include "csr"
include "decode"
/*
 * RV32IM simple software implementation
 */


const traceMode: Bool = false


public type Hart = record {
	regs: [32]Word32
	pc: Nat32

	bus: *BusInterface

	irq: Word32

	public end: Bool
	public csrs: [4096]Word32
}


public type BusInterface = record {
	public read: *(adr: Nat32, size: Nat8) -> Word32
	public write: *(adr: Nat32, value: Word32, size: Nat8) -> Unit
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

const opSYSTEM = 0x73// system
const opFENCE = 0x0F// fence


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


public func init (hart: *Hart, id: Nat32, bus: *BusInterface) -> Unit {
	printf("hart #%d init\n", id)
	hart.csrs[Nat32 csr_mhartid_adr] = Word32 id
	hart.csrs[Nat32 csr_misa_adr] = csr_misa_xlen_32 or csr_misa_i or csr_misa_m
	hart.regs = []
	hart.pc = 0
	hart.bus = bus
	hart.irq = 0x0
	hart.end = false
}



func fetch (hart: *Hart) -> Word32 {
	return hart.bus.read(hart.pc, size=4)
}


public func tick (hart: *Hart) -> Unit {
	if hart.irq != 0 {
		trace(hart.pc, "\nINT #%02X\n", hart.irq)
		let vect_offset: Nat32 = Nat32 hart.irq * 4
		hart.pc = vect_offset
		hart.irq = 0
	}

	let instr: Word32 = fetch(hart)
	exec(hart, instr)

	// count mcycle
	hart.csrs[Nat32 csr_mcycle_adr] = Word32 (Nat32 hart.csrs[Nat32 csr_mcycle_adr] + 1)
}


func exec (hart: *Hart, instr: Word32) -> Unit {
	let op: Word8 = extract_op(instr)
	let funct3: Word8 = extract_funct3(instr)

	hart.regs[0] = 0

	if op == opI {
		execI(hart, instr)
		hart.pc = hart.pc + 4
	} else if op == opR {
		execR(hart, instr)
		hart.pc = hart.pc + 4
	} else if op == opLUI {
		execLUI(hart, instr)
		hart.pc = hart.pc + 4
	} else if op == opAUIPC {
		execAUIPC(hart, instr)
		hart.pc = hart.pc + 4
	} else if op == opJAL {
		execJAL(hart, instr)
	} else if op == opJALR and funct3 == 0 {
		execJALR(hart, instr)
	} else if op == opB {
		execB(hart, instr)
	} else if op == opL {
		execL(hart, instr)
		hart.pc = hart.pc + 4
	} else if op == opS {
		execS(hart, instr)
		hart.pc = hart.pc + 4
	} else if op == opSYSTEM {
		execSystem(hart, instr)
		hart.pc = hart.pc + 4
	} else if op == opFENCE {
		execFence(hart, instr)
		hart.pc = hart.pc + 4
	} else {
		trace(hart.pc, "UNKNOWN OPCODE: %08X\n", op)
	}
}


// Immediate instructions
func execI (hart: *Hart, instr: Word32) -> Unit {
	let funct3: Word8 = extract_funct3(instr)
	let funct7: Word8 = extract_funct7(instr)
	let imm: Int32 = expand12(extract_imm12(instr))
	let rd: Nat8 = extract_rd(instr)
	let rs1: Nat8 = extract_rs1(instr)

	if funct3 == 0 {
		// Add immediate

		trace(hart.pc, "addi x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.regs[rd] = Word32 (Int32 hart.regs[rs1] + imm)
	} else if funct3 == 1 and funct7 == 0 {
		/* SLLI is a logical left shift (zeros are shifted
		into the lower bits); SRLI is a logical right shift (zeros are shifted into the upper bits); and SRAI
		is an arithmetic right shift (the original sign bit is copied into the vacated upper bits). */

		trace(hart.pc, "slli x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.regs[rd] = hart.regs[rs1] << unsafe Nat8 imm
	} else if funct3 == 2 {
		// SLTI - set [1 to rd if rs1] less than immediate

		trace(hart.pc, "slti x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.regs[rd] = Word32 (Int32 hart.regs[rs1] < imm)
	} else if funct3 == 3 {
		trace(hart.pc, "sltiu x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.regs[rd] = Word32 (Nat32 hart.regs[rs1] < Nat32 imm)
	} else if funct3 == 4 {
		trace(hart.pc, "xori x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.regs[rd] = hart.regs[rs1] xor Word32 imm
	} else if funct3 == 5 and funct7 == 0 {
		trace(hart.pc, "srli x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.regs[rd] = (hart.regs[rs1] >> unsafe Nat8 imm)
	} else if funct3 == 5 and funct7 == 0x20 {
		trace(hart.pc, "srai x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.regs[rd] = hart.regs[rs1] >> unsafe Nat8 imm
	} else if funct3 == 6 {
		trace(hart.pc, "ori x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.regs[rd] = hart.regs[rs1] or Word32 imm
	} else if funct3 == 7 {
		trace(hart.pc, "andi x%d, x%d, %d\n", rd, rs1, imm)

		//
		hart.regs[rd] = hart.regs[rs1] and Word32 imm
	}
}


// Register to register
func execR (hart: *Hart, instr: Word32) -> Unit {
	let funct3: Word8 = extract_funct3(instr)
	let funct7: Word8 = extract_funct7(instr)
	let rd: Nat8 = extract_rd(instr)
	let rs1: Nat8 = extract_rs1(instr)
	let rs2: Nat8 = extract_rs2(instr)

	let v0: Word32 = hart.regs[rs1]
	let v1: Word32 = hart.regs[rs2]

	if funct7 == 1 {

		//
		// "M" extension
		//

		if funct3 == 0 {
			// MUL rd, rs1, rs2
			trace(hart.pc, "mul x%d, x%d, x%d\n", rd, rs1, rs2)

			hart.regs[rd] = Word32 (Int32 v0 * Int32 v1)
		} else if funct3 == 1 {
			// MULH rd, rs1, rs2
			// Записывает в целевой регистр старшие биты
			// которые бы не поместились в него при обычном умножении
			trace(hart.pc, "mulh x%d, x%d, x%d\n", rd, rs1, rs2)

			hart.regs[rd] = unsafe Word32 (unsafe Word64 (unsafe Int64 v0 * unsafe Int64 v1) >> 32)
		} else if funct3 == 2 {
			// MULHSU rd, rs1, rs2
			// mul high signed unsigned
			trace(hart.pc, "mulhsu x%d, x%d, x%d\n", rd, rs1, rs2)

			// NOT IMPLEMENTED!
			notImplemented("mulhsu x%d, x%d, x%d", rd, rs1, rs2)
			//hart.regs[rd] = unsafe Word32 (Word64 (Int64 v0 * Int64 v1) >> 32)
		} else if funct3 == 3 {
			// MULHU rd, rs1, rs2
			trace(hart.pc, "mulhu x%d, x%d, x%d\n", rd, rs1, rs2)

			// multiply unsigned high
			notImplemented("mulhu x%d, x%d, x%d\n", rd, rs1, rs2)
			//hart.regs[rd] = unsafe Word32 (Word64 (Nat64 v0 * Nat64 v1) >> 32)
		} else if funct3 == 4 {
			// DIV rd, rs1, rs2
			trace(hart.pc, "div x%d, x%d, x%d\n", rd, rs1, rs2)

			hart.regs[rd] = Word32 (Int32 v0 / Int32 v1)
		} else if funct3 == 5 {
			// DIVU rd, rs1, rs2
			trace(hart.pc, "divu x%d, x%d, x%d\n", rd, rs1, rs2)

			hart.regs[rd] = Word32 (Nat32 v0 / Nat32 v1)
		} else if funct3 == 6 {
			// REM rd, rs1, rs2
			trace(hart.pc, "rem x%d, x%d, x%d\n", rd, rs1, rs2)

			hart.regs[rd] = Word32 (Int32 v0 % Int32 v1)
		} else if funct3 == 7 {
			// REMU rd, rs1, rs2
			trace(hart.pc, "remu x%d, x%d, x%d\n", rd, rs1, rs2)

			hart.regs[rd] = Word32 (Nat32 v0 % Nat32 v1)
		}

		return
	}

	if funct3 == 0 and funct7 == 0x00 {
		trace(hart.pc, "add x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.regs[rd] = Word32 (Int32 v0 + Int32 v1)
	} else if funct3 == 0 and funct7 == 0x20 {
		trace(hart.pc, "sub x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.regs[rd] = Word32 (Int32 v0 - Int32 v1)
	} else if funct3 == 1 {
		// shift left logical

		trace(hart.pc, "sll x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		//printf("?%x\n", v0)
		hart.regs[rd] = v0 << unsafe Nat8 v1
	} else if funct3 == 2 {
		// set less than

		trace(hart.pc, "slt x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.regs[rd] = Word32 (Int32 v0 < Int32 v1)
	} else if funct3 == 3 {
		// set less than unsigned

		trace(hart.pc, "sltu x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.regs[rd] = Word32 (Nat32 v0 < Nat32 v1)
	} else if funct3 == 4 {

		trace(hart.pc, "xor x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.regs[rd] = v0 xor v1
	} else if funct3 == 5 and funct7 == 0 {
		// shift right logical

		trace(hart.pc, "srl x%d, x%d, x%d\n", rd, rs1, rs2)

		hart.regs[rd] = v0 >> unsafe Nat8 v1
	} else if funct3 == 5 and funct7 == 0x20 {
		// shift right arithmetical

		trace(hart.pc, "sra x%d, x%d, x%d\n", rd, rs1, rs2)

		// ERROR: не реализован арифм сдвиг!
		//hart.regs[rd] = v0 >> Int32 v1
	} else if funct3 == 6 {
		trace(hart.pc, "or x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.regs[rd] = v0 or v1
		//printf("=%08x (%08x, %08x)\n", hart.regs[rd], v0, v1)
	} else if funct3 == 7 {
		trace(hart.pc, "and x%d, x%d, x%d\n", rd, rs1, rs2)

		//
		hart.regs[rd] = v0 and v1
		//printf("=%08x (%08x, %08x)\n", hart.regs[rd], v0, v1)
	}
}


// Load upper immediate
func execLUI (hart: *Hart, instr: Word32) -> Unit {

	let imm: Word32 = extract_imm31_12(instr)
	let rd: Nat8 = extract_rd(instr)

	trace(hart.pc, "lui x%d, 0x%X\n", rd, imm)

	hart.regs[rd] = imm << 12
}


// Add upper immediate to PC
func execAUIPC (hart: *Hart, instr: Word32) -> Unit {
	let imm: Int32 = expand12(extract_imm31_12(instr))
	let x: Nat32 = hart.pc + Nat32 (Word32 imm << 12)
	let rd: Nat8 = extract_rd(instr)

	trace(hart.pc, "auipc x%d, 0x%X\n", rd, imm)

	hart.regs[rd] = Word32 x
}


// Jump and link
func execJAL (hart: *Hart, instr: Word32) -> Unit {
	let rd: Nat8 = extract_rd(instr)
	let raw_imm: Word32 = extract_jal_imm(instr)
	let imm: Int32 = expand20(raw_imm)

	trace(hart.pc, "jal x%d, %d\n", rd, imm)

	hart.regs[rd] = Word32 (hart.pc + 4)
	hart.pc = Nat32 (Int32 hart.pc + imm)
}


// Jump and link (by register)
func execJALR (hart: *Hart, instr: Word32) -> Unit {
	let rs1: Nat8 = extract_rs1(instr)
	let rd: Nat8 = extract_rd(instr)
	let imm: Int32 = expand12(extract_imm12(instr))

	trace(hart.pc, "jalr %d(x%d)\n", imm, rs1)

	// rd <- pc + 4
	// pc <- (rs1 + imm) & ~1

	let next_instr_ptr = Int32 (hart.pc + 4)
	let nexpc: Word32 = Word32 (Int32 hart.regs[rs1] + imm) and 0xFFFFFFFE
	hart.regs[rd] = Word32 next_instr_ptr
	hart.pc = Nat32 nexpc
}


// Branch instructions
func execB (hart: *Hart, instr: Word32) -> Unit {
	let funct3: Word8 = extract_funct3(instr)
	let rs1: Nat8 = extract_rs1(instr)
	let rs2: Nat8 = extract_rs2(instr)
	let imm: Int16 = extract_b_imm(instr)

	var nexpc: Nat32 = hart.pc + 4

	if funct3 == 0 {
		// BEQ - Branch if equal

		trace(hart.pc, "beq x%d, x%d, %d\n", rs1, rs2, imm)

		// Branch if two registers are equal
		if hart.regs[rs1] == hart.regs[rs2] {
			nexpc = Nat32 (Int32 hart.pc + Int32 imm)
		}
	} else if funct3 == 1 {
		// BNE - Branch if not equal

		trace(hart.pc, "bne x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if hart.regs[rs1] != hart.regs[rs2] {
			nexpc = Nat32 (Int32 hart.pc + Int32 imm)
		}
	} else if funct3 == 4 {
		// BLT - Branch if less than (signed)

		trace(hart.pc, "blt x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if Int32 hart.regs[rs1] < Int32 hart.regs[rs2] {
			nexpc = Nat32 (Int32 hart.pc + Int32 imm)
		}
	} else if funct3 == 5 {
		// BGE - Branch if greater or equal (signed)

		trace(hart.pc, "bge x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if Int32 hart.regs[rs1] >= Int32 hart.regs[rs2] {
			nexpc = Nat32 (Int32 hart.pc + Int32 imm)
		}
	} else if funct3 == 6 {
		// BLTU - Branch if less than (unsigned)

		trace(hart.pc, "bltu x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if Nat32 hart.regs[rs1] < Nat32 hart.regs[rs2] {
			nexpc = Nat32 (Int32 hart.pc + Int32 imm)
		}
	} else if funct3 == 7 {
		// BGEU - Branch if greater or equal (unsigned)

		trace(hart.pc, "bgeu x%d, x%d, %d\n", rs1, rs2, imm)

		//
		if Nat32 hart.regs[rs1] >= Nat32 hart.regs[rs2] {
			nexpc = Nat32 (Int32 hart.pc + Int32 imm)
		}
	}

	hart.pc = nexpc
}


// Load instructions
func execL (hart: *Hart, instr: Word32) -> Unit {
	let funct3: Word8 = extract_funct3(instr)
	let imm: Int32 = expand12(extract_imm12(instr))
	let rd: Nat8 = extract_rd(instr)
	let rs1: Nat8 = extract_rs1(instr)
	let rs2: Nat8 = extract_rs2(instr)

	let adr = Nat32 (Int32 hart.regs[rs1] + imm)

	if funct3 == 0 {
		// LB (Load 8-bit signed integer value)

		trace(hart.pc, "lb x%d, %d(x%d)\n", rd, imm, rs1)

		hart.regs[rd] = hart.bus.read(adr, size=1)
	} else if funct3 == 1 {
		// LH (Load 16-bit signed integer value)

		trace(hart.pc, "lh x%d, %d(x%d)\n", rd, imm, rs1)

		hart.regs[rd] = hart.bus.read(adr, size=2)
	} else if funct3 == 2 {
		// LW (Load 32-bit signed integer value)

		trace(hart.pc, "lw x%d, %d(x%d)\n", rd, imm, rs1)

		hart.regs[rd] = hart.bus.read(adr, size=4)
	} else if funct3 == 4 {
		// LBU (Load 8-bit unsigned integer value)

		trace(hart.pc, "lbu x%d, %d(x%d)\n", rd, imm, rs1)

		hart.regs[rd] = hart.bus.read(adr, size=1)
	} else if funct3 == 5 {
		// LHU (Load 16-bit unsigned integer value)

		trace(hart.pc, "lhu x%d, %d(x%d)\n", rd, imm, rs1)

		hart.regs[rd] = hart.bus.read(adr, size=2)
	}
}


// Store instructions
func execS (hart: *Hart, instr: Word32) -> Unit {
	let funct3: Word8 = extract_funct3(instr)
	let funct7: Word8 = extract_funct7(instr)
	let rd: Nat8 = extract_rd(instr)
	let rs1: Nat8 = extract_rs1(instr)
	let rs2: Nat8 = extract_rs2(instr)

	let imm4to0 = Nat32 rd
	let imm11to5 = Nat32 funct7
	let _imm: Word32 = (unsafe Word32 imm11to5 << 5) or unsafe Word32 imm4to0
	let imm: Int32 = expand12(_imm)

	let adr = Nat32 Word32 (Int32 hart.regs[rs1] + imm)
	let val: Word32 = hart.regs[rs2]

	if funct3 == 0 {
		// SB (save 8-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(hart.pc, "sb x%d, %d(x%d)\n", rs2, imm, rs1)

		//
		hart.bus.write(adr, val, size=1)
	} else if funct3 == 1 {
		// SH (save 16-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(hart.pc, "sh x%d, %d(x%d)\n", rs2, imm, rs1)

		//
		hart.bus.write(adr, val, size=2)
	} else if funct3 == 2 {
		// SW (save 32-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(hart.pc, "sw x%d, %d(x%d)\n", rs2, imm, rs1)

		//
		hart.bus.write(adr, val, size=4)
	}
}


func execSystem (hart: *Hart, instr: Word32) -> Unit {
	let funct3: Word8 = extract_funct3(instr)
	let rd: Nat8 = extract_rd(instr)
	let rs1: Nat8 = extract_rs1(instr)
	let csr: Nat16 = unsafe Nat16 extract_imm12(instr)

	if instr == instrECALL {
		trace(hart.pc, "ecall\n")

		//
		hart.irq = hart.irq or intSysCall
	} else if instr == instrEBREAK {
		trace(hart.pc, "ebreak\n")
		hart.end = true

		// CSR instructions
	} else if funct3 == funct3_CSRRW {
		// CSR read & write
		csr_rw(hart, csr, rd, rs1)
	} else if funct3 == funct3_CSRRS {
		// CSR read & set bit
		let mask_reg: Nat8 = rs1
		csr_rs(hart, csr, rd, mask_reg)
	} else if funct3 == funct3_CSRRC {
		// CSR read & clear bit
		let mask_reg: Nat8 = rs1
		csr_rc(hart, csr, rd, mask_reg)
	} else if funct3 == funct3_CSRRWI {
		let imm: Nat8 = rs1
		csr_rwi(hart, csr, rd, imm)
	} else if funct3 == funct3_CSRRSI {
		let imm: Nat8 = rs1
		csr_rsi(hart, csr, rd, imm)
	} else if funct3 == funct3_CSRRCI {
		let imm: Nat8 = rs1
		csr_rci(hart, csr, rd, imm)
	} else {
		trace(hart.pc, "UNKNOWN SYSTEM INSTRUCTION: 0x%x\n", instr)
		hart.end = true
	}
}


func execFence (hart: *Hart, instr: Word32) -> Unit {
	if instr == instrPAUSE {
		trace(hart.pc, "PAUSE\n")
	}
}



/*
The CSRRW (Atomic Read/Write CSR) instruction atomically swaps values in the CSRs and integer registers. CSRRW reads the old value of the CSR, zero-extends the value to XLEN bits, then writes it to integer register rd. The initial value in rs1 is written to the CSR. If rd=x0, then the instruction shall not read the CSR and shall not cause any of the side effects that might occur on a CSR read.
*/
func csr_rw (hart: *Hart, csr: Nat16, rd: Nat8, rs1: Nat8) -> Unit {
	//printf("CSR_RW(csr=0x%X, rd=r%d, rs1=r%d)\n", csr, rd, rs1)
	let nv: Word32 = hart.regs[rs1]
	hart.regs[rd] = hart.csrs[csr]
	hart.csrs[csr] = hart.csrs[rs1]
}


/*
The CSRRS (Atomic Read and Set Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be set in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be set in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
*/
func csr_rs (hart: *Hart, csr: Nat16, rd: Nat8, rs1: Nat8) -> Unit {
	// csrrs rd, csr, rs
	//printf("CSR_RS(csr=0x%X, rd=r%d, rs1=r%d)\n", csr, rd, rs1)
	let set: Word32 = hart.regs[rs1]
	hart.regs[rd] = hart.csrs[csr]
	hart.csrs[csr] = hart.csrs[csr] or hart.regs[rs1]
}


/*
The CSRRC (Atomic Read and Clear Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be cleared in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be cleared in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
*/
func csr_rc (hart: *Hart, csr: Nat16, rd: Nat8, rs1: Nat8) -> Unit {
	// csrrc rd, csr, rs
	//printf("CSR_RC(csr=0x%X, rd=r%d, rs1=r%d)\n", csr, rd, rs1)
	let set: Word32 = hart.regs[rs1]
	hart.regs[rd] = hart.csrs[csr]
	hart.csrs[csr] = hart.csrs[csr] and not hart.regs[rs1]
}


// read+write immediate(5-bit)
func csr_rwi (hart: *Hart, csr: Nat16, rd: Nat8, imm: Nat8) -> Unit {
	//TODO
	//printf("RWI\n")
	fatal("RWI not implemented\n")
}


// read+clear immediate(5-bit)
func csr_rsi (hart: *Hart, csr: Nat16, rd: Nat8, imm: Nat8) -> Unit {
	//TODO
	//printf("RSI\n")
	fatal("RSI not implemented\n")
}


// read+clear immediate(5-bit)
func csr_rci (hart: *Hart, csr: Nat16, rd: Nat8, imm: Nat8) -> Unit {
	//TODO
	//printf("RCI\n")
	fatal("RCI not implemented\n")
}



func trace (pc: Nat32, form: *Str8, ...) -> Unit {
	if not traceMode {
		return
	}

	var va: va_list
	__va_start(va, form)
	printf("[%08X] ", pc)
	vprintf(form, va)
	__va_end(va)
}


func trace2 (pc: Nat32, form: *Str8, ...) -> Unit {
	var va: va_list
	__va_start(va, form)
	printf("[%08X] ", pc)
	vprintf(form, va)
	__va_end(va)
}


func fatal (form: *Str8, ...) -> Unit {
	var va: va_list
	__va_start(va, form)
	vprintf(form, va)
	__va_end(va)
	exit(-1)
}


func notImplemented (form: *Str8, ...) -> Unit {
	var va: va_list
	__va_start(va, form)
	printf("\n\nINSTRUCTION_NOT_IMPLEMENTED: \"")
	vprintf(form, va)
	__va_end(va)
	puts("\"\n")
	exit(-1)
}


public func show_regs (hart: *Hart) -> Unit {
	var i = Nat16 0
	while i < 16 {
		printf("x%02d = 0x%08x", i, hart.regs[i])
		printf("    ")
		printf("x%02d = 0x%08x\n", i + 16, hart.regs[i + 16])
		i = i + 1
	}
}

