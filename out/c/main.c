
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "main.h"


#define text_filename  "./image.bin"

static hart_Hart hart;

//public func bus_violation_event(reason: Nat32) {
//	hart.irq(&hart, rvHart.intMemViolation)
//}


static void show_mem();

int main() {
	printf("RISC-V VM\n");

	hart_BusInterface busctl = (hart_BusInterface){
		.read = &bus_read,
		.write = &bus_write
	};

	const uint32_t nbytes = bus_load_rom(text_filename);

	if (nbytes <= 0) {
		exit(1);
	}

	hart_init(&hart, 0, &busctl);

	printf("*** START ***\n");

	while (!hart.end) {
		hart_tick(&hart);
	}

	printf("*** END ***\n");

	printf("hart.cnt = %u\n", hart.cnt);

	printf("\nCore dump:\n");
	hart_show_regs(&hart);
	printf("\n");
	show_mem();

	return 0;
}

static void show_mem() {
	uint32_t i = 0;
	uint8_t *const ramptr = bus_get_ram_ptr();
	while (i < 256) {
		printf("%08X", i * 16);

		uint32_t j = 0;
		while (j < 16) {
			printf(" %02X", ramptr[i + j]);
			j = j + 1;
		}

		printf("\n");

		i = i + 16;
	}
}

