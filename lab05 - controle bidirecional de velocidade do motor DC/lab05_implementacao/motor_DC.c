#include "motor_DC.h"

#define GPIO_PORTE 0x10
#define GPIO_PORTF 0x20

void motor_dc_init(void) {
    // inicializa os GPIO responsaveis pelo motor

    //1a. RCGPIO: 0:desabilitar, 1:habilitar o clock na porta
    //datasheet pdf 382: Reg 89: General-Purpose Input/Output Run Mode Clock Gating Control (RCGCGPIO), offset 0x608
	SYSCTL_RCGCGPIO_R |= (GPIO_PORTE | GPIO_PORTF);
	
    //1b. PRGPIO: verifica se a porta esta pronta para uso.
    while((SYSCTL_PRGPIO_R & (GPIO_PORTE | GPIO_PORTF)) != (GPIO_PORTE | GPIO_PORTF)){};
	
	// 2. AMSEL: 1: habilita, 0: desabilita porta modo analogica
    // datasheet pdf 786: Reg 21: GPIO Analog Mode Select (GPIOAMSEL), offset 0x528
    GPIO_PORTE_AHB_AMSEL_R &= (!0x3); // E0 e E1
    GPIO_PORTF_AHB_AMSEL_R &= (!0x4); // F2
		
	// 3. Limpar PCTL para selecionar o modo GPIO
    // datasheet pdf 787: Reg 22: GPIO Port Control (GPIOPCTL), offset 0x52C
    GPIO_PORTE_AHB_PCTL_R &= (!0x3);
    GPIO_PORTF_AHB_PCTL_R &= (!0x4);

	// 4. DIR: 0: input, 1: output
    // datasheet pdf 760: Register 2: GPIO Direction (GPIODIR), offset 0x400
    GPIO_PORTE_AHB_DIR_R |= 0x3;
    GPIO_PORTF_AHB_DIR_R |= 0x4;
		
	// 5. AFSEL: 0: desabilita, 1: habilita funcao alternativa
    // datasheet pdf 770: Reg 10: GPIO Alternate Function Select (GPIOAFSEL), offset 0x420
    GPIO_PORTE_AHB_AFSEL_R &= (!0x3);
    GPIO_PORTF_AHB_AFSEL_R &= (!0x4);
		
	// 6. DEN: 0: desabilita, 1: habilita GPIO digital
    // datasheet pdf 781: Reg 18: GPIO Digital Enable (GPIODEN), offset 0x51C
    GPIO_PORTE_AHB_DEN_R |= 0x3;
    GPIO_PORTF_AHB_DEN_R |= 0x4;
	
	// 7. Habilitar resistor de pull-up interno, setar PUR para 1
}

void motor_dc_ON(bool on) {
    // atualiza port EN1 do U1
    if(on)
        GPIO_PORTF_AHB_DATA_R |= 0x4;
    else
        GPIO_PORTF_AHB_DATA_R &= (!0x4);
}

void motor_dc_uptade(bool pwm_signal, bool direction) {
    // atualiza port IN1 e IN2 do U1	
    if(pwm_signal) {
        if(direction){
            GPIO_PORTE_AHB_DATA_R = 0x1;
        } else {
            GPIO_PORTE_AHB_DATA_R = 0x2;
        }
    } else {
        GPIO_PORTE_AHB_DATA_R = 0x3;
		}	
}
