
#include <stdint.h>

#include "vm_sys.h"
#include "console.h"
#include "system.h"

#include <stdarg.h>

#include "printf.h"


uint32_t a = 0x12345678;
uint32_t b = 0xA5A5A5A5;

char *str = "Hello world!";

void zset(void *mem, uint32_t len);
void mcpy(void *dst, void *src, uint32_t len);


char k[8] = {1, 2, 3, 4, 5, 6, 7, 8};
char j[8];



char buf1[1024];
char buf2[1024];

int main()
{
	int a = 10;
	int b = 5;
	int c = b - a;

	printf("Hello World!\n");
	printf("%% = '%%'\n");
	printf("c = '%c'\n", '$');
	printf("s = \"%s\"\n", "Hi!");
	printf("d = %d\n", 123);
	printf("-d = %d\n", -103);
	printf("x = 0x%x\n", 0x1234567F);
	
	
	//mcpy(buf2, buf1, 1024);
	
	mcpy(j, k, 8);
	
	zset(k, 8);
	
	int i = 0;
	while (i < 8) {
		printf("k[%d] = %d\n", i, (int)k[i]);
		i = i + 1;
	}
	
	i = 0;
	while (i < 8) {
		printf("j[%d] = %d\n", i, (int)j[i]);
		i = i + 1;
	}
	
	

    //asm("csrrw    %0, misa, %1");
	//asm("ebreak");
    
    uint32_t prev_value;
    uint32_t new_value = 1;
    
    __asm__ volatile ("csrrw    %0, misa, %1"  
                      : "=r" (prev_value) /* output: register %0 */
                      : "r" (new_value)  /* input : register */
                      : /* clobbers: none */);

	//volatile uint32_t x = 0x80001200;

	/*if (1) {
		// memory violation
		int *p = 0x222222;
		*p = 0;
	}*/

    return 0;
}

