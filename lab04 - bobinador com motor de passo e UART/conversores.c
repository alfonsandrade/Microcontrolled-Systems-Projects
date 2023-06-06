#include "conversores.h"

char decimalToChar(unsigned int decimal) {
    if(decimal > 9)
        return (char)-1;
    return ('0' + decimal);
}

int charToDecimal(char caractere) {
    if(caractere < '0' || caractere > '9')
        return -1;
    return (caractere - '0');
}

int stringToInt(char* numStr) {
    int num = atoi(numStr);  // converte o vetor de caracteres para um inteiro
    return num;
}
