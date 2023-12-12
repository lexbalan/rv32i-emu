
#include <stdarg.h>


void putchar(char c) {
	write(0, &c, 1);
}


char *sprintf_hex32(char *buf, int d);
char *sprintf_dec32(char *buf, int d);
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

			// буффер для печати всего кроме строк
			char buf[10+1];
			char *sptr = &buf[0];

			if (c == 'd') {
				int d = va_arg(a_list, int);

				if (d < 0) {
					putchar('-');
					//asm("ebreak");
					d = -d;
				}

				sprintf_dec32(sptr, d);
			} else if (c == 'x') {
				int d = va_arg(a_list, int);
				sprintf_hex32(sptr, d);
			} else if (c == 's') {
				char *s = va_arg(a_list, char*);
				sptr = s;
			} else if (c == 'c') {
				int c = va_arg(a_list, char);
				sptr[0] = c;
				sptr[1] = 0;
			} else if (c == '%') {
				sptr = "%";
			}

			printf_str8(sptr);

		} else {
			putchar(c);
		}

		i = i + 1;
	}

	va_end(a_list);

	return 0;
}


char *sprintf_hex32(char *buf, int d)
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


	int j = 0;
	while(i) {
		--i;
		buf[j] = cc[i];
		++j;
	}

	buf[j] = 0;

	return buf;
}


char *sprintf_dec32(char *buf, int d)
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


	int j = 0;
	while(i) {
		--i;
		buf[j] = cc[i];
		++j;
	}

	buf[j] = 0;

	return buf;
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

