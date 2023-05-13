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
			
		IMPORT LEDS_AND_DISPLAYS_init
		IMPORT select_leds
		IMPORT select_dig_DS
		IMPORT turn_leds_ON
		IMPORT turn_DS1_ON
		IMPORT turn_DS2_ON
		
		IMPORT SysTick_Wait1us
		IMPORT SysTick_Wait1ms
; ========================
; Constantes
NUM_ATTEMPTS        EQU    0x20000004
; ========================
; Ponteiros
ARRAY_PW            EQU    0x20000000

; -------------------------------------------------------------------------------
; Função main()    
Start              
    BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
    BL SysTick_Init
    BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
    BL LCD_init
    BL MKBOARD_init
    BL LEDS_AND_DISPLAYS_init    
    ; Initialize the password length counter
    MOV R4, #0
MainLoop
	BL LCD_reset
    LDR R0, =MSG_OPEN
    BL LCD_print_string
    ; pega um valor do teclado
    MOV R0, #0xC0
    BL LCD_command
    LDR R0, =MSG_PWscreen
    BL LCD_print_string
	
wait_click
    BL MKBOARD_getValuePressed
    CMP R0, #0xFF
    BEQ wait_click
; Check if the pressed key is 'E'
    CMP R0, #0x0E
    BNE not_e_key
; Check if the password has 4 digits
    CMP R4, #4
    BNE wait_click
; If 'E' is pressed and the password has 4 digits, store the password and display MSG_CLOSING
Closing
    BL LCD_reset
    LDR R0, =MSG_CLOSING
    BL LCD_print_string
; Display the stored password on the second line
; Print the MSG_PWscreen before displaying the stored password
    MOV R0, #0xC0
    BL LCD_command
    LDR R0, =MSG_PWscreen
    BL LCD_print_string
    LDR R1, =ARRAY_PW
    MOV R2, #0
display_password_loop
    LDRB R0, [R1]
    BL MKBOARD_valueToASCII
    BL LCD_write_data
    ADD R1, R1, #1
    ADD R2, R2, #1
    CMP R2, #4
    BLT display_password_loop
; Add appropriate delay subroutine to pause the display for 5 seconds
    LDR R0, =5000
    BL SysTick_Wait1ms
	BL Closed
; Display MSG_CLOSED
Closed
    BL LCD_reset
    LDR R0, =MSG_CLOSED
    BL LCD_print_string

not_e_key
; Check if the password already has 4 digits
    CMP R4, #4
    BEQ wait_click
; Store the pressed key value in ARRAY_PW
    LDR R1, =ARRAY_PW
    ADD R1, R1, R4
    STR R0, [R1]
; Increment the password length counter
    ADD R4, R4, #1
; Check if the password length counter is now 4
    CMP R4, #5
    BNE not_final_digit
; If the password length counter is now 4, null-terminate the ARRAY_PW string
    ADD R1, R1, #1
    MOV R0, #0
    STR R0, [R1]
not_final_digit
; Convert the value to ASCII and display it
    BL MKBOARD_valueToASCII
    BL LCD_write_data
    B wait_click

MSG_OPEN	DCB "Cofre Aberto :) !",0
MSG_OPENING	DCB	"Cofre Abrindo",0
MSG_CLOSING	DCB "Cofre Fechando",0
MSG_CLOSED	DCB	"Cofre Fechado!  ",0
MSG_LOCKED	DCB	"Cofre Travado!",0
MSG_PWscreen DCB " PW:",0

    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
