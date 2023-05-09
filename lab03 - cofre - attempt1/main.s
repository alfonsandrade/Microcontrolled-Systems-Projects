; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Constantes
STATE_OPEN	    EQU	0
STATE_OPENING	EQU	1
STATE_CLOSE		EQU 2
STATE_CLOSING	EQU	3
STATE_BLOCKED	EQU	4
; ========================
; Ponteiros
ARRAY_PW_OPEN		EQU	0x20000000
ARRAY_PW_CLOSED	    EQU	0x20000010
ARRAY_PW_BLOCKED	EQU	0x20000020
ARRAY_PW_MASTER	    EQU	0x20000030
SW1_STATE_PTR		EQU	0x20000040
; ========================
; Registradores
LCD_CURR_STR		RN	R12
LCD_DATA_PTR		RN	R11
STATE				RN	R10
PW_OPEN_PTR		    RN	R9
PW_CLOSED_PTR		RN	R9
PW_BLOCKED_PTR		RN	R9
ATTEMPTS			RN	R8
LED_COUNT		    RN	R8
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
        IMPORT  PLL_Init
        IMPORT  SysTick_Init
        IMPORT  SysTick_Wait1ms
        IMPORT	SysTick_Wait1us
        IMPORT  GPIO_Init
        IMPORT  LCD_init
        IMPORT  LCD_CMD
        IMPORT	LCD_DATA
        IMPORT	Matrix_read
        IMPORT	LCD_print
        IMPORT	Blocked_Blink_ON
        IMPORT	Blocked_Blink_OFF
			; -------------------------------------------------------------------------------------------------------------------------
		; Strings
		EXPORT STR_OPEN		
		EXPORT STR_OPENING		
		EXPORT STR_CLOSED		
		EXPORT STR_CLOSING	   
		EXPORT STR_BLOCKED		
; -------------------------------------------------------------------------------------------------------------------------
; -------------------------------------------------------------------------------
; Função main()
Start
    BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
    BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
    BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	BL LCD_init
    ; resetando o estado do botão
    LDR		R0, =SW1_STATE_PTR
    MOV		R1, #0
    STR		R1, [R0]
    ; senha mestre
    LDR		R0, =ARRAY_PW_MASTER
	MOV 	R1, #0x1234
	STR		R1, [R0]
    B		State_Open
; -------------------------------------------------------------------------------
; Estado: ABERTO
State_Open
    ; inicializando
    MOV		STATE, #STATE_OPEN
    LDR		LCD_CURR_STR, =STR_OPEN
    MOV		LCD_DATA_PTR, LCD_CURR_STR
    LDR		PW_OPEN_PTR, =ARRAY_PW_OPEN
    SUB		PW_OPEN_PTR, #4
open_loop
    ; escreve no lcd
    BL		LCD_print
    ; lê o teclado
    BL		Matrix_read
    ; volta se não leu nada
    CMP		R0, #0x10
    BEQ		open_loop
    MOV		R1, R0
    ; incrementa o ponteiro da senha
    ADD		PW_OPEN_PTR, #4
    ; vê se passou de 4 digitos
    LDR		R0, =ARRAY_PW_OPEN
    ADD		R0, #16
    CMP		PW_OPEN_PTR, R0
    BNE		state_open_write
    ; vai pro estado FECHANDO se recebeu '#'
    CMP		R1, #0xF
    BEQ		state_open_change
    ; resetando a senha da memória
    LDR		PW_OPEN_PTR, =ARRAY_PW_OPEN
state_open_write
    ; escreve no vetor
    STR		R1, [PW_OPEN_PTR]
    B		open_loop
state_open_change
    ; espera 1s
    MOV		R0, #1000
    BL		SysTick_Wait1ms
    B		State_Closing
; -------------------------------------------------------------------------------
; Estado: ABRINDO
State_Opening
    ; inicializando
    MOV		STATE, #STATE_OPENING
    LDR		LCD_CURR_STR, =STR_OPENING
    MOV		LCD_DATA_PTR, LCD_CURR_STR
    ; escreve no lcd
    BL		LCD_print
    ; espera 5s
    MOV		R0, #5000
    BL		SysTick_Wait1ms
    B		State_Open
; -------------------------------------------------------------------------------
; Estado: FECHADO
State_Close
    ; inicializando
    MOV		STATE, #STATE_CLOSE
    BL		LCD_init
    LDR		LCD_CURR_STR, =STR_CLOSED
    MOV		LCD_DATA_PTR, LCD_CURR_STR
    LDR		PW_CLOSED_PTR, =ARRAY_PW_CLOSED
    MOV		ATTEMPTS, #3
    ; escreve no lcd
    BL		LCD_print
closed_loop
    ; lê o teclado
    BL		Matrix_read
    ; volta se não leu nada
    CMP		R0, #0x10
    BEQ		closed_loop
    MOV		R1, R0
    ; escrevendo no vetor
    STR		R1, [PW_CLOSED_PTR]
    ; continuando se o vetor não encheu
    LDR		R0, =ARRAY_PW_CLOSED
    ADD		R0, #12
    CMP		PW_CLOSED_PTR, R0
    ITT		NE
        ADDNE	PW_CLOSED_PTR, #4
        BNE		closed_loop
    ; comparando os vetores
    LDR		R0, =ARRAY_PW_CLOSED
    LDR		R1, =ARRAY_PW_OPEN
    BL		Password_check
    ; senha correta
    CMP		R0, #1
    BEQ		State_Opening
    ; senha incorreta
    ADD		ATTEMPTS, #1
    LDR		PW_CLOSED_PTR, =ARRAY_PW_CLOSED
    CMP		ATTEMPTS, #3
    BGE		State_Blocked
    B		closed_loop
; -------------------------------------------------------------------------------
; Estado: FECHANDO
State_Closing
    ; inicializando
    MOV		STATE, #STATE_CLOSING
    BL		LCD_init
    LDR		LCD_CURR_STR, =STR_CLOSING
    MOV		LCD_DATA_PTR, LCD_CURR_STR
    ; escreve no lcd
    BL		LCD_print
    ; espera 5s
    MOV		R0, #5000
    BL		SysTick_Wait1ms
    B		State_Close
; -------------------------------------------------------------------------------
; Estado: TRAVADO
State_Blocked
    ; inicializando
    MOV		STATE, #STATE_BLOCKED
    LDR		LCD_CURR_STR, =STR_BLOCKED
    MOV		LCD_DATA_PTR, LCD_CURR_STR
    ; escreve no lcd
    BL		LCD_print
    LDR		PW_BLOCKED_PTR, =ARRAY_PW_BLOCKED
    MOV		LED_COUNT, #0
blocked_loop
    ; pisca os LEDs
    BL		Blocked_blink
    ; verifica o botão
    LDR		R0, =SW1_STATE_PTR
    LDR		R1, [R0]
    CMP		R1, #1
    BNE		blocked_loop
blocked_loop_buttonRead
    ; pisca os LEDs
    BL		Blocked_blink
    ; verifica o teclado
    BL		Matrix_read
    CMP		R0, #0x10
    BEQ		blocked_loop_buttonRead
    ; escreve na memória
    STR		R0, [PW_BLOCKED_PTR]
    ; continua se não encheu o vetor
    LDR		R0, =ARRAY_PW_BLOCKED
    ADD		R0, #12
    CMP		PW_BLOCKED_PTR, R0
    ITT		NE
        ADDNE	PW_BLOCKED_PTR, #4
        BNE		blocked_loop_buttonRead
    ; compara os vetores
    LDR		R0, =ARRAY_PW_BLOCKED
    LDR		R1, =ARRAY_PW_MASTER
    BL		Password_check
    ; senha incorreta
    CMP		R0, #0
    IT		EQ
        LDREQ	PW_BLOCKED_PTR, =ARRAY_PW_BLOCKED
    BEQ		blocked_loop_buttonRead
    ; senha correta
    LDR		R0, =SW1_STATE_PTR
    MOV		R1, #0
    STR		R1, [R0]
    B		State_Open
; -------------------------------------------------------------------------------
; Function: Blocked_blink
; Input parameter: N/A
; Output parameter: N/A
Blocked_blink
    PUSH	{LR}               ; Save the Link Register (LR) to the stack
    ADD		LED_COUNT, #1      ; Increment the LED_COUNT by 1

    ; Semi-cycle ON
    CMP		LED_COUNT, #1000   ; Compare LED_COUNT with 1000
    IT		GT                 ; If Greater Than (GT), execute the next instruction
    MOVGT	LED_COUNT, #1      ; If the condition is true, reset LED_COUNT to 1
    BGT		blink_on           ; Branch to blink_on if LED_COUNT > 1000

    ; Semi-cycle OFF
    CMP		LED_COUNT, #500    ; Compare LED_COUNT with 500
    BGT		blink_off          ; Branch to blink_off if LED_COUNT > 500
    B		blink_on           ; Branch to blink_on

blink_off
    BL		Blocked_Blink_OFF  ; Call the Blocked_Blink_OFF function
    B		blink_wait         ; Branch to blink_wait

blink_on
    BL		Blocked_Blink_ON   ; Call the Blocked_Blink_ON function

blink_wait
    MOV		R0, #1             ; Set R0 to 1
    BL		SysTick_Wait1ms    ; Call the SysTick_Wait1ms function with R0 as the argument
    POP		{LR}               ; Restore the Link Register (LR) from the stack
    BX		LR                 ; Return from the function

; -------------------------------------------------------------------------------
; Função Password_check
; Parâmetro de entrada: R0 -> ponteiro para senha 1
;						R1 -> ponteiro para senha 2
; Parâmetro de saída: R0 -> 1 se as senhas são iguais, 0 se não
Password_check
    LDR		R2, [R0], #4
    LDR		R3, [R1], #4
    CMP		R2, R3
    BNE		passwordCheck_fail
    LDR		R2, [R0], #4
    LDR		R3, [R1], #4
    CMP		R2, R3
    BNE		passwordCheck_fail
    LDR		R2, [R0], #4
    LDR		R3, [R1], #4
    CMP		R2, R3
    BNE		passwordCheck_fail
    LDR		R2, [R0]
    LDR		R3, [R1]
    CMP		R2, R3
    BNE		passwordCheck_fail
    MOV		R0, #1
    B		passwordCheck_end
passwordCheck_fail
    MOV		R0, #0
passwordCheck_end
    BX		LR
; -------------------------------------------------------------------------------------------------------------------------
; Strings
STR_OPEN		DCB	"Cofre aberto, digite nova senha para fechar o cofre. ",0
STR_OPENING		DCB	"Cofre abrindo... ",0
STR_CLOSED		DCB	"Cofre fechado! ",0
STR_CLOSING	    DCB	"Cofre fechando... ",0
STR_BLOCKED		DCB	"Cofre Travado! ",0
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------
    ALIGN                        ;Garante que o fim da seção está alinhada
    END                          ;Fim do arquivo