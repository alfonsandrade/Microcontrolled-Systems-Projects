#ifndef _MATRIX_KEYBOARD_H_
#define _MATRIX_KEYBOARD_H_

#include <stdint.h>

/** @brief Inicializa o teclado matricial numérico */
void MKBOARD_init(void);

/** 
 * @brief Retorna o caractere pressionado no teclado numérico
 * @return '0' a '9' ou '*' ou '#' ou '-' caso nenhuma tecla pressionada
*/
char MKBOARD_getCharPressed(void);

#endif // _MATRIX_KEYBOARD_H_
