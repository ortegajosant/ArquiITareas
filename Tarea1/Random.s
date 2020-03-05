setup	MOV		R1, #0x65
		MOV		R2, #0x500
		;;		Inicia cálculo de numeros aleatorios
random	CMP		R2, #0x550
		BEQ		primeSet
		;;		Obtiene bit 8
		AND		R3, R1, #1
		;;		Obtiene bit 6
		LSR		R4, R1, #2
		AND		R4, R4, #1
		;;		Obtiene bit 5
		LSR		R5, R1, #3
		AND		R5, R5, #1
		;;		Obtiene bit 4
		LSR		R6, R1, #4
		AND		R6, R6, #1
		;;		Inicia XOR
		EOR		R7, R3, R4 ;; XOR 8 y 6
		EOR		R7, R7, R5 ;; XOR R7 y 5
		EOR		R7, R7, R6 ;; XOR R7 y 4
		;;		Ajusta el nuevo número
		LSL		R7, R7, #7
		LSR		R1, R1, #1
		ADD		R1, R7, R1
		STR		R1, [R2]
		ADD		R2, R2, #0x4
		B		random
		;;		Inicia con el cálculo de números primos
primeSet	MOV		R2, #0x500
		MOV		R3, #0x700
		MOV		R7, #1
		MOV		R6, #0
		;;		Es el ciclo para verificar si el número es primo
primeLoop	LDR		R8, [R2]
		CMP		R8, #1 ;; Compara con 1
		BEQ		notPrime
		CMP		R8, #2 ;; Compara con 2
		BEQ		isPrime
		CMP		R8, #3 ;; Compara con 3
		BEQ		isPrime
		MOV		R9, #1 ;; Inicializa el primer valor para evaluar primalidad
divider	CMP		R2, #0x550
		BEQ		finish
		ADD		R9, R9, #1
		CMP		R9, R8
		BEQ		isPrime
		MOV		R10, R8
divLoop	SUB		R10, R10, R9
		CMP		R10, R9
		BEQ		notPrime
		CMP		R10, R9
		BLT		divider
		B		divLoop
isPrime	STR		R7, [R3]
		B		check
notPrime	STR		R6, [R3]
		B		check
check	ADD		R2, R2, #0x4
		ADD		R3, R3, #0x4
		B		primeLoop
finish	END