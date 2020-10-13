extern int MIN_2(int x, int y);

int main(void) {
	
	int min_val;
	int a[5] = {20,18,23,24,25};

	min_val = a[0];

	int i;
	for(i=1; i<5; i++) {
		min_val = MIN_2(min_val, a[i]);
	}

	return min_val;
}