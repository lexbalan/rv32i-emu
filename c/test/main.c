
#include <stdint.h>
#include <stdarg.h>

#include "../sys/printf.h"
#include "../sys/console.h"
#include "../sys/system.h"
#include "../sys/base.h"
#include "../sys/vm_sys.h"
#include "sha256.h"


uint32_t a0 = 0x12345678;
volatile uint32_t b0 = 0xA5A5A5A5;
volatile uint32_t x0;

char *str = "Hello world!";


char k[8] = {1, 2, 3, 4, 5, 6, 7, 8};
char j[8];


char buf1[1024];
char buf2[1024];


uint32_t c0 = 8;
uint32_t d0 = 2;

void yyy();


int main()
{
	volatile int jj = 3;
	int a = 3 * jj;
	int b = 5;
	int c = b - a;

	int u = a0;

	printf("A = %d\n", a);

	printf("Hello World!\n");
	printf("%% = '%%'\n");
	printf("c = '%c'\n", '$');
	printf("s = \"%s\"\n", "Hi!");
	printf("d = %d\n", 123);
	printf("-d = %d\n", -1234);
	printf("x = 0x%x\n", 0x1234567F);

	x0 = a0 | b0;
	printf("a | b = 0x%x\n", x0);
	x0 = a0 & b0;
	printf("a0 & b0 = 0x%x\n", x0);
	x0 = a0 ^ b0;
	printf("a0 ^ b0 = 0x%x\n", x0);
	printf("c0 << d0 = 0x%x\n", c0 << d0);
	printf("c0 >> d0 = 0x%x\n", c0 >> d0);

	test_crc32();

	yyy();

	//mcpy(buf2, buf1, 1024);

//	memcpy(j, k, 8);
//
//	memzero(k, 8);
//
//	int i = 0;
//	while (i < 8) {
//		printf("k[%d] = %d\n", i, (int)k[i]);
//		i = i + 1;
//	}
//
//	i = 0;
//	while (i < 8) {
//		printf("j[%d] = %d\n", i, (int)j[i]);
//		i = i + 1;
//	}

	//asm("csrrw	%0, misa, %1");
	asm("ecall");

	asm("ebreak");

	uint32_t prev_value;
	uint32_t new_value = 1;

	__asm__ volatile ("csrrw  %0, misa, %1"
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



#ifndef __lengthof
#define __lengthof(x) (sizeof(x) / sizeof((x)[0]))
#endif /* __lengthof */


#define datastring  "123456789"
#define expected_hash  0xCBF43926UL

static uint8_t data[9] = datastring;

int test_crc32() {
	printf("CRC32 test\n");

	const uint32_t crc = crc32_run((uint8_t *)&data, __lengthof(data));

	printf("crc32.doHash(\"%s\") = %x\n", (char *)datastring, crc);

	if (crc == expected_hash) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}




#ifndef __lengthof
#define __lengthof(x) (sizeof(x) / sizeof((x)[0]))
#endif /* __lengthof */


#define inputDataLength  32

struct SHA256_TestCase {
	char input_data[inputDataLength];
	uint32_t input_data_len;

	sha256_Hash expected_result;
};
typedef struct SHA256_TestCase SHA256_TestCase;

static SHA256_TestCase test0 = {
	.input_data = "abc",
	.input_data_len = 3,
	.expected_result = {
		0xBA, 0x78, 0x16, 0xBF, 0x8F, 0x1, 0xCF, 0xEA,
		0x41, 0x41, 0x40, 0xDE, 0x5D, 0xAE, 0x22, 0x23,
		0xB0, 0x3, 0x61, 0xA3, 0x96, 0x17, 0x7A, 0x9C,
		0xB4, 0x10, 0xFF, 0x61, 0xF2, 0x0, 0x15, 0xAD
	}
};

static SHA256_TestCase test1 = {
	.input_data = "Hello World!",
	.input_data_len = 12,
	.expected_result = {
		0x7F, 0x83, 0xB1, 0x65, 0x7F, 0xF1, 0xFC, 0x53,
		0xB9, 0x2D, 0xC1, 0x81, 0x48, 0xA1, 0xD6, 0x5D,
		0xFC, 0x2D, 0x4B, 0x1F, 0xA3, 0xD6, 0x77, 0x28,
		0x4A, 0xDD, 0xD2, 0x0, 0x12, 0x6D, 0x90, 0x69
	}
};

#define tests  {&test0, &test1}

static bool doTest(SHA256_TestCase *test) {
	sha256_Hash test_hash;
	uint8_t *const msg = (uint8_t *)&test->input_data;
	const uint32_t msg_len = test->input_data_len;

	sha256_hash(msg, msg_len, &test_hash);

	printf("'%s'", &test->input_data);
	printf(" -> ");

	uint32_t i = 0;
	while (i < sha256_hashSize) {
		printf("%x", test_hash[i]);
		i = i + 1;
	}

	printf("\n");

	//return memcmp(&test_hash, &test->expected_result, sizeof(sha256_Hash)) == 0;
}

void yyy() {
	doTest(&test0);
	doTest(&test1);
}

