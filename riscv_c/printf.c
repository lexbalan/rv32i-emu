
#include <stdarg.h>


void putchar(char c) {
	write(0, &c, 1);
}


int printf(char *str, ...)
{
    va_list a_list;
    va_start(a_list, str);

	char c;
	int i = 0;
	while (1) {
		c = str[i];
		if (c == 0) {
			break;
		}

		if (c == '%') {
			++i;
			c = str[i];
			++i;

			if (c == 'x') {
				int d = va_arg(a_list, int);

				int pos = 8;
				while(pos) {
					--pos;
					int x = (d >> (pos * 4)) & 0xF;

					c = 'z';
					if (x <= 9) {
						c = '0' + x;
					} else {
						c = 'A' + (x - 10);
					}

					putchar(c);
				}
			}

			continue;

		} else {
			putchar(c);
			i = i + 1;
		}


	}

	va_end(a_list);

	return 0;
}

