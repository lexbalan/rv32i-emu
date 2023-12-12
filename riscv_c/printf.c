
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

				if (d < 0) {
					putchar('-');
					//d = 7546234;
					//asm("ebreak");
					d = 0 - d;
				}

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
			} else if (c == '%') {
				putchar('%');
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
	char cc[8] = {0};
	int pos = 8;

	int i = 0;
	int n;

	do {
		n = d % 16;
		d = d / 16;

		char c;
		if (n <= 9) {
			c = '0' + n;
		} else {
			c = 'A' + (n - 10);
		}

		cc[i] = c;
		i = i + 1;
	} while (d);

	while(i) {
		--i;
		putchar(cc[i]);
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

