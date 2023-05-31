#ifndef _MOTOR_H_
#define _MOTOR_H_

#include "tm4c1294ncpdt.h"
#include <stdint.h>

void motor_init(void);

/**
 * @brief gira no sentido horario 0.088º
*/
void fullRotation_H(void);

/**
 * @brief gira no sentido anti horario 0.088º
*/
void fullRotation_A(void);

/**
 * @brief gira no sentido horario 0.044º 
*/
void halfRotation_H(void);

/**
 * @brief gira no sentido anti horario 0.044º 
*/
void halfRotation_A(void);

#endif //_MOTOR_H_
