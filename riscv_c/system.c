
#include "console.h"
#include "system.h"

int write(int fd, void *data, int len) {
	int i = 0;
	while (i < len) {
		console_print_char8(((char *)data)[i]);
		i = i + 1;
	}
	return i;
}

