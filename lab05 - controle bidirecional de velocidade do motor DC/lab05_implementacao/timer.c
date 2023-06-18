#include "timer.h"

void timer_init(void) {

    // 1. Como vamos utilizar o timer2, habilitar o bit 2 no registrador RCGCTIMER
    SYSCTL_RCGCTIMER_R = SYSCTL_RCGCTIMER_R | 0x04;

    // esperar enquanto bit 2 do registrador PRTIMER não está setado.
    while( (SYSCTL_PRTIMER_R & 0x04) != 0x04 ) { }

    // 2. Desabilitar o timer2 para fazer as configurações (adiante vamos habilitá-lo novamente)
    TIMER2_CTL_R = TIMER2_CTL_R & (!0x1);

    // 3. Conforme calculamos os valores, colocar o timer2 no modo 32 bits então escrever 0x00 nos 
    // bits respectivos do registrador GPTMCFG
    TIMER2_CFG_R = TIMER2_CFG_R & (!0x3);

    // 4. selecao de modo 0x2: periodico
    TIMER2_TAMR_R = TIMER2_TAMR_R | 0x2;

    // 5. Carregar o valor de contagem no registrador timerA no registrador GPTMTAILR
    TIMER2_TAILR_R = 79999; //0.001 s * 80Mhz - 1

    // 6. Como nao temos prescale, deixar o registrador GPTMTAPR zerado.
    TIMER2_TAPR_R = TIMER2_TAPR_R & (!0xFF);

    // 7. Como vamos utilizar o timerA, setar o bit TnTOCINT no registrador GPTMICR, para garantir 
    // que a primeira interrupção seja atendida.
    TIMER2_ICR_R = TIMER2_ICR_R | 0x01;

    // 8. a) Como vamos utilizar interrupção para estouro do timer, escrever 1 no bit TATOIM do 
    // registrador GPTMIMR
    TIMER2_IMR_R = TIMER2_IMR_R | 0x01;

    // 8. b) Setar a prioridade da interrupção do timer respectivo no respectivo registrador 
    //      NVIC Priority Register.
    // - Primeiramente verificar qual é o número da interrupção do Timer2A na tabela 2-9 do datasheet. (interrupção numero 23)
    // - Encontrar qual o registrador de prioridade do NVIC tem a prioridade para a interrupção de nº23 (timer2A)
    // - Colocar o valor da prioridade no campo da respectiva interrupção (neste caso vamos colocar prioridade 4)
    NVIC_PRI5_R = NVIC_PRI5_R | (4 << 29); //(bit 29 a 31 do)

    // 8. c) Habilitar a interrupção do timer respectivo no respectivo registrador NVIC Interrupt Enable Register
    // - Encontrar qual o registrador de habilitação do NVIC habilita a interrupção de nº23 (timer2A)
    // - Setar o bit no campo da respectiva interrupção (neste caso vamos colocar prioridade 4)
    NVIC_EN0_R = NVIC_EN0_R | (1 << 23);

    // 9) Habilitar o bit TAEN no registrador GPTMCTL para começar o timer. A partir deste momento o timer fará a contagem 
    // e quando estourar cairá na rotina de tratamento de interrupção.
    TIMER2_CTL_R = TIMER2_CTL_R | 0x1;
}
