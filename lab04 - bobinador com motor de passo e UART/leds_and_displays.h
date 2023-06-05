#ifndef _LEDS_AND_DISPLAYS_H_
#define _LEDS_AND_DISPLAYS_H_

#include <stdint.h>

/** @brief Inicaliza leds sequencias e os dois Displays de 7 segmentos */
void LEDS_AND_DISPLAYS_init(void);

/** @brief Seleciona os leds a serem ligados ou desligados (Usar a funcao turn on para ligar)*/
void select_leds(uint8_t leds);

/** @brief Seleciona o digito hexadecimal a ser exibido nos displays (Usar a função turn on para ligar)*/
void select_dig_DS(uint8_t hexa);

/** 
 * @brief Liga ou desliga os leds selecionados 
 * @param on 0: desliga, !=0 liga
*/
void turn_leds_ON(int on);

/** 
 * @brief Liga ou desliga o DS1
 * @param on 0: desliga, !=0 liga
*/
void turn_DS1_ON(int on);

/** 
 * @brief Liga ou desliga o DS2
 * @param on 0: desliga, !=0 liga
*/
void turn_DS2_ON(int on);

#endif //_LEDS_AND_DISPLAYS_H_
