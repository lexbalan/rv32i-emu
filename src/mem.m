//
//

include "libc/stdio"

import "mmio"


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


@inlinehint
func isAdressInRange(x: Nat32, a: Nat32, b: Nat32) -> Bool {
	return x >= a and x < b
}


public func read8(adr: Nat32) -> Word8 {
	var x = Word8 0

	if isAdressInRange(adr, ramStart, ramEnd) {
		let ptr = *Word8 Ptr &ram[adr - ramStart]
		x = *ptr
	} else if isAdressInRange(adr, mmioStart, mmioEnd) {
		//
	} else if isAdressInRange(adr, romStart, romEnd) {
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

	if isAdressInRange(adr, ramStart, ramEnd) {
		let ptr = *Word16 Ptr &ram[adr - ramStart]
		x = *ptr
	} else if isAdressInRange(adr, mmioStart, mmioEnd) {
		//
	} else if isAdressInRange(adr, romStart, romEnd) {
		let ptr = *Word16 Ptr &rom[adr - romStart]
		x = *ptr
	} else {
		memoryViolation("r", adr)
	}

	//printf("MEM_READ_16[%x] = 0x%x\n", adr, x to Nat32)
	return x
}


public func read32(adr: Nat32) -> Word32 {
	var x = Word32 0

	if isAdressInRange(adr, romStart, romEnd) {
		let ptr = *Word32 Ptr &rom[adr - romStart]
		x = *ptr
	} else if isAdressInRange(adr, ramStart, ramEnd) {
		let ptr = *Word32 Ptr &ram[adr - ramStart]
		x = *ptr
	} else if isAdressInRange(adr, mmioStart, mmioEnd) {
		//TODO
	} else {
		memoryViolation("r", adr)
	}

	//printf("MEM_READ_32[%x] = 0x%x\n", adr, x)

	return x
}



public func write8(adr: Nat32, value: Word8) {
	if isAdressInRange(adr, ramStart, ramEnd) {
		let ptr = *Word8 Ptr &ram[adr - ramStart]
		*ptr = value
	} else if isAdressInRange(adr, mmioStart, mmioEnd) {
		mmio.write8(adr - mmioStart, value)
	} else {
		memoryViolation("w", adr)
	}
}


public func write16(adr: Nat32, value: Word16) {
	if isAdressInRange(adr, ramStart, ramEnd) {
		let ptr = *Word16 Ptr &ram[adr - ramStart]
		*ptr = value
	} else if isAdressInRange(adr, mmioStart, mmioEnd) {
		mmio.write16(adr - mmioStart, value)
	} else {
		memoryViolation("w", adr)
	}
}


public func write32(adr: Nat32, value: Word32) {
	if isAdressInRange(adr, ramStart, ramEnd) {
		let ptr = *Word32 Ptr &ram[adr - ramStart]
		*ptr = value
	} else if isAdressInRange(adr, mmioStart, mmioEnd) {
		mmio.write32(adr - mmioStart, value)
	} else {
		memoryViolation("w", adr)
	}

	//printf("MEM_WRITE_32[%x] = 0x%x\n", adr, value)
}
