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
        IMPORT  PortJ_Input
		IMPORT  GPIOPortJ_Handler
			
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
		
		IMPORT EnableInterrupt
		IMPORT DisableInterrupt
		
		IMPORT SysTick_Wait1us
		IMPORT SysTick_Wait1ms
		
		EXPORT enter_pw_master_interrupt
; ========================
; Constantes
NUM_ATTEMPTS    EQU    0x20000004

; ========================
; Ponteiros
ARRAY_PW        EQU 0x20000000
INPUT_PW        EQU 0x20000008
; Constantes

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
MainLoop
	BL LCD_reset
	MOV R5, #0
	MOV R4, #0
	;BL DisableInterrupt
    LDR R0, =MSG_OPEN
    BL LCD_print_string
    MOV R0, #0xC0
    BL LCD_command
    LDR R0, =MSG_PWscreen
    BL LCD_print_string

wait_click_open
    BL MKBOARD_getValuePressed
    CMP R0, #0xFF
    BEQ wait_click_open
; Check if the pressed key is 'E'
    CMP R0, #0x0E
    BNE not_e_key_open
; Check if the password has 4 digits
    CMP R4, #4
    BNE wait_click_open

Closing
    BL LCD_reset
	LDR R1, =INPUT_PW ; Source array pointer
    LDR R2, =ARRAY_PW ; Destination array pointer
    MOV R3, #5 ; Size of the array to copy (4 digits + null-terminator)
    BL copy_array ; Call the copy_array function
    LDR R1, =INPUT_PW ; Array pointer
    MOV R2, #5 ; Size of the array to clear (4 digits + null-terminator)
	BL clear_array
	LDR R0, =MSG_CLOSING
    BL LCD_print_string
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

Closed
    BL LCD_reset
    LDR R0, =MSG_CLOSED
    BL LCD_print_string
	MOV R0, #0xC0
    BL LCD_command
    LDR R0, =MSG_PWscreen
    BL LCD_print_string
	MOV R4, #0
	LDR R1, =INPUT_PW ; Array pointer
    MOV R2, #5 ; Size of the array to clear (4 digits + null-terminator)
	BL clear_array
wait_click_closed
    BL MKBOARD_getValuePressed
    CMP R0, #0xFF
    BEQ wait_click_closed
; Check if the pressed key is 'E'
    CMP R0, #0x0E
    BNE not_e_key_closed
; Check if the password has 4 digits
    CMP R4, #4
    BNE wait_click_closed
; If 'E' is pressed and the password has 4 digits, store the password and display MSG_CLOSING
Password_Check
	; Call the compare_arrays function
	LDR R1, =INPUT_PW ; Pointer to the first array (INPUT_PW)
	LDR R2, =ARRAY_PW ; Pointer to the second array (ARRAY_PW)
	MOV R3, #4 ; Size of the arrays to compare (4 in your case)
	BL compare_arrays ; Call the function
	; Check the result in R0
	CMP R0, #1
	BEQ Opening
	BNE attempt_count

; Display MSG_CLOSED
not_e_key_open
; Check if the password already has 4 digits
    CMP R4, #4
    BEQ wait_click_open
; Store the pressed key value in ARRAY_PW
    LDR R1, =INPUT_PW
    ADD R1, R1, R4
    STR R0, [R1]
; Increment the password length counter
    ADD R4, R4, #1
; Check if the password length counter is now 4
    CMP R4, #5
    BNE not_final_digit_open
; If the password length counter is now 4, null-terminate the ARRAY_PW string
    ADD R1, R1, #1
    MOV R0, #0
    STR R0, [R1]
not_final_digit_open
; Convert the value to ASCII and display it
    BL MKBOARD_valueToASCII
    BL LCD_write_data
    B wait_click_open

not_e_key_closed
; Check if the password already has 4 digits
    CMP R4, #4
    BEQ wait_click_closed
; Store the pressed key value in ARRAY_PW
    LDR R1, =INPUT_PW
    ADD R1, R1, R4
    STR R0, [R1]
; Increment the password length counter
    ADD R4, R4, #1
; Check if the password length counter is now 4
    CMP R4, #5
    BNE not_final_digit_closed
; If the password length counter is now 4, null-terminate the ARRAY_PW string
    ADD R1, R1, #1
    MOV R0, #0
    STR R0, [R1]
not_final_digit_closed
; Convert the value to ASCII and display it
    BL MKBOARD_valueToASCII
    BL LCD_write_data
    B wait_click_closed
	
attempt_count
	ADD R5, R5, 1
	CMP R5, #2
	BEQ Blocked
	BNE attempt_screen

Opening
    BL LCD_reset
    LDR R0, =MSG_OPENING
    BL LCD_print_string
    LDR R0, =5000
    BL SysTick_Wait1ms
	BL MainLoop	
	
attempt_screen
	BL LCD_reset
    LDR R0, =MSG_AttemptScreen
    BL LCD_print_string
	LDR R0, =3000
    BL SysTick_Wait1ms
	BL Closed
	
Blocked
	BL LCD_reset
    LDR R0, =MSG_BLOCKED
    BL LCD_print_string
;	BL EnableInterrupt
	MOV R4, #0
	LDR R1, =INPUT_PW ; Array pointer
    MOV R2, #5 ; Size of the array to clear (4 digits + null-terminator)
	BL clear_array
	LDR R0, =3000
    BL SysTick_Wait1ms
	B Blocked

enter_pw_master_interrupt
	BL LCD_reset
    LDR R0, =MSG_BLOCKED
    BL LCD_print_string
	MOV R0, #0xC0
    BL LCD_command
    LDR R0, =MSG_PWscreen
	BL LCD_print_string
wait_click_blocked
    BL MKBOARD_getValuePressed
    CMP R0, #0xFF
    BEQ wait_click_blocked
; Check if the pressed key is 'E'
    CMP R0, #0x0E
    BNE not_e_key_blocked
; Check if the password has 4 digits
    CMP R4, #4
    BNE wait_click_blocked
Password_Check_master
	; Call the compare_arrays function
	LDR R1, =INPUT_PW ; Pointer to the first array (INPUT_PW)
	LDR R2, =MASTER_PW ; Pointer to the second array (ARRAY_PW)
	MOV R3, #4 ; Size of the arrays to compare (4 in your case)
	BL compare_arrays ; Call the function
	; Check the result in R0
	CMP R0, #1
	BEQ Opening
	BNE Blocked

not_e_key_blocked
; Check if the password already has 4 digits
    CMP R4, #4
    BEQ wait_click_blocked
; Store the pressed key value in ARRAY_PW
    LDR R1, =INPUT_PW
    ADD R1, R1, R4
    STR R0, [R1]
; Increment the password length counter
    ADD R4, R4, #1
; Check if the password length counter is now 4
    CMP R4, #5
    BNE not_final_digit_blocked
; If the password length counter is now 4, null-terminate the ARRAY_PW string
    ADD R1, R1, #1
    MOV R0, #0
    STR R0, [R1]
not_final_digit_blocked
; Convert the value to ASCII and display it
    BL MKBOARD_valueToASCII
    BL LCD_write_data
    B wait_click_closed

copy_array
    PUSH {R1, R2, R3, LR} ; Save the registers

copy_loop
    LDRB R0, [R1]  ; Load a byte from the source array
    STRB R0, [R2]  ; Store the byte in the destination array
    ADD R1, R1, #1 ; Increment the source array pointer
    ADD R2, R2, #1 ; Increment the destination array pointer
    SUBS R3, R3, #1 ; Decrement the size counter
    BNE copy_loop  ; If the size counter is not zero, continue copying
    POP {R1, R2, R3, LR} ; Restore the registers
    BX LR ; Return to the calling function
	
clear_array
    PUSH {R1, R2, LR} ; Save the registers

clear_loop
    MOV R0, #0      ; Load the value 0
    STRB R0, [R1]   ; Store the value 0 in the array
    ADD R1, R1, #1  ; Increment the array pointer
    SUBS R2, R2, #1 ; Decrement the size counter
    BNE clear_loop  ; If the size counter is not zero, continue clearing
    POP {R1, R2, LR} ; Restore the registers
    BX LR ; Return to the calling function

; Function to compare two arrays
; R1 - Pointer to the first array (INPUT_PW)
; R2 - Pointer to the second array (ARRAY_PW)
; R3 - Size of the arrays to compare (4 in your case)
; Returns: R0 = 1 if arrays are equal, R0 = 0 if arrays are not equal

compare_arrays
    PUSH {R1, R2, R3, LR} ; Save the registers

compare_loop
    LDRB R0, [R1]  ; Load a byte from the first array
    LDRB R4, [R2]  ; Load a byte from the second array
    CMP R0, R4     ; Compare the loaded bytes
    BNE not_equal  ; If the bytes are not equal, jump to not_equal

    ADD R1, R1, #1 ; Increment the first array pointer
    ADD R2, R2, #1 ; Increment the second array pointer
    SUBS R3, R3, #1 ; Decrement the size counter
    BNE compare_loop  ; If the size counter is not zero, continue comparing

    ; Arrays are equal
    MOV R0, #1
    B finish_compare

not_equal
    ; Arrays are not equal
    MOV R0, #0

finish_compare
    POP {R1, R2, R3, LR} ; Restore the registers
    BX LR ; Return to the calling function

; If 'E' is pressed and the password has 4 digits, store the password and display MSG_CLOSING

MASTER_PW DCB "7777",0
MSG_OPEN	DCB "Cofre Aberto :)!",0
MSG_OPENING	DCB	"Cofre Abrindo!",0
MSG_CLOSING	DCB "Cofre Fechando...",0
MSG_CLOSED	DCB	"Cofre Fechado !",0
MSG_BLOCKED	DCB	"Cofre Travado !",0
MSG_PWscreen DCB " PW:",0
MSG_AttemptScreen DCB "Tentativa --",0
STR2 DCB " Teste ",0

    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
