setup	MOV		R2, #0x500 ;; Posición inicial de la palabra
		ADD		R12, R2,#0x34 ;; Posición final
		MOV		R1, #0x43 ;; C
		STR		R1, [R2]
		MOV		R1, #0x6C ;; l
		STR		R1, [R2, #4]
		MOV		R1, #0x61 ;; a
		STR		R1, [R2, #8]
		MOV		R1, #0x75 ;; u
		STR		R1, [R2, #12]
		MOV		R1, #0x64 ;; d
		STR		R1, [R2, #16]
		MOV		R1, #0x65 ;; e
		STR		R1, [R2, #20]
		MOV		R1, #0x20 ;; Space
		STR		R1, [R2, #24]
		MOV		R1, #0x53 ;; S
		STR		R1, [R2, #28]
		MOV		R1, #0x68 ;; h
		STR		R1, [R2, #32]
		MOV		R1, #0x61 ;; a
		STR		R1, [R2, #36]
		MOV		R1, #0x6E ;; n
		STR		R1, [R2, #40]
		MOV		R1, #0x6E ;; n
		STR		R1, [R2, #44]
		MOV		R1, #0x6F ;; o
		STR		R1, [R2, #48]
		MOV		R1, #0x6E ;; n
		STR		R1, [R2, #52]
		;;		Se agrega la suma de 23 al caractér
loop		LDR		R0, [R2] ;; Carga el caractér sin encriptar
		ADD		R0, R0, #23
		BL		lfsrProc ;; Brinca a realizar el cálculo para el siguiente LFSR
		EOR		R1, R0, R1 ;; XOR entre el caracter aumentado y el siguiente LFSR
		STR		R1, [R2] ;; Sobreescribe el valor
		CMP		R2, R12
		BEQ		encryptF
		ADD		R2, R2, #4
		B		loop
		;;		LFSR al valor indicado
lfsrProc	MOV		R1, R0
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
		MOV		PC, LR
encryptF	SUB		R11, R2, #0x500
		MOV		R10, #0x620
		STR		R11, [R10]
		;;		------------------- Desencriptación -------------------
		MOV		R12, #0x500
loopSet	MOV		R9, #0x0
set		LDR		R0, [R12]	;; Palabra
		MOV		R8, R9
		MOV		R11, #0x0   ;; Operando 2
		MOV		R3, #0x7	;; Shift base
		MOV		R6, #0x0	;; Desplazamiento operando 2
cryptLoop	LSR		R1, R0, R3	;; Desplazamiento de la palabra
		AND		R4, R1, #1	;; Bit de la posición actual palabra encriptada
		AND		R8, R8, #1	;; Bit de la posición actual operando 2
		EOR		R8, R8, R4	;; Siguiente bit del operando 2
		ADD		R6, R6, #1	;; Aumenta valor de desplzamiento R6
		LSL		R11, R11, #1	;; Agrega nuevo bit a la palabra
		ADD		R11, R11, R8	;; Se agrega el bit en el final
		SUB		R3, R3, #1
		CMP		R6, #8
		BEQ		lfsrProc2
		B		cryptLoop
lfsrProc2	MOV		R1, R11
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
check	CMP		R7, R9
		BEQ		saveWord
		MOV		R9, #0x1
		B		set
saveWord	SUB		R11, R11, #23 ;; Resta 23 al valor obtenido
		STR		R11, [R12, #512] ;; Lo guarda en memoria
		LDR		R3, [R10]
		ADD		R3, R3, #0x500
		CMP		R12, R3 ;; Verigfica que se haya terminado la palabra
		BEQ		finish
		ADD		R12, R12, #4
		B		loopSet
finish	END
		
