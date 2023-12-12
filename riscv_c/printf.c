
#include <stdarg.h>


void putchar(char c) {
	write(0, &c, 1);
}



void print_hex32(int d);
void print_dec32(int d);


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

			if (c == 'd') {
				int d = va_arg(a_list, int);
				print_dec32(d);
			} else if (c == 'x') {
				int d = va_arg(a_list, int);
				print_hex32(d);
			} else if (c == 'c') {
				int c = va_arg(a_list, char);
				putchar(c);
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


void print_hex32(int d) {
	char c = 'Z';
	int pos = 8;
	while(pos) {
		--pos;
		int x = (d >> (pos * 4)) & 0xF;

		if (x <= 9) {
			c = '0' + x;
		} else {
			c = 'A' + (x - 10);
		}

		putchar(c);
	}
}



void print_dec32(int d) {

}

