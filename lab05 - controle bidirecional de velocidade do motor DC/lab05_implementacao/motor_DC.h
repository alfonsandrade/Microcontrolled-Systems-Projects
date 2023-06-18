#ifndef _MOTOR_DC_H_
#define _MOTOR_DC_H_

#include <stdint.h>
#include "tm4c1294ncpdt.h"
#include <stdbool.h>

void motor_dc_init(void);

/** @brief liga/desliga o motor */
void motor_dc_ON(bool on);

/**
 * @brief envia o sinal para o motor de acordo com a direcao selecionada
 * @param pwm_signal
 * @param direction 1: horario, 0: anti-horario
*/
void motor_dc_uptade(bool pwm_signal, bool direction);

#endif
