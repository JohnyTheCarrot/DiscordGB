include "hardware.inc"

section "Memory Utils", rom0

; hl => source
; de => dest
; bc => bytecount
MemCopy::
    ; return if bc is 0: if (b == c && b == 0) return;
    ld      a,      c
    cp      b
    jr      nz,     .copy
    cp      0
    ret     z
    ; copy one byte from hl++ to de++ after decrementing bc, then return to
    ; start to repeat if necessary
.copy
    dec     bc
    ld      a,      [hl+]
    ld      [de],   a
    inc     de
    jr      MemCopy

/*
; h  => value
; de => dest
; bc => bytecount
MemSet::
    ld      a,      c
    cp      b
    jr      nz,     .copy
    cp      0
    ret     z
.copy
    dec     bc
    ld      a,      h
    ld      [de],   a
    inc     de
    jr      MemSet
*/

/*
might use in the future, do not delete

; hl => source
; de => dest
; bc => bytecount
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
*/

; hl => source
TilemapCopy::
    ; load into de (destination) _SCRN0 ($9800) and clear b & c
    ld      de,     _SCRN0
    ld      b,      0
    ld      c,      0

    ; declare for loop for rows: for (; b < SCRN_Y_B; b++)
.forLoopY
    ld      a,      b
    cp      SCRN_Y_B
    ret     z
    inc     b
    ; reset c before starting column for loop
    ld      c,      0

    ; declare for loop for columns: for (; c < SCRN_Y_B; c++)
.forLoopX
    ; go to .createFiller if c == SCRN_X_B, .createFiller will return to .forLoopY when done
    ld      a,      c
    cp      SCRN_X_B
    jr      z,     .createFiller
    
    ; *(de++) = *(hl++); c++;
    ld      a,     [hl+]
    ld      [de],  a
    inc     de
    inc     c

    ; repeat loop
    jr      .forLoopX

    ; we need to fill the non-visible part of VRAM (c > SCRN_X_B) with stuff,
    ; the tile index doesn't matter, but it's 0 here
.createFiller
    ld      c,      0

.forLoopFiller
    ld      a,      c
    cp      SCRN_VX_B - SCRN_X_B
    jr      z,      .stopForLoop
    ld      a,      0
    ld      [de],   a
    inc     de
    inc     c
    jr      .forLoopFiller

.stopForLoop
    jr      .forLoopY
