#ifndef _MOTOR_H_
#define _MOTOR_H_

#include "tm4c1294ncpdt.h"
#include <stdint.h>

void motor_init(void);

/**
 * @brief gira no sentido horario 0.088º
*/
void motor_clockwise_fullRotation(void);

/**
 * @brief gira no sentido anti horario 0.088º
*/
void motor_counterClockwise_fullRotation(void);

/**
 * @brief gira no sentido horario 0.044º 
*/
void motor_clockwise_halfRotation(void);

/**
 * @brief gira no sentido anti horario 0.044º 
*/
void motor_counterClockwise_halfRotation(void);

#endif //_MOTOR_H_
