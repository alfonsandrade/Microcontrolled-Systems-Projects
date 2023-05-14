;interrupt.s
; - configura SW1 e SW2 da placa EK-TM4C1294XL
; - habilita interrupcoes de SW1 e SW2 da placa EK-TM4C1294XL

; -------------------------------------------------------------------------------
	THUMB	; instrucoes do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declaracoes EQU - Defines
; ========================
; Definicoes dos Registradores Gerais
SYSCTL_RCGCGPIO_R	EQU 0x400FE608
SYSCTL_PRGPIO_R		EQU 0x400FEA08	
NVIC_EN1_R			EQU 0xE000E104 ;registrador de fontes de interrupcao de 32 a 63
NVIC_PRI12_R		EQU 0xE000E430 ;registrador de prioridades para fonte de interrupcao de 48 a 51

; ========================
; Definicoes dos Ports

; PORT J
GPIO_PORTJ               	EQU 2_000000100000000
GPIO_PORTJ_AHB_LOCK_R    	EQU 0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU 0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU 0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU 0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU 0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU 0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU 0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU 0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU 0x400603FC
GPIO_PORTJ_AHB_IM_R     	EQU 0x40060410
GPIO_PORTJ_AHB_IS_R			EQU 0x40060404
GPIO_PORTJ_AHB_IBE_R		EQU 0x40060408
GPIO_PORTJ_AHB_IEV_R		EQU 0x4006040C
GPIO_PORTJ_AHB_ICR_R    	EQU 0x4006041C
GPIO_PORTJ_AHB_RIS_R		EQU 0x40060414

; -------------------------------------------------------------------------------
; Area de Codigo - Tudo abaixo da diretiva a seguir sera armazenado na memoria de 
; codigo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma funcao do arquivo for chamada em outro arquivo	
		EXPORT SW1_SW2_init
			
		IMPORT IS_LOCKED

;--------------------------------------------------------------------------------
; Funcao SW1_SW2_init
; Parametro de entrada: Nao tem
; Parametro de saida: Nao tem
SW1_SW2_init
	;=====================
	; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
	LDR R0, =SYSCTL_RCGCGPIO_R
	LDR R1, [R0]
	ORR R1, #GPIO_PORTJ ;ativa port J
	STR R1, [R0]
	
	; verificar no PRGPIO se a porta está pronta para uso.
	LDR R0, =SYSCTL_PRGPIO_R
Espera_Porta
	LDR R1, [R0]		;carrega informacao do PRGPIO_R
	MOV R2, #GPIO_PORTJ	;seleciona o bit da porta J
	AND R1, R1, R2		;seleciona apenas os bits das portas referentes
	TST R1, R2			;compara se os bits estao iguais
	BEQ Espera_Porta
	
	; 2. Limpar o AMSEL para desabilitar a analógica
	LDR R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta J
	LDR R1, [R0]
	BIC R1, #2_1 	;PJ0_AMSEL = 0: SW1 desabilitado porta analogica	
	BIC R1, #2_10 	;PJ1_AMSEL = 0: SW2 desabilitado porta analogica
	STR R1, [R0]
	
	; 3. Limpar PCTL para selecionar o GPIO
	LDR R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta J
	LDR R1, [R0]
	BIC R1, #2_1	;PJ0_PCTL = 0: SW1 modo GPIO
	BIC R1, #2_10	;PJ1_PCTL = 0: SW2 modo GPIO
	STR R1, [R0]
	
	; 4. DIR para 0: input (BIC), 1: output (ORR)
	LDR R0, =GPIO_PORTJ_AHB_DIR_R
	LDR R1, [R0]
	BIC R1, #2_1	;PJ0_DIR = 0: SW1 input
	BIC R1, #2_10	;PJ1_DIR = 0: SW2 input
	STR R1, [R0]
	
	; 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem funcao alternativa
	LDR R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta J
	LDR R1, [R0]
	BIC R1, #2_1	;PJ0_AFSEL = 0: SW1 sem funcao alternativa
	BIC R1, #2_10	;PJ1_AFSEL = 0: SW2 sem funcao alternativa
	STR R1, [R0]
	
	; 6. Setar os bits de DEN para habilitar I/O digital
	LDR R0, =GPIO_PORTJ_AHB_DEN_R
	LDR R1, [R0]
	ORR R1, #2_1	;PJ0_DEN = 1: SW1 modo I/O digital
	ORR R1, #2_10	;PJ1_DEN = 1: SW2 modo I/O digital
	STR R1, [R0]
	
	; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
	LDR R0, =GPIO_PORTJ_AHB_PUR_R
	LDR R1, [R0]
	ORR R1, #2_1	;PJ0_PUR = 1: SW1 com resistor de pull-up interno
	ORR R1, #2_10	;PJ1_PUR = 1: SW2 com resistor de pull-up interno
	STR R1, [R0]
	
	; configura interrupcoes
	PUSH {LR}
	BL interrupt_config
	POP {LR}
	
	BX  LR ;return

;--------------------------------------------------------------------------------
; Funcao interrupt_config
; Parametro de entrada: Nao tem
; Parametro de saida: Nao tem
interrupt_config

	;desabilita as interrupcoes do port J (0:disable, 1:enable)
	LDR R0, =GPIO_PORTJ_AHB_IM_R
	LDR R1, [R0]
	BIC	R1, #2_01	;PJ0_AHB_IM = 0: desabilita interrupcoes de SW1
	BIC R1, #2_10	;PJ1_AHB_IM = 0: desabilita interrupcoes de SW2
	STR	R1, [R0]
	
	; configura interrupcao como borda
	LDR	R0, =GPIO_PORTJ_AHB_IS_R
	LDR R1, [R0]
	BIC	R1, #2_01	;PJ0_IS = 0: interrupcao de SW1 por borda
	BIC R1, #2_10	;PJ1_IS = 0: interrupcao de SW2 por borda
	STR	R1, [R0]
	
	; configura interrupcao borda unica
	LDR	R0, =GPIO_PORTJ_AHB_IBE_R
	LDR R1, [R0]
	BIC R1, #2_01	;PJ0_IBE = 0: interrupcao de SW1 por borda unica
	BIC	R1, #2_10	;PJ1_IBE = 0: interrupcao de SW2 por borda unica
	STR	R1, [R0]
	
	;Configurar borda de descida para J0 e borda de subida para J1 no registrador GPIOIEV
	LDR	R0, =GPIO_PORTJ_AHB_IEV_R
	LDR R1, [R0]
	BIC R1, #2_01	;PJ0_IEV = 0: interrupcao de SW1 por borda de descida
	ORR R1, #2_10	;PJ1_IEV = 1: interrupcao de SW2 por borda de subida
	STR R1, [R0]
	
	;Seta os bits para garantir que a interrupcao sera atendida limpando o 
	; GPIORIS e GPIOMIS, realizando o ACK no registrador
	; GPIOICR para ambos os pinos.
	LDR	R0, =GPIO_PORTJ_AHB_ICR_R
	LDR R1, [R0]
	ORR R1, #2_01	;PJ0_ICR = 1: conclui interrupcao para SW1 (possibilita nova interrupcao)
	ORR R1, #2_10	;PJ1_ICR = 1: conclui interrupcao para SW2 (possibilita nova interrupcao)
	STR	R1, [R0]
	
	; reabilita as interrupcoes do port J  (0:disable, 1:enable)
	LDR R0, =GPIO_PORTJ_AHB_IM_R
	LDR R1, [R0]
	ORR	R1, #2_01 	;PJ0_IM = 1: habilita interrupcoes de SW1
	ORR R1, #2_10	;PJ1_IM = 1: habilita interrupcoes de SW2
	STR	R1, [R0]
			
	; ativar a fonte geral de interrupcoes no NVIC
	LDR R0, =NVIC_EN1_R	;numero da interrupcao do port J: 51 (Tabela 2-9 pg 116 datasheet)
	LDR R1, [R0]
	MOV	R2, #2_1
	LSL	R2, #19		;numero 51 -> bit 19 do port J
	ORR	R1, R1, R2	;NVIC_EN1: bit 19 = 1
	STR	R1, [R0]
			
	; define a prioridade da fonte de interrupcao
	LDR	R0, =NVIC_PRI12_R	; PRIX12: configura prioridade da interrupcao do numero 48 (1a posicao) a 51 (4a posicao)
	LDR	R1, [R0]
	MOV R2, #2_111
	LSL R2, #29		
	BIC	R1, R2		;limpa bits 29, 30 e 31 do reg PRI12
	MOV	R3, #5 		;define a prioridade
	LSL	R3, #29		;4a posicao do reg PRI12
	ORR	R1, R1, R3	;escreve os bits 29, 30 e 31 do reg PRI12
	STR R1, [R0]
			
	BX LR ;retorno

; -------------------------------------------------------------------------------
; Função GPIOPortJ_Handler (Tratamento de interrupcao da PORT J)
; Parâmetro de entrada: Não tem
; Parâmetro de saída: nao tem
GPIOPortJ_Handler
	; destrava cofre
	LDR R0, =IS_LOCKED
	MOV R1, #0
	STRB R1, [R0]	;escreve em 1 byte
	
	; habilita novamente a interrupcao da port J (SW1 e SW2)
	LDR R0, =GPIO_PORTJ_AHB_ICR_R
	LDR R1, [R0]
	ORR R1, #2_11
	STR R1, [R0]

	BX LR	; return

; -------------------------------------------------------------------------------
; fim do arquivo
	ALIGN	; garante que o fim da secao esta alinhada 
    END		; fim do arquivo