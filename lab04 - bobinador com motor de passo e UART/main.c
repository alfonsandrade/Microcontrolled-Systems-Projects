#include <stdint.h>
#include "tm4c1294ncpdt.h"
#include "uart.h"
#include "motor.h"

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


void leitura(void) {

	uint8_t c;
	
	while((UART0_FR_R & UART_FR_RXFE) == UART_FR_RXFE) { }

	c = UART0_DR_R;

	LCD_write_data(c);
}

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	LCD_init();
	UART_init();
	motor_init();

	while (1) {
		fullRotation_H();
	}
}
