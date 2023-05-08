; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Rev1: 10/03/2018
; Rev2: 10/04/2019
; Este programa espera o usuário apertar a chave USR_SW1 e/ou a chave USR_SW2.
; Caso o usuário pressione a chave USR_SW1, acenderá o LED3 (PF4). Caso o usuário pressione 
; a chave USR_SW2, acenderá o LED4 (PF0). Caso as duas chaves sejam pressionadas, os dois 
; LEDs acendem.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================

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
        IMPORT PortJ_Input
		IMPORT GPIOPortJ_Handler
		IMPORT LCD_init
		IMPORT LCD_DATA
		IMPORT LCD_print_string
		IMPORT LCD_reset
		
; -------------------------------------------------------------------------------
; Função wait_5_seconds
; Parâmetro de entrada: nao tem
; Parâmetro de saída: nao tem
wait_1_seconds
	MOV R0, #1000
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
; -------------------------------------------------------------------------------
    AREA CODE, CODE
    ENTRY
Start
    BL PLL_Init
    BL SysTick_Init
    BL GPIO_Init
    BL LCD_init

MainLoop
    LDR R0, =COFRE_ABERTO
    BL LCD_print_string
	BL wait_1_seconds
	BL LCD_reset
    LDR R0, =COFRE_FECHADO
    BL LCD_print_string
	BL wait_1_seconds
	BL LCD_reset
    LDR R0, =COFRE_BLOQUEIO
    BL LCD_print_string
	BL wait_1_seconds
	BL LCD_reset
    LDR R0, =SENHA_CORRETA
    BL LCD_print_string
	BL wait_1_seconds
	BL LCD_reset
    LDR R0, =SENHA_ERRADA 
    BL LCD_print_string
	BL wait_1_seconds
	BL LCD_reset

    B MainLoop


COFRE_ABERTO   DCB "COFRE ABERTO", 0 ; Null-terminated string using your syntax
COFRE_FECHADO  DCB "COFRE FECHADO", 0 ; Null-terminated string using your syntax
COFRE_BLOQUEIO DCB "COFRE BLOQUEADO", 0 ; Null-terminated string using your syntax
SENHA_CORRETA  DCB "SENHA CORRETA", 0 ; Null-terminated string using your syntax
SENHA_ERRADA   DCB "SENHA ERRADA", 0 ; Null-terminated string using your syntax; Função wait_5_seconds

    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
