#include <stdint.h>
#include <stdbool.h>
#include "tm4c1294ncpdt.h"
#include "util.h"
#include "conversores.h"
#include "leds_onboard.h"
#include "leds_and_displays.h"
#include "lcd.h"
#include "matrix_keyboard.h"
#include "timer.h"
#include "motor.h"
#include "uart.h"
#include "sw1_and_sw2.h"

/* defines */

typedef enum State {
	STATE_INIT,
	STATE_GET_INPUT,
	STATE_INIT_CYCLE,
	STATE_PRINT_TURN,
	STATE_INCREMENTS_ANGLES,
	STATE_FULL_CW,
	STATE_FULL_CC,
	STATE_HALF_CW,
	STATE_HALF_CC,
	STATE_UPDATE_LEDS,
	STATE_UPDATE_TURNS,
	STATE_END
} State;

#define HALF_STEP 's' 		// slow
#define FULL_STEP 'f' 		// fast
#define CLOCKWISE 'h'			// horario
#define COUNTER_CLOCKWISE 'a'	// anti-horario

/* Estruturas */

typedef struct Motor {
	int turns_remaining;	// numero de voltas de 1 a 10
	int32_t angle;			// angulo rotacionado
	char direction;			// CLOCKWISE ou COUNTER_CLOCKWISE
	char speed;				// HALF_STEP ou FULL_STEP
} Motor;

typedef struct  Leds {
	uint8_t selected;	// leds selecionados 0x00 a 0xFF
	int32_t angle;		// angulo rotacionado
} Leds;

/* variaveis */

State state = STATE_INIT;	// estado atual da maquina
Motor motor;				// instancia do motor
Leds leds;					// instancia dos leds sequenciais
bool led_onboard_on; 		// booleano que define se o led onboard esta ligado

/** @brief interrupcao do timer */
void Timer2A_Handler(void);

/** @brief tratamento de interrupção gerado pelos botoes */
void GPIOPortJ_Handler(void);

/* Funcoes de estados */

void runState_INIT(void);
void runState_GET_INPUT(void);
void runState_INIT_CYCLE(void);
void runState_PRINT_TURN(void);
void runState_INCREMENTS_ANGLES(void);
void runState_CW_FULL(void);
void runState_CC_FULL(void);
void runState_CW_HALF(void);
void runState_CC_HALF(void);
void runState_UPDATE_LEDS(void);
void runState_UPDATE_TURNS(void);
void runState_END(void);

int main(void) {

	PLL_Init();
	SysTick_Init();
	leds_onboard_init();
	LEDS_AND_DISPLAYS_init();
	LCD_init();
	MKBOARD_init();
	timer_init();
	motor_init();
	SW1_SW2_init();
	UART_init();

	state = STATE_INIT;
	DisableInterrupts();

	// delay para UART estabilizar
	SysTick_Wait1ms(500);

	while (1) {
		switch (state) {
		case STATE_INIT:
			runState_INIT();
			break;
		case STATE_GET_INPUT:
			runState_GET_INPUT();
			break;
		case STATE_INIT_CYCLE:
			runState_INIT_CYCLE();
			break;
		case STATE_PRINT_TURN:
			runState_PRINT_TURN();
			break;
		case STATE_INCREMENTS_ANGLES:
			runState_INCREMENTS_ANGLES();
			break;
		case STATE_FULL_CW:
			runState_CW_FULL();
			break;
		case STATE_FULL_CC:
			runState_CC_FULL();
			break;
		case STATE_HALF_CW:
			runState_CW_HALF();
			break;
		case STATE_HALF_CC:
			runState_CC_HALF();
			break;
		case STATE_UPDATE_LEDS:
			runState_UPDATE_LEDS();
			break;
		case STATE_UPDATE_TURNS:
			runState_UPDATE_TURNS();
			break;
		default: // STATE_END
			runState_END();
			break;
		}
	}
}

void runState_INIT() {

	// mesagem inicial no terminal
	UART_clear_terminal();
	UART_send_str("Pressione '*' no teclado para iniciar \n\r");

	// enquanto o usuario nao pressiona '*' no teclado matricial
	while (MKBOARD_getCharPressed() != '*') { }
	
	// resetando as referencias
	motor.angle = 0.0;
	motor.turns_remaining = 0;
	leds.angle = 0.0;
	leds.selected = 0x0;

	// passa para proximo estado
	state = STATE_GET_INPUT;
}

void runState_GET_INPUT(void) {
    
    char str_Turns[10];  // array para armazenar a string de números
    int i;
	// solicitar numero de voltas
    UART_send_str("Por favor insira o numero de voltas e pressione ENTER \n\r");
    // suponha que você esteja lendo caracteres de uma UART serial em um loop
    for (i = 0; i < 9; i++) {
        str_Turns[i] = UART_receive();  
        if (str_Turns[i] == '\n' || str_Turns[i] == '\r' ) {   // se um caractere de nova linha, pare de ler
            break;
        }
    }
    str_Turns[i] = '\0';  // termine a string com um caractere nulo
    int int_Turns = stringToInt( str_Turns );
	motor.turns_remaining = int_Turns;

	// solicitar o sentido
    UART_send_str("Por favor insira o sentido 'h' para horario 'a' para anti-horario \n\r");
	//motor.direction = CLOCKWISE;
    char direction = 'z'; 
    while(direction != 'h' && direction != 'a'){
        direction = UART_receive( );
    }
    if(direction == 'h'){
        motor.direction = CLOCKWISE;
    }
    else{
        motor.direction = COUNTER_CLOCKWISE;
    }
	// solicitar a velocidade
	motor.speed = HALF_STEP;
	//motor.speed = FULL_STEP;
	char speed = 'z'; 
    while(direction != 's' && direction != 'f'){
        direction = UART_receive( );
    }
    if(direction == 's'){
        motor.speed = HALF_STEP;
    }
    else{
        motor.speed = FULL_STEP;
    }
    printf("Motor Settings:\n");
    printf("Speed: %c\n", motor.speed);
    printf("Direction: %c\n", motor.direction);
    printf("Turns Remaining: %d\n", motor.turns_remaining);
	state = STATE_INIT_CYCLE;
}

void runState_INIT_CYCLE(void) {
	// inicializa interrupcoes
	EnableInterrupts();
	if(motor.direction == CLOCKWISE) {
		leds.selected = 0x80;
	} else {
		leds.selected = 0x01;
	}
	select_leds(leds.selected);
	turn_leds_ON(true);
	// retorno ao usuario
	UART_send_str("Sentido: ");
	if(motor.direction == CLOCKWISE) {
		UART_send_str("HORARIO \n\r");
	} else {
		UART_send_str("ANTI-HORARIO \n\r");
	}

	UART_send_str("Velocidade: ");
	if(motor.speed == FULL_STEP) {
		UART_send_str("FULL-STEP \n\r");
	} else {
		UART_send_str("HALF-STEP \n\r");
	}

	UART_send_str("Voltas restantes: ");

	state = STATE_PRINT_TURN;
}

void runState_PRINT_TURN(void) {

	UART_send(decimalToChar(motor.turns_remaining));
	UART_send_str(" ");

	// proximo estado
	state = STATE_INCREMENTS_ANGLES;
}

void runState_INCREMENTS_ANGLES(void) {

	// incrementa angulo do motor, leds e toma decisao de giro
	if(motor.speed == FULL_STEP) {
		motor.angle += 88;
		leds.angle += 88;

		if(motor.direction == CLOCKWISE) {
			state = STATE_FULL_CW;
		} else {
			state = STATE_FULL_CC;
		}
	} else {
		motor.angle += 44;
		leds.angle += 44;
		
		if(motor.direction == CLOCKWISE) {
			state = STATE_HALF_CW;
		} else {
			state = STATE_HALF_CC;
		}
	}
}

void runState_CW_FULL(void) {
	motor_clockwise_fullRotation();
	state = STATE_UPDATE_LEDS;
}

void runState_CC_FULL(void) {
	motor_counterClockwise_fullRotation();
	state = STATE_UPDATE_LEDS;
}

void runState_CW_HALF(void) {
	motor_clockwise_halfRotation();
	state = STATE_UPDATE_LEDS;
}

void runState_CC_HALF(void) {
	motor_counterClockwise_halfRotation();
	state = STATE_UPDATE_LEDS;
}

void runState_UPDATE_LEDS(void) {

	if(leds.angle > 45000) {
		leds.angle -= 45000;
		if(motor.direction == CLOCKWISE) {
			if(leds.selected == 0x1) {
				leds.selected = 0x80;
			} else {
				leds.selected = leds.selected >> 1;
			}
		} else {
			if(leds.selected == 0x80) {
				leds.selected = 0x1;
			} else {
				leds.selected = leds.selected << 1;
			}
		}
		select_leds(leds.selected);
	}

	state = STATE_UPDATE_TURNS;
}

void runState_UPDATE_TURNS(void) {

	if(motor.angle > 3600000) {
		motor.angle -= 360000;
		motor.turns_remaining -= 1;

		if(motor.turns_remaining < 0) {
			state = STATE_END;
		} else {
			state = STATE_PRINT_TURN;
		}
	} else {
		state = STATE_INCREMENTS_ANGLES;
	}
}

void runState_END() {
	
	// desabilita interrupções
	DisableInterrupts();

	// apaga os leds
	turn_leds_ON(false);

	// mostra mensagem de FIM no terminal
	UART_send_str("FIM \r\n");
	SysTick_Wait1ms(3000);

	state = STATE_INIT;
}

void Timer2A_Handler(void) {

	// Limpa flag de interrupcao
	TIMER2_ICR_R = 0x01;

	// shifta estado do led onboard
	led_onboard_on = !led_onboard_on;

	// liga ou desliga led onboard
	if(led_onboard_on) {
		PortN_Output(0x2);
	} else {
		PortN_Output(0x0);
	}
}

void GPIOPortJ_Handler(void) {

	// Limpa flag de interrupcao
	GPIO_PORTJ_AHB_ICR_R = GPIO_PORTJ_AHB_ICR_R | (0x3);

	// Atualiza novo estado
	state = STATE_END;
}
