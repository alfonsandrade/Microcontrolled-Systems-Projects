; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Programa referente ao Lab 01 da turma de microcontroladores 2023.1
; Programa incrementado a partir do projeto GPIO2 da aula de GPIO do professor Peron.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
TRUE 	EQU 0x1
FALSE 	EQU 0x0

UNIDADE			EQU 0x20000000	;4bits
DEZENA			EQU 0x2000000f	;4bits
PASSO_VALOR		EQU 0x2000001e	;4bits
LED_CRESCENTE	EQU	0x2000002d	;4bits
LED_ATUAL		EQU	0x2000004b	;8bits

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
		IMPORT  GPIO_Init
        IMPORT  PortF_Output
        IMPORT  PortJ_Input
		IMPORT 	select_leds
		IMPORT 	set_leds
		IMPORT 	set_DS1_ON
		IMPORT 	set_DS2_ON
		IMPORT	select_dig_DS


; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	
	; inicializacao das variaveis
	LDR R0, =UNIDADE
	MOV R1, #9
	STR R1, [R0]
	
	LDR R0, =DEZENA
	MOV R1, #9
	STR R1, [R0]
	
	LDR R0, =PASSO_VALOR
	MOV R1, #1
	STR R1, [R0]
	
	LDR R0, =LED_ATUAL
	MOV R1, #2_01000000
	STR	R1, [R0]
	
	LDR R0, =LED_CRESCENTE
	MOV R1, #FALSE
	STR R1, [R0]

MainLoop
	BL PortJ_Input				 ;Chama a subrotina que lê o estado das chaves e coloca o resultado em R0
Verifica_SW2	
	CMP R0, #2_00000001			 ;Verifica se somente a chave SW2 está pressionada
	BEQ SW2_pressionada
Verifica_SW1
	CMP R0, #2_00000010
	BEQ SW1_pressionada
	B end_loop
SW2_pressionada
	BL operacao_pausada
	B MainLoop
SW1_pressionada
	BL select_next_passo_valor
end_loop
	BL operacao_normal
	B MainLoop

; -------------------------------------------------------------------------------
; Função select_next_passo_valor
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
select_next_passo_valor
	LDR R1, =PASSO_VALOR
	LDR R0, [R1]	;coleta o passo do valor
	ADD R0, #1		;soma o valor do passo
	CMP R0, #10		;verifica se passo passou de 10
	MOVEQ R0, #1		;reseta o passo
	STR R0, [R1]	;armazena novo valor do passo
	BX LR

; -------------------------------------------------------------------------------
; Função select_next_valor
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
select_next_valor
	LDR R1, =UNIDADE
	LDR R0, [R1]	;coleta valor da unidade
	LDR R3, =DEZENA
	LDR R2, [R3]	;coleta valor da dezena
	LDR R5, =PASSO_VALOR
	LDR R4, [R5]	;coleta valor do passo
	ADD R0, R4		;incrementa passo
	CMP R0, #10		;verifica se passou unidade de 10
	ITT CS			;se unidade >= 10
		SUBCS R0, #10	;diminui 10 da unidade
		ADDCS R2, #1	;soma 1 a dezena
	CMP R2, #10		;verifica se dezena passou de 10
	MOVEQ R2, #0		;se dezena >= 10, reseta dezena
	STR R0, [R1]	;armazena novo valor da unidade
	STR R2, [R3]	;armazena novo valor da dezena
	BX LR

; -------------------------------------------------------------------------------
; Função select_next_led
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
select_next_led
	LDR R1, =LED_ATUAL
	LDR R0, [R1]	;coleta bits do led atual
	LDR R3, =LED_CRESCENTE
	LDR R2, [R3]	;coleta passo do led
	CMP R2, #TRUE	;verifica se esta crescente
	BNE led_decrescente	;pula se ele for decrescente
	CMP R0, #2_00000001	;eh crescente, verifica se esta no ultimo bit
	MOVEQ R2, #FALSE	;se esta no ultimo bit, inverte para decrescente
	B select_next_led_end ;pula para atualizar o valor do led
led_decrescente
	CMP	R0, #2_10000000	;eh decrescente, verifica se esta no ultimo bit
	MOVEQ R2, #TRUE		;se esta no ultimo bit, inverte para crescente
select_next_led_end	;atualiza valor do led
	CMP R2, #TRUE	;verifica se eh crescente ou decrescente
	ITE EQ
		LSREQ R0, R0, #1 ;shifta para direita
		LSLNE R0, R0, #1 ;shifta para esquerda
	STR R0, [R1] ;armazena os bits do led
	STR R2, [R3] ;armazena se eh crescente ou decrescente
	BX LR


; -------------------------------------------------------------------------------
; Função operacao_normal
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
operacao_normal
	PUSH {LR}
	BL select_next_valor
	POP {LR}
	
	PUSH {LR}
	BL select_next_led
	POP {LR}
	;reseta o timer
	MOV R10, #0
piscar_normal
	PUSH {LR}
	BL pisca_led
	POP {LR}
	
	PUSH {LR}
	BL pisca_dezena
	POP {LR}
	
	PUSH {LR}
	BL pisca_unidade
	POP {LR}
	
	ADD R10, R10, #6 ;soma 6ms ao timer
	CMP R10, #500 ;verifica se passou 500 ms
	BLO piscar_normal
	BX LR
	
; -------------------------------------------------------------------------------
; Função operacao_pausada
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
operacao_pausada
	;reseta o timer
	MOV R10, #0
piscar_pausado
	
	;seleciona todos os leds
	MOV R0, #2_11111111
	PUSH {LR}
	BL select_leds
	POP {LR}
	
	;verifica se fica ligado ou desligado
	CMP R10, #250
	BLO leds_pausado_ligado
	;leds desligados
	LDR R0, =FALSE
	PUSH {LR}
	BL set_leds
	POP {LR}
	B valor_pausado
leds_pausado_ligado
	LDR R0, =TRUE
	PUSH {LR}
	BL set_leds
	POP {LR}
valor_pausado
	; delay de 1 ms
	MOV R0, #1
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}

	PUSH {LR}
	BL pisca_dezena
	POP {LR}
	
	PUSH {LR}
	BL pisca_unidade
	POP {LR}
	
	ADD R10, R10, #5 ;soma 5ms ao timer
	CMP R10, #500 ;verifica se passou 500 ms
	BLO piscar_pausado
	BX LR

; -------------------------------------------------------------------------------
; Função pisca_led
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
pisca_led
	;seleciona os leds
	LDR R1, =LED_ATUAL
	LDR R0, [R1]
	PUSH {LR}
	BL select_leds
	POP {LR}
	
	; liga leds
	MOV R0, #TRUE
	PUSH {LR}
	BL set_leds
	POP {LR}
	
	; delay de 1 ms
	MOV R0, #1
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
	
	; desliga leds
	MOV R0, #FALSE
	PUSH {LR}
	BL set_leds
	POP {LR}
	
	; delay de 1 ms
	MOV R0, #1
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
	
	BX LR	;return

; -------------------------------------------------------------------------------
; Função pisca_unidade
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
pisca_unidade
	; seleciona unidade
	LDR R1, =UNIDADE
	LDR R0, [R1]
	PUSH {LR}
	BL select_dig_DS
	POP {LR}
	
	; acende unidade
	MOV R0, #TRUE
	PUSH {LR}
	BL set_DS2_ON
	POP {LR}
	
	; espera 1 ms
	MOV R0, #1
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
	
	; desliga unidade
	MOV R0, #FALSE
	PUSH {LR}
	BL set_DS2_ON
	POP {LR}
	
	; espera 1 ms
	MOV R0, #1
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
	
	BX LR ; return
	
; -------------------------------------------------------------------------------
; Função pisca_dezena
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
pisca_dezena
	;seleciona dezena
	LDR R1, =DEZENA
	LDR R0, [R1]
	PUSH {LR}
	BL select_dig_DS
	POP {LR}
	
	; acende dezena
	MOV R0, #TRUE
	PUSH {LR}
	BL set_DS1_ON
	POP {LR}
	
	; espera 1 ms
	MOV R0, #1
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
	
	; desliga dezena
	MOV R0, #FALSE
	PUSH {LR}
	BL set_DS1_ON
	POP {LR}
	
	; espera 1 ms
	MOV R0, #1
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}

	BX LR

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo


