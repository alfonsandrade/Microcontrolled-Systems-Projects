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

; -------------------------------------------------------------------------------
; Função main()
Start  			
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	BL LCD_init
	
	MOV R0, #'A'
	BL LCD_DATA
	
	LDR R0, =STR2
	BL print_string
	
MainLoop
	NOP
	B MainLoop                   ;Volta para o laço principal	

; -------------------------------------------------------------------------------
; Função LCD_write_data
; Parâmetro de entrada: R0: ASCII a ser escrito
; Parâmetro de saída: nao tem
print_string
loop_print_string
	LDRB R1, [R0], #1
	PUSH {LR}
	BL LCD_DATA
	POP {LR}
	CMP R1, #0
	BNE loop_print_string
	
	BX LR


; -------------------------------------------------------------------------------

STR1	DCB	"UTFPR - micro",0
STR2	DCB	'n','o','m','e',0

    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
