include "hardware.inc"

section "rom entry point", rom0 [$100]
    nop
    jp      Entry

    ds      $150 - @

section "entry", rom0
Entry:
    di

    ; disable sound
    ldh     a,          [rNR52]
    xor     AUDENA_ON
    ldh     [rNR52],    a

    ; set palette
    ld      a,          %11100100
    ldh     [rBGP],     a

    ; turn the LCD off
    call    StopLCD

    ; copy tiles into VRAM
    ld      hl,         DiscordLogo
    ld      de,         _VRAM
    ld      bc,         DiscordLogo.end - DiscordLogo
    call    MemCopy

    ; copy tilemap into VRAM
    ld      hl,         DiscordLogoTilemap
    call    TilemapCopy

    ; turn the LCD on
    call    StartLCD

    ; turn timer control on at 16 kilohertz
    ld      a,          TACF_START | TACF_16KHZ
    ld      hl,         rTAC
    ldh     [rTAC],     a

    ; initialise variables
    ld      hl,         IsStartupFinished
    ld      [hl],       0
    ld      hl,         CurrentDelayCount
    ld      [hl],       0

    ; set interrupt flags and enable interrupts
    ld      a,          IEF_TIMER | IEF_STAT
    ldh     [rIE],      a
    ld      a,          STATF_MODE00
    ldh     [rSTAT],    a
    ei

.waitForStartupToFinish
    ld      hl,         IsStartupFinished
    ld      a,          [hl]
    cp      1
    jr      nz,         .waitForStartupToFinish

    call    WaitVBlank
    call    StopLCD

    ; copy tiles into VRAM
    ld      hl,         DiscordClient
    ld      de,         _VRAM
    ld      bc,         DiscordClient.end - DiscordClient
    call    MemCopy

    ; copy tilemap into VRAM
    ld      hl,         DiscordClientTilemap
    call    TilemapCopy

    call    StartLCD
    di

.loop
    halt
    jp .loop

TimerInterrupt:
    ; save af
    push    af
    push    hl

    ld      hl,     CurrentDelayCount
    inc     [hl]
    ld      a,      [hl]
    ; 2s / (1 / 16384Hz) / 256 ticks = 128 rTIMA overflows ; + 1 because we increment before the check
    cp      128 + 1
    jr      z,     .finishDelay
    
    ; we're finished with the interrupt, restore registers, return and turn interrupts back on
.finishInterrupt
    pop     hl
    pop     af
    reti

    ; the delay is done, set IsStartupFinished to true, disable the timer, it and the hblank interrupt, and jump to .finishInterrupt
.finishDelay
    ld      hl,     IsStartupFinished
    inc     [hl]

    ; disable timer
    ldh     a,      [rTAC]
    xor     TACF_START
    ldh     [rTAC], a

    ; disable hblank and the timer interrupts
    ldh     a,      [rIE]
    xor     IEF_STAT
    xor     IEF_TIMER
    ldh     [rIE],  a

    ; jump to finish
    jr      .finishInterrupt

HBlank:
    ; save interrupts
    push    af
    push    hl
    push    bc

    ; load SineLookupTable into hl and add [rLY] to hl
    ld      hl,         SineLookupTable
    ldh     a,          [rLY]
    ld      b,          0
    ld      c,          a
    add     hl,         bc

    ; add [CurrentDelayCount] to hl
    ld      a,          [CurrentDelayCount]
    ld      c,          a
    add     hl,         bc

    ; check if hl > SineLookupTable.end, if so, clear [hl]
    ; before moving on to loading [hl] into [rSCX],
    ; else just load [hl] as it is into [rSCX]
    ld      a,          h
    cp      (SineLookupTable.end & $FF00) >> 8
    jr      c,          .smallerThanSineTableEnd

    ld      a,          l
    cp      SineLookupTable.end & $FF
    jr      c,         .smallerThanSineTableEnd

    xor     a
    ld      [hl],       a

    ; load [hl] into [rSCX]
.smallerThanSineTableEnd
    ld      a,          [hl]
    ldh     [rSCX],     a

    ; we're done, pop registers off stack & return + enable interrupts
    pop     bc
    pop     hl
    pop     af
    reti

SineLookupTable:
    def ANGLE = 0.0
    REPT 144
        db MUL(10, SIN(ANGLE))
        redef ANGLE = ANGLE + 1700.0
    ENDR
.end

; db "Version 1.0"
; db "Made with love by JohnyTheCarrot#0001 on Discord"

section "HBlank", rom0 [$48]
    jp      HBlank

section "Timer Interrupt", rom0 [$50]
    jp      TimerInterrupt