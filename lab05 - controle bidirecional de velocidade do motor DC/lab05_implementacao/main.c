#include <stdint.h>
#include <stdbool.h>
#include "tm4c1294ncpdt.h"
#include "util.h"
#include "adc.h"
#include "timer.h"
#include "lcd.h"
#include "matrix_keyboard.h"
#include "motor_DC.h"

#include "leds_and_displays.h"

#define LOW 0
#define HIGH 1
#define CLOCK_WISE 1
#define COUNTER_CLOCK_WISE 0

bool PWM_signal = LOW; 		  		// sinal para o motor (HIGH ou LOW) => (ligado/desligado)
unsigned int timer = 0;		  		// timer que define quando o motor ira alterar a velocidade (ms)
unsigned int current_velocity = 0;	// velocidade atual do motor (0 a 4095)
unsigned int selected_velocity= 0;	// velocidade selecionada do motor (0 a 4095)
bool current_direction 	= 0;		// direcao atual do motor (CLOCK_WISE(1) ou COUNTER_CLOCK_WISE(0))
bool selected_direction = 0;		// direcao selecionada do motor (CLOCK_WISE(1) ou COUNTER_CLOCK_WISE(0))
unsigned int duty_cycle = 50;		// DC do PWM (0 a 100)

/** @brief Interrupcao timer2: usado como PWM neste projeto */
void Timer2A_Handler(void) {

	// limpa flag de interrupcao
	TIMER2_ICR_R = 0x01;

	// aumenta o timer
	timer += (TIMER2_TAILR_R + 1) / 80000; // ((cont + 1)*1000)/80Mhz [ms]

	// calcula o dutycycle
	duty_cycle = (current_velocity * 100) / 0xFFF;
	
	// atualiza o novo tempo de contagem
	if(PWM_signal == LOW)
		TIMER2_TAILR_R = 800 * duty_cycle; // 80000*DC/100
	else
		TIMER2_TAILR_R = 800 * (100 - duty_cycle); // (80000*(100-DC))/100

	// toggle no sinal PWM
	PWM_signal = !PWM_signal;
}


int main(void) {

	PLL_Init();
	SysTick_Init();

	LEDS_AND_DISPLAYS_init();
	ADC_init();
	timer_init();
	LCD_init();
	motor_dc_init();

	// delay para UART estabilizar
	// SysTick_Wait1ms(500);

	select_leds(0xFF);
	turn_leds_ON(true);
	SysTick_Wait1ms(1000);

	while (true) {
		current_velocity = ADC_read();
		select_leds(PWM_signal << 5);
	}
}
