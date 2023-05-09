; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 19/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; ========================
; Definições do Keypad
PORTL_L1	EQU		2_00000001
PORTL_L2	EQU		2_00000010
PORTL_L3	EQU		2_00000100
PORTL_L4	EQU		2_00001000
PORTL_L		EQU		2_00001111
PORTM_C1	EQU		2_00010000
PORTM_C2	EQU		2_00100000
PORTM_C3	EQU		2_01000000
PORTM_C4	EQU		2_10000000
PORTM_C		EQU		2_11110000
; ========================
; Definições dos Ports
NVIC_EN1_R			EQU 0xE000E104
NVIC_PRI12_R		EQU 0xE000E430

; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU 0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU 0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU 0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU 0x400603FC
GPIO_PORTJ               	EQU 2_000000100000000
GPIO_PORTJ_AHB_IM_R     	EQU 0x40060410
GPIO_PORTJ_AHB_IS_R			EQU 0x40060404
GPIO_PORTJ_AHB_IBE_R		EQU 0x40060408
GPIO_PORTJ_AHB_IEV_R		EQU 0x4006040C
GPIO_PORTJ_AHB_ICR_R    	EQU 0x4006041C
GPIO_PORTJ_AHB_RIS_R		EQU 0x40060414


; PORT F
GPIO_PORTF_AHB_LOCK_R    	EQU    0x4005D520
GPIO_PORTF_AHB_CR_R      	EQU    0x4005D524
GPIO_PORTF_AHB_AMSEL_R   	EQU    0x4005D528
GPIO_PORTF_AHB_PCTL_R    	EQU    0x4005D52C
GPIO_PORTF_AHB_DIR_R     	EQU    0x4005D400
GPIO_PORTF_AHB_AFSEL_R   	EQU    0x4005D420
GPIO_PORTF_AHB_DEN_R     	EQU    0x4005D51C
GPIO_PORTF_AHB_PUR_R     	EQU    0x4005D510	
GPIO_PORTF_AHB_DATA_R    	EQU    0x4005D3FC
GPIO_PORTF               	EQU    2_000000000100000	


; PORT K
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
GPIO_PORTK              EQU 2_1000000000

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
	
; PORT L
GPIO_PORTL_LOCK_R   	 	EQU    0x40062520
GPIO_PORTL_CR_R    		  	EQU    0x40062524
GPIO_PORTL_AMSEL_R  	 	EQU    0x40062528
GPIO_PORTL_PCTL_R   	 	EQU    0x4006252C
GPIO_PORTL_DIR_R    	 	EQU    0x40062400
GPIO_PORTL_AFSEL_R   		EQU    0x40062420
GPIO_PORTL_DEN_R     		EQU    0x4006251C
GPIO_PORTL_PUR_R     		EQU    0x40062510	
GPIO_PORTL_DATA_R   	 	EQU    0x400623FC
GPIO_PORTL          	    EQU    2_000010000000000
		
; PORT P
GPIO_PORTP_LOCK_R    		EQU    0x40065520
GPIO_PORTP_CR_R      		EQU    0x40065524
GPIO_PORTP_AMSEL_R   		EQU    0x40065528
GPIO_PORTP_PCTL_R    		EQU    0x4006552C
GPIO_PORTP_DIR_R     		EQU    0x40065400
GPIO_PORTP_AFSEL_R   		EQU    0x40065420
GPIO_PORTP_DEN_R     		EQU    0x4006551C
GPIO_PORTP_PUR_R     		EQU    0x40065510	
GPIO_PORTP_DATA_R    		EQU    0x400653FC
GPIO_PORTP               	EQU    2_010000000000000
	
; PORT Q
GPIO_PORTQ_LOCK_R    		EQU    0x40066520
GPIO_PORTQ_CR_R      		EQU    0x40066524
GPIO_PORTQ_AMSEL_R   		EQU    0x40066528
GPIO_PORTQ_PCTL_R    		EQU    0x4006652C
GPIO_PORTQ_DIR_R     		EQU    0x40066400
GPIO_PORTQ_AFSEL_R   		EQU    0x40066420
GPIO_PORTQ_DEN_R     		EQU    0x4006651C
GPIO_PORTQ_PUR_R     		EQU    0x40066510	
GPIO_PORTQ_DATA_R    		EQU    0x400663FC
GPIO_PORTQ               	EQU    2_100000000000000

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortF_Output			; Permite chamar PortN_Output de outro arquivo
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
		EXPORT GPIOPortJ_Handler
		EXPORT LCD_init
		EXPORT LCD_DATA
		EXPORT LCD_print_string
		EXPORT LCD_reset
		EXPORT LerTeclado
		EXPORT KeyCode_to_ASCII
		IMPORT SysTick_Wait1us
		IMPORT SysTick_Wait1ms
			
		
				
;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; após isso verificar no PRGPIO se a porta está pronta para uso.
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endereço do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTF                 ;Seta o bit da porta F
			ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
			ORR		R1, #GPIO_PORTK			;LCD - PINOS DE DADOS
			ORR		R1, #GPIO_PORTM			;LCD - PINOS DE COMANDO
			ORR		R1, #GPIO_PORTL			;TECLADO MATRICIAL
			ORR		R1, #GPIO_PORTM			;TECLADO MATRICIAL
			ORR		R1, #GPIO_PORTP			
			ORR		R1, #GPIO_PORTQ
            STR     R1, [R0]						;Move para a memória os bits das portas no endereço do RCGCGPIO
 
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;Lê da memória o conteúdo do endereço do registrador
			MOV     R2, #GPIO_PORTF                 ;Seta os bits correspondentes às portas para fazer a comparação
			ORR     R2, #GPIO_PORTJ                 ;Seta o bit da porta J, fazendo com OR
			ORR		R2, #GPIO_PORTK			;LCD - PINOS DE DADOS
			ORR		R1, #GPIO_PORTL			;TECLADO MATRICIAL
			ORR		R1, #GPIO_PORTM			;TECLADO MATRICIAL
			ORR		R1, #GPIO_PORTP			
            TST     R1, R2							;ANDS de R1 com R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o laço. Senão continua executando
 
; 2. Limpar o AMSEL para desabilitar a analógica
            MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a função analógica
            LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta J
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da memória
            LDR     R0, =GPIO_PORTF_AHB_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta F
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta F da memória
			
			; LCD
			LDR		R0, =GPIO_PORTK_AMSEL_R		;LCD - PINOS DE DADOS
			STR 	R1, [R0]
			LDR		R0, =GPIO_PORTM_AMSEL_R		;LCD - PINOS DE COMANDOS + Matricial
			STR		R1, [R0]
		
			; Matricial
			LDR		R0, =GPIO_PORTL_AMSEL_R		;Matricial
			STR		R1, [R0]
			LDR		R0, =GPIO_PORTP_AMSEL_R
			STR		R1, [R0]
			LDR		R0, =GPIO_PORTQ_AMSEL_R
			STR		R1, [R0]
			
 
; 3. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
            LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta J
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da memória
            LDR     R0, =GPIO_PORTF_AHB_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta F
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta F da memória
			
			; LCD
			LDR		R0, =GPIO_PORTK_PCTL_R	;LCD - PINOS DE DADOS
			STR		R1, [R0]
			LDR		R0, =GPIO_PORTM_PCTL_R	;LCD - PINOS DE COMANDOS + ;Matricial
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTL_PCTL_R	;Matricial
			STR		R1, [R0]
			LDR		R0, =GPIO_PORTP_PCTL_R
			STR		R1, [R0]
			LDR		R0, =GPIO_PORTQ_PCTL_R
			STR		R1, [R0]
			
; 4. DIR para 0 se for entrada, 1 se for saída
            LDR     R0, =GPIO_PORTF_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta F
			MOV     R1, #2_00010001					;PF4 & PF0 para LED
            STR     R1, [R0]						;Guarda no registrador
			; O certo era verificar os outros bits da PF para não transformar entradas em saídas desnecessárias
            LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta J
            MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com saída
            STR     R1, [R0]						;Guarda no registrador PCTL da porta J da memória
			
			; LCD - APENAS COMO ESCRITA (OUTPUT)
			LDR		R0, =GPIO_PORTK_DIR_R
			MOV		R1, #0xFF
			STR		R1, [R0]
			
			; PM0:2 - 1 (saída) LCD - Dados
			; PM4:7 - 1 (saída) Matricial
			LDR		R0, =GPIO_PORTM_DIR_R
			MOV		R1, #2_11110111
			STR		R1, [R0]
			
			;Matricial
			; PL0:3 - 0 (entrada)
			LDR		R0, =GPIO_PORTL_DIR_R
			MOV		R1, #2_00000000
			STR		R1, [R0]
			
			; PP5 - 1 (saída)
			LDR		R0, =GPIO_PORTP_DIR_R
			MOV		R1, #2_00100000
			STR		R1, [R0]
			; PQ0:3 - 1 (saída)
			LDR		R0, =GPIO_PORTQ_DIR_R
			MOV		R1, #2_00001111
			STR		R1, [R0]
			
			; PP5 - 1 (saída)
			LDR		R0, =GPIO_PORTP_DIR_R
			MOV		R1, #2_00100000
			STR		R1, [R0]
			; PQ0:3 - 1 (saída)
			LDR		R0, =GPIO_PORTQ_DIR_R
			MOV		R1, #2_00001111
			STR		R1, [R0]
			
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem função alternativa
            MOV     R1, #0x00						;Colocar o valor 0 para não setar função alternativa
            LDR     R0, =GPIO_PORTF_AHB_AFSEL_R		;Carrega o endereço do AFSEL da porta F
            STR     R1, [R0]						;Escreve na porta
            LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta J
            STR     R1, [R0]                        ;Escreve na porta
			
			; LCD
			MOV		R1, #0x0
			LDR		R0, =GPIO_PORTK_AFSEL_R
			STR		R1, [R0]
			LDR		R0, =GPIO_PORTM_AFSEL_R
			STR		R1, [R0]
			;Matricial
			LDR		R0, =GPIO_PORTL_AFSEL_R
			STR		R1, [R0]
			LDR		R0, =GPIO_PORTP_AFSEL_R
			STR		R1, [R0]
			LDR		R0, =GPIO_PORTQ_AFSEL_R
			STR		R1, [R0]
			
			
; 6. Setar os bits de DEN para habilitar I/O digital
            LDR     R0, =GPIO_PORTF_AHB_DEN_R			;Carrega o endereço do DEN
            MOV     R1, #2_00010001                     ;Ativa os pinos PF0 e PF4 como I/O Digital
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
 
            LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endereço do DEN
			MOV     R1, #2_00000011                     ;Ativa os pinos PJ0 e PJ1 como I/O Digital      
            STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			
			; LCD
			LDR		R0, =GPIO_PORTK_DEN_R	;LCD - PINOS DE DADOS
			MOV		R1, #2_11111111
			STR		R1, [R0]

			;LCD + Matricial
			LDR		R0, =GPIO_PORTM_DEN_R
			MOV		R1, #2_11110111
			STR		R1, [R0]
			
			;Matricial
			LDR		R0, =GPIO_PORTL_DEN_R
			MOV		R1, #2_00001111
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTP_DEN_R
			MOV		R1, #2_00100000
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTQ_DEN_R
			MOV		R1, #2_00001111
			STR		R1, [R0]
			
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endereço do PUR para a porta J
			MOV     R1, #2_00000011						;Habilitar funcionalidade digital de resistor de pull-up 
                                                        ;nos bits 0 e 1
            STR     R1, [R0]							;Escreve no registrador da memória do resistor de pull-up
			;Matricial
			LDR		R0, =GPIO_PORTL_PUR_R
			MOV		R1, #2_00001111
			STR		R1, [R0]

			
; config da interrupção

			;desabilita as interrupcoes
			LDR 	R0, =GPIO_PORTJ_AHB_IM_R
			LDR 	R1, [R0]	;pega info
			BIC		R1, #2_11	;reseta bits
			ORR		R1, R1, #2_00	;seta bits
			STR		R1, [R0]	;registra
			
			; configura como borda
			LDR		R0, =GPIO_PORTJ_AHB_IS_R
			LDR 	R1, [R0]	;pega info
			BIC		R1, #2_11	;reseta bits
			ORR		R1, R1, #2_00	;seta bits
			STR		R1, [R0]
			
			;configura borda unica
			LDR		R0, =GPIO_PORTJ_AHB_IBE_R
			LDR 	R1, [R0]	;pega info
			BIC		R1, #2_11	;reseta bits
			ORR		R1, R1, #2_00	;seta bits
			STR		R1, [R0]
			
			;Configurar borda de descida para J0 e borda de subida para J1 no registrador GPIOIEV
			LDR		R0, =GPIO_PORTJ_AHB_IEV_R
			LDR 	R1, [R0]	;pega info
			BIC		R1, #2_11	;reseta bits
			ORR		R1, R1, #2_10	;seta bits
			STR		R1, [R0]
			
			;Garantir que a interrupção será atendida limpando o GPIORIS e GPIOMIS, realizando o ACK no registrador
			; GPIOICR para ambos os pinos. Setar os bits;
			LDR		R0, =GPIO_PORTJ_AHB_ICR_R
			LDR 	R1, [R0]	;pega info
			BIC		R1, #2_11	;reseta bits
			ORR		R1, R1, #2_11	;seta bits
			STR		R1, [R0]
			
			; reabilita as interrupções
			LDR 	R0, =GPIO_PORTJ_AHB_IM_R
			LDR 	R1, [R0]	;pega info
			BIC		R1, #2_11	;reseta bits
			ORR		R1, R1, #2_11	;seta bits
			STR		R1, [R0]	;registra
			
			
			; ativar a fonte de interrupção no NVIC
			LDR		R0, =NVIC_EN1_R
			LDR 	R1, [R0]
			MOV		R2, #2_1
			LSL		R2, #19
			ORR		R1, R1, R2
			STR		R1, [R0]
			
			; define a prioridade da fonte de interrupcao
			LDR		R0, =NVIC_PRI12_R
			LDR		R1, [R0]
			MOV 	R2, #2_111	;para limpar os bits do R1
			LSL 	R2, #29		
			BIC		R1, R1, R2
			MOV		R3, #5 ;prioridade
			LSL		R3, #29	;4a posicao do reg PRI12
			ORR		R1, R1, R3
			STR 	R1, [R0]
			
;retorno            
			BX      LR
			LTORG

; -------------------------------------------------------------------------------
; Função PortF_Output
; Parâmetro de entrada: R0 --> se os BIT4 e BIT0 estão ligado ou desligado
; Parâmetro de saída: Não tem
PortF_Output
	LDR	R1, =GPIO_PORTF_AHB_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00010001                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta F o barramento de dados dos pinos F4 e F0
	BX LR									;Retorno

; -------------------------------------------------------------------------------
; Função PortJ_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
PortJ_Input
	LDR	R1, =GPIO_PORTJ_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR R0, [R1]                            ;Lê no barramento de dados dos pinos [J1-J0]
	BX LR									;Retorno
		
; -------------------------------------------------------------------------------
; Função GPIOPortJ_Handler
; Parâmetro de entrada: Não tem
; Parâmetro de saída: nao tem
GPIOPortJ_Handler
	LDR R1, =GPIO_PORTJ_AHB_RIS_R
	LDR R2, [R1]
	CMP R2, #2_01
	BEQ bt_J0_pressed
	CMP R2, #2_10
	BEQ bt_J1_release
	B bt_J1_release
bt_J0_pressed
	LDR R1, =GPIO_PORTJ_AHB_ICR_R
	STR R2, [R1]
	MOV R0, #1
	B set_led_interrupt
bt_J1_release
	LDR R1, =GPIO_PORTJ_AHB_ICR_R
	STR R2, [R1]
	MOV R0, #0
set_led_interrupt
	PUSH {LR}
	BL PortF_Output
	POP {LR}
	
	BX LR

; -------------------------------------------------------------------------------
LCD_init
	; Inicializar no modo 2 linhas / caracter matriz 5x7
	MOV	R0, #0x38
	PUSH{LR}
	BL LCD_CMD
	POP{LR}
		
	MOV R0, #40
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	
	; Cursor com autoincremento para direita
	MOV	R0, #0x06
	PUSH{LR}
	BL LCD_CMD
	POP{LR}
	
	MOV R0, #40
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	
	; Configurar o cursor (habilitar o display + cursor + não-pisca) 
	MOV	R0, #0x0F	
	PUSH{LR}
	BL LCD_CMD
	POP{LR}
		
	MOV R0, #40
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	
	PUSH{LR}
	BL LCD_reset
	POP{LR}
	
	BX LR

; -------------------------------------------------------------------------------
; Função LCD_RESET
; Parâmetro de entrada: nao tem
; Parâmetro de saída: nao tem
LCD_reset

	MOV	R0, #0x01
	PUSH{LR}
	BL LCD_CMD
	POP{LR}
	
	MOV R0, #5000
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}

	BX LR

; -------------------------------------------------------------------------------
; Função LCD_CMD
; Parâmetro de entrada: R0: comando a ser executado
; Parâmetro de saída: nao tem
LCD_CMD
	LDR R1, =GPIO_PORTK_DATA_R
	STR	R0, [R1]
	
	LDR R1, =GPIO_PORTM_DATA_R
	MOV	R0, #2_100	;EN=1, RW=0 ,RS=1
	STR R0, [R1]
	
	MOV R0, #10
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	
	LDR R1, =GPIO_PORTM_DATA_R
	MOV	R0, #2_000	;EN=0, RW=0 ,RS=0
	STR R0, [R1]
	
	BX LR

; -------------------------------------------------------------------------------
; Função LCD_write_data
; Parâmetro de entrada: R0: ASCII a ser escrito
; Parâmetro de saída: nao tem
LCD_DATA
	LDR R1, =GPIO_PORTK_DATA_R
	STR	R0, [R1]
	
	LDR R1, =GPIO_PORTM_DATA_R
	MOV	R0, #2_101	;EN=1, RW=0 ,RS=1
	STR R0, [R1]
	
	MOV R0, #10
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	
	LDR R1, =GPIO_PORTM_DATA_R
	MOV	R0, #2_001	;EN=0, RW=0 ,RS=1
	STR R0, [R1]
	
	MOV R0, #40
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	
	BX LR
; -------------------------------------------------------------------------------
; Função LCD_print_string
; Parâmetro de entrada: R0: Endereço da string a ser impressa
; Parâmetro de saída: nao tem
LCD_print_string
    PUSH {R4, LR} ; Salvar R4 e LR no stack
    MOV R4, R0    ; Mover o endereço da string para R4

print_loop
    LDRB R0, [R4] ; Carregar o byte atual da string em R0
    CMP R0, #0    ; Comparar R0 com 0 (verificar se é o terminador nulo)
    BEQ done      ; Se R0 == 0, então sair do loop e ir para o rótulo 'done'

    BL LCD_DATA   ; Escrever o caractere em R0 no LCD
    ADD R4, R4, #1 ; Incrementar o ponteiro da string R4
    B print_loop  ; Voltar para o início do loop

done
    POP {R4, LR} ; Restaurar R4 e LR do stack
    BX LR        ; Retornar

; -------------------------------------------------------------------------------
; Função KeyCode_to_ASCII
; Parâmetro de entrada: R1 -> Key code
; Parâmetro de saída: R0 -> ASCII character
KeyCode_to_ASCII
    CMP R1, #0xA       ; Check if the key code is between A and D
    BLT NumericKey
    ADD R0, R1, #55    ; Convert key code A-D to ASCII (A=65, B=66, C=67, D=68)
    BX LR

NumericKey
    ADD R0, R1, #0x30  ; Convert key code 0-9 to ASCII (0=48, 1=49, ..., 9=57)
    BX LR
; -------------------------------------------------------------------------------
; Função LerTeclado
; Parâmetro de entrada: N/A
; Parâmetro de saída: R0 -> Tecla pressionada (*->E #->F), 0x10 se nenhuma
LerTeclado
	PUSH	{LR}

	; coluna 1
	MOV		R0, #PORTM_C1
	BL		LerColuna
	CMP		R0, #0
	BEQ		test_coluna_2
	; uma tecla foi detectada
	; C1xL1 - 1
	TST		R0, #PORTL_L1
	ITT		NE
		MOVNE	R1, #0x1
		BNE		teclado_debounce
	; C1xL2 - 4
	TST		R0, #PORTL_L2
	ITT		NE
		MOVNE	R1, #0x4
		BNE		teclado_debounce
	; C1xL3 - 7
	TST		R0, #PORTL_L3
	ITT		NE
		MOVNE	R1, #0x7
		BNE		teclado_debounce
	; C1xL4 - E
	TST		R0, #PORTL_L4
	ITT		NE
		MOVNE	R1, #0xE
		BNE		teclado_debounce
	B		nenhuma_coluna

test_coluna_2
	; coluna 2
	MOV		R0, #PORTM_C2
	BL		LerColuna
	CMP		R0, #0
	BEQ		test_coluna_3
	; uma tecla foi detectada
	; C2xL1 - 2
	TST		R0, #PORTL_L1
	ITT		NE
		MOVNE	R1, #0x2
		BNE		teclado_debounce
	; C2xL2 - 5
	TST		R0, #PORTL_L2
	ITT		NE
		MOVNE	R1, #0x5
		BNE		teclado_debounce
	; C2xL3 - 8
	TST		R0, #PORTL_L3
	ITT		NE
		MOVNE	R1, #0x8
		BNE		teclado_debounce
	; C2xL4 - 0
	TST		R0, #PORTL_L4
	ITT		NE
		MOVNE	R1, #0x0
		BNE		teclado_debounce
	B		nenhuma_coluna

test_coluna_3
	; coluna 3
	MOV		R0, #PORTM_C3
	BL		LerColuna
	CMP		R0, #0
	BEQ		test_coluna_4
	; uma tecla foi detectada
	; C3xL1 - 3
	TST		R0, #PORTL_L1
	ITT		NE
		MOVNE	R1, #0x3
		BNE		teclado_debounce
	; C3xL2 - 6
	TST		R0, #PORTL_L2
	ITT		NE
		MOVNE	R1, #0x6
		BNE		teclado_debounce
	; C3xL3 - 9
	TST		R0, #PORTL_L3
	ITT		NE
		MOVNE	R1, #0x9
		BNE		teclado_debounce
	; C3xL4 - F
	TST		R0, #PORTL_L4
	ITT		NE
		MOVNE	R1, #0xF
		BNE		teclado_debounce
	B		nenhuma_coluna

test_coluna_4
	; coluna 4
	MOV		R0, #PORTM_C4
	BL		LerColuna
	CMP		R0, #0
	BEQ		nenhuma_coluna
	; uma tecla foi detectada
	; C4xL1 - A
	TST		R0, #PORTL_L1
	ITT		NE
		MOVNE	R1, #0xA
		BNE		teclado_debounce
	; C4xL2 - B
	TST		R0, #PORTL_L2
	ITT		NE
		MOVNE	R1, #0xB
		BNE		teclado_debounce
	; C4xL3 - C
	TST		R0, #PORTL_L3
	ITT		NE
		MOVNE	R1, #0xC
		BNE		teclado_debounce
	; C4xL4 - D
	TST		R0, #PORTL_L4
	ITT		NE
		MOVNE	R1, #0xD
		BNE		teclado_debounce
	B		nenhuma_coluna

nenhuma_coluna
	MOV		R1, #0x10
	B		fim_colunas

teclado_debounce
	MOV		R0, #1000
	BL		SysTick_Wait1ms

fim_colunas
	MOV		R0, R1

	POP		{LR}
	BX		LR


; -------------------------------------------------------------------------------
; Função LerColuna
; Parâmetro de entrada: R0 -> Bit da coluna
; Parâmetro de saída: R0 -> Bit da linha ativa (0 se nenhuma)
LerColuna
	PUSH	{LR}
	
	MOV		R3, R0
	
	; configurando a coluna como saída
	LDR		R0, =GPIO_PORTM_DIR_R
	LDR		R1, [R0]
	BIC		R1, #PORTM_C
	ORR		R1, R3
	STR		R1, [R0]
	; escrevendo 0 na coluna
	LDR		R0, =GPIO_PORTM_DATA_R
	LDR		R1, [R0]
	BIC		R1,	R3
	STR		R1, [R0]
	; polling
	MOV		R0, #100
	BL		SysTick_Wait1us
	; lendo as linhas
	LDR		R0, =GPIO_PORTL_DATA_R
	LDR		R1, [R0]
	; linha 1
	TST		R1, #PORTL_L1
	ITT		EQ
		MOVEQ	R1, #PORTL_L1
		BEQ		fim_verifica_linhas
	; linha 2
	TST		R1, #PORTL_L2
	ITT		EQ
		MOVEQ	R1, #PORTL_L2
		BEQ		fim_verifica_linhas
	; linha 3
	TST		R1, #PORTL_L3
	ITT		EQ
		MOVEQ	R1, #PORTL_L3
		BEQ		fim_verifica_linhas
	; linha 4
	TST		R1, #PORTL_L4
	ITT		EQ
		MOVEQ	R1, #PORTL_L4
		BEQ		fim_verifica_linhas
	; nenhuma ativa
	MOV		R1, #0
fim_verifica_linhas
	
	; debouncing
	CMP		R1, #0
	ITT		NE
		MOVNE	R0, #200
		BLNE	SysTick_Wait1ms
	MOV		R0, R1
	
	POP		{LR}
	BX		LR
; -------------------------------------------------------------------------------
; fim do arquivo
	ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo