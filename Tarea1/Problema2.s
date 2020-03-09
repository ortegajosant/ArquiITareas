setup	MOV		R1, #0x74	;; Semilla para iniciar generador de número aleatorios
		MOV		R2, #0x500 ;; Posición base de memoria
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
		;;		Loop para encontrar si el número es primo o no
divider	CMP		R2, #0x550
		BEQ		finish
		ADD		R9, R9, #1 ;; Aumenta 1 en el divisor actual
		CMP		R9, R8	;; Compara si el número es igual al divisor actual
		BEQ		isPrime	;; Si lo es, entonces es primo
		MOV		R10, R8	;; Si no, entonces continua
divLoop	SUB		R10, R10, R9 ;; Resta el divisor actual
		CMP		R10, R9	;; Compara si el número es igual al divisor actual
		BEQ		notPrime	;; Si es igual al divisor, entonces no es primo
		CMP		R10, R9	;; Compara si es menor al divisor actual
		BLT		divider	;; Si es menor, entoces aumenta en 1 el divisor
		B		divLoop	;; Si no, entonces vuelve al loop para seguir restando el divisor acutal
isPrime	STR		R7, [R2, #512] ;; Guarda el memoria el resultado de Primalidad 1
		B		check
notPrime	STR		R6, [R2, #512]	;; Guarda el memoria el resultado de Primalidad 0
		B		check
check	ADD		R2, R2, #0x4	;; Aumenta en 4 la posicion de memoria
		B		primeLoop		;; Continúa con más números
finish	END
