#include "motorCommand.h"

void executeMotorCommand(MotorCommand command) {
    // Set the speed
    if (command.speed == 0) {
        setHalfStep();
    } else {
        setFullStep();
    }

    // Calculate the number of steps
    int steps;
    if (command.speed == 0) {
        steps = command.turns * 8192; // Number of half steps in one turn
    } else {
        steps = command.turns * 4096; // Number of full steps in one turn
    }

    // Set the direction and number of turns
    for (int i = 0; i < steps; i++) {
        if (command.direction == 0) {
            if (command.speed == 0) {
                motor_clockwise_halfRotation();
            } else {
                motor_clockwise_fullRotation();
            }
        } else {
            if (command.speed == 0) {
                motor_counterClockwise_halfRotation();
            } else {
                motor_counterClockwise_fullRotation();
            }
        }
    }
}