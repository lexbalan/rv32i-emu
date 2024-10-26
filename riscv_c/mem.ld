/* Thanks https://github.com/darklife/darkriscv */

__heap_size  = 0x20;
__stack_size = 0x1FF;


MEMORY
{
	ROM (rx) : ORIGIN = 0x00000000, LENGTH = 0x10000
	RAM (rw) : ORIGIN = 0x10000000, LENGTH = 4096
}

SECTIONS
{
	.boot : {
		*(.isr_vector)
		*(boot)
	} > ROM
	
	.text : {
		*(.text*)
		*(.rodata*)
	} > ROM

	.data : {
		_data_start = .;
		*(.sdata SORT(.data.*))
		*(.data SORT(.data.*))
		_data_end = .;
	} > RAM AT > ROM
	
	_data_flash_start = LOADADDR(.data);
	
	.bss : {
		_bss_start = .;
		*(.sbss SORT(.bss.*) COMMON)
		*(.bss SORT(.bss.*) COMMON)
		_bss_end = .;
	} > RAM
	
	.heap :
	{
		. = ALIGN(4);
		PROVIDE ( end = . );
		_heap_start = .;
		. = . + __heap_size;
		. = ALIGN(4);
		_heap_end = .;
	} > RAM

	.stack :
	{
		. = ALIGN(4);
		_stack_end = .;
		. = . + __stack_size;
		. = ALIGN(4);
		_stack_start = .;
	} > RAM
}

