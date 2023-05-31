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

void motor_clockwise_fullRotation(void) {
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0xE; // 2_1110
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0xD; // 2_1101
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0xB; // 2_1011
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0x7; // 2_0111
    SysTick_Wait1ms(10);
}

void motor_counterClockwise_fullRotation(void) {
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0x7; // 2_0111
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0xB; // 2_1011
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0xD; // 2_1101
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0xE; // 2_1110
    SysTick_Wait1ms(10);
}

void motor_clockwise_halfRotation(void) {
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0xE; // 2_1110
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0xC; // 2_1100
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0xD; // 2_1101
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0x9; // 2_1001
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0xB; // 2_1011
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0x3; // 2_0011
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0x7; // 2_0111
    SysTick_Wait1ms(10);
}

void motor_counterClockwise_halfRotation(void) {
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0x7; // 2_0111
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0x3; // 2_0011
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0xB; // 2_1011
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0x9; // 2_1001
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0xD; // 2_1101
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0xC; // 2_1100
    SysTick_Wait1ms(10);
    GPIO_PORTH_AHB_DATA_R = (GPIO_PORTH_AHB_DATA_R & (!0xF)) | 0xE; // 2_1110
    SysTick_Wait1ms(10);
}
