			.text 
			.global _start

_start:
   			LDR R4, =RESULT 	// Store memory address of result in R4
			LDR R2, [R4,#4] 	// [R4,#4] gives the value that is stored in memory at the address R4 shifted by 4 bytes
			ADD R3, R4, #8 		// R3 will hold the address that was stored in R4, shifted by 8 bytes. This is where the number list starts
			LDR R0, [R3] 		// R0 holds the first number in the list which will eventually be the max
			LDR R5, [R3] 		// R5 holds the first number in the list which will eventually be the min

LOOP: 	
			SUBS R2, R2, #1 	// Decrement R2 by one
			BEQ DONE 			// If the counter is 0, end the loop (go to DONE)
			ADD R3, R3, #4 		// Increment R3 by 4, which results in the memory address stored in R3 to be shifted by 4 bytes (R3 points to the next number in the list)
			LDR R1, [R3] 		// R1 holds the next number in the list; we load the value that R3 points at into R1
			CMP R0, R1 			// Compare R0 to R1 to check if it is greater than the maximum
			BGE MIN 			// If R1 is not greater than R0, branch to MIN
			MOV R0, R1 			// If R1 is greater than R0, update the current max
			B LOOP 				// Branch back to the loop to continue iterating over the elements of the array

MIN: 		CMP R5, R1 			// Compare R5 and R1
			BLE LOOP 			// If R5 is smaller than R1, go back to LOOP to iterate over another element
			MOV R5, R1 			// If R1 is smaller than R5, R1 becomes the new global min and it is stored in R5
			B LOOP 				// Go back to the LOOP to iterate over the rest of the numbers

DONE: 
			SUB R6, R0, R5 		// Subtract the minimum, R5, from the maximum, R0 and put the result in R6 
			STR R6,[R4] 		// Store R6 in the address of R4

END:		B END

RESULT: 	.word 0
N:			.word 7
NUMBERS:	.word 9,5,3,6
			.word 1,9,2
