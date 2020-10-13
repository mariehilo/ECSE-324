int main(void) {
	int a[5] = {1, 20, 3, 4, 5}; 
	int min_val = a[0]; 
	int k; 

	for(k=1; k<5; k++) {
		if(min_val > a[k]) {
			min_val = a[k]; 
		}
	}
	return min_val; 
}
