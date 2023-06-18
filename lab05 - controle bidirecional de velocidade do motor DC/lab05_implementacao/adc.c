#include "adc.h"

#define GPIO_PORTE 0x10

void ADC_init(void) {
    
    // 1. ativa o clock da porta
    SYSCTL_RCGCGPIO_R = SYSCTL_RCGCGPIO_R | (GPIO_PORTE);

    // verifica no PRGPIO se a porta esta pronta para uso
    while((SYSCTL_PRGPIO_R & GPIO_PORTE ) != GPIO_PORTE) { }
    
    // 2. AMSEL para 1:habilitar, 0:desabilitar funcao analogica no pino
    GPIO_PORTE_AHB_AMSEL_R = GPIO_PORTE_AHB_AMSEL_R | 0x10; // PE4: potenciometro

    // 3. DIR para 0: input (&!(...)), 1: output (|(...))
    GPIO_PORTE_AHB_DIR_R = GPIO_PORTE_AHB_DIR_R & (!0x10); // PE4: potenciometro

    // 4. AFSEL para 1: habilitar, 0: desabilitar funcao alternativa
    // (nao define qual função alternativa, apenas habilita/desabilita)
    GPIO_PORTE_AHB_AFSEL_R = GPIO_PORTE_AHB_AFSEL_R | 0x10;

    // 6. DEN para 1: habilitar, 0: desabilitar funcao digital no pino
    GPIO_PORTE_AHB_DEN_R = GPIO_PORTE_AHB_DEN_R & (!0x10); // PE4: potenciometro
    
    // PCTL para selecionar o GPIO (VERIFICAR SE EH NECESSARIO USAR ISSO NO ADC)
    // GPIO_PORTE_AHB_PCTL_R = GPIO_PORTE_AHB_PCTL_R & (!0x10);

    // PUR: 0: dabilita, 1: habilita resistor de pull-up interno
    GPIO_PORTE_AHB_PUR_R |= 0x10;

    // configuração do ADC

    // 6. Habilitar o clock no módulo ADC no registrador RCGCADC (cada bit representa uma ADC)
    SYSCTL_RCGCADC_R = SYSCTL_RCGCADC_R | SYSCTL_RCGCADC_R0; // ADC0

    //  esperar até que a respectiva ADC esteja pronta para ser acessada no 
    // registrador PRADC (cada bit representa uma ADC). Escolher ADC0 ou ADC1.
    while( (SYSCTL_PRADC_R & SYSCTL_PRADC_R0) != SYSCTL_PRADC_R0) {}

    // 7. Escolher a máxima taxa de amostragem no registrador ADCPC
    // datasheet pdf 1159: Register 65: ADC Peripheral Configuration (ADCPC), offset 0xFC4
    ADC0_PC_R = ADC0_PC_R | 0x7;
    
    // 8. SSPRI para configurar a prioridade de cada sequecniador
    // Cada sequenciador deve ter prioridade diferente
    // 0x0: maior, 0x3: menor
    // datasheet pdf 1099: Register 9: ADC Sample Sequencer Priority (ADCSSPRI), offset 0x020
    ADC0_SSPRI_R = ADC0_SSPRI_R | (0x0 << 12);  //SS3 (Maior prioridade)
    ADC0_SSPRI_R = ADC0_SSPRI_R | (0x1 << 8);   //SS2
    ADC0_SSPRI_R = ADC0_SSPRI_R | (0x2 << 4);   //SS1
    ADC0_SSPRI_R = ADC0_SSPRI_R | (0x3);        //SS0

    // 9. ACTSS: 1: habilita, 0: desabilita sequenciadores
    // desabilitar para configura-lo. Para desabilitar o SS3 escrever 0 no bit ASEN3.
    // datasheet pdf 1077: Register 1: ADC Active Sample Sequencer (ADCACTSS), offset 0x000
    ADC0_ACTSS_R = ADC0_ACTSS_R & (!0x8);

    // 10. EMUX: configura o tipo de gatilho para cada conversão analogica.
    // Por exemplo, se for utilizar gatilho por software no SS3, escrever 0000 nos bits EM3[3-0].
    // datasheet pdf 1091: Register 6: ADC Event Multiplexer Select (ADCEMUX), offset 0x014
    ADC0_EMUX_R = ADC0_EMUX_R & !(0xF000);

    // 11. SSMUXn: configura a fonte de entrada analógica para cada amostra na sequencia de amostragem
    // Por exemplo, se utilizar o canal AN0 (PE3) no SS3, escrever 0000 nos bits 3-0 do registrador ADCSSMUX3.
    // datasheet pdf 1141: Register 41: ADC Sample Sequence Input Multiplexer Select 3 (ADCSSMUX3), offset 0x0A0
    ADC0_SSMUX3_R = ADC0_SSMUX3_R | 0x9; // AIN9 (PE4)
    
    // 12. ADCSSCTLn: configura ob bit de controle para cada amostra da sequencia de amostragem
    // Sempre o último nibble deve ter o bit END setado.
    // Por exemplo, para o SS3, que possui somente uma amostra, habilitar IE0 e 
    // END0, escrever 0110 no único nibble do ADCSSCTL3.
    ADC0_SSCTL3_R = ADC0_SSCTL3_R | 0x6;

    // 13. ACTSS: 1:habilita, 0:desabilita sequenciadores
    // habilitar novamente o sequenciador SS3 depois de configurado
    ADC0_ACTSS_R = ADC0_ACTSS_R | 0x8;
}

uint16_t ADC_read(void) {
	
    uint16_t value;

    // slide 31

    // inicia gatilho de software no sequenciador atraves do reg PSSI.
    // datasheet pdf 1103: Register 11: ADC Processor Sample Sequence Initiate (ADCPSSI), offset 0x028
    ADC0_PSSI_R |= 0x0008;

    // fazer polling no RIS ate o fim da conversao
    // datasheet pdf 1079: Register 2: ADC Raw Interrupt Status (ADCRIS), offset 0x004
    while((ADC0_RIS_R & 0x8) != 0x8) { }

    // ler o resultado da conversao no reg SSFIFOn, como o SS3 tem apenas uma posicao na FIFO,
    // entao ler somente uma vez
    value = ADC0_SSFIFO3_R;

    // Realizar o ACK no registrador ADCISC para limpar o bit de conversão no reg ADCRIS
    ADC0_ISC_R &= (!0x0008);

	return value;
}
