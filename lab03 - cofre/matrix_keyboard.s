;matrix_keyboard.s
; Desenvolvido para a placa EK-TM4C1294XL
; Codigo que apresenta algumas funcionalidades:

; -------------------------------------------------------------------------------
	THUMB	; instrucoes do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declaracoes EQU - Defines
; ========================
; Definicoes dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08

COLUMN_1	EQU	2_10000000
COLUMN_2	EQU 2_01000000
COLUMN_3	EQU	2_00100000
COLUMN_4	EQU 2_00010000
LINE_1		EQU 2_1110
LINE_2		EQU 2_1101
LINE_3		EQU 2_1011
LINE_4		EQU 2_0111

; ========================
; Definicoes dos Ports

;PORT L
GPIO_PORTL				EQU 2_10000000000
GPIO_PORTL_DATA_BITS_R  EQU 0x40062000
GPIO_PORTL_DATA_R       EQU 0x400623FC
GPIO_PORTL_DIR_R        EQU 0x40062400
GPIO_PORTL_IS_R         EQU 0x40062404
GPIO_PORTL_IBE_R        EQU 0x40062408
GPIO_PORTL_IEV_R        EQU 0x4006240C
GPIO_PORTL_IM_R         EQU 0x40062410
GPIO_PORTL_RIS_R        EQU 0x40062414
GPIO_PORTL_MIS_R        EQU 0x40062418
GPIO_PORTL_ICR_R        EQU 0x4006241C
GPIO_PORTL_AFSEL_R      EQU 0x40062420
GPIO_PORTL_DR2R_R       EQU 0x40062500
GPIO_PORTL_DR4R_R       EQU 0x40062504
GPIO_PORTL_DR8R_R       EQU 0x40062508
GPIO_PORTL_ODR_R        EQU 0x4006250C
GPIO_PORTL_PUR_R        EQU 0x40062510
GPIO_PORTL_PDR_R        EQU 0x40062514
GPIO_PORTL_SLR_R        EQU 0x40062518
GPIO_PORTL_DEN_R        EQU 0x4006251C
GPIO_PORTL_LOCK_R       EQU 0x40062520
GPIO_PORTL_CR_R         EQU 0x40062524
GPIO_PORTL_AMSEL_R      EQU 0x40062528
GPIO_PORTL_PCTL_R       EQU 0x4006252C
GPIO_PORTL_ADCCTL_R     EQU 0x40062530
GPIO_PORTL_DMACTL_R     EQU 0x40062534
GPIO_PORTL_SI_R         EQU 0x40062538
GPIO_PORTL_DR12R_R      EQU 0x4006253C
GPIO_PORTL_WAKEPEN_R    EQU 0x40062540
GPIO_PORTL_WAKELVL_R    EQU 0x40062544
GPIO_PORTL_WAKESTAT_R   EQU 0x40062548
GPIO_PORTL_PP_R         EQU 0x40062FC0
GPIO_PORTL_PC_R         EQU 0x40062FC4

;PORT M
GPIO_PORTM				EQU 2_1000000000000
GPIO_PORTM_DATA_BITS_R  EQU 0x40063000
GPIO_PORTM_DATA_R       EQU 0x400633FC
GPIO_PORTM_DIR_R        EQU 0x40063400
GPIO_PORTM_IS_R         EQU 0x40063404
GPIO_PORTM_IBE_R        EQU 0x40063408
GPIO_PORTM_IEV_R        EQU 0x4006340C
GPIO_PORTM_IM_R         EQU 0x40063410
GPIO_PORTM_RIS_R        EQU 0x40063414
GPIO_PORTM_MIS_R        EQU 0x40063418
GPIO_PORTM_ICR_R        EQU 0x4006341C
GPIO_PORTM_AFSEL_R      EQU 0x40063420
GPIO_PORTM_DR2R_R       EQU 0x40063500
GPIO_PORTM_DR4R_R       EQU 0x40063504
GPIO_PORTM_DR8R_R       EQU 0x40063508
GPIO_PORTM_ODR_R        EQU 0x4006350C
GPIO_PORTM_PUR_R        EQU 0x40063510
GPIO_PORTM_PDR_R        EQU 0x40063514
GPIO_PORTM_SLR_R        EQU 0x40063518
GPIO_PORTM_DEN_R        EQU 0x4006351C
GPIO_PORTM_LOCK_R       EQU 0x40063520
GPIO_PORTM_CR_R         EQU 0x40063524
GPIO_PORTM_AMSEL_R      EQU 0x40063528
GPIO_PORTM_PCTL_R       EQU 0x4006352C
GPIO_PORTM_ADCCTL_R     EQU 0x40063530
GPIO_PORTM_DMACTL_R     EQU 0x40063534
GPIO_PORTM_SI_R         EQU 0x40063538
GPIO_PORTM_DR12R_R      EQU 0x4006353C
GPIO_PORTM_WAKEPEN_R    EQU 0x40063540
GPIO_PORTM_WAKELVL_R    EQU 0x40063544
GPIO_PORTM_WAKESTAT_R   EQU 0x40063548
GPIO_PORTM_PP_R         EQU 0x40063FC0
GPIO_PORTM_PC_R         EQU 0x40063FC4

; -------------------------------------------------------------------------------
; Area de Codigo - Tudo abaixo da diretiva a seguir sera armazenado na memoria de 
; codigo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma funcao do arquivo for chamada em outro arquivo	
		EXPORT MKBOARD_init
		EXPORT MKBOARD_getValuePressed
		EXPORT MKBOARD_valueToASCII
			
		IMPORT SysTick_Wait1us
		IMPORT SysTick_Wait1ms

;--------------------------------------------------------------------------------
; Funcao MKBOARD_init
; Parametro de entrada: Nao tem
; Parametro de saida: Nao tem
MKBOARD_init
;=====================
	;FALTA IMPLEMENTAR ESCRITA AMIGAVEL DAQUI PARA BAIXO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	; VER arquivo LCD.S
	; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
	LDR	R0, =SYSCTL_RCGCGPIO_R  ;Carrega o endereço do registrador RCGCGPIO
	LDR R1, [R0]
	ORR	R1, #GPIO_PORTL         ; teclado - PINOS LINHAS 
	ORR R1, #GPIO_PORTM			; teclado - PINOS COLUNAS
    STR R1, [R0]				;Move para a memória os bits das portas no endereço do RCGCGPIO

	; verificar no PRGPIO se a porta está pronta para uso.
	LDR R0, =SYSCTL_PRGPIO_R	;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
Espera_Porta  
	LDR R1, [R0]				;Lê da memória o conteúdo do endereço do registrador
	MOV R2, #GPIO_PORTL
	ORR R2, #GPIO_PORTM
	AND R1, R1, R2		;seleciona apenas os bits das portas referentes
	TST R1, R2			;compara se os bits estao iguais
	BEQ Espera_Porta	;Se o flag Z=1, volta para o laço. Senão continua executando
 
	; 2. Limpar o AMSEL para desabilitar a analógica
	LDR R0, =GPIO_PORTL_AMSEL_R
	LDR R1, [R0]
	BIC R1, #0xF	; L0 a L3 = 0 : desabilita analogica
	STR R1, [R0]
	
	LDR R0, =GPIO_PORTM_AMSEL_R
	LDR R1, [R0]
	BIC R1, #0xF0	; M4 a M7 = 0 : desabilita analogica
	STR R1, [R0]
 
	; 3. Limpar PCTL para selecionar o GPIO
	LDR R0, =GPIO_PORTL_PCTL_R
	LDR R1, [R0]
	BIC R1, R1, #0xF	;L0 a L3 = 0: seleciona modo GPIO
	STR R1, [R0]
	
	LDR R0, =GPIO_PORTM_PCTL_R
	LDR R1, [R0]
	BIC R1, R1, #0xF0	;M4 a M7 = 0: seleciona modo GPIO
	STR R1, [R0]

	; 4. DIR para 0: input (BIC), 1: output (ORR)
    LDR R0, =GPIO_PORTL_DIR_R
	LDR R1, [R0]
	BIC R1, R1, #0xF	;L0 a L3 = 0: INPUT
    STR R1, [R0]
	
    LDR R0, =GPIO_PORTM_DIR_R
	LDR R1, [R0]
	ORR	R1, R1, #0xF0	;M4 a M7 = 1: OUTPUT
    STR R1, [R0]
			
	; 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem função alternativa
	LDR R0, =GPIO_PORTL_AFSEL_R
	LDR R1, [R0]
	BIC R1, R1, #0xF	;L0 a L3 = 0: sem funcao alternativa
	STR R1, [R0]
	LDR R0, =GPIO_PORTM_AFSEL_R
	LDR R1, [R0]
	BIC R1, R1, #0xF0	;M4 a M7 = 0: sem funcao alternativa
	STR R1, [R0]
			
	; 6. Setar os bits de DEN para habilitar I/O digital
	LDR R0, =GPIO_PORTL_DEN_R	;carrega o endereço do DEN
	LDR R1, [R0]
	ORR R1, R1, #0xF	;L0 a L3 = 1: habilita I/O digital
	STR R1, [R0]
 
	LDR R0, =GPIO_PORTM_DEN_R
	LDR R1, [R0]
	ORR R1, R1, #0xF0	;M4 a M7 = 1: habilita I/O digital
	STR R1, [R0]

	; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
	LDR R0, =GPIO_PORTL_PUR_R	;Carrega o endereço do PUR
	LDR R1, [R0]
	ORR R1, R1, #0xF	;L0 a L3 = 1: habilita funcionalidade digital de resistor de pull-up
    STR R1, [R0]

	BX  LR ;return

;--------------------------------------------------------------------------------
; Funcao MKBOARD_getValuePressed
; Parametro de entrada: Nao tem
; Parametro de saida: R0:
; 1: 0x1 ;2: 0x2 	; ...
; A: 0xA ;...		; D: 0xD ; *: 0xE ; #: 0xF
; nenhuma tecla pressionada: 0xFF
MKBOARD_getValuePressed
	PUSH {R1, R2, R3, R4, R5, R6} ;armazena registradores utilizados
	
init_count_deboucing
	MOV R1, #0	;reseta contador de deboucing
	MOV R2, #2_10000000 ;inicia na coluna 4
set_column
	LDR R5, =GPIO_PORTM_DATA_R	;Colunas
	LDR R6, [R5]	;pega dados da porta M (coluna)
	AND R6, #0xF0	;seleciona apenas os bits de 4 a 7
	ORR R6, #0xF0	;seta apenas os bits de 4 a 7
	BIC	R6, R2		;limpa apenas o bit da coluna
	STR R6, [R5]	;seta coluna a ser lida
	
	LDR R5, =GPIO_PORTL_DATA_R	;Linhas
	LDR R3, [R5]		;pega dados da porta L (linha)
	AND R3, #0xF		;captura apenas os primeiros 4 bits (linhas)
	CMP R3, #2_1110
	BEQ check_boucing	;se primeira linha pressionada
	CMP R3, #2_1101
	BEQ check_boucing	;se segunda linha pressionada
	CMP R3, #2_1011
	BEQ check_boucing	;se terceira linha pressionada
	CMP R3, #2_0111
	BEQ check_boucing	;se quarta linha pressionada
	
	LSR R2, #1 ;shifta 1 bit
	CMP R2, #2_00001000	;verifica se terminou as colunas
	BNE set_column
	; se terminou as colunas, entao nenhuma tecla foi pressionada
	MOV R0, #0xFF
	B return_MKBOARD_getValuePressed

check_boucing
	; espera 5ms
	MOV R0, #5
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
	
	; verifica se o botao ainda continua pressionado
	LDR R5, =GPIO_PORTL_DATA_R	;Linhas
	LDR R4, [R5]	;captura novamente a linha e coluna pressionada
	AND R4, #0xF	;captura apenas os primeiros 4 bits
	CMP R3, R4		;verifica se continua igual
	BNE init_count_deboucing ;se nao continua, reseta o contador
	ADD R1, #1	;soma 1 ao contador
	CMP R1, #20	;verifica se atingiu valor estavel
	BNE check_boucing	;se nao atingiu, verifica novamente

select_value
	; pega define o botao que foi pressionado
	MOV R0, #0
	ORR R0, R2, R3 ; R0 = C|L
	CMP R0, #2_00011110 ; C1, L1
	ITT EQ
		MOVEQ R0, #0x1
		BEQ return_MKBOARD_getValuePressed
	CMP R0, #2_00011101; C1, L2
	ITT EQ
		MOVEQ R0, #0x4
		BEQ return_MKBOARD_getValuePressed
	CMP R0, #2_00011011; C1, L3
	ITT EQ
		MOVEQ R0, #0x7
		BEQ return_MKBOARD_getValuePressed
	CMP R0, #2_00010111; C1, L4
	ITT EQ
		MOVEQ R0, #0xE ; *
		BEQ return_MKBOARD_getValuePressed
	CMP R0, #2_00101110; C2, L1
	ITT EQ
		MOVEQ R0, #0x2
		BEQ return_MKBOARD_getValuePressed
	CMP R0, #2_00101101; C2, L2
	ITT EQ
		MOVEQ R0, #0x5
		BEQ return_MKBOARD_getValuePressed
	CMP R0, #2_00101011; C2, L3
	ITT EQ
		MOVEQ R0, #0x8
		BEQ return_MKBOARD_getValuePressed
	CMP R0, #2_00100111; C2, L4
	ITT EQ
		MOVEQ R0, #0x0
		BEQ return_MKBOARD_getValuePressed
	CMP R0, #2_01001110; C3, L1
	ITT EQ
		MOVEQ R0, #0x3
		BEQ return_MKBOARD_getValuePressed
	CMP R0, #2_01001101; C3, L2
	ITT EQ
		MOVEQ R0, #0x6
		BEQ return_MKBOARD_getValuePressed
	CMP R0, #2_01001011; C3, L3
	ITT EQ
		MOVEQ R0, #0x9
		BEQ return_MKBOARD_getValuePressed
	CMP R0, #2_01000111; C3, L4
	ITT EQ
		MOVEQ R0, #0xF; #
		BEQ return_MKBOARD_getValuePressed
	CMP R0, #2_10001110; C4, L1
	ITT EQ
		MOVEQ R0, #0xA
		BEQ return_MKBOARD_getValuePressed
	CMP R0, #2_10001101; C4, L2
	ITT EQ
		MOVEQ R0, #0xB
		BEQ return_MKBOARD_getValuePressed
	CMP R0, #2_10001011; C4, L3
	ITT EQ
		MOVEQ R0, #0xC
		BEQ return_MKBOARD_getValuePressed
	MOV R0, #0xD	
	
return_MKBOARD_getValuePressed
	POP {R1, R2, R3, R4, R5, R6}
	BX LR ;return

;--------------------------------------------------------------------------------
; Funcao MKBOARD_valueToASCII
; Parametro de entrada: R0: Valor em exadecimal
; Parametro de saida: R0: Valor em ASCII
; Valores diferentes: 
; A: 0xA ;...		; D: 0xD ; *: 0xE ; #: 0xF
; nenhuma tecla pressionada: 0xFF
MKBOARD_valueToASCII
	CMP R0, #0x0
	ITT EQ
		MOVEQ R0, #'0'
		BEQ return_valueToASCII
	CMP R0, #0x1
	ITT EQ
		MOVEQ R0, #'1'
		BEQ return_valueToASCII
	CMP R0, #0x2
	ITT EQ
		MOVEQ R0, #'2'
		BEQ return_valueToASCII
	CMP R0, #0x3
	ITT EQ
		MOVEQ R0, #'3'
		BEQ return_valueToASCII
	CMP R0, #0x4
	ITT EQ
		MOVEQ R0, #'4'
		BEQ return_valueToASCII
	CMP R0, #0x5
	ITT EQ
		MOVEQ R0, #'5'
		BEQ return_valueToASCII
	CMP R0, #0x6
	ITT EQ
		MOVEQ R0, #'6'
		BEQ return_valueToASCII
	CMP R0, #0x7
	ITT EQ
		MOVEQ R0, #'7'
		BEQ return_valueToASCII
	CMP R0, #0x8
	ITT EQ
		MOVEQ R0, #'8'
		BEQ return_valueToASCII
	CMP R0, #0x9
	ITT EQ
		MOVEQ R0, #'9'
		BEQ return_valueToASCII
	CMP R0, #0xA
	ITT EQ
		MOVEQ R0, #'A'
		BEQ return_valueToASCII
	CMP R0, #0xB
	ITT EQ
		MOVEQ R0, #'B'
		BEQ return_valueToASCII
	CMP R0, #0xC
	ITT EQ
		MOVEQ R0, #'C'
		BEQ return_valueToASCII
	CMP R0, #0xD
	ITT EQ
		MOVEQ R0, #'D'
		BEQ return_valueToASCII
	CMP R0, #0xE
	ITT EQ
		MOVEQ R0, #'E'
		BEQ return_valueToASCII
	MOV R0, #'F'
return_valueToASCII
	BX LR ; return

; -------------------------------------------------------------------------------
; fim do arquivo
	ALIGN                           ; garante que o fim da se??o est? alinhada 
    END                             ; fim do arquivo