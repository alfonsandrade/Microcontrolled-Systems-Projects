; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; Constantes
STATE_OPEN	    EQU	0
STATE_OPENING	EQU	1
STATE_CLOSED	EQU 2
STATE_CLOSING	EQU	3
STATE_BLOCKED	EQU	4
; ========================
; Ponteiros
ARRAY_PW_OPEN		EQU	0x20000000
ARRAY_PW_CLOSED	    EQU	0x20000010
ARRAY_PW_BLOCKED	EQU	0x20000020
ARRAY_PW_MASTER		EQU	0x20000030
SW1_STATE_PTR		EQU	0x20000040
; ========================
; Registradores
LCD_CURR_STR		RN	R12
LCD_DATA_PTR		RN	R11
STATE				RN	R10
PW_OPEN_PTR			RN	R9
PW_CLOSED_PTR		RN	R9
PW_BLOCKED_PTR		RN	R9
ATTEMPTS			RN	R8
LED_COUNT		RN	R8
; ========================
; Definições do LCD
PORTK_LCD_DATA	EQU		2_11111111
PORTM_LCD_RS	EQU		2_00000001
PORTM_LCD_RW	EQU		2_00000010
PORTM_LCD_EN	EQU		2_00000100
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
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definições dos registradores NVIC
NVIC_EN1_R				EQU		0xE000E104
NVIC_PRI12_R			EQU		0xE000E430
NVIC_PORTJ_EN_SHIFT		EQU		19
NVIC_PORTJ_PRI_SHIFT	EQU		29
; ========================
; Definições dos Ports
; PORT A
GPIO_PORTA_AHB_LOCK_R    	EQU    0x40058520
GPIO_PORTA_AHB_CR_R      	EQU    0x40058524
GPIO_PORTA_AHB_AMSEL_R   	EQU    0x40058528
GPIO_PORTA_AHB_PCTL_R    	EQU    0x4005852C
GPIO_PORTA_AHB_DIR_R     	EQU    0x40058400
GPIO_PORTA_AHB_AFSEL_R   	EQU    0x40058420
GPIO_PORTA_AHB_DEN_R     	EQU    0x4005851C
GPIO_PORTA_AHB_PUR_R     	EQU    0x40058510
GPIO_PORTA_AHB_DATA_R    	EQU    0x400583FC
GPIO_PORTA               	EQU    2_000000000000001
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ_AHB_IM_R			EQU    0x40060410
GPIO_PORTJ_AHB_IS_R			EQU    0x40060404
GPIO_PORTJ_AHB_IBE_R		EQU    0x40060408
GPIO_PORTJ_AHB_IEV_R		EQU    0x4006040C
GPIO_PORTJ_AHB_ICR_R		EQU    0x4006041C
GPIO_PORTJ_AHB_RIS_R		EQU    0x40060414
GPIO_PORTJ               	EQU    2_000000100000000
; PORT K
GPIO_PORTK_LOCK_R    		EQU    0x40061520
GPIO_PORTK_CR_R      		EQU    0x40061524
GPIO_PORTK_AMSEL_R   		EQU    0x40061528
GPIO_PORTK_PCTL_R    		EQU    0x4006152C
GPIO_PORTK_DIR_R    	 	EQU    0x40061400
GPIO_PORTK_AFSEL_R   		EQU    0x40061420
GPIO_PORTK_DEN_R    	 	EQU    0x4006151C
GPIO_PORTK_PUR_R    	 	EQU    0x40061510
GPIO_PORTK_DATA_R   	 	EQU    0x400613FC
GPIO_PORTK          	    EQU    2_000001000000000
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
; PORT M
GPIO_PORTM_LOCK_R   	 	EQU    0x40063520
GPIO_PORTM_CR_R     	 	EQU    0x40063524
GPIO_PORTM_AMSEL_R   		EQU    0x40063528
GPIO_PORTM_PCTL_R    		EQU    0x4006352C
GPIO_PORTM_DIR_R    	 	EQU    0x40063400
GPIO_PORTM_AFSEL_R   		EQU    0x40063420
GPIO_PORTM_DEN_R    	 	EQU    0x4006351C
GPIO_PORTM_PUR_R    	 	EQU    0x40063510
GPIO_PORTM_DATA_R   	 	EQU    0x400633FC
GPIO_PORTM          	    EQU    2_000100000000000
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
        EXPORT LCD_init
        EXPORT LCD_CMD
        EXPORT LCD_DATA
        EXPORT Matrix_read
        EXPORT LCD_print
        EXPORT Blocked_Blink_ON
        EXPORT Blocked_Blink_OFF
        EXPORT GPIOPortJ_Handler
        IMPORT	SysTick_Wait1us
        IMPORT	SysTick_Wait1ms
        IMPORT	STR_OPEN
        IMPORT	STR_OPENING
        IMPORT	STR_CLOSED
        IMPORT	STR_CLOSING
        IMPORT	STR_BLOCKED
;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; 1 - Ativa o clock nos ports K, L e M
    LDR		R0, =SYSCTL_RCGCGPIO_R
    MOV		R1, #GPIO_PORTA
    ORR		R1, #GPIO_PORTJ
    ORR		R1, #GPIO_PORTK
    ORR		R1, #GPIO_PORTL
    ORR		R1, #GPIO_PORTM
    ORR		R1, #GPIO_PORTP
    ORR		R1, #GPIO_PORTQ
    STR		R1, [R0]
    LDR     R0, =SYSCTL_PRGPIO_R
EsperaGPIO
    LDR     R2, [R0]
    MOV		R1, #GPIO_PORTA
    ORR		R1, #GPIO_PORTJ
    ORR		R1, #GPIO_PORTK
    ORR		R1, #GPIO_PORTL
    ORR		R1, #GPIO_PORTM
    ORR		R1, #GPIO_PORTP
    ORR		R1, #GPIO_PORTQ
    TST     R1, R2
    BEQ     EsperaGPIO
; 2 - Desabilita a funcionalidade analógica
    MOV		R1, #0
    LDR		R0, =GPIO_PORTA_AHB_AMSEL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTJ_AHB_AMSEL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTK_AMSEL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTL_AMSEL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTM_AMSEL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTP_AMSEL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTQ_AMSEL_R
    STR		R1, [R0]
; 3 - Seleciona GPIO
    MOV		R1, #0
    LDR		R0, =GPIO_PORTA_AHB_PCTL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTJ_AHB_PCTL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTK_PCTL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTL_PCTL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTM_PCTL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTP_PCTL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTQ_PCTL_R
    STR		R1, [R0]
; 4 - Entrada / Saída;
; PA4:7 - 1 (saída)
    LDR		R0, =GPIO_PORTA_AHB_DIR_R
    MOV		R1, #2_11110000
    STR		R1, [R0]
; PJ0 - 0 (entrada)
    LDR		R0, =GPIO_PORTJ_AHB_DIR_R
    MOV		R1, #2_00000000
    STR		R1, [R0]
; PK0:7 - 1 (saída)
    LDR		R0, =GPIO_PORTK_DIR_R
    MOV		R1, #2_11111111
    STR		R1, [R0]
; PL0:3 - 0 (entrada)
    LDR		R0, =GPIO_PORTL_DIR_R
    MOV		R1, #2_00000000
    STR		R1, [R0]
; PM0:2 - 1 (saída)
; PM4:7 - 1 (saída)
    LDR		R0, =GPIO_PORTM_DIR_R
    MOV		R1, #2_11110111
    STR		R1, [R0]
; PP5 - 1 (saída)
    LDR		R0, =GPIO_PORTP_DIR_R
    MOV		R1, #2_00100000
    STR		R1, [R0]
; PQ0:3 - 1 (saída)
    LDR		R0, =GPIO_PORTQ_DIR_R
    MOV		R1, #2_00001111
    STR		R1, [R0]
; 5 - Desabilita função alternativa
    MOV		R1, #0
    LDR		R0, =GPIO_PORTA_AHB_AFSEL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTJ_AHB_AFSEL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTK_AFSEL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTL_AFSEL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTM_AFSEL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTP_AFSEL_R
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTQ_AFSEL_R
    STR		R1, [R0]
; 6 - Habilita I/O digital
    LDR		R0, =GPIO_PORTA_AHB_DEN_R
    MOV		R1, #2_11110000
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTJ_AHB_DEN_R
    MOV		R1, #2_00000001
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTK_DEN_R
    MOV		R1, #2_11111111
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTL_DEN_R
    MOV		R1, #2_00001111
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTM_DEN_R
    MOV		R1, #2_11110111
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTP_DEN_R
    MOV		R1, #2_00100000
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTQ_DEN_R
    MOV		R1, #2_00001111
    STR		R1, [R0]
; 7 - Resistor de pull-up
    LDR		R0, =GPIO_PORTJ_AHB_PUR_R
    MOV		R1, #2_00000001
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTL_PUR_R
    MOV		R1, #2_00001111
    STR		R1, [R0]
; 8 - Desabilita interrupções
    LDR		R0, =GPIO_PORTJ_AHB_IM_R
    MOV		R1, #2_0
    STR		R1, [R0]
;- Configura tipo
    LDR		R0, =GPIO_PORTJ_AHB_IS_R
    MOV		R1, #2_0
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTJ_AHB_IBE_R
    MOV		R1, #2_0
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTJ_AHB_IEV_R
    MOV		R1, #2_1
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTJ_AHB_ICR_R
    MOV		R1, #2_1
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTJ_AHB_IM_R
    MOV		R1, #2_1
    STR		R1, [R0]
; Port J - Enable
    LDR		R0, =NVIC_EN1_R
    MOV		R1, #1
    LSL		R1, #NVIC_PORTJ_EN_SHIFT
    STR		R1, [R0]
; Port J - Prioridade 3
    LDR		R0, =NVIC_PRI12_R
    MOV		R1, #3
    LSL		R1, #NVIC_PORTJ_PRI_SHIFT
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTA_AHB_DATA_R
    LDR		R1, [R0]
    BIC		R1, R1, #2_11110000
    ORR		R1, R1, #2_11110000
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTQ_DATA_R
    LDR		R1, [R0]
    BIC		R1, R1, #2_00001111
    ORR		R1, R1, #2_00001111
    STR		R1, [R0]
    BX		LR
    LTORG
; -------------------------------------------------------------------------------
; Função LCD_init
; Parâmetro de entrada: N/A
; Parâmetro de saída: N/A
LCD_init
    PUSH	{LR}
    ; estado para inicialização
    CMP		STATE, #STATE_OPEN
    BEQ		lcd_init_moving
    B		lcd_init_static
lcd_init_moving
    ; 8-bit, 1-line, 5x7 dots
    MOV		R0, #2_00110000
    MOV		R1, #40
    BL		LCD_CMD
    ; increment AC, cursor + display shift
    MOV		R0, #2_00000111
    MOV		R1, #40
    BL		LCD_CMD
    ; display ON, cursor OFF
    MOV		R0, #2_00001100
    MOV		R1, #40
    BL		LCD_CMD
    ; reset
    MOV		R0, #2_00000001
    MOV		R1, #1640
    BL		LCD_CMD
    ; cursor just offscreen
    MOV		R0, #0x90
    MOV		R1, #40
    BL		LCD_CMD
    B		lcd_init_end
lcd_init_static
    ; 8-bit, 1-line, 5x7 dots
    MOV		R0, #2_00110000
    MOV		R1, #40
    BL		LCD_CMD
    ; increment AC, cursor shift
    MOV		R0, #2_00000110
    MOV		R1, #40
    BL		LCD_CMD
    ; display ON, cursor OFF
    MOV		R0, #2_00001100
    MOV		R1, #40
    BL		LCD_CMD
    ; reset
    MOV		R0, #2_00000001
    MOV		R1, #1640
    BL		LCD_CMD
lcd_init_end
    POP		{LR}
    BX		LR
; -------------------------------------------------------------------------------
; Função LCD_CMD
; Parâmetro de entrada: R0 -> comando
;						R1 -> tempo de espera
; Parâmetro de saída: N/A
LCD_CMD
    PUSH	{LR}
    MOV		R2, R0
    MOV		R3, R1
    LDR		R0, =GPIO_PORTK_DATA_R
    MOV		R1, R2
    STR		R1, [R0]
    LDR		R0, =GPIO_PORTM_DATA_R
    LDR		R1, [R0]
    BIC		R1, #PORTM_LCD_RS
    ORR		R1, #0
    BIC		R1, #PORTM_LCD_EN
    ORR		R1, #PORTM_LCD_EN
    STR		R1, [R0]
    MOV		R0, #10
    BL		SysTick_Wait1us
    LDR		R0, =GPIO_PORTM_DATA_R
    LDR		R1, [R0]
    BIC		R1, #PORTM_LCD_EN
    ORR		R1, #0
    STR		R1, [R0]
    MOV		R0, R3
    BL		SysTick_Wait1us
    POP		{LR}
    BX		LR
; -------------------------------------------------------------------------------
; Função LCD_DATA
; Parâmetro de entrada: R0 -> comando
; Parâmetro de saída: N/A
LCD_DATA
    PUSH	{LR}
    LDR		R1, =GPIO_PORTK_DATA_R
    STR		R0, [R1]
    LDR		R0, =GPIO_PORTM_DATA_R
    LDR		R1, [R0]
    BIC		R1, #PORTM_LCD_RS
    ORR		R1, #PORTM_LCD_RS
    BIC		R1, #PORTM_LCD_EN
    ORR		R1, #PORTM_LCD_EN
    STR		R1, [R0]
    MOV		R0, #10
    BL		SysTick_Wait1us
    LDR		R0, =GPIO_PORTM_DATA_R
    LDR		R1, [R0]
    BIC		R1, #PORTM_LCD_EN
    ORR		R1, #0
    STR		R1, [R0]
    MOV		R0, #40
    BL		SysTick_Wait1us
    POP		{LR}
    BX		LR
; -------------------------------------------------------------------------------
; Função LCD_print
; Parâmetro de entrada: N/A
; Parâmetro de saída: N/A
LCD_print
    PUSH	{LR}
    ; estado para inicialização
    CMP		STATE, #STATE_OPEN
    BEQ		LCD_print_moving
    B		LCD_print_static
LCD_print_moving
    ; carrega o char do ponteiro para o dado a ser escrito
    LDRB	R0, [LCD_DATA_PTR]
    ; reseta se chegou no zero
    CMP		R0, #0
    ITT 	EQ
        LDREQ	R0, [LCD_CURR_STR]
        MOVEQ	LCD_DATA_PTR, LCD_CURR_STR
    ; incrementa o ponteiro
    ADD		LCD_DATA_PTR, #1
    ; escrevendo o char
    BL		LCD_DATA
    ; esperando pra ficar bonito
    MOV		R0, #500
    BL		SysTick_Wait1ms
    B		LCD_print_end
LCD_print_static
    ; carrega o char
    LDRB	R0, [LCD_DATA_PTR], #1
    ; se é 0, acabou a string
    CMP		R0, #0
    BEQ		LCD_print_end
    ; escrevendo o char
    BL		LCD_DATA
    ; esperando pra ficar bonito
    MOV		R0, #50
    BL		SysTick_Wait1ms
    B		LCD_print_static
LCD_print_end
    POP		{LR}
    BX		LR
; -------------------------------------------------------------------------------
; Função Matrix_read
; Parâmetro de entrada: N/A
; Parâmetro de saída: R0 -> Tecla pressionada (*->E #->F), 0x10 se nenhuma
Matrix_read
    PUSH	{LR}
    ; coluna 1
    MOV		R0, #PORTM_C1
    BL		Matrix_read_j
    CMP		R0, #0
    BEQ		matrix_J2
    ; uma tecla foi detectada
    ; C1xL1 - 1
    TST		R0, #PORTL_L1
    ITT		NE
        MOVNE	R1, #0x1
        BNE		debounce_wait
    ; C1xL2 - 4
    TST		R0, #PORTL_L2
    ITT		NE
        MOVNE	R1, #0x4
        BNE		debounce_wait
    ; C1xL3 - 7
    TST		R0, #PORTL_L3
    ITT		NE
        MOVNE	R1, #0x7
        BNE		debounce_wait
    ; C1xL4 - E
    TST		R0, #PORTL_L4
    ITT		NE
        MOVNE	R1, #0xE
        BNE		debounce_wait
    B		matrix_noneJ
matrix_J2
    ; coluna 2
    MOV		R0, #PORTM_C2
    BL		Matrix_read_j
    CMP		R0, #0
    BEQ		matrix_J3
    ; uma tecla foi detectada
    ; C2xL1 - 2
    TST		R0, #PORTL_L1
    ITT		NE
        MOVNE	R1, #0x2
        BNE		debounce_wait
    ; C2xL2 - 5
    TST		R0, #PORTL_L2
    ITT		NE
        MOVNE	R1, #0x5
        BNE		debounce_wait
    ; C2xL3 - 8
    TST		R0, #PORTL_L3
    ITT		NE
        MOVNE	R1, #0x8
        BNE		debounce_wait
    ; C2xL4 - 0
    TST		R0, #PORTL_L4
    ITT		NE
        MOVNE	R1, #0x0
        BNE		debounce_wait
    B		matrix_noneJ
matrix_J3
    ; coluna 3
    MOV		R0, #PORTM_C3
    BL		Matrix_read_j
    CMP		R0, #0
    BEQ		matrix_J4
    ; uma tecla foi detectada
    ; C3xL1 - 3
    TST		R0, #PORTL_L1
    ITT		NE
        MOVNE	R1, #0x3
        BNE		debounce_wait
    ; C3xL2 - 6
    TST		R0, #PORTL_L2
    ITT		NE
        MOVNE	R1, #0x6
        BNE		debounce_wait
    ; C3xL3 - 9
    TST		R0, #PORTL_L3
    ITT		NE
        MOVNE	R1, #0x9
        BNE		debounce_wait
    ; C3xL4 - F
    TST		R0, #PORTL_L4
    ITT		NE
        MOVNE	R1, #0xF
        BNE		debounce_wait
    B		matrix_noneJ
matrix_J4
    ; coluna 4
    MOV		R0, #PORTM_C4
    BL		Matrix_read_j
    CMP		R0, #0
    BEQ		matrix_noneJ
    ; uma tecla foi detectada
    ; C4xL1 - A
    TST		R0, #PORTL_L1
    ITT		NE
        MOVNE	R1, #0xA
        BNE		debounce_wait
    ; C4xL2 - B
    TST		R0, #PORTL_L2
    ITT		NE
        MOVNE	R1, #0xB
        BNE		debounce_wait
    ; C4xL3 - C
    TST		R0, #PORTL_L3
    ITT		NE
        MOVNE	R1, #0xC
        BNE		debounce_wait
    ; C4xL4 - D
    TST		R0, #PORTL_L4
    ITT		NE
        MOVNE	R1, #0xD
        BNE		debounce_wait
    B		matrix_noneJ
matrix_noneJ
    MOV		R1, #0x10
    B		matrix_endJ
debounce_wait
    MOV		R0, #200
    BL		SysTick_Wait1ms
matrix_endJ
    MOV		R0, R1
    POP		{LR}
    BX		LR
; -------------------------------------------------------------------------------
; Função Matrix_read_j
; Parâmetro de entrada: R0 -> Bit da coluna
; Parâmetro de saída: R0 -> Bit da linha ativa (0 se nenhuma)
Matrix_read_j
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
        BEQ		matrix_end_iCheck
    ; linha 2
    TST		R1, #PORTL_L2
    ITT		EQ
        MOVEQ	R1, #PORTL_L2
        BEQ		matrix_end_iCheck
    ; linha 3
    TST		R1, #PORTL_L3
    ITT		EQ
        MOVEQ	R1, #PORTL_L3
        BEQ		matrix_end_iCheck
    ; linha 4
    TST		R1, #PORTL_L4
    ITT		EQ
        MOVEQ	R1, #PORTL_L4
        BEQ		matrix_end_iCheck
    ; nenhuma ativa
    MOV		R1, #0
matrix_end_iCheck
    ; debouncing
    CMP		R1, #0
    ITT		NE
        MOVNE	R0, #200
        BLNE	SysTick_Wait1ms
    MOV		R0, R1
    POP		{LR}
    BX		LR
; -------------------------------------------------------------------------------
; Liga todos os LEDs
; Entrada: N/A
; Saída: N/A
Blocked_Blink_ON
; Escrevendo em PP
    LDR		R0, =GPIO_PORTP_DATA_R
    LDR		R1, [R0]
    BIC		R1, R1, #2_00100000
    ORR		R1, R1, #2_00100000
    STR		R1, [R0]
    BX		LR
; -------------------------------------------------------------------------------
; Desliga todos os LEDs
; Entrada: N/A
; Saída: N/A
Blocked_Blink_OFF
; Escrevendo em PP
    LDR		R0, =GPIO_PORTP_DATA_R
    LDR		R1, [R0]
    BIC		R1, R1, #2_00100000
    ORR		R1, R1, #2_00000000
    STR		R1, [R0]
    BX		LR
; -------------------------------------------------------------------------------
; Interrupção Port J
GPIOPortJ_Handler
    ; verificando estado
    CMP		STATE, #STATE_BLOCKED
    BNE		portj_interr_ack
    ; verificando se já foi pressionado
    LDR		R0, =SW1_STATE_PTR
    LDR		R1, [R0]
    CMP		R1, #1
    BEQ		portj_interr_ack
    ; lendo resposta
    LDR		R0, =GPIO_PORTJ_AHB_RIS_R
    LDR		R1, [R0]
    ; teste SW1
    TST		R1, #2_1
    IT		NE
        LDRNE	R0, =SW1_STATE_PTR
        MOVNE	R1, #1
        STRNE	R1, [R0]
portj_interr_ack
    ; acknowledge
    LDR		R0, =GPIO_PORTJ_AHB_ICR_R
    MOV		R1, #2_1
    STR		R1, [R0]
    BX LR
; -------------------------------------------------------------------------------
    ALIGN                           ; garante que o fim da seção está alinhada
    END                             ; fim do arquivo