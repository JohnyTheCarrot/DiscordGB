include "hardware.inc"
include "consts.inc"

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
    ; - load width and height into Temp
    ld      hl,         Temp
    xor     a
    ld      [hl+],      a
    ld      [hl],       a ; 1 byte shorter than just writing 0 here

    ; - actually load, will use Temp
    ld      hl,         DiscordLogoTilemap
    ld      de,         _SCRN0
    call    TilemapCopy

    ; turn the LCD on
    call    StartLCD

    ; set interrupt flags and enable interrupts
    ld      a,          IEF_TIMER | IEF_STAT | IEF_VBLANK
    ldh     [rIE],      a
    ld      a,          STATF_MODE00
    ldh     [rSTAT],    a
    ei

    sleep_fast          2.0

    ld      hl,         rIE
    res     1,          [hl]

    ; di
    call    WaitVBlank
    call    StopLCD

    reset_screen_scroll

    ; copy tiles into VRAM
    ld      hl,         DiscordClient
    ld      de,         _VRAM
    ld      bc,         DiscordClient.end - DiscordClient
    call    MemCopy

    ; copy tilemap into VRAM
    ld      hl,         Temp
    ld      [hl],       2
    inc     hl
    ld      [hl],       2

    ld      hl,         DiscordClientTilemap
    ld      de,         _SCRN0
    call    TilemapCopy

    ld      hl,         Dialog
    ld      de,         _VRAM + (DiscordClient.end - DiscordClient)
    ld      bc,         Dialog.end - Dialog
    call    MemCopy

    ld      hl,         Temp
    xor     a
    ld      [hl+],      a
    ld      [hl],       a

    ld      hl,         DialogTilemap
    ld      de,         _SCRN1
    call    TilemapCopy

    ld      hl,         _SCRN1
    ld      d,          (DiscordClient.end - DiscordClient) / 16
    call    IncrementMem

    ld      a,          7
    ldh     [rWX],      a
    ld      a,          144 - 6 * 8
    ldh     [rWY],      a

    ld      hl,         Font
    ld      de,         _VRAM + (DiscordClient.end - DiscordClient) + (Dialog.end - Dialog)
    ld      bc,         Font.end - Font
    call    MemCopyMono

    call    StartLCD

    ldh     a,          [rP1]
    or      P1F_GET_DPAD
    ldh     [rP1],      a

    ; ld      hl,         Intro
    ; call    StartDialogSequence
    ld      hl,         OptionDialog
    call    ShowOptionDialog

.loop
    halt
    jr .loop



HBlank:
    ; save registers
    push    af
    push    hl
    push    bc

    ; load SineLookupTable into hl and add [rLY] to hl
    ld      h,          high(SineLookupTable)
    ldh     a,          [rLY]
    ld      l,          a

    ; add [CurrentDelayCount] to hl
    ld      a,          [CurrentDelayCount]
    ld      b,          0
    ld      c,          a
    add     hl,         bc

    ; check if hl > SineLookupTable.end, if so, clear [hl]
    ; before moving on to loading [hl] into [rSCX],
    ; else just load [hl] as it is into [rSCX]
    ld      a,          h
    cp      high(SineLookupTable.end)
    jr      c,          .smallerThanSineTableEnd
    jr      nz,         .clearSCX

    ld      a,          l
    cp      low(SineLookupTable.end)
    jr      c,         .smallerThanSineTableEnd

.clearSCX
    xor     a
    ldh     [rSCX],     a
    jr      .finish

    ; load [hl] into [rSCX]
.smallerThanSineTableEnd
    ld      a,          [hl]
    ldh     [rSCX],     a

.finish
    ; we're done, pop registers off stack & return + enable interrupts
    pop     bc
    pop     hl
    pop     af
    reti



VBlank:
    push    af
    push    bc

    call    UpdateInput

    pop     bc
    pop     af
    reti



db "Version 1.0"
db "Made with love by JohnyTheCarrot#0001 on Discord"

section "VBlank", rom0 [$40]
    jp      VBlank

section "HBlank", rom0 [$48]
    jp      HBlank

section "Timer Interrupt", rom0 [$50]
    jp      TimerInterrupt