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
		IMPORT LCD_reset
		IMPORT LCD_command
		IMPORT LCD_write_data
		IMPORT LCD_print_string
			
		IMPORT MKBOARD_init
		IMPORT MKBOARD_getValuePressed
		IMPORT MKBOARD_valueToASCII
			
		IMPORT SysTick_Wait1us

; -------------------------------------------------------------------------------
; Função main()
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
	B MainLoop                   ;Volta para o laço principal	

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

    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
