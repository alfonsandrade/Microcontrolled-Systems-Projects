#ifndef _CONVERSORES_H_
#define _CONVERSORES_H_
#include <stdio.h>
#include <stdlib.h>

/**
 * @brief conversão de um valor decimal para char
 * @param decimal valor entre 0 e 9
 * @return char correspondente ou -1 caso decimal fora do range
*/
char decimalToChar(unsigned int decimal);

/**
 * @brief conversão de um char para um valor decimal
 * @param caractere valor de 0 a 9 em ASCII
 * @return inteiro correspondente ou -1 caso decimal fora do range
*/
int charToDecimal(char caractere);

/**
 * @brief converte um valor para string
 * @param num 0-100
 * @param str ponteiro para a primeira posicao da string ja alocada com 4 posicoes sendo ddd'\0'
*/
void intToString(unsigned int num, char* str);

#endif //_CONVERSORES_H_
