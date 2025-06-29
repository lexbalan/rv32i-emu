import "bus"
import "hart/hart"
include "ctypes"
include "stdlib"
include "stdio"

import "bus" as bus
import "hart/hart" as rvHart


const text_filename = "./image.bin"


var hart: Hart


public func main () -> Int {
	printf("RISC-V VM\n")

	let nbytes: Nat32 = bus.load_rom(text_filename)
	if nbytes <= 0 {
		exit(1)
	}

	var busctl: BusInterface = BusInterface {
		read = &bus.read
		write = &bus.write
	}

	rvHart.init(&hart, 0, &busctl)

	printf("*** START ***\n")

	while not hart.end {
		rvHart.tick(&hart)
	}

	printf("*** END ***\n")
	printf("hart.cnt = %u\n", hart.cnt)

	printf("\nCore dump:\n")
	rvHart.show_regs(&hart)
	printf("\n")
	bus.show_ram()

	return 0
}

