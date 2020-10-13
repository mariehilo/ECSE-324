			.text
			.global _start

_start:  
			LDR R0, =RESULT 	// R0 points to the result
			LDR R1,[R0,#4] 		// R1 holds N; Load R1 from the address in R0 plus 4 
          	MOV R2, #1 			// Value of the accumulator
        	BL FACTORIAL 		// Call the subroutine (branch to FACTORIAL)
         	B END				// Branch to DONE


FACTORIAL: 
           	PUSH {R0-R2}		// Push R0, R1, R2
            MUL R2,R2,R1		// Multiply R1 and R2 and store in R2
           	SUBS R1,R1,#1		// Decrements the counter
          	BEQ EXIT			// Branch back if equals 
         	B FACTORIAL			// Branch back to FACTORIAL loop 

EXIT:
            LDR R0, =RESULT 	// R0 points to the result 
            MOV R0, R2			// Storing R2 into R0 
            BX LR				// Branch to the instruction in the link register -- goes to BL FACTORIAL then DONE 

END:        B END
RESULT:     .word 0
N:          .word 3
