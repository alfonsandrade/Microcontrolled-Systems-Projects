#include "motor.h"

#define GPIO_PORTH 0x80

void SysTick_Wait1ms(uint32_t delay);
void SysTick_Wait1us(uint32_t delay);

void motor_init(void) {
    // 1. ativa o clock da porta
    SYSCTL_RCGCGPIO_R = SYSCTL_RCGCGPIO_R | (GPIO_PORTH);

    // verifica no PRGPIO se a porta esta pronta para uso
    while((SYSCTL_PRGPIO_R & GPIO_PORTH ) != GPIO_PORTH) {};
    
    // 2. limpa o AMSEL para desabilita a analogica
    GPIO_PORTH_AHB_AMSEL_R = GPIO_PORTH_AHB_AMSEL_R & (!0xF);
    
    // 3. Limpar PCTL para selecionar o GPIO
    GPIO_PORTH_AHB_PCTL_R = GPIO_PORTH_AHB_PCTL_R & (!0xF);

    // 4. DIR para 0: input (&!(...)), 1: output (|(...))
    GPIO_PORTH_AHB_DIR_R = GPIO_PORTH_AHB_DIR_R | 0xF;

    // 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem funcao alternativa
    GPIO_PORTH_AHB_AFSEL_R = GPIO_PORTH_AHB_AFSEL_R & (!0xF);
    
    // 6. Setar os bits de DEN para habilitar I/O digital
    GPIO_PORTH_AHB_DEN_R = GPIO_PORTH_AHB_DEN_R | 0xF;

    // 7. Para habilitar resistor de pull-up interno, setar PUR para 1
	// N/A
}

void fullRotation_H(void) {
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0x8; // 2_1000
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0x4; // 2_0100
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0x2; // 2_0010
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0x1; // 2_0001
    SysTick_Wait1ms(10);
}
