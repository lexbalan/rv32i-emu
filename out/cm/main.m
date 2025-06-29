import "bus"
import "hart/hart"
include "ctypes"
include "stdlib"
include "stdio"

import "bus" as bus
import "hart/hart" as rvHart


const text_filename = "./image.bin"

const showText: Bool = false


var hart: Hart


//public func bus_violation_event(reason: Nat32) {
//	hart.irq(&hart, rvHart.intMemViolation)
//}


public func main () -> Int {
	printf("RISC-V VM\n")

	var busctl: BusInterface = BusInterface {
		read = &bus.read
		write = &bus.write
	}

	let romptr: *[]Word8 = bus.get_rom_ptr()
	let nbytes: Nat32 = loader(text_filename, romptr, bus.romSize)

	if nbytes <= 0 {
		exit(1)
	}

	rvHart.init(&hart, 0, &busctl)

	printf("*** START ***\n")

	while not hart.end {
		rvHart.tick(&hart)
	}

	printf("hart.cnt = %u\n", hart.cnt)

	printf("\nCore dump:\n")
	rvHart.show_regs(&hart)
	printf("\n")
	show_mem()

	return 0
}


func loader (filename: *Str8, bufptr: *[]Word8, buf_size: Nat32) -> Nat32 {
	printf("LOAD: %s\n", filename)

	let fp: *File = fopen(filename, "rb")

	if fp == nil {
		printf("error: cannot open file '%s'", filename)
		return 0
	}

	let n: SizeT = fread(bufptr, 1, SizeT buf_size, fp)

	printf("LOADED: %zu bytes\n", n)

	if showText {
		var i = SizeT 0
		while i < (n / 4) {
			printf("%08zx: 0x%08x\n", i, (unsafe *[]Nat32 bufptr)[i])
			i = i + 4
		}

		printf("-----------\n")
	}

	fclose(fp)

	return unsafe Nat32 n
}


func show_mem () -> Unit {
	var i = Nat32 0
	let ramptr: *[]Word8 = bus.get_ram_ptr()
	while i < 256 {
		printf("%08X", i * 16)

		var j = Nat32 0
		while j < 16 {
			printf(" %02X", ramptr[i + j])
			j = j + 1
		}

		printf("\n")

		i = i + 16
	}
}

