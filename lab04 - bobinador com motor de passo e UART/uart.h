#ifndef _UART_H_
#define _UART_H_

#include "tm4c1294ncpdt.h"
#include <stdint.h>

/**
 * @brief inicializa a UART da placa
*/
void UART_init(void);

/**
 * @brief faz leitura do buffer da UART
 * 
 * @return caractere lido ou -1 caso não seja possivel ler
*/
char UART_receive(void);

/**
 * @brief faz a escrita do caractere via UART
 * @param c caractere a ser enviado
 * @return 1: sucesso, 0:nao foi possível enviar
*/
int UART_send(char c);

/**
 * @brief faz a escrita da string via UART
 * @param str ponteiro para a string
 * @return 1: sucesso, 0:nao foi possível enviar
*/
int UART_send_str(char* str);


#endif //_UART_H_
