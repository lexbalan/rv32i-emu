

int __mulsi3(int a, int b) {
	int n = 0;
	while (b) {
		n = n + a;
		b = b - 1;
	}
	return n;
}


int __modsi3(int divident, int divisor) {
	if (divisor == 0) {
		// x / 0 (!)
	}

	while (divident > divisor) {
		divident = divident - divisor;
	}

	return divident;
}


int __divsi3(int divident, int divisor) {
	if (divisor == 0) {
		// x / 0 (!)
	}

	int r = 0;
	while (1) {
		divident = divident - divisor;
		if (divident <= 0) {
			break;
		}
		r = r + 1;
	}

	return r;
}


