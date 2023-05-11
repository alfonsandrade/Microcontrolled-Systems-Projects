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
		IMPORT LCD_reset
		IMPORT LCD_command
		IMPORT LCD_write_data
		IMPORT LCD_print_string
			
		IMPORT MKBOARD_init
		IMPORT MKBOARD_getValuePressed
		IMPORT MKBOARD_valueToASCII
			
		IMPORT SysTick_Wait1us

; -------------------------------------------------------------------------------
; Fun��o main()
Start  			
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	BL LCD_init
	BL MKBOARD_init
	
	LDR R0, =STR1
	BL LCD_print_string
	MOV R0, #1000
	BL SysTick_Wait1ms
	BL LCD_reset
	
MainLoop
	
	; pega um valor do teclado
	BL MKBOARD_getValuePressed
	
	CMP R0, #0xFF
	BEQ MainLoop
	CMP R0, #0xF
	BEQ Reset      
	BL MKBOARD_valueToASCII
	BL LCD_write_data
	B MainLoop

Reset
	BL LCD_reset
	B MainLoop                   ;Volta para o la�o principal	

; -------------------------------------------------------------------------------

STR1	DCB	"DEU BOA 1",0
STR2	DCB "DEU BOA 2", 0
;STR2	DCB	'n','o','m','e',0
MSG_NENHUM_VALOR DCB "Sem Valor!",0
MSG_OPEN	DCB "Cofre Aberto :) !",0
MSG_OPENING	DCB	"Cofre Abrindo",0
MSG_CLOSING	DCB "Cofre Fechando",0
MSG_CLOSED	DCB	"Cofre Fechado!",0
MSG_LOCKED	DCB	"Cofre Travado!",0

    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
