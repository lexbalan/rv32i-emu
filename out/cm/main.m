
@c_include "stdlib.h"
@c_include "stdio.h"
import "mem" as mem
import "core/core" as riscvCore


const text_filename = "./image.bin"

const showText = false


var core: core.Core


//public func mem_violation_event(reason: Nat32) {
//	core.irq(&core, riscvCore.intMemViolation)
//}


public func main() -> ctypes64.Int {
	stdio.printf("RISC-V VM\n")

	var memctl: core.BusInterface = core.BusInterface {
		read8 = &mem.read8
		read16 = &mem.read16
		read32 = &mem.read32
		write8 = &mem.write8
		write16 = &mem.write16
		write32 = &mem.write32
	}

	let romptr = mem.get_rom_ptr()
	let nbytes = loader(text_filename, romptr, mem.romSize)

	if nbytes <= 0 {
		stdlib.exit(1)
	}

	core.init(&core, &memctl)

	stdio.printf("~~~ START ~~~\n")

	while not core.end {
		core.tick(&core)
	}

	stdio.printf("core.cnt = %u\n", core.cnt)

	stdio.printf("\nCore dump:\n")
	core.show_regs(&core)
	stdio.printf("\n")
	show_mem()

	return 0
}


func loader(filename: *Str8, bufptr: *[]Word8, buf_size: Nat32) -> Nat32 {
	stdio.printf("LOAD: %s\n", filename)

	let fp = stdio.fopen(filename, "rb")

	if fp == nil {
		stdio.printf("error: cannot open file '%s'", filename)
		return 0
	}

	let n = stdio.fread(bufptr, 1, ctypes64.SizeT buf_size, fp)

	stdio.printf("LOADED: %zu bytes\n", n)

	if showText {
		var i: ctypes64.SizeT = ctypes64.SizeT 0
		while i < (n / 4) {
			stdio.printf("%08zx: 0x%08x\n", i, (*[]Nat32 bufptr)[i])
			i = i + 4
		}

		stdio.printf("-----------\n")
	}

	stdio.fclose(fp)

	return Nat32 n
}


func show_mem() -> Unit {
	var i: Int32 = 0
	let ramptr = mem.get_ram_ptr()
	while i < 256 {
		stdio.printf("%08X", i * 16)

		var j: Int32 = 0
		while j < 16 {
			stdio.printf(" %02X", ramptr[i + j])
			j = j + 1
		}

		stdio.printf("\n")

		i = i + 16
	}
}

