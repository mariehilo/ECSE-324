			.text
			.global _start

_start:		LDR R4, =N			// R4 points to the N location (the pointer of the stack) 
			LDR R2, [R4]		// R2 holds the number of elements in the list; Loads the number of numbers into R2
			ADD R3,	R4, #4 		// R3 points to the first number 

LOOP:		SUBS R2, R2, #1 	// Decrement the loop counter 
			BLT DONE			// Branch to DONE if R2 is lower than 0 -- branch if lower than
			LDR R0, [R3] 		// R0 holds the number that is pointed by R3
			ADD R3, R3, #4		// R3 points to the next number in the list
			SUBS SP, SP, #4		// Update the stack pointer
			STR R0, [SP]		// Set the new top element (store the value at that spot) 
			B LOOP          	// Branch back to LOOP
						

DONE:		LDR R1, [SP]		// Pop the top element into R1
			ADD SP, SP, #4		// Update the stack pointer (top) by increasing SP
 			LDR R2, [SP]		// Pop the top element into R2
			ADD SP, SP, #4		// Update the stack pointer (top) by increasing SP
			LDR R3, [SP]		// Pop the top element into R3
			ADD SP, SP, #4		// Update the new top by increasing SP(return to its initial state)

END:		B END 				// Infinite loop


N:		 	.word	3
NUMBERS:	.word	2,3,4		//the list of numbers
