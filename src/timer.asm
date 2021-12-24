include "hardware.inc"

section "Timer WRAM", wram0
CurrentDelayCount:: ds 1
DelayGoal::         ds 1

section "Timer Handler & Utils", rom0
TimerInterrupt::
    ; save af
    push    af
    push    hl

    ld      hl,     CurrentDelayCount
    inc     [hl]
    
    ; we're finished with the interrupt, restore registers, return and turn interrupts back on
.finishInterrupt
    pop     hl
    pop     af
    reti



/*
    ticks = x * 4096Hz / 256 where x is the amount of seconds
    Modifies: hl, a
*/
Sleep::
    call    EnableTimer
    
.waitForDelayFinish
    ld      hl,     CurrentDelayCount
    ld      a,      [hl]
    ld      hl,     DelayGoal
    cp      [hl]
    jr      nz,     .waitForDelayFinish
    ret



/*
    Modifies: hl, a
*/
EnableTimer:
    ; clear CurrentDelayCount
    ld      hl,         CurrentDelayCount
    ld      [hl],       0

    ; enable timer interrupt
    ld      hl,     rIE
    set     2,      [hl] ; 2 is the bit of the timer interrupt flag
    ret



/*
    Modifies: hl
*/
DisableTimer:
    ld      hl,     rIE
    res     2,      [hl] ; 2 is the bit of the timer interrupt flag
    ret