include "hardware.inc"

section "Memory Utils", rom0

; hl => source
; de => dest
; bc => bytecount
MemCopy::
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
    jr      MemCopy

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
    ld      de,     _SCRN0
    ld      b,      0
    ld      c,      0

.forLoopY
    ld      a,      b
    cp      SCRN_Y_B
    ret     z
    inc     b
    ld      c,      0

.forLoopX
    ld      a,      c
    cp      SCRN_X_B
    jr      z,     .createFiller
    
    ld      a,     [hl+]
    ld      [de],  a
    inc     de
    inc     c

    jr      .forLoopX

.createFiller
    push    bc
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
    pop     bc
    jr      .forLoopY
