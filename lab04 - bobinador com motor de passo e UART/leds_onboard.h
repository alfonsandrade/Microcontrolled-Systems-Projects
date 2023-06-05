#ifndef _LEDS_ONBOARD_H
#define _LEDS_ONBOARD_H

#include <stdint.h>

/**
 * @brief Inicializa os leds onboard
*/
void leds_onboard_init(void);

/**
 * @brief Escreve os valores no port N
 * @param valor 0x1: acende led 1, 0x2: acende led 2, 0x3: acende led 1 e 2
*/
void PortN_Output(uint32_t valor);

#endif // _LEDS_ONBOARD_H
