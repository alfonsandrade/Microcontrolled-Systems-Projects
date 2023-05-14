;leds_and_displays.s
; Desenvolvido para a placa EK-TM4C1294XL

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; Definições de Valores
BIT0	EQU	0x01
BIT1	EQU	0x02
BIT2	EQU	0x04
BIT3	EQU	0x08
BIT4	EQU	0x10
BIT5	EQU	0x20
BIT6	EQU	0x40
BIT7	EQU	0x80

DISP_DIG_0 EQU 2_00111111
DISP_DIG_1 EQU 2_00000110
DISP_DIG_2 EQU 2_01011011
DISP_DIG_3 EQU 2_01001111
DISP_DIG_4 EQU 2_01100110
DISP_DIG_5 EQU 2_01101101
DISP_DIG_6 EQU 2_01111101
DISP_DIG_7 EQU 2_00000111
DISP_DIG_8 EQU 2_01111111
DISP_DIG_9 EQU 2_01101111
DISP_DIG_A EQU 2_01110111
DISP_DIG_B EQU 2_01111100
DISP_DIG_C EQU 2_00111001
DISP_DIG_D EQU 2_01011110
DISP_DIG_E EQU 2_01111001
DISP_DIG_F EQU 2_01110001

; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08

; ========================
; Definições dos Ports

; PORT Q
GPIO_PORTA				EQU 2_000000000000001
GPIO_PORTB				EQU 2_000000000000010
GPIO_PORTC				EQU 2_000000000000100
GPIO_PORTD				EQU 2_000000000001000
GPIO_PORTE				EQU 2_000000000010000
GPIO_PORTF				EQU 2_000000000100000
GPIO_PORTG				EQU	2_000000001000000
GPIO_PORTH				EQU 2_000000010000000
GPIO_PORTJ				EQU 2_000000100000000
GPIO_PORTK				EQU 2_000001000000000
GPIO_PORTL				EQU 2_000010000000000
GPIO_PORTM				EQU 2_000100000000000
GPIO_PORTN				EQU 2_001000000000000
GPIO_PORTP				EQU 2_010000000000000
GPIO_PORTQ				EQU 2_100000000000000

; PORT A
GPIO_PORTA_DATA_BITS_R  EQU 0x40058000
GPIO_PORTA_DATA_R       EQU 0x400583FC
GPIO_PORTA_DIR_R        EQU 0x40058400
GPIO_PORTA_IS_R         EQU 0x40058404
GPIO_PORTA_IBE_R        EQU 0x40058408
GPIO_PORTA_IEV_R        EQU 0x4005840C
GPIO_PORTA_IM_R         EQU 0x40058410
GPIO_PORTA_RIS_R        EQU 0x40058414
GPIO_PORTA_MIS_R        EQU 0x40058418
GPIO_PORTA_ICR_R        EQU 0x4005841C
GPIO_PORTA_AFSEL_R      EQU 0x40058420
GPIO_PORTA_DR2R_R       EQU 0x40058500
GPIO_PORTA_DR4R_R       EQU 0x40058504
GPIO_PORTA_DR8R_R       EQU 0x40058508
GPIO_PORTA_ODR_R        EQU 0x4005850C
GPIO_PORTA_PUR_R        EQU 0x40058510
GPIO_PORTA_PDR_R        EQU 0x40058514
GPIO_PORTA_SLR_R        EQU 0x40058518
GPIO_PORTA_DEN_R        EQU 0x4005851C
GPIO_PORTA_LOCK_R       EQU 0x40058520
GPIO_PORTA_CR_R         EQU 0x40058524
GPIO_PORTA_AMSEL_R      EQU 0x40058528
GPIO_PORTA_PCTL_R       EQU 0x4005852C
GPIO_PORTA_ADCCTL_R     EQU 0x40058530
GPIO_PORTA_DMACTL_R     EQU 0x40058534
GPIO_PORTA_SI_R         EQU 0x40058538
GPIO_PORTA_DR12R_R      EQU 0x4005853C
GPIO_PORTA_WAKEPEN_R    EQU 0x40058540
GPIO_PORTA_WAKELVL_R    EQU 0x40058544
GPIO_PORTA_WAKESTAT_R   EQU 0x40058548
GPIO_PORTA_PP_R         EQU 0x40058FC0
GPIO_PORTA_PC_R         EQU 0x40058FC4

; PORT B
GPIO_PORTB_DATA_BITS_R  EQU 0x40059000
GPIO_PORTB_DATA_R       EQU 0x400593FC
GPIO_PORTB_DIR_R        EQU 0x40059400
GPIO_PORTB_IS_R         EQU 0x40059404
GPIO_PORTB_IBE_R        EQU 0x40059408
GPIO_PORTB_IEV_R        EQU 0x4005940C
GPIO_PORTB_IM_R         EQU 0x40059410
GPIO_PORTB_RIS_R        EQU 0x40059414
GPIO_PORTB_MIS_R        EQU 0x40059418
GPIO_PORTB_ICR_R        EQU 0x4005941C
GPIO_PORTB_AFSEL_R      EQU 0x40059420
GPIO_PORTB_DR2R_R       EQU 0x40059500
GPIO_PORTB_DR4R_R       EQU 0x40059504
GPIO_PORTB_DR8R_R       EQU 0x40059508
GPIO_PORTB_ODR_R        EQU 0x4005950C
GPIO_PORTB_PUR_R        EQU 0x40059510
GPIO_PORTB_PDR_R        EQU 0x40059514
GPIO_PORTB_SLR_R        EQU 0x40059518
GPIO_PORTB_DEN_R        EQU 0x4005951C
GPIO_PORTB_LOCK_R       EQU 0x40059520
GPIO_PORTB_CR_R         EQU 0x40059524
GPIO_PORTB_AMSEL_R      EQU 0x40059528
GPIO_PORTB_PCTL_R       EQU 0x4005952C
GPIO_PORTB_ADCCTL_R     EQU 0x40059530
GPIO_PORTB_DMACTL_R     EQU 0x40059534
GPIO_PORTB_SI_R         EQU 0x40059538
GPIO_PORTB_DR12R_R      EQU 0x4005953C
GPIO_PORTB_WAKEPEN_R    EQU 0x40059540
GPIO_PORTB_WAKELVL_R    EQU 0x40059544
GPIO_PORTB_WAKESTAT_R   EQU 0x40059548
GPIO_PORTB_PP_R         EQU 0x40059FC0
GPIO_PORTB_PC_R         EQU 0x40059FC4

; PORT P
GPIO_PORTP_DATA_BITS_R  EQU 0x40065000
GPIO_PORTP_DATA_R       EQU 0x400653FC
GPIO_PORTP_DIR_R        EQU 0x40065400
GPIO_PORTP_IS_R         EQU 0x40065404
GPIO_PORTP_IBE_R        EQU 0x40065408
GPIO_PORTP_IEV_R        EQU 0x4006540C
GPIO_PORTP_IM_R         EQU 0x40065410
GPIO_PORTP_RIS_R        EQU 0x40065414
GPIO_PORTP_MIS_R        EQU 0x40065418
GPIO_PORTP_ICR_R        EQU 0x4006541C
GPIO_PORTP_AFSEL_R      EQU 0x40065420
GPIO_PORTP_DR2R_R       EQU 0x40065500
GPIO_PORTP_DR4R_R       EQU 0x40065504
GPIO_PORTP_DR8R_R       EQU 0x40065508
GPIO_PORTP_ODR_R        EQU 0x4006550C
GPIO_PORTP_PUR_R        EQU 0x40065510
GPIO_PORTP_PDR_R        EQU 0x40065514
GPIO_PORTP_SLR_R        EQU 0x40065518
GPIO_PORTP_DEN_R        EQU 0x4006551C
GPIO_PORTP_LOCK_R       EQU 0x40065520
GPIO_PORTP_CR_R         EQU 0x40065524
GPIO_PORTP_AMSEL_R      EQU 0x40065528
GPIO_PORTP_PCTL_R       EQU 0x4006552C
GPIO_PORTP_ADCCTL_R     EQU 0x40065530
GPIO_PORTP_DMACTL_R     EQU 0x40065534
GPIO_PORTP_SI_R         EQU 0x40065538
GPIO_PORTP_DR12R_R      EQU 0x4006553C
GPIO_PORTP_WAKEPEN_R    EQU 0x40065540
GPIO_PORTP_WAKELVL_R    EQU 0x40065544
GPIO_PORTP_WAKESTAT_R   EQU 0x40065548
GPIO_PORTP_PP_R         EQU 0x40065FC0
GPIO_PORTP_PC_R         EQU 0x40065FC4

; PORT Q
GPIO_PORTQ_DATA_BITS_R  EQU 0x40066000
GPIO_PORTQ_DATA_R       EQU 0x400663FC
GPIO_PORTQ_DIR_R        EQU 0x40066400
GPIO_PORTQ_IS_R         EQU 0x40066404
GPIO_PORTQ_IBE_R        EQU 0x40066408
GPIO_PORTQ_IEV_R        EQU 0x4006640C
GPIO_PORTQ_IM_R         EQU 0x40066410
GPIO_PORTQ_RIS_R        EQU 0x40066414
GPIO_PORTQ_MIS_R        EQU 0x40066418
GPIO_PORTQ_ICR_R        EQU 0x4006641C
GPIO_PORTQ_AFSEL_R      EQU 0x40066420
GPIO_PORTQ_DR2R_R       EQU 0x40066500
GPIO_PORTQ_DR4R_R       EQU 0x40066504
GPIO_PORTQ_DR8R_R       EQU 0x40066508
GPIO_PORTQ_ODR_R        EQU 0x4006650C
GPIO_PORTQ_PUR_R        EQU 0x40066510
GPIO_PORTQ_PDR_R        EQU 0x40066514
GPIO_PORTQ_SLR_R        EQU 0x40066518
GPIO_PORTQ_DEN_R        EQU 0x4006651C
GPIO_PORTQ_LOCK_R       EQU 0x40066520
GPIO_PORTQ_CR_R         EQU 0x40066524
GPIO_PORTQ_AMSEL_R      EQU 0x40066528
GPIO_PORTQ_PCTL_R       EQU 0x4006652C
GPIO_PORTQ_ADCCTL_R     EQU 0x40066530
GPIO_PORTQ_DMACTL_R     EQU 0x40066534
GPIO_PORTQ_SI_R         EQU 0x40066538
GPIO_PORTQ_DR12R_R      EQU 0x4006653C
GPIO_PORTQ_WAKEPEN_R    EQU 0x40066540
GPIO_PORTQ_WAKELVL_R    EQU 0x40066544
GPIO_PORTQ_WAKESTAT_R   EQU 0x40066548
GPIO_PORTQ_PP_R         EQU 0x40066FC0
GPIO_PORTQ_PC_R         EQU 0x40066FC4

; -------------------------------------------------------------------------------
; Area de Codigo - Tudo abaixo da diretiva a seguir sera armazenado na memoria de 
; codigo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma funcao do arquivo for chamada em outro arquivo	
		EXPORT LEDS_AND_DISPLAYS_init
		EXPORT select_leds
		EXPORT select_dig_DS
		EXPORT turn_leds_ON
		EXPORT turn_DS1_ON
		EXPORT turn_DS2_ON
			
		IMPORT SysTick_Wait1us
		IMPORT SysTick_Wait1ms

;--------------------------------------------------------------------------------
; Funcao MKBOARD_init
; Parametro de entrada: Nao tem
; Parametro de saida: Nao tem
LEDS_AND_DISPLAYS_init
;=====================
	; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
	LDR	R0, =SYSCTL_RCGCGPIO_R  ;Carrega o endereço do registrador RCGCGPIO
	LDR R1, [R0]
	ORR	R1, #GPIO_PORTA         ; leds 8 a 5 + disp: 'd' a 'DP'
	ORR	R1, #GPIO_PORTQ			; leds 1 a 4 + disp: 'a' a 'c'
	ORR R1, #GPIO_PORTB			; acionamento dos displays
	ORR R1, #GPIO_PORTP			; acionamento dos leds
    STR R1, [R0]				;Move para a memória os bits das portas no endereço do RCGCGPIO

	; verificar no PRGPIO se a porta está pronta para uso.
	LDR R0, =SYSCTL_PRGPIO_R	;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
Espera_Porta  
	LDR R1, [R0]				;Lê da memória o conteúdo do endereço do registrador
	MOV R2, #GPIO_PORTA
	ORR R2, #GPIO_PORTQ
	ORR R2, #GPIO_PORTB
	ORR R2, #GPIO_PORTP
	AND R1, R1, R2		;seleciona apenas os bits das portas referentes
	TST R1, R2			;compara se os bits estao iguais
	BEQ Espera_Porta	;Se o flag Z=1, volta para o laço. Senão continua executando
 
	; 2. Limpar o AMSEL para desabilitar a analógica
	LDR R0, =GPIO_PORTA_AMSEL_R
	LDR R1, [R0]
	BIC R1, #0xF0	; A4 a A7 = 0 : desabilita analogica (leds e display)
	STR R1, [R0]
	LDR R0, =GPIO_PORTQ_AMSEL_R
	LDR R1, [R0]
	BIC R1, #0x0F	; Q0 a Q3 = 0 : desabilita analogica (leds e display)
	STR R1, [R0]
	LDR R0, =GPIO_PORTB_AMSEL_R
	LDR R1, [R0]
	BIC R1, #BIT4  ; B4 = 0: desabilita analogica (on/off DS1)
	BIC R1, #BIT5  ; B5 = 0: desabilita analogica (on/off DS2)
	STR R1, [R0]
	LDR R0, =GPIO_PORTP_AMSEL_R
	LDR R1, [R0]
	BIC R1, #BIT5	; P5 = 0: desabilita analogica (on/off leds)
	STR R1, [R0]
 
	; 3. Limpar PCTL para selecionar o GPIO
	LDR R0, =GPIO_PORTA_PCTL_R
	LDR R1, [R0]
	BIC R1, #0xF0	; A4 a A7 = 0 : seleciona modo GPIO (leds e display)
	STR R1, [R0]
	LDR R0, =GPIO_PORTQ_PCTL_R
	LDR R1, [R0]
	BIC R1, #0x0F	; Q0 a Q3 = 0: seleciona modo GPIO (leds e displays)
	STR R1, [R0]
	LDR R0, =GPIO_PORTB_PCTL_R
	LDR R1, [R0]
	BIC R1, #BIT4	; B4 = 0: seleciona modo GPIO (acionamento DS1)
	BIC R1, #BIT5	; B5 = 0: seleciona modo GPIO (acionamento DS2)
	STR R1, [R0]
	LDR R0, =GPIO_PORTP_PCTL_R
	LDR R1, [R0]
	BIC R1, #BIT5	; P5 = 0: seleciona modo GPIO (acionamento dos leds)
	STR R1, [R0]

	; 4. DIR para 0: input (BIC), 1: output (ORR)
    LDR R0, =GPIO_PORTA_DIR_R
	LDR R1, [R0]
	ORR R1, #0xF0	;A4 a A7 = 1: OUTPUT
    STR R1, [R0]
	LDR R0, =GPIO_PORTQ_DIR_R
	LDR R1, [R0]
	ORR R1, #0x0F	;Q0 a Q3 = 1: OUTPUT
	STR R1, [R0]
	LDR R0, =GPIO_PORTB_DIR_R
	LDR R1, [R0]
	ORR R1, #BIT4	;B4 = 1: output (on/off DS1)
	ORR R1, #BIT5	;B5 = 1: output (on/off DS2)
	STR R1, [R0]
	LDR R0, =GPIO_PORTP_DIR_R
	LDR R1, [R0]
	ORR R1, #BIT5	;P5 = 1: output (on/off leds)
	STR R1, [R0]
			
	; 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem função alternativa
	LDR R0, =GPIO_PORTA_AFSEL_R
	LDR R1, [R0]
	BIC R1, #0xF0 ; A4 a A7 = 0: sem funcao alternativa
	STR R1, [R0]
	LDR R0, =GPIO_PORTQ_AFSEL_R
	LDR R1, [R0]
	BIC R1, #0x0F ; Q0 a Q3 = 0: sem funcao alternativa
	STR R1, [R0]
	LDR R0, =GPIO_PORTB_AFSEL_R
	LDR R1, [R0]
	BIC R1, #BIT4 ; B4 = 0: sem funcao alternativa
	BIC R1, #BIT5 ; B5 = 0: sem funcao alternativa
	STR R1, [R0]
	LDR R0, =GPIO_PORTP_AFSEL_R
	LDR R1, [R0]
	BIC R1, #BIT5 ; P5 = 0: sem funcao alternativa
	STR R1, [R0]
			
	; 6. Setar os bits de DEN para habilitar I/O digital
	LDR R0, =GPIO_PORTA_DEN_R
	LDR R1, [R0]
	ORR R1, #0xF0	;A4 a A7 = 1 : habilita I/O digital
	STR R1, [R0]
	LDR R0, =GPIO_PORTQ_DEN_R
	LDR R1, [R0]
	ORR R1, #0x0F	;Q0 a Q3 = 1: habilita I/O digital
	STR R1, [R0]
	LDR R0, =GPIO_PORTB_DEN_R
	LDR R1, [R0]
	ORR R1, #BIT4	;B4 = 1 :habilita I/O digital
	ORR R1, #BIT5	;B5 = 1 :habilita I/O digital
	STR R1, [R0]
	LDR R0, =GPIO_PORTP_DEN_R
	LDR R1, [R0]
	ORR R1, #BIT5	;P5 = 1 :habilita I/O digital
	STR R1, [R0]

	; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
	; N/A

	BX  LR ;return
	
; -------------------------------------------------------------------------------
; Função select_leds
; Parâmetro de entrada: R0 --> 2_XXXXXXXX X=1: led selecionado, X=0: led nao selecioando
; Parâmetro de saída: Não tem
select_leds
	PUSH {R1, R2, R3} 	;armazena registradores utilizados
	
	LDR	R1, =GPIO_PORTQ_DATA_R
	LDR R2, [R1]
	BIC R2, #0x0F		; limpa o primeiro nibble
	AND R3, R0, #0x0F 	; pega o primeiro nibble do R0
	ORR R2, R3			; concatena a entrada com os valores ja setados
	STR R2, [R1]		; escreve no registrador
	
	LDR R1, =GPIO_PORTA_DATA_R
	LDR R2, [R1]
	BIC R2, #0xF0	;limpa o segundo nibble
	AND R3, R0, #0xF0	;pega o segundo nibble do R0
	ORR R2, R3			;concatena a entrada com os valores ja setados
	STR R2, [R1]		;escreve no registrador

	POP {R1, R2, R3}	;devolve registradores utilizados
	BX LR	;return

; -------------------------------------------------------------------------------
; Função select_dig_DS
; Parâmetro de entrada: R0 --> 0 a F, R0 != 0 a F => R0 = 0
; Parâmetro de saída: Não tem
select_dig_DS
	AND R0, #0xF 	;seleciona os 4 primeiros bits de R0
	;seta os bits dos leds correspondentes de acordo com o digito
	CMP R0, #0x1
	ITT	EQ
		LDREQ	R0, =DISP_DIG_1
		BEQ 	select_dig_DS_end		
	CMP R0, #0x2
	ITT	EQ
		LDREQ	R0, =DISP_DIG_2
		BEQ 	select_dig_DS_end
	CMP R0, #0x3
	ITT EQ
		LDREQ	R0, =DISP_DIG_3
		BEQ 	select_dig_DS_end
	CMP R0, #0x4
	ITT EQ
		LDREQ	R0, =DISP_DIG_4
		BEQ 	select_dig_DS_end
	CMP R0, #0x5
	ITT EQ
		LDREQ	R0, =DISP_DIG_5
		BEQ 	select_dig_DS_end
	CMP R0, #0x6
	ITT EQ
		LDREQ	R0, =DISP_DIG_6
		BEQ 	select_dig_DS_end
	CMP R0, #0x7
	ITT EQ
		LDREQ	R0, =DISP_DIG_7
		BEQ 	select_dig_DS_end
	CMP R0, #0x8
	ITT EQ
		LDREQ	R0, =DISP_DIG_8
		BEQ 	select_dig_DS_end
	CMP R0, #0x9
	ITT EQ
		LDREQ	R0, =DISP_DIG_9
		BEQ 	select_dig_DS_end
	CMP R0, #0xa
	ITT EQ
		LDREQ	R0, =DISP_DIG_A
		BEQ 	select_dig_DS_end
	CMP R0, #0xb
	ITT EQ
		LDREQ	R0, =DISP_DIG_B
		BEQ 	select_dig_DS_end
	CMP R0, #0xc
	ITT EQ
		LDREQ	R0, =DISP_DIG_C
		BEQ 	select_dig_DS_end
	CMP R0, #0xd
	ITT EQ
		LDREQ	R0, =DISP_DIG_D
		BEQ 	select_dig_DS_end
	CMP R0, #0xe
	ITT EQ
		LDREQ	R0, =DISP_DIG_E
		BEQ 	select_dig_DS_end
	CMP R0, #0xf
	ITT EQ
		LDREQ	R0, =DISP_DIG_F
		BEQ 	select_dig_DS_end
	LDR	R0, =DISP_DIG_0
select_dig_DS_end
	PUSH {LR}
	BL select_leds
	POP {LR}
	BX LR

; -------------------------------------------------------------------------------
; Função turn_leds_ON
; Parâmetro de entrada: R0 --> R0 = 0: desliga, R0 != 0: liga
; Parâmetro de saída: Não tem
turn_leds_ON
	PUSH {R1, R2}
	CMP 	R0, #0		;verifica se R0 = 0
	MOVNE 	R0, #BIT5	;se R0 != 0 seta o bit para ligar led (P5)
	LDR 	R1, =GPIO_PORTP_DATA_R	;carrega endereco port P
	LDR 	R2, [R1]
	BIC		R2, #BIT5	;limpa o bit
	ORR		R2, R0		;concatena R2 com R0
	STR 	R2, [R1]	;escreve em port P
	POP {R1, R2}
	BX LR

; -------------------------------------------------------------------------------
; Função turn_DS1_ON
; Parâmetro de entrada: R0 --> R0 = 0: desliga, R0 != 0: liga
; Parâmetro de saída: Não tem
turn_DS1_ON
	PUSH {R1, R2}
	CMP R0, #0
	MOVNE R0, #BIT4				;se R0 != 0 seta o bit para ligar o DS1 B4
	LDR R1, =GPIO_PORTB_DATA_R	;carrega endereco port B
	LDR R2, [R1]				;carrega dado
	BIC R2, #BIT4				;limpa o bit
	ORR R2, R0					;concatena com o parametro
	STR R2, [R1]				;escreve na memoria
	POP {R1, R2}
	BX 	LR						;retorno
	
; -------------------------------------------------------------------------------
; Função turn_DS2_ON
; Parâmetro de entrada: R0 --> R0 = 0: desliga, R0 != 0: liga
; Parâmetro de saída: Não tem
turn_DS2_ON 
	PUSH {R1, R2}
	CMP R0, #0
	MOVNE R0, #BIT5				;seta bit para ligar disp 2 (R0 = TRUE != 0)
	LDR R1, =GPIO_PORTB_DATA_R	;carrega endereco port B
	LDR R2, [R1]				;carrega dado
	BIC R2, #BIT5				;limpa o bit
	ORR R2, R0					;concatena com o parametro
	STR R2, [R1]				;escreve na memoria
	POP {R1, R2}	
	BX LR						;retorno
	
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------
    ALIGN	;Garante que o fim da seção está alinhada 
    END     ;Fim do arquivo