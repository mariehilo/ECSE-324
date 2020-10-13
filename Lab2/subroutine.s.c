			.text	
			.global	MIN_2
	
MIN_2:
			CMP	R0,	R1
			BXLE LR
			MOV	RO,	R1
			BX LR
			
			.end