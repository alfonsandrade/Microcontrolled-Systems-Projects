#include <stdint.h>
#include <stdbool.h>
#include "tm4c1294ncpdt.h"
#include "conversores.h"
#include "util.h"
#include "adc.h"
#include "timer.h"
#include "lcd.h"
#include "matrix_keyboard.h"
#include "motor_DC.h"
#include "leds_and_displays.h"

#define LOW 0
#define HIGH 1
#define CLOCK_WISE 'h'
#define COUNTER_CLOCK_WISE 'a'
#define TIME_TO_UPTADE_VELOCITY 10 // ms
#define ACCELERATION 4 // int somado ou subtraido da velocidade a cada TIME_TO_UPDADE_VELOCITY

typedef enum State {
	STATE_INIT,
	STATE_GET_INIT_DIRECTION,
	STATE_START_MOTOR,
	STATE_GET_CONFIG_DIRECTION,
	STATE_GET_CONFIG_VELOCITY,
	STATE_UPDADE_CONFIG,
	STATE_UPDADE_LCD_AND_MOTOR
} State;

void runState_INIT(void);
void runState_GET_INIT_DIRECTION(void);
void runState_START_MOTOR(void);
void runState_GET_CONFIG_DIRECTION(void);
void runState_GET_CONFIG_VELOCITY(void);
void runState_UPDADE_CONFIG(void);
void runState_UPDADE_LCD_AND_MOTOR(void);

State state = STATE_INIT;		// estado da maquina de estados
bool PWM_signal = LOW; 		  	// sinal para o motor (HIGH ou LOW) => (ligado/desligado)
int timer_ms = 0;	  			// timer que define quando o motor ira alterar a velocidade (ms)
int current_velocity = 0;		// velocidade atual do motor (0 a 4095)
int selected_velocity= 0;		// velocidade selecionada do motor (0 a 4095)
char current_direction = 'h';	// direcao atual do motor (CLOCK_WISE ou COUNTER_CLOCK_WISE)
char selected_direction = 'a'; 	// direcao selecionada do motor (CLOCK_WISE ou COUNTER_CLOCK_WISE)
unsigned int duty_cycle = 50;	// DC do PWM (0 a 100)

/** @brief Interrupcao timer2: usado como PWM neste projeto */
void Timer2A_Handler(void) {

	// limpa flag de interrupcao
	TIMER2_ICR_R = 0x01;

	// calcula o dutycycle
	duty_cycle = (current_velocity * 100) / 0xFFF;
	
	// atualiza o novo tempo de contagem e incrementa contador
	if(PWM_signal == LOW) {
		TIMER2_TAILR_R = 800 * duty_cycle; // 80000*DC/100
		timer_ms++;
	} else {
		TIMER2_TAILR_R = 800 * (100 - duty_cycle); // (80000*(100-DC))/100
	}

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
	MKBOARD_init();

	// delay para UART estabilizar
	// SysTick_Wait1ms(500);

	while (true) {

		switch (state) {
		case STATE_INIT:
			runState_INIT();
			break;
		case STATE_GET_INIT_DIRECTION:
			runState_GET_INIT_DIRECTION();
			break;
		case STATE_START_MOTOR:
			runState_START_MOTOR();
			break;
		case STATE_GET_CONFIG_DIRECTION:
			runState_GET_CONFIG_DIRECTION();
			break;
		case STATE_GET_CONFIG_VELOCITY:
			runState_GET_CONFIG_VELOCITY();
			break;
		case STATE_UPDADE_CONFIG:
			runState_UPDADE_CONFIG();
			break;
		default: //STATE_UPDADE_LCD_AND_MOTOR
			runState_UPDADE_LCD_AND_MOTOR();
			break;
		}
	}
}

void runState_INIT(void) {
	turn_leds_ON(false);
	motor_dc_ON(false);	// desliga motor
	DisableInterrupts(); // desabilita timer

	// retorno ao usuario
	LCD_reset();
	LCD_print_string("Motor parado!   ");
	SysTick_Wait1ms(2000);

	state = STATE_GET_INIT_DIRECTION;
}

void runState_GET_INIT_DIRECTION(void) {
	
	// retorno ao usuario
	LCD_set_cursor(1,0);
	LCD_print_string("Sentido: 1:H 2:A");

	// loop para captura do teclado
	do {
		selected_direction = MKBOARD_getCharPressed();
	} while(selected_direction != '1' && selected_direction != '2');
	
	// retorno de tecla pressionada
	LCD_reset();
	if(selected_direction == '1'){
		selected_direction = 'h';
		LCD_print_string("Horario (H)");
	} else  {
		selected_direction = 'a';
		LCD_print_string("Anti-Horario (A)");
	}
	SysTick_Wait1ms(2000);

	state = STATE_START_MOTOR;
}

void runState_START_MOTOR(void) {

	current_velocity = 0;
	selected_velocity = ADC_read();
	timer_ms = 0;
	current_direction = selected_direction;

	motor_dc_ON(true);
	EnableInterrupts();

	state = STATE_GET_CONFIG_DIRECTION;
}

void runState_GET_CONFIG_DIRECTION(void) {

	static char c;
	c = MKBOARD_getCharPressed();

	if(c == '1')
		selected_direction = 'h';
	else if (c == '2') {
		selected_direction = 'a';
	}

	if(c == '*')
		state = STATE_INIT;
	else
		state = STATE_GET_CONFIG_VELOCITY;
}

void runState_GET_CONFIG_VELOCITY(void) {
	selected_velocity = ADC_read();
	state = STATE_UPDADE_CONFIG;
}

void runState_UPDADE_CONFIG(void) {

	// acelera a cada TIME_TO_UPTADE_VELOCITY ms
	if(timer_ms > TIME_TO_UPTADE_VELOCITY) {
		timer_ms -= TIME_TO_UPTADE_VELOCITY;

		// diminui velocidade
		if(current_direction != selected_direction || 
		   current_direction == selected_direction && selected_velocity < current_velocity)
		{
			current_velocity -= ACCELERATION;
			if(current_velocity < 0) {
				current_velocity *= (-1);
				current_direction = selected_direction;
			}
		} else if(current_direction == selected_direction && selected_velocity > current_velocity) {
			current_velocity += ACCELERATION;
		}
	}

	state = STATE_UPDADE_LCD_AND_MOTOR;
}

void runState_UPDADE_LCD_AND_MOTOR(void) {
	
	if(current_direction == 'h') {
		motor_dc_uptade(PWM_signal, 1);
	} else {
		motor_dc_uptade(PWM_signal, 0);
	}

	static char buffer[4];
	
	LCD_set_cursor(0,0);
	LCD_print_string("ATUAL : ");
	LCD_write_data(current_direction);
	LCD_print_string(" ");
	intToString(current_velocity * 100/0xFFF, buffer);
	LCD_print_string(buffer);
	LCD_print_string("%  ");
	
	LCD_set_cursor(1,0);
	LCD_print_string("CONFIG: ");
	LCD_write_data(selected_direction);
	LCD_print_string(" ");
	intToString(selected_velocity * 100/0xFFF, buffer);
	LCD_print_string(buffer);
	LCD_print_string("%  ");

	state = STATE_GET_CONFIG_DIRECTION;
}
