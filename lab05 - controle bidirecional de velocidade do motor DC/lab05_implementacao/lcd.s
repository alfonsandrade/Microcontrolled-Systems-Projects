;lcd.s
; Desenvolvido para a placa EK-TM4C1294XL
; Codigo que apresenta algumas funcionalidades:
; LCD_init
; LCD_reset
; LCD_command
; LCD_write_data

; -------------------------------------------------------------------------------
	THUMB	; instrucoes do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declaracoes EQU - Defines
; ========================
; Definicoes dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definicoes dos Ports

; PORT K
GPIO_PORTK              EQU 2_1000000000
GPIO_PORTK_DATA_BITS_R  EQU 0x40061000
GPIO_PORTK_DATA_R       EQU 0x400613FC
GPIO_PORTK_DIR_R        EQU 0x40061400
GPIO_PORTK_IS_R         EQU 0x40061404
GPIO_PORTK_IBE_R        EQU 0x40061408
GPIO_PORTK_IEV_R        EQU 0x4006140C
GPIO_PORTK_IM_R         EQU 0x40061410
GPIO_PORTK_RIS_R        EQU 0x40061414
GPIO_PORTK_MIS_R        EQU 0x40061418
GPIO_PORTK_ICR_R        EQU 0x4006141C
GPIO_PORTK_AFSEL_R      EQU 0x40061420
GPIO_PORTK_DR2R_R       EQU 0x40061500
GPIO_PORTK_DR4R_R       EQU 0x40061504
GPIO_PORTK_DR8R_R       EQU 0x40061508
GPIO_PORTK_ODR_R        EQU 0x4006150C
GPIO_PORTK_PUR_R        EQU 0x40061510
GPIO_PORTK_PDR_R        EQU 0x40061514
GPIO_PORTK_SLR_R        EQU 0x40061518
GPIO_PORTK_DEN_R        EQU 0x4006151C
GPIO_PORTK_LOCK_R       EQU 0x40061520
GPIO_PORTK_CR_R         EQU 0x40061524
GPIO_PORTK_AMSEL_R      EQU 0x40061528
GPIO_PORTK_PCTL_R       EQU 0x4006152C
GPIO_PORTK_ADCCTL_R     EQU 0x40061530
GPIO_PORTK_DMACTL_R     EQU 0x40061534
GPIO_PORTK_SI_R         EQU 0x40061538
GPIO_PORTK_DR12R_R      EQU 0x4006153C
GPIO_PORTK_WAKEPEN_R    EQU 0x40061540
GPIO_PORTK_WAKELVL_R    EQU 0x40061544
GPIO_PORTK_WAKESTAT_R   EQU 0x40061548
GPIO_PORTK_PP_R         EQU 0x40061FC0
GPIO_PORTK_PC_R         EQU 0x40061FC4

; PORT M
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
GPIO_PORTM              EQU 2_100000000000

; -------------------------------------------------------------------------------
; Area de Codigo - Tudo abaixo da diretiva a seguir sera armazenado na memoria de 
; codigo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma funcao do arquivo for chamada em outro arquivo	
		EXPORT LCD_init
		EXPORT LCD_reset
		EXPORT LCD_command
		EXPORT LCD_write_data
		EXPORT LCD_print_string
			
		IMPORT SysTick_Wait1us

;--------------------------------------------------------------------------------
; Funcao LCD_init
; Parametro de entrada: Nao tem
; Parametro de saida: Nao tem
LCD_init
	; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
	LDR	R0, =SYSCTL_RCGCGPIO_R	;carrega o endereco do registrador RCGCGPIO
	LDR R1, [R0]				;carrega dado do registrador
	ORR R1, #GPIO_PORTK			;seta apenas pinos da porta dos PINOS DE DADOS LCD 
	ORR	R1, #GPIO_PORTM			;seta apenas pinos da porta dos PINOS DE COMANDO LCD 
	STR R1, [R0]				;move para a memoria os bits das portas no endereco do RCGCGPIO

	; verificar no PRGPIO se a porta esta pronta para uso.
	LDR R0, =SYSCTL_PRGPIO_R	;carrega o endere�o do PRGPIO para esperar os GPIO ficarem prontos
Espera_porta
	LDR	R1, [R0]			;le da memoria o conteudo do endere�o do registrador
	MOV	R2, #GPIO_PORTK		;LCD - PINOS DE DADOS
	ORR	R2, #GPIO_PORTM		;LCD - PINOS DE COMANDO
	AND R1, R1, R2			;seleciona apenas os pinos de porta de comparacao
	TST R1, R2				;ANDS de R1 com R2
	BEQ Espera_porta		;Se o flag Z=1, volta para o la�o. Sen�o continua executando
	
	; 2. Limpar o AMSEL para desabilitar a anal�gica
	LDR	R0, =GPIO_PORTK_AMSEL_R	;LCD - PINOS DE DADOS
	LDR R1, [R0]
	BIC R1, #0xFF	; Pinos PK0 a PK7 = 0: desabilita analogica
	STR R1, [R0]
	
	LDR	R0, =GPIO_PORTM_AMSEL_R	;LCD - PINOS DE COMANDOS
	LDR R1, [R0]
	BIC R1, #2_111	; Pinos M0 a M2 = 0: desabilita analogica
	STR	R1, [R0]
	
	; 3. Limpar PCTL para selecionar o GPIO
	LDR	R0, =GPIO_PORTK_PCTL_R	;LCD - PINOS DE DADOS
	LDR R1, [R0]
	BIC R1, #0xFF	; Pinos PK0 a PK7 = 0: seleciona modo GPIO
	STR	R1, [R0]
	
	LDR	R0, =GPIO_PORTM_PCTL_R	;LCD - PINOS DE COMANDOS
	LDR R1, [R0]
	BIC R1, #2_111	; Pinos M0 a M2 = 0: seleciona modo GPIO
	STR	R1, [R0]

	; 4. DIR para 0: input (BIC), 1: output (ORR)
	LDR	R0, =GPIO_PORTK_DIR_R
	LDR R1, [R0]
	ORR	R1, R1, #0xFF ; pinos PK0 a PK7 = 1: output
	STR	R1, [R0]
	
	LDR	R0, =GPIO_PORTM_DIR_R
	LDR R1, [R0]
	ORR R1, R1, #2_111 ; pinos M0 a M2 = 1: output
	STR R1, [R0]

	; 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem funcao alternativa
	LDR	R0, =GPIO_PORTK_AFSEL_R
	LDR R1, [R0]
	BIC R1, R1, #0xFF ; pinos PK0 a PK7 = 0: sem funcao alternativa
	STR	R1, [R0]
	
	LDR	R0, =GPIO_PORTM_AFSEL_R
	LDR R1, [R0]
	BIC R1, R1, #2_111 ;pinos M0 a M2 = 0: sem funcao alternativa
	STR	R1, [R0]
	
	; 6. Setar os bits de DEN para habilitar I/O digital
	LDR	R0, =GPIO_PORTK_DEN_R	;LCD - PINOS DE DADOS
	LDR R1, [R0]
	ORR	R1, R1, #0xFF ; pinos K0 a K7 = 1: habilita I/O digital
	STR	R1, [R0]
	
	LDR	R0, =GPIO_PORTM_DEN_R	;LCD - PINOS DE COMANDOS
	LDR R1, [R0]
	ORR R1, R1, #2_111 ; pinos M0 a M3 = 1 : habilita I/O digital
	STR	R1, [R0]
	
	; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
	; N/A
	
	; chama funcao para configuracao do LCD
	PUSH {LR}
	BL LCD_config
	POP {LR}

	BX	LR

; -------------------------------------------------------------------------------
; Função LCD_config
; Parâmetro de entrada: nao tem
; Parâmetro de saída: nao tem
LCD_config
	
	; Inicializar no modo 2 linhas / caracter matriz 5x7
	MOV	R0, #0x38
	PUSH{LR}
	BL LCD_command
	POP{LR}
		
	MOV R0, #40
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	
	; Cursor com autoincremento para direita
	MOV	R0, #0x06
	PUSH{LR}
	BL LCD_command
	POP{LR}
	
	MOV R0, #40
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	
	; Configurar o cursor (habilitar o display + cursor + não-pisca) 
	MOV	R0, #0x0F	
	PUSH{LR}
	BL LCD_command
	POP{LR}
		
	; espera 40us
	MOV R0, #40
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	
	; reseta LCD
	PUSH{LR}
	BL LCD_reset
	POP{LR}

	BX LR	;return

; -------------------------------------------------------------------------------
; Função LCD_reset
; Parâmetro de entrada: nao tem
; Parâmetro de saída: nao tem
LCD_reset
	; envia comando de reset
	MOV	R0, #0x01
	PUSH{LR}
	BL LCD_command
	POP{LR}
	
	; espera 1.64ms
	MOV R0, #1640
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}

	BX LR

; -------------------------------------------------------------------------------
; Funcao LCD_command
; Parâmetro de entrada: R0: comando a ser executado
; Parâmetro de saída: nao tem
LCD_command
	PUSH {R1} ; amazena registradores usados na funcao
	
	;seta dados de entrada
	LDR R1, =GPIO_PORTK_DATA_R
	STR	R0, [R1]
	
	;habilita lcd e escreve comando
	LDR R1, =GPIO_PORTM_DATA_R
	MOV	R0, #2_100	;EN=1, RW=0 ,RS=1
	STR R0, [R1]
	
	; espera 10us
	MOV R0, #10
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	
	; desabilita lcd
	LDR R1, =GPIO_PORTM_DATA_R
	MOV	R0, #2_000	;EN=0, RW=0 ,RS=0
	STR R0, [R1]
	
	POP {R1}	;restaura registradores usados na funcao
	BX LR		;return

; -------------------------------------------------------------------------------
; Função LCD_write_data
; Parâmetro de entrada: R0: ASCII a ser escrito
; Parâmetro de saída: nao tem
LCD_write_data
	PUSH {R1} ;amazena registradores usados na funcao
	
	;seta dados de entrada
	LDR R1, =GPIO_PORTK_DATA_R
	STR	R0, [R1]
	
	;habilita LCD e escreve dados
	LDR R1, =GPIO_PORTM_DATA_R
	MOV	R0, #2_101	;EN=1, RW=0 ,RS=1
	STR R0, [R1]
	
	;espera 10us
	MOV R0, #10
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	
	;desabilita LCD
	LDR R1, =GPIO_PORTM_DATA_R
	MOV	R0, #2_001	;EN=0, RW=0 ,RS=1
	STR R0, [R1]
	
	; espera 40us
	MOV R0, #40
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	
	POP {R1}	;restaura registradores usados na funcao
	BX LR		;retorno

; -------------------------------------------------------------------------------
; Função LCD_write_data
; Parâmetro de entrada: R0: ASCII a ser escrito
; Parâmetro de saída: nao tem
LCD_print_string
	PUSH {R1, R2}
	MOV R1, R0 ;pega o ponteiro do inicio da string
loop_print_string
	LDRB R2, [R1], #1
	MOV R0, R2
	CMP R0, #0
	BEQ end_LCD_print_string
	PUSH {LR}
	BL LCD_write_data
	POP {LR}
	B loop_print_string
end_LCD_print_string
	POP {R1, R2}
	BX LR

; -------------------------------------------------------------------------------
; fim do arquivo
	ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo