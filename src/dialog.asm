include "hardware.inc"
include "consts.inc"

def MAX_LINE_LENGTH     = 18
def MAX_DIALOG_LINES    = 4

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

    ; set first line destination & set c to 0
    ld      c,      MAX_LINE_LENGTH

.loop
    ; while ((a = [hl+]) != 0), returning from subroutine when while loop finishes
    ld      a,      [hl]
    cp      0
    ret     z

    push    hl

    ld      hl,     ASCIICodeToTileIndex 
    sub     " "
    call    ArrayRead

    push    hl
    call    WaitVRAMAccessible
    pop     hl

    ld      [de],   a
    inc     de

    pop     hl

    ld      a,      [hl+]
    cp      NEXT_DIALOG
    ret     z

    ; if !(--c), jr to .loop, else prepare for next line
    dec     c
    jr      nz,     .loop

    ; prepare for next line: add SCRN_VX_B (aka the part of the scanline that isn't visible) to e so that we can move onto the next line
    ld      a,      e
    add     SCRN_VX_B - MAX_LINE_LENGTH
    ld      e,      a

    ; reset c back to MAX_LINE_LENGTH, so that it may count back to down to 0
    ld      c,      MAX_LINE_LENGTH

    ; we're prepared, let's enter the loop again
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