#ifndef __VM_SYS__
#define __VM_SYS__

#include <stdint.h>

#define mmioStart  0xF00C0000
#define mmioSize  0xFFFF
#define mmioEnd	(mmioStart + mmioSize)

#define consoleMMIOAdr			   (mmioStart + 0x10)
#define consolePrintCHAR8_ADR		(consoleMMIOAdr + 0x00)
#define consoleScanChar8Adr		  (consoleMMIOAdr + 0x01)
#define consolePrintInt32Adr		 (consoleMMIOAdr + 0x10)
#define consolePrintUInt32Adr		(consoleMMIOAdr + 0x14)
#define consolePrintInt32HexAdr	  (consoleMMIOAdr + 0x18)
#define consolePrintUInt32HexAdr	 (consoleMMIOAdr + 0x1C)

// not implemented
//#define consolePrintInt64Adr		(consoleMMIOAdr + 0x20)
//#define consolePrintUInt64Adr	   (consoleMMIOAdr + 0x28)

#define CONSOLE_PUT_CHAR8  (*((volatile uint8_t *)CONSOLE_PUT_CHAR8_ADR))
#define CONSOLE_GET_CHAR8  (*((volatile uint8_t *)CONSOLE_GET_CHAR8_ADR))


#endif  /* __VM_SYS__ */
