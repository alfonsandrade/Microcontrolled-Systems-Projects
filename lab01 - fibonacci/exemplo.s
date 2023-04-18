; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>

; -------------------------------------------------------------------------------
;
ADDR_VETOR EQU 0x20000500
ADDR_ORDENADO EQU 0x20000600

; Função main()
Start  
; Comece o código aqui <======================================================

	; atribuicao dos ponteiros
	LDR R0, =ADDR_VETOR
	MOV R2, #0
	
	; insereção dos valores na RAM a partir de 0x2000 0500
	MOV R3, #3
	STRB R3, [R0], #1
	MOV R3, #244
	STRB R3, [R0], #1
	MOV R3, #14
	STRB R3, [R0], #1
	MOV R3, #233
	STRB R3, [R0], #1
	MOV R3, #1
	STRB R3, [R0], #1
	MOV R3, #6
	STRB R3, [R0], #1
	MOV R3, #9
	STRB R3, [R0], #1
	MOV R3, #18
	STRB R3, [R0], #1
	MOV R3, #13
	STRB R3, [R0], #1
	MOV R3, #254
	STRB R3, [R0], #1
	MOV R3, #21
	STRB R3, [R0], #1
	MOV R3, #34
	STRB R3, [R0], #1
	MOV R3, #2
	STRB R3, [R0], #1
	MOV R3, #67
	STRB R3, [R0], #1
	MOV R3, #135
	STRB R3, [R0], #1
	MOV R3, #8
	STRB R3, [R0], #1
	MOV R3, #89
	STRB R3, [R0], #1
	MOV R3, #43
	STRB R3, [R0], #1
	MOV R3, #5
	STRB R3, [R0], #1
	MOV R3, #105
	STRB R3, [R0], #1
	MOV R3, #144
	STRB R3, [R0], #1
	MOV R3, #201
	STRB R3, [R0], #1
	MOV R3, #55
	STRB R3, [R0], #1
	
	; selecao dos numeros de fibonacci
	LDR R0, =ADDR_VETOR
	LDR R1, =ADDR_ORDENADO
	MOV R2, #0
proxValor
	LDRB R3, [R0], #1
	CMP R3, #0
	BEQ selectionSort
	MOV R4, #0
	MOV R5, #1
proxFibonacci
	ADD R6, R5, R4
	MOV R4, R5
	MOV R5, R6
	CMP R3, R6
	ITTT EQ
		STRBEQ R3, [R1], #1
		ADDEQ R2, R2, #1
		BEQ proxValor
	CMP R3, R6
	BLO proxValor
	BHS proxFibonacci
	
	; ordena os valores da RAM
selectionSort
	LDR R1, =ADDR_ORDENADO
	MOV R3, #0 ;indice i
	MOV R4, #0 ;indice do menor
	MOV R5, #0 ;indice j
	MOV R6, #0 ;valor [i]
	MOV R7, #0 ;valor [j]
	MOV R10, #0 ; aux1
	MOV R11, #0 ; aux2
proxMenor
	CMP R3, R2
	BHS fimDoPrograma
	MOV R4, R3
	ADD R5, R4, #1
proxComparador
	CMP R5, R2
	BHS trocar
	LDRB R6, [R1, R4]
	LDRB R7, [R1, R5]
	CMP R7, R6
	IT LO
		MOVLO R4, R5
	ADD R5, R5, #1
	B proxComparador
trocar
	LDRB R10, [R1, R4]
	LDRB R11, [R1, R3]
	STRB R10, [R1, R3]
	STRB R11, [R1, R4]
	ADD R3, R3, #1
	B proxMenor

fimDoPrograma
	NOP
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
