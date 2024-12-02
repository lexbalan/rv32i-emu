
#include <stdint.h>


void __rt0() {
#if 1
  // Зануление BSS сегмента
  {
	extern void _bss_start, _bss_end;
	uint8_t *const p = &_bss_start;
	const uint32_t bss_size = (uint32_t)&_bss_end - (uint32_t)&_bss_start;

	uint32_t i = 0;
	while (i < bss_size) {
	  p[i] = 0;
	  ++i;
	}
  }
#endif


#if 1
  // Копирование .data сегмента из FLASH в RAM
  {
	extern void _data_start, _data_end, _data_flash_start;
	uint8_t *const dst = &_data_start;
	uint8_t *const src = &_data_flash_start;
	const uint32_t data_size = (uint32_t)&_data_end - (uint32_t)&_data_start;

	uint32_t i = 0;
	while (i < data_size) {
	  dst[i] = src[i];
	  ++i;
	}
  }
#endif
}


extern int main();


extern void* _stack_start; // Объявляем внешний символ, который должен быть определен в линкерном скрипте


// not worked ..
void set_stack_pointer() {
    __asm__ volatile (
        "la sp, _stack_start\n"  // Загружаем адрес _stack_start в sp
    );
}


// if not defined boot section, will be defined firstly (!)
__attribute__ ((section ("boot"))) void __boot() {

#if 1
	__asm__ volatile (
		"add sp, zero, %0"
		:
		: "r" (&_stack_start)  /* input : register */
		: /* clobbers: none */);

#endif
	/*__asm__ volatile (
		"lui   sp, %hi(_stack_start)\n"
		"addi  sp, %lo(_stack_start)\n"
	);*/

//	set_stack_pointer();

	__rt0();
	main();

	__asm__ volatile ("ebreak");
}




