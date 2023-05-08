; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Rev1: 10/03/2018
; Rev2: 10/04/2019
; Este programa espera o usu�rio apertar a chave USR_SW1 e/ou a chave USR_SW2.
; Caso o usu�rio pressione a chave USR_SW1, acender� o LED3 (PF4). Caso o usu�rio pressione 
; a chave USR_SW2, acender� o LED4 (PF0). Caso as duas chaves sejam pressionadas, os dois 
; LEDs acendem.

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; ========================

; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
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
; Fun��o wait_5_seconds
; Par�metro de entrada: nao tem
; Par�metro de sa�da: nao tem
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
SENHA_ERRADA   DCB "SENHA ERRADA", 0 ; Null-terminated string using your syntax; Fun��o wait_5_seconds

    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
