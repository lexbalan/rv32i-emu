
#include <stdarg.h>


void putchar(char c) {
	write(0, &c, 1);
}



void printf_hex32(int d);
void printf_dec32(int d);
void printf_str8(char *s);


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

			if (c == 'd') {
				int d = va_arg(a_list, int);
				printf_dec32(d);
			} else if (c == 'x') {
				int d = va_arg(a_list, int);
				printf_hex32(d);
			} else if (c == 's') {
				char *s = va_arg(a_list, char*);
				printf_str8(s);
			} else if (c == 'c') {
				int c = va_arg(a_list, char);
				putchar(c);
			}

		} else {
			putchar(c);
		}

		i = i + 1;
	}

	va_end(a_list);

	return 0;
}


void printf_hex32(int d)
{
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


void printf_dec32(int d)
{
	char cc[10] = {0};
	int i = 0;
	int n;
	do {
		n = d % 10;
		d = d / 10;
		cc[i] = '0' + n;
		i = i + 1;
	} while (d);

	while(i) {
		--i;
		putchar(cc[i]);
	}
}


void printf_str8(char *s)
{
	while (1) {
		const char c = *s;
		if (c == 0) {
			break;
		}
		putchar(c);
		++s;
	}
}

