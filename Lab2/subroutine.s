				.text
				.global _start

_start:			LDR R0, =NUMBERS			// R0 points to the first number
				LDR	R1, N					// R1 contains the numbers of elements
				PUSH {R0, R1, LR}			// Push parameters and link register (LR) 
				BL SUBROUTINE				// Call the subroutine using BL; Copies the address of the instruction into LR 
				LDR R0, [SP, #4]			// Get the return value from stack
				STR R0, RESULT				// Store R0 in RESULT memory
				LDR	LR, [SP, #8]			// Restore LR by loading LR from the address in SP plus 8
				ADD SP, SP, #12				// Remove the params from the stack

stop:			B stop						// End
				
SUBROUTINE:		PUSH {R0-R3}				// Push R0, R1, R2, R3 		
				LDR R1, [SP, #20]			// Load R1 from the address in SP plus 20 
				LDR R2, [SP, #16]			// Load R2 from the address in SP plus 16
				LDR R0, [R2]				// Load the value of the first number (R2) into R0

LOOP:			SUBS R1, R1,#1				// Decrement the loop
				BEQ end						// End the loop
				ADD R2, R2, #4				// R2 points to the next value in the list
				LDR	R3, [R2]				// R3 holds the next value in the list
				CMP R0, R3					// Check if it is lesser than the minimum
				BLE LOOP					// Branch if less than or equal
				MOV R0, R3					// Update the current minimum (R0)
				B LOOP						// Branch to LOOP 

end:			STR R0, [SP, #20]			// Store the smallest (minimum) number in the stack
				BX LR						// Branch to the instruction in the link register -- goes to BL SUBROUTINE

NUMBERS:		.word	69,11,6
N:				.word	6
RESULT:			.word	0
				.end
