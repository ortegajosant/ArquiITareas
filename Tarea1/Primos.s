primeSet	MOV		R2, #0x500
		MOV 		R3, #0x700
		MOV		R7, #1
		MOV		R6, #0
		;;		Es el ciclo para verificar si el número es primo
primeLoop	LDR		R8, [R2]
		MOV		R8, #55
		CMP		R8, #1 ;; Compara con 1
		BEQ		notPrime
		CMP		R8, #2 ;; Compara con 2
		BEQ		isPrime
		CMP		R8, #3 ;; Compara con 3
		BEQ		isPrime
		MOV		R9, #1 ;; Inicializa el primer valor para evaluar primalidad
divider	ADD		R9, R9, #1
		CMP		R9, R8
		BEQ		isPrime
		MOV		R10, R8
divLoop	SUB		R10, R10, R9
		CMP		R10, R9
		BEQ		notPrime
		BLT		divider
		B		divLoop
isPrime	STR		R7, [R3]
		B		check
notPrime	STR		R6, [R3]
		B		check
check	CMP		R2, #0x550
		BEQ		finish
		ADD		R2, R2, #0x4
		ADD		R3, R3, #0x4
		B		primeLoop
finish	END
