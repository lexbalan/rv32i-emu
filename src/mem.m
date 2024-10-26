//

include "libc/ctypes"
include "libc/stdio"


// see mem.ld
public const ramSize = 4096
public const ramStart = 0x10000000
public const ramEnd = ramStart + ramSize


public const romSize = 0x10000
public const romStart = 0x00000000
public const romEnd = romStart + romSize


const mmioSize = 0xFFFF
const mmioStart = 0xF00C0000
const mmioEnd = mmioStart + mmioSize

const consoleMMIOAdr = mmioStart + 0x10
const consolePutAdr = consoleMMIOAdr + 0
const consoleGetAdr = consoleMMIOAdr + 1

const consolePrintInt32Adr = consoleMMIOAdr + 0x10
const consolePrintUInt32Adr = consoleMMIOAdr + 0x14
const consolePrintInt32HexAdr = consoleMMIOAdr + 0x18
const consolePrintUInt32HexAdr = consoleMMIOAdr + 0x1C

const consolePrintInt64Adr = consoleMMIOAdr + 0x20
const consolePrintUInt64Adr = consoleMMIOAdr + 0x28


var rom: [romSize]Word8
var ram: [ramSize]Word8


public func get_ram_ptr() -> *[]Word8 {
	return &ram
}

public func get_rom_ptr() -> *[]Word8 {
	return &rom
}



func memoryViolation(rw: Char8, adr: Nat32) {
	printf("*** MEMORY VIOLATION '%c' 0x%08x ***\n", rw, adr)
//	memoryViolation_event(0x55) // !
}


public func read8(adr: Nat32) -> Word8 {
	var x = Word8 0

	if adr >= ramStart and adr <= ramEnd {
		let ptr = *Word8 Ptr &ram[adr - ramStart]
		x = *ptr
	} else if adr >= mmioStart and adr <= mmioEnd {
		//
	} else if adr >= romStart and adr <= romEnd {
		let ptr = *Word8 Ptr &rom[adr - romStart]
		x = *ptr
	} else {
		memoryViolation("r", adr)
		x = 0
	}

	//printf("MEM_READ_8[%x] = 0x%x\n", adr, x to Nat32)

	return x
}


public func read16(adr: Nat32) -> Word16 {
	var x = Word16 0

	if adr >= ramStart and adr <= ramEnd {
		let ptr = *Word16 Ptr &ram[adr - ramStart]
		x = *ptr
	} else if adr >= mmioStart and adr <= mmioEnd {
		//
	} else if adr >= romStart and adr <= romEnd {
		let ptr = *Word16 Ptr &rom[adr - romStart]
		x = *ptr
	} else {
		memoryViolation("r", adr)
		x = 0
	}

	//printf("MEM_READ_16[%x] = 0x%x\n", adr, x to Nat32)

	return x
}


public func read32(adr: Nat32) -> Word32 {
	var x = Word32 0

	if adr >= romStart and adr <= romEnd {
		let ptr = *Word32 Ptr &rom[adr - romStart]
		x = *ptr
	} else if adr >= ramStart and adr <= ramEnd {
		let ptr = *Word32 Ptr &ram[adr - ramStart]
		x = *ptr
	} else if adr >= mmioStart and adr <= mmioEnd {
		x = 0
	} else {
		memoryViolation("r", adr)
	}

	//printf("MEM_READ_32[%x] = 0x%x\n", adr, x)

	return x
}



public func write8(adr: Nat32, value: Word8) {
	if adr >= ramStart and adr <= ramEnd {
		let ptr = *Word8 Ptr &ram[adr - ramStart]
		*ptr = value
	} else if adr >= mmioStart and adr <= mmioEnd {
		if adr == consolePutAdr {
			let v = Char8 value
			printf("%c", v)
			return
		}
	} else {
		memoryViolation("w", adr)
	}
}


public func write16(adr: Nat32, value: Word16) {
	if adr >= ramStart and adr <= ramEnd {
		let ptr = *Word16 Ptr &ram[adr - ramStart]
		*ptr = value
	} else if adr >= mmioStart and adr <= mmioEnd {
		if adr == consolePutAdr {
			putchar(Int value)
			return
		}
	} else {
		memoryViolation("w", adr)
	}
}


public func write32(adr: Nat32, value: Word32) {
	if adr >= ramStart and adr <= ramEnd {
		let ptr = *Word32 Ptr &ram[adr - ramStart]
		*ptr = value
	} else if adr >= mmioStart and adr <= mmioEnd {
		if adr == consolePutAdr {
			putchar(Int value)
			return
		} else if adr == consolePrintInt32Adr {
			printf("%u", value)
			return
		} else if adr == consolePrintUInt32Adr {
			printf("%u", value)
			return
		} else if adr == consolePrintInt32HexAdr {
			printf("%x", value)
			return
		} else if adr == consolePrintUInt32HexAdr {
			printf("%x", value)
			return
		}

	} else {
		memoryViolation("w", adr)
	}

	//printf("MEM_WRITE_32[%x] = 0x%x\n", adr, value)
}

