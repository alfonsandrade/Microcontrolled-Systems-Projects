; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 19/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; Defini��es dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Defini��es dos Ports
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

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortF_Output			; Permite chamar PortN_Output de outro arquivo
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
		EXPORT GPIOPortJ_Handler
			
		IMPORT SysTick_Wait1us
		
				
;--------------------------------------------------------------------------------
; Fun��o GPIO_Init
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; ap�s isso verificar no PRGPIO se a porta est� pronta para uso.
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endere�o do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTF                 ;Seta o bit da porta F
			ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
            STR     R1, [R0]						;Move para a mem�ria os bits das portas no endere�o do RCGCGPIO
 
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endere�o do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;L� da mem�ria o conte�do do endere�o do registrador
			MOV     R2, #GPIO_PORTF                 ;Seta os bits correspondentes �s portas para fazer a compara��o
			ORR     R2, #GPIO_PORTJ                 ;Seta o bit da porta J, fazendo com OR
            TST     R1, R2							;ANDS de R1 com R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o la�o. Sen�o continua executando
 
; 2. Limpar o AMSEL para desabilitar a anal�gica
            MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a fun��o anal�gica
            LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endere�o do AMSEL para a porta J
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da mem�ria
            LDR     R0, =GPIO_PORTF_AHB_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta F
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta F da mem�ria
 
; 3. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
            LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endere�o do PCTL para a porta J
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da mem�ria
            LDR     R0, =GPIO_PORTF_AHB_PCTL_R      ;Carrega o R0 com o endere�o do PCTL para a porta F
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta F da mem�ria

; 4. DIR para 0 se for entrada, 1 se for sa�da
            LDR     R0, =GPIO_PORTF_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta F
			MOV     R1, #2_00010001					;PF4 & PF0 para LED
            STR     R1, [R0]						;Guarda no registrador
			; O certo era verificar os outros bits da PF para n�o transformar entradas em sa�das desnecess�rias
            LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta J
            MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com sa�da
            STR     R1, [R0]						;Guarda no registrador PCTL da porta J da mem�ria			
			
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem fun��o alternativa
            MOV     R1, #0x00						;Colocar o valor 0 para n�o setar fun��o alternativa
            LDR     R0, =GPIO_PORTF_AHB_AFSEL_R		;Carrega o endere�o do AFSEL da porta F
            STR     R1, [R0]						;Escreve na porta
            LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endere�o do AFSEL da porta J
            STR     R1, [R0]                        ;Escreve na porta
			
; 6. Setar os bits de DEN para habilitar I/O digital
            LDR     R0, =GPIO_PORTF_AHB_DEN_R			;Carrega o endere�o do DEN
            MOV     R1, #2_00010001                     ;Ativa os pinos PF0 e PF4 como I/O Digital
            STR     R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital 
 
            LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endere�o do DEN
			MOV     R1, #2_00000011                     ;Ativa os pinos PJ0 e PJ1 como I/O Digital      
            STR     R1, [R0]                            ;Escreve no registrador da mem�ria funcionalidade digital

; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endere�o do PUR para a porta J
			MOV     R1, #2_00000011						;Habilitar funcionalidade digital de resistor de pull-up 
                                                        ;nos bits 0 e 1
            STR     R1, [R0]							;Escreve no registrador da mem�ria do resistor de pull-up
			
; config da interrup��o

			;desabilita as interrupcoes
			LDR 	R0, =GPIO_PORTJ_AHB_IM_R
			LDR 	R1, [R0]		;pega info
			BIC		R1, #2_1		;reseta bits
			ORR		R1, R1, #2_0 	;seta bits
			STR		R1, [R0]		;registra
			; configura como borda
			LDR		R0, =GPIO_PORTJ_AHB_IS_R
			LDR 	R1, [R0]	;pega info
			BIC		R1, #2_1	;reseta bits
			ORR		R1, R1, #2_0	;seta bits
			STR		R1, [R0]
			;configura borda unica
			LDR		R0, =GPIO_PORTJ_AHB_IBE_R
			LDR 	R1, [R0]	;pega info
			BIC		R1, #2_1	;reseta bits
			ORR		R1, R1, #2_0	;seta bits
			STR		R1, [R0]
			;Configurar borda de descida para J0 e borda de subida para J1 no registrador GPIOIEV
			LDR		R0, =GPIO_PORTJ_AHB_IEV_R
			LDR 	R1, [R0]	;pega info
			BIC		R1, #2_1	;reseta bits
			ORR		R1, R1, #2_0	;seta bits
			STR		R1, [R0]
			;Garantir que a interrup��o ser� atendida limpando o GPIORIS e GPIOMIS, realizando o ACK no registrador
			; GPIOICR para ambos os pinos. Setar os bits;
			LDR		R0, =GPIO_PORTJ_AHB_ICR_R
			LDR 	R1, [R0]	;pega info
			BIC		R1, #2_1	;reseta bits
			ORR		R1, R1, #2_1	;seta bits
			STR		R1, [R0]
			; reabilita as interrup��es
			LDR 	R0, =GPIO_PORTJ_AHB_IM_R
			LDR 	R1, [R0]	;pega info
			BIC		R1, #2_11	;reseta bits
			ORR		R1, R1, #2_11	;seta bits
			STR		R1, [R0]	;registra
			; ativar a fonte de interrup��o no NVIC
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
			
			BX      LR ;retorno


; -------------------------------------------------------------------------------
; Fun��o PortF_Output
; Par�metro de entrada: R0 --> se os BIT4 e BIT0 est�o ligado ou desligado
; Par�metro de sa�da: N�o tem
PortF_Output
	LDR	R1, =GPIO_PORTF_AHB_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00010001                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par�metro de entrada
	STR R0, [R1]                            ;Escreve na porta F o barramento de dados dos pinos F4 e F0
	BX LR									;Retorno

; -------------------------------------------------------------------------------
; Fun��o PortJ_Input
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: R0 --> o valor da leitura
PortJ_Input
	LDR	R1, =GPIO_PORTJ_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR R0, [R1]                            ;L� no barramento de dados dos pinos [J1-J0]
	BX LR									;Retorno
		
; -------------------------------------------------------------------------------
; Fun��o GPIOPortJ_Handler
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: nao tem
GPIOPortJ_Handler
	LDR R1, =GPIO_PORTJ_AHB_RIS_R
	LDR R2, [R1]
	CMP R2, #2_1
	BEQ bt_J0_pressed
bt_J0_pressed
	LDR R1, =GPIO_PORTJ_AHB_ICR_R
	STR R2, [R1]
	MOV R0, #1
	B set_led_interrupt
set_led_interrupt
	PUSH {LR}
	BL PortF_Output
	POP {LR}
	
	BX LR
; -------------------------------------------------------------------------------
DisableInterrupt
	LDR 	R0, =GPIO_PORTJ_AHB_IM_R
	LDR 	R1, [R0]		;pega info
	BIC		R1, #2_1		;reseta bits
	ORR		R1, R1, #2_0 	;seta bits
	STR		R1, [R0]		;registra


EnableInterrupt
	LDR 	R0, =GPIO_PORTJ_AHB_IM_R
	LDR 	R1, [R0]	;pega info
	BIC		R1, #2_11	;reseta bits
	ORR		R1, R1, #2_11	;seta bits
	STR		R1, [R0]	;registra

	

; -------------------------------------------------------------------------------
; fim do arquivo
	ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo