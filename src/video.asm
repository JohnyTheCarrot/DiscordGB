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



/*
    Sets bit LCDCF_WINON on rLCDC.

    Modifies: hl
*/
EnableWindow::
    ld      hl,         rLCDC
    set     5,          [hl]    ; set 5 (LCDCF_WINON) on [rLCDC]
    set     6,          [hl]    ; set 6 (LCDCF_WIN9C00) on [rLCDC]
    ret



DisableWindow::
    ldh     a,          [rLCDC]
    xor     LCDCF_WINON
    ldh     [rLCDC],    a
    ret


/*
    Waits for the VBlank period.

    Modifies: af
*/
WaitVBlank::
    ldh     a,          [rLY]
    cp      144
    jr      nz,         WaitVBlank
    ret



/*
    Waits for VRAM access to be safe.

    Modifies: hl, af
*/
WaitVRAMAccessible::
    ld      hl,         rSTAT
.wait
    bit     1,          [hl] ; check STATF_BUSY bit
    jr      nz,         .wait
    ret