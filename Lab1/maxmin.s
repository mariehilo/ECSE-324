			.text
			.global _start 
_start:
			LDR R0, =MAX 		// Store the memory address of MAX in R0 - R0 is a pointer to MAX
			LDR R1, =MIN 		// Store the memory address of MIN in R1 - R1 is a pointer to MIN
			LDR R2, [R0, #8] 	// [R0,#8] gives the value that is stored in memory at the address R0 shifted by 8 bytes. R2 holds the number of elements in the list
			ADD R2, R2, #1 		// Add 1 to the contents of R2, which is the counter. and places the sum in R2 (this is needed for the next loop)
			ADD R3, R0, #12		// R3 points to the first number in the list
			LDR R4, [R3]		// Load R4 from the address in R3. R4 therefore holds the first number of the list
			SUB R5, R5, R5		// Clear the R5 register to hold the sum of all numbers in the list (R5 is subtracted from R5 then stored in R5)

//Finding the sum of all the numbers in the list
LOOPSUM:	SUBS R2, R2, #1		// Decrement the counter
			BEQ DONESUM			// If the counter reaches zero, end the loop
			ADD R5, R5, R4		// Add the contents of R4 to the sum (R5) and place it in R5
			ADD R3, R3, #4		// R3 points to the next number on the list 
			LDR R4, [R3]		// Load R4 from the address in R3. R4 holds the next number in the list
			B LOOPSUM

DONESUM:	SUB R6, R6, R6		// Clear the R6 register (R6 is subtracted from R6 then stored in R6) 
			LDR R2, [R0, #8]	// Reinitialize the counter for the next loop by reloading R2, which holds the number of elements in the list
			ADD R3, R0, #12		// R3 points to the first number in the list
			LDR R4, [R3]		// Load R4 from the address in R3. R4 therefore holds the first number of the list

//Finding the maximum of the algebraic expression
LOOPMAX:	SUBS R2, R2, #1		// Decrement the counter (counts the number of iterations) 
			BEQ DONEMAX			// If the counter reaches zero, end the loop
			ADD R3, R3, #4		// R3 points to the next number on the list
			LDR R10, [R3]		// Load the value of the next number in the list (R10) from the address in R3
			ADD R7, R4, R10		// Add the first number of the list (R4)and the next number in the list (R10) together and place it in R7
			SUB R8, R5, R7		// Calculate the sum of the other pair by subtracting the contents of R7 from R5 (sum of list)and place it in R8
			MUL R9, R8, R7		// Multiply both sums (R7 and R8 together) and place it in R9
			CMP R6, R9			// Check if the multiplication, R9, is larger than R6, the current MAX value
			BGE LOOPMAX			// If R9 is smaller than R6, branch back to loop and start again
			MOV R6, R9			// If R9 is larger than R6, update the current max to be R9
			B LOOPMAX			// Branch back to loop

DONEMAX:	STR R6, [R0]		// Store R6 in the address R0 (MAX)
			LDR R2, [R0, #8]	// Reinitialize the counter for the next loop. R2 holds the number of elements in the list
			ADD R3, R0, #12		// R3 points to the first number in the list
			LDR R4, [R3]		// Load the contents of R4 in the address R3

//Finding the minimum of the algebraic expression
LOOPMIN:	SUBS R2, R2, #1		// Decrement the counter (counts the number of iterations) 
			BEQ DONEMIN			// If the counter reaches zero, end the loop 
			ADD R3, R3, #4		// R3 points to the next number on the list
			LDR R10, [R3]		// Load the value of the next number in the list (R10) from the address in R3
			ADD R7, R4, R10		// Add the first number of the list (R4)and the next number in the list (R10) together and place it in R7
			SUB R8, R5, R7		// Calculate the sum of the other pair by subtracting the contents of R7 from R5 (sum of list)and place it in R8
			MUL R9, R8, R7		// Multiply both sums (R7 and R8 together) and place it in R9
			CMP R6, R9			// Check if the multiplication, R9, is larger than R6, the current MIN value
			BLE LOOPMIN			// If R9 is smaller than R6, branch back to loop and start again
			MOV R6, R9			// If R9 is larger than R6, update the current min to be R9
			B LOOPMIN			// Branch back to loop

DONEMIN:	STR R6, [R1]		//Store the result in the memory location R6 (MIN) 

END: 		B END

MAX:		.word	0			
MIN: 		.word	0
N:			.word	4
NUMBERS:	.word	6,11,21,22

			
