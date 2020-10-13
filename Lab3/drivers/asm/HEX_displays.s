		.text

		.equ HEX_DISP_1, 0xFF200020
		.equ HEX_DISP_2, 0xFF200030	
		.global HEX_clear_ASM
		.global HEX_flood_ASM
		.global HEX_write_ASM

HEX_clear_ASM:					// R0 holds a hot-one encoding of which HEX display
		PUSH {R1-R8,LR}
		LDR R1, =HEX_DISP_1		//Put the location of the HEX3-0 register into R0
		MOV R3, #0				//Hex counter
		
HEX_clear_LOOP:
		CMP R3, #6				//Looping all of them
		BEQ HEX_clear_CORRECT	//If there is an error branch to done

		AND R4, R0, #1			//0x0000 0000 is equal to 0x0000 00001
		CMP R4, #1				//If they are equal it makes it the desired HEX
		BEQ HEX_clear_CORRECT	//Branch to the part that works correctly
							
		ASR R0, R0, #1			//If not equal, then shift by 1 bit
		ADD R3, R3, #1			//Increment counter that will tell which one is our HEX
		B HEX_clear_LOOP		//Loop again if result not correct
		
HEX_clear_CORRECT:
		CMP R3, #3				//If counter is greater than 3, we are at HEX 4 or 5
		SUBGT R3, R3, #4		//Set counter back to either 0 or 1 since the bits are being updated
		LDRGT R1, =HEX_DISP_2	//We set it to the the other display HEX
		LDR R2, [R1]
		MOV R5, #0xFFFFFF00		//Give it an initial value
		B HEX_clear_LOOP2		//To push back

HEX_clear_LOOP2:
		CMP R3, #0				//If not equal to 0, update it
		BEQ HEX_clear_DONE		//Branch to done
		LSL R5, R5, #8			//Shifting left by 8 bits
		ADD R5, R5, #0xFF		//Keeping the empty space constant
		SUB R3, R3, #1			//Decrement the counter
		B HEX_clear_LOOP2

HEX_clear_DONE:
		AND R2, R2, R5			//and ing the two values
		STR R2, [R1]			//Storing back on the display
		POP {R1-R8, R14}
		BX LR

HEX_flood_ASM:					// R0 holds a hot-one encoding of which HEX display
		PUSH {R1-R8,R14}
		LDR R1, =HEX_DISP_1		//Putting location of the HEX3-0 register into R0
		MOV R3, #0				//hex counter
		
HEX_flood_LOOP:
		CMP R3, #6				//Looping all of them
		BEQ HEX_flood_CORRECT	//Branch to done if error

		AND R4, R0, #1			// 0x0000 0000 is equal to 0x0000 00001, Shift if not
		CMP R4, #1				//If they are equal it makes it the desired HEX
		BEQ HEX_flood_CORRECT	//Branch to the part that works correctly
							
		ASR R0, R0, #1			//If not equal, then shift by 1 bit
		ADD R3, R3, #1			//Increment counter that will tell which one is our HEX
		B HEX_flood_LOOP		//Loop again if result not correct
		
HEX_flood_CORRECT:
		CMP R3, #3				//If counter is greater than 3, we are at HEX 4 or 5
		SUBGT R3, R3, #4		//Set counter back to either 0 or 1 since the bits are being updated
		LDRGT R1, =HEX_DISP_2	//We set it to the the other disp HEX
		LDR R2, [R1]
		MOV R5, #0x000000FF		//Give it an initial value
		B HEX_flood_LOOP2		//To push back

HEX_flood_LOOP2:
		CMP R3, #0				//If not equal to 0, update it
		BEQ HEX_flood_DONE		//Branch to done
		LSL R5, R5, #8			//Shifting left by 8 bits
		SUB R3, R3, #1			//Decrement counter
		B HEX_flood_LOOP2

HEX_flood_DONE:
		ORR R2, R2, R5			//We and the two values
		STR R2, [R1]			//We store back on the display
		POP {R1-R8,LR}
		BX LR

//HEX_flood_ASM:					//R0 contains the hex to flood
//		LDR R1, =HEX_DISP_1
//		MOV R2, #0xFFFFFFFF		//setting all as on
//		STR R2, [R1]
//		LDR R1, =HEX_DISP_2
//		STR R2, [R1]
//		BX LR

HEX_write_ASM:					//R0 holds a hot-one encoding of which HEX display, R1 holds the character value
		MOV R10, R0
		MOV R9, R1
		PUSH {R1-R8,LR}
		BL HEX_clear_ASM		//Clear the display we have before doing anything else
		POP {R1-R8,R14}
		MOV R0, R10
		
		PUSH {R1-R8,LR}
		LDR R1, =HEX_DISP_1		//Put location of the HEX3-0 register into R0
		MOV R3, #0				//counter for which hex counts
		B HEX_write_0

HEX_write_0:
		CMP R9, #48
		BNE HEX_write_1
		MOV R5, #0x3F
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_1:	
		CMP R9, #49
		BNE HEX_write_2
		MOV R5, #0x06
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_2:	
		CMP R9, #50
		BNE HEX_write_3
		MOV R5, #0x5B
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_3:	
		CMP R9, #51
		BNE HEX_write_4
		MOV R5, #0x4F
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_4:	
		CMP R9, #52
		BNE HEX_write_5
		MOV R5, #0x66
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_5:	
		CMP R9, #53
		BNE HEX_write_6
		MOV R5, #0x6D
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_6:	
		CMP R9, #54
		BNE HEX_write_7
		MOV R5, #0x7D
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_7:	
		CMP R9, #55
		BNE HEX_write_8
		MOV R5, #0x07
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_8:	
		CMP R9, #56
		BNE HEX_write_9
		MOV R5, #0x7F
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_9:	
		CMP R9, #57
		BNE HEX_write_A
		MOV R5, #0x6F
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_A:	
		CMP R9, #58
		BNE HEX_write_B
		MOV R5, #0x77
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_B:	
		CMP R9, #59
		BNE HEX_write_C
		MOV R5, #0x7C
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_C:	
		CMP R9, #60
		BNE HEX_write_D
		MOV R5, #0x39
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_D:	
		CMP R9, #61
		BNE HEX_write_E
		MOV R5, #0x5E
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_E:	
		CMP R9, #62
		BNE HEX_write_F
		MOV R5, #0x79
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_F:	
		CMP R9, #63
		BNE HEX_write_OFF
		MOV R5, #0x71
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_OFF:
		MOV R5, #0
		MOV R8, R5
		B HEX_write_LOOP
		
HEX_write_LOOP:
		CMP R3, #6				//Loop all
		BEQ HEX_write_CORRECT	//branch to done if error

		AND R4, R0, #1			// 0x0000 0000 is equal to 0x0000 00001, shift if not
		CMP R4, #1				//If they are equal it makes it the desired HEX
		BEQ HEX_write_CORRECT	//Branch to the part that works
							
		ASR R0, R0, #1			//If not equal, then shift by 1 bit
		ADD R3, R3, #1			//Increment counter that will tell which one is our HEX
		B HEX_write_LOOP		//Loop again if result not correct
		
HEX_write_CORRECT:
		CMP R3, #3				//If counter is greater than 3, we are at HEX 4 or 5
		SUBGT R3, R3, #4		//Setting counter back to either 0 or 1 since we are updating the bits
		LDRGT R1, =HEX_DISP_2	//Set it to the the other disp HEX
		LDR R2, [R1]
		MOV R5, R8				//Give R8 an initial value, which is from our switch case
		B HEX_write_LOOP2		//To push

HEX_write_LOOP2:
		CMP R3, #0				//if not equal to 0, we update it
		BEQ HEX_write_DONE		//branch to done		
		LSL R5, R5, #8			//shift left by 8 bits, 
		SUB R3, R3, #1			//decrement counter
		B HEX_write_LOOP2

HEX_write_DONE:
		ORR R2, R2, R5			//we and the two values
		STR R2, [R1]			//we store back on the display
		POP {R1-R8,LR}
		BX LR
		.end
