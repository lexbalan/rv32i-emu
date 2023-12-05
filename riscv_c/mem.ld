/* Thanks https://github.com/darklife/darkriscv */
  __heap_size  = 0x20;  /* required amount of heap */
  __stack_size = 0x40;  /* required amount of stack */


/* Ищет символы строки в 10007fb7 то есть в RAM Нет там стек! */

  MEMORY
  {
    ROM (rwx) : ORIGIN = 0x00000000, LENGTH = 0x10000
    RAM (rwx) : ORIGIN = 0x10000000, LENGTH = 256
  }
  SECTIONS
  {
    /*.text :
    {
      *(boot)
      *(.text)
      *(.rodata*)
	  
	   говорим - размести data тут а сами потом считаем ее в ram 
	  _data_flash_start = .;
	  *(.data)
	  _data_flash_end = .;
	  
    } > ROM
    
    .data :
    {
      *(.sbss)
	  
	  _data_start = .;
      *(.data)
	  _data_end = .;
	  
	  _bss_start = .;
      *(.bss)
	  _bss_end = .;
	  
      *(COMMON)
    } > RAM*/
	
	.boot : {*(boot)} > ROM
	
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
    } >RAM

    .stack :
    {
      . = ALIGN(4);
      _estack = .;
      . = . + __stack_size;
      . = ALIGN(4);
      _sstack = .;
    } >RAM
  }

