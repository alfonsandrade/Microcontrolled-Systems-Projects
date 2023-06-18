#ifndef _LCD_H_
#define _LCD_H_

#include <stdint.h>
#include "util.h"

/** @brief inicializa LCD */
void LCD_init(void);

/** @brief limpa LCD e posiciona cursor na linha e coluna 0*/
void LCD_reset(void);

/** @brief envia o comando ao LCD */
void LCD_command(uint8_t cmd);

/** @brief escreve o caractere c na posição atual do cursor do LCD */
void LCD_write_data(uint8_t c);

/** @brief imprime string a partir da posição atual do cursor do LCD*/
void LCD_print_string(char *str);

/** 
 * @brief posiciona o cursor de acordo com a linha e coluna
 * @param line 0-1
 * @param column 0-15
*/
void LCD_set_cursor(int line, int column);


#endif // _LCD_H_
