#ifndef _MOTORCOMMAND_H_
#define _MOTORCOMMAND_H_
#include <stdbool.h>
#include <motor.h>

// Structure to represent the motor command
typedef struct {
    int turns;
    bool direction; // 0 - clockwise, 1 - counter-clockwise
    bool speed;     // 0 - half step, 1 - full step
} MotorCommand;

// Function to execute the motor command
void executeMotorCommand(MotorCommand command);

#endif