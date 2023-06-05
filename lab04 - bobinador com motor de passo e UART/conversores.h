#ifndef _CONVERSORES_H_
#define _CONVERSORES_H_

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

#endif //_CONVERSORES_H_
