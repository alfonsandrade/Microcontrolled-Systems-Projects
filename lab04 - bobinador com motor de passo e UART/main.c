#include <stdint.h>
#include "tm4c1294ncpdt.h"
#include "uart.h"
#include "motor.h"
#include "uart.h"
#include "motorCommand.h"
#include <string.h>

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void SysTick_Wait1us(uint32_t delay);

// Import do assembly
void LCD_init(void);
void LCD_reset(void);
void LCD_command(uint8_t cmd);
void LCD_write_data(uint8_t c);
void LCD_print_string(char *str);

void GPIO_Init(void);
uint32_t PortJ_Input(void);
void PortN_Output(uint32_t leds);

#define BUFFER_SIZE 10

char commandBuffer[BUFFER_SIZE];
int bufferIndex = 0;

void UART_receiveCommand(void) {
    char receivedChar = UART_receive();
    if (receivedChar == '*') { // Start of a new command
        bufferIndex = 0;
    } else if (receivedChar == '\n' || receivedChar == '\r') { // End of command
        commandBuffer[bufferIndex] = '\0'; // Null-terminate the string
        MotorCommand command = parseCommand(commandBuffer);
        executeMotorCommand(command);
        bufferIndex = 0; // Reset the buffer index
    } else if (bufferIndex < BUFFER_SIZE - 1) { // Avoid buffer overflow
        commandBuffer[bufferIndex++] = receivedChar;
    }
}

MotorCommand parseCommand(char* commandStr) {
    MotorCommand command;
    command.turns = atoi(&commandStr[0]); // Convert the first character to an integer
    command.direction = commandStr[2] - '0'; // Convert the third character to a boolean
    command.speed = commandStr[4] - '0'; // Convert the fifth character to a boolean
    return command;
}

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	LCD_init();
	UART_init();
	motor_init();
	
	char c =  'a';

	while (1) {		
		UART_send_str("Ola mundo \r\n");
		SysTick_Wait1ms(1500);
		UART_send(c);
		c++;
	}
}
