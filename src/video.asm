include "hardware.inc"

section "Video Utils", rom0
StopLCD::
    ldh     a,          [rLCDC]
    xor     LCDCF_ON
    ldh     [rLCDC],    a
    ret

StartLCD::
    ldh     a,          [rLCDC]
    or      LCDCF_ON
    ldh     [rLCDC],    a
    ret

StartLCDAndEnableWindow::
    ldh     a,          [rLCDC]
    or      LCDCF_ON | LCDCF_WINON | LCDCF_WIN9C00
    ldh     [rLCDC],    a
    ret

WaitVBlank::
    ldh     a,          [rLY]
    cp      144
    jr      nz,         WaitVBlank
    ret
