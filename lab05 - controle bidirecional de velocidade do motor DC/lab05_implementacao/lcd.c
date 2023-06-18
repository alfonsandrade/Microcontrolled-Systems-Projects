#include "lcd.h"

void LCD_set_cursor(int line, int column) {
    if(line == 0)
        LCD_command(0x80 + column);
    else
        LCD_command(0xC0 + column);

    SysTick_Wait1us(40);
}
