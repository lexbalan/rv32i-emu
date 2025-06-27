
#include <stdint.h>
#include <stdarg.h>

#include "../sys/printf.h"
#include "../sys/console.h"
#include "../sys/system.h"
#include "../sys/base.h"
#include "../sys/vm_sys.h"


int main()
{
	printf("Hello World!\n");

	asm("ecall");
	asm("ebreak");

	return 0;
}


