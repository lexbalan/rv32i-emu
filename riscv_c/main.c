
#define MMIO_START 0xF00C0000
#define MMMIO_SIZE 0xFFFF
#define MMIO_END   (MMIO_START + MMMIO_SIZE)

#define CONSOLE_MMIO_ADR  (MMIO_START + 0x10)
#define CONSOLE_PUT_ADR   (CONSOLE_MMIO_ADR + 0)
#define CONSOLE_GET_ADR   (CONSOLE_MMIO_ADR + 1)

#define CONSOLE_PUT  (*((volatile char *)CONSOLE_PUT_ADR))
#define CONSOLE_GET  (*((volatile char *)CONSOLE_PUT_ADR))


int main() {
	int i = 0;
	
	while (1) {
		if (i & 1) {
			CONSOLE_PUT = '0' + i;
		}
		i = i + 1;

		if (i > 10) {
			break;
		}
	}
	
	asm("ebreak");

    return 0;
}
