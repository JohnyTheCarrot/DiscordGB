include "hardware.inc"
include "consts.inc"

section "Dialog", rom0
/*
    hl => source
    de => dest
    bc => bytecount
*/
MemCopyMono::
    ld      a,      c
    cp      b
    jr      nz,     .copy
    cp      0
    ret     z
.copy
    dec     bc
    ld      a,      [hl+]
    ld      [de],   a
    inc     de
    ld      [de],   a
    inc     de
    jr      MemCopyMono



/*
    hl  => char pointer
*/
LoadCharTiles::
    ld      de,     _SCRN1 + SCRN_VX_B + 1
    ld      c,      MAX_LINE_LENGTH

.loop
    ; while ((a = [hl+]) != STR_TERM), returning from subroutine when while loop finishes
    ld      a,      [hl]
    cp      STR_TERM
    ret     z
    cp      DELAY
    jr      z,      .sleepText
    cp      SHAKE_SCREEN
    jr      z,      .shakeScreen
    cp      NEWLINE
    jr      z,      .newline

    add     ((DiscordClient.end - DiscordClient) + (Dialog.end - Dialog)) / 16

    cp      " "
    jr      z,      :+
    sleep_fast MIN_TIMER_PERIOD / 2
    :

    push    hl
    call    WaitVRAMAccessible
    pop     hl

    ld      [de],   a
    inc     de

    ld      a,      [hl+]
    cp      NEXT_DIALOG
    ret     z

    ; if !(--c), jr to .loop, else prepare for next line, if c is zero, we go to the next line
    dec     c
    ;jr      nz,     .loop
    jr      .loop

    ; prepare for next line: add SCRN_VX_B  - MAX_LINE_LENGTH (aka the part of the scanline that isn't visible) to e so that we can move onto the next line
    ; ld      a,      e
    ; add     SCRN_VX_B - MAX_LINE_LENGTH
    ; ld      e,      a

    ; reset c back to MAX_LINE_LENGTH, so that it may count back to down to 0
    ; ld      c,      MAX_LINE_LENGTH

    ; we're prepared, let's enter the loop again
    jr      .loop

.sleepText
    sleep_fast  1.0
    inc         hl
    jr          .loop

.newline
    inc     hl
    ld      a,      e
    add     c
    add     SCRN_VX_B - MAX_LINE_LENGTH
    ld      e,      a
    ld      c,      MAX_LINE_LENGTH
    jr      .loop

.shakeScreen
    push    af
    xor     a

.shakeLoop
    inc     a
    cp      3
    jr      z,      .finish
    push    af
    sleep_slow MIN_TIMER_PERIOD
    call    WaitVBlank
    ld      a,      DEFAULT_SCREEN_Y + SCREEN_SHAKE_AMOUNT
    ldh     [rSCY], a
    ld      a,      DEFAULT_SCREEN_X - SCREEN_SHAKE_AMOUNT
    ldh     [rSCX], a
    sleep_slow MIN_TIMER_PERIOD
    call    WaitVBlank
    ld      a,      DEFAULT_SCREEN_Y - SCREEN_SHAKE_AMOUNT
    ldh     [rSCY], a
    ld      a,      DEFAULT_SCREEN_X + SCREEN_SHAKE_AMOUNT
    ldh     [rSCX], a
    sleep_slow MIN_TIMER_PERIOD
    call    WaitVBlank
    ld      a,      DEFAULT_SCREEN_Y + SCREEN_SHAKE_AMOUNT
    ldh     [rSCY], a
    ld      a,      DEFAULT_SCREEN_X + SCREEN_SHAKE_AMOUNT
    ldh     [rSCX], a
    sleep_slow MIN_TIMER_PERIOD
    call    WaitVBlank
    ld      a,      DEFAULT_SCREEN_Y - SCREEN_SHAKE_AMOUNT
    ldh     [rSCY], a
    ld      a,      DEFAULT_SCREEN_X - SCREEN_SHAKE_AMOUNT
    ldh     [rSCX], a
    pop     af
    jp      .shakeLoop

.finish
    reset_screen_scroll
    pop     af
    inc     hl
    jp      .loop


/*
    hl => pointer to null-terminated string
    Uses: de, c, af
*/
ShowOptionDialog::
    ; Clear a, then load a into [CurrentlySelectedDialogOption], effectively clearing [CurrentlySelectedDialogOption].
    ; We clear it because the value there might either not have been initialised, or it had a lingering value, either way we need to clear it.
    xor     a
    ld      [CurrentlySelectedDialogOption], a

.draw
    push    hl

    ld      a,      l
    ld      [CurrentDialogPointer],     a
    ld      a,      h
    ld      [CurrentDialogPointer + 1], a

    call    EnableWindow

    ; clear visible vram before writing to it, in case the current line is shorter than the previous
    for Y, 1, 5
    ld      h,      ((DiscordClient.end - DiscordClient) + (Dialog.end - Dialog)) / 16
    ld      bc,     MAX_LINE_LENGTH
    ld      de,     _SCRN1 + SCRN_VX_B * Y + 1
    call    MemSet
    endr

    pop     hl

    ; at hl++ there will be a single byte that says how many options to expect, read it into b
    ld      a,      [hl]
    ld      [CurrentDialogLineCount], a
    ld      b,      a
    inc     hl

    ; set line destination
    ld      de,     _SCRN1 + SCRN_VX_B + 1

.optionRenderLoop
    ; The following, times value of b, will be two pointers, the first of the two pointing towards the string of the option
    ; and the second of the two will point to the handler of the option, for execution should the user select that option.
    ; For now, we will ignore the handler, as we only need that pointer if the user actually selected the option.
    ld      a,      [hl+]
    ld      c,      a
    ld      a,      [hl+]
    push    hl      ; save hl for later use

    ; render the line using the string pointer we just retrieved
    ld      h,      a ; a into h, due to endiannness
    ld      l,      c
    ; we save the VRAM pointer de before rendering the line so that
    ; we can easily add SCRN_VX_B to it later to get to the next line
    push    de
    call    .renderLine
    pop     de

    ; we're done with that line, restore hl
    pop     hl
    
    ; move on to next line
    ld      a,      e
    add     SCRN_VX_B
    ld      e,      a

    ; increment hl past handler pointer
    inc     hl
    inc     hl

    ; as long as (--b) != 0, get back to .optionRenderLoop
    dec     b
    jr      nz,     .optionRenderLoop

.inputWaitLoop
    ld      c,      P1F_BTN_A | P1F_DPAD_RIGHT | P1F_DPAD_DOWN | P1F_DPAD_UP
    call    WaitForInput

    cp      P1F_DPAD_DOWN
    jr      z,      .moveSelectDown
    cp      P1F_DPAD_UP
    jr      z,      .moveSelectUp
    cp      P1F_BTN_A
    jr      z,      .selectOption
    cp      P1F_DPAD_RIGHT
    jr      z,      .selectOption
    jr      .inputWaitLoop

.selectOption
    ld      a,      [CurrentDialogPointer]
    ld      l,      a
    ld      a,      [CurrentDialogPointer + 1]
    ld      h,      a
    inc     hl      ; move past size byte and str pointer
    inc     hl
    inc     hl
    
    ld      a,      [CurrentlySelectedDialogOption]
    sla     a
    ld      c,      a
    ; ld      b,      0 => not necessary, we used b to count down to zero so this is guaranteed to be zero
    add     hl,     bc
    ld      a,      [CurrentlySelectedDialogOption]
    bit     0,      a
    jr      z,      :+

    inc     hl
    inc     hl

:
    ld      a,      [hl+]
    ld      c,      a
    ld      h,      [hl]
    ld      l,      c

    jp      hl

.moveSelectUp
    ld      hl,     CurrentlySelectedDialogOption
    ld      a,      [hl]
    cp      0
    jr      z,      .prepareRedraw
    dec     [hl]
    jr      .prepareRedraw

.moveSelectDown
    ld      hl,     CurrentlySelectedDialogOption
    ld      b,      [hl]
    ld      a,      [CurrentDialogLineCount]
    inc     b
    cp      b
    jr      z,      .prepareRedraw
    inc     [hl]

.prepareRedraw
    ld      a,      [CurrentDialogPointer]
    ld      l,      a
    ld      a,      [CurrentDialogPointer + 1]
    ld      h,      a
    jp      .draw

.renderLine
    ; check if current line is selected line, if not just proceed to rendering line
    ld      a,      [CurrentDialogLineCount]
    sub     b
    ld      c,      a
    ld      a,      [CurrentlySelectedDialogOption]
    cp      c
    jr      nz,     :+
    ld      a,      NEXT_DIALOG + ((DiscordClient.end - DiscordClient) + (Dialog.end - Dialog)) / 16
    jr      :++

:
    ld      a,      ((DiscordClient.end - DiscordClient) + (Dialog.end - Dialog)) / 16
:
    ; if yes, we need to draw the arrow icon, and then we can proceed to the rendering of the line

    push    hl
    call    WaitVRAMAccessible
    pop     hl

    ld      [de],   a
    inc     de

.loop
    ; retrieve char at hl+, if terminator, return char rendering subroutine
    ld      a,      [hl+]
    cp      STR_TERM
    ret     z

    add     ((DiscordClient.end - DiscordClient) + (Dialog.end - Dialog)) / 16

    push    hl
    call    WaitVRAMAccessible
    pop     hl

    ld      [de],   a
    inc     de

    jr      .loop


/*
    hl => pointer to null-terminated string
    Uses: de, c, af
*/
StartDialogSequence::
    push    hl
    call    EnableWindow

.whileHasNext
    ; clear visible vram before writing to it, in case the current line is shorter than the previous
    for Y, 1, 5
    ld      h,      ((DiscordClient.end - DiscordClient) + (Dialog.end - Dialog)) / 16
    ld      de,     _SCRN1 + SCRN_VX_B * Y + 1
    ld      bc,     MAX_LINE_LENGTH
    call    MemSet
    endr

    ; get back our hl, as it was modified during StringLen
    pop     hl
    
    call    LoadCharTiles
    push    hl

    ld      a,      [hl]
    cp      STR_TERM
    jr      z,      .finish
    ld      c,      P1F_BTN_A | P1F_DPAD_DOWN | P1F_DPAD_RIGHT
    call    WaitForInput
    jr      .whileHasNext


.finish
    pop     hl
    ld      c,      P1F_BTN_A | P1F_DPAD_DOWN | P1F_DPAD_RIGHT
    call    WaitForInput
    call    HideDialog
    ret


/*
    At this time, this functions as an alias to DisableWindow.
    When called DisableWindow, will take care of the returning of this subroutine.
*/
HideDialog::
    jp      DisableWindow


; ============================
; Utils
; ============================

/*
hl => map
a  => value
return value => a
*/
/*
ArrayRead:
    push    de
    push    hl
    ; calculate index
    ld      d,      0
    ld      e,      a
    add     hl,     de
    ld      a,      [hl]
    
    pop     hl
    pop     de
    ret
*/

section "Dialog Specific RAM", wram0
CurrentlySelectedDialogOption:: ds 1
CurrentDialogLineCount: ds 1
CurrentDialogPointer: ds 2
