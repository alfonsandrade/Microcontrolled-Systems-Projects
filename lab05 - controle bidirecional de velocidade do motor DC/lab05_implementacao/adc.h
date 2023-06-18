#ifndef _ADC_H_
#define _ADC_H_

#include "tm4c1294ncpdt.h"
#include <stdint.h>

/** @brief Inicializa a configuração do ADC */
void ADC_init(void);

/**
 * @brief Inicia leitura do ADC e retorna o valor lido
 * @return 0 a 4095 (12 bits)
*/
uint16_t ADC_read(void);

#endif
