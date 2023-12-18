
#include <stdint.h>

#include "console.h"
#include "system.h"


int write(int fd, void *data, int len) {
	int i = 0;
	while (i < len) {
		console_put(((uint8_t *)data)[i]);
		i = i + 1;
	}
	return i;
}

