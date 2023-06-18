#ifndef _UTIL_H_
#define _UTIL_H_

#include <stdint.h>

/* Funções do Sistema */

/** @brief Define clock do sistema como 80Mhz */
void PLL_Init(void);

/** @brief Define configurações para funções de delay */
void SysTick_Init(void);

/** @brief delay em milissegundos (1E-3) */
void SysTick_Wait1ms(uint32_t delay);

/** @brief delay em microssegundos (1E-6) */
void SysTick_Wait1us(uint32_t delay);

/** @brief desabilita interrupcoes */
void DisableInterrupts(void);

/** @brief habilita interrupcoes */
void EnableInterrupts(void);


#endif //_UTIL_H
