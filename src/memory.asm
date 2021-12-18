include "hardware.inc"

def ASCII_START_CODE = $20

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

ShiftLeftLIntoH:
    sla     l
    ret     nc
    set     0,      h
    ret

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

; hl => string pointer
; de => dest
; bc => bytecount
MemCopyASCII::
    ; return if bc is 0: if (b == c && b == 0) return;
    ld      a,      c
    cp      b
    jr      nz,     .copy
    cp      0
    ret     z

    ; runs per character
.copy
    dec     bc
    push    bc
    ld      c,      0

    ; runs per line of character
.copyCharacter
    push    hl
    ld      a,      [hl]
    sub     ASCII_START_CODE ; we're using this as the base pointer
    ld      l,      a
    ld      h,      0

    ; hl * 8 via hl << 3
    call    ShiftLeftLIntoH
    call    ShiftLeftLIntoH
    call    ShiftLeftLIntoH

    ; add (Font address + c) to hl
    push    de
    ld      de,     Font
    add     hl,     de
    ld      d,      0
    ld      a,      c
    ld      e,      a
    add     hl,     de
    pop     de

    ; load [hl] into [de+] and [de+]
    ld      a,      [hl]
    ld      [de],   a
    inc     de
    ld      [de],   a
    inc     de

    ; restore hl; if ++c == 8, move to next character in string
    inc     c
    ld      a,      c
    pop     hl
    cp      8
    jr      c,      .copyCharacter

    ; character done, move on to next
    inc     hl
    pop     bc
    jr      MemCopyASCII

; hl => map
; a  => value
; return value => a
MapLookup:
    push    de
    push    hl
    ; calculate index
    sub     $20
    ld      d,      0
    ld      e,      a
    add     hl,     de
    ld      a,      [hl]
    
    pop     hl
    pop     de
    ret

; hl => string pointer
; de => dest
; bc => bytecount
TilemapASCII::
    ; return if bc is 0: if (b == c && b == 0) return;
    ld      a,      c
    cp      b
    jr      nz,     .load
    cp      0
    ret     z

.load
    dec     bc
    ld      a,      [hl+]
    
    push    hl
    ld      hl,     ASCIICodeToTileIndex
    call    MapLookup
    pop     hl

    ld      [de],   a
    inc     de

    jr      TilemapASCII

; hl => dest
; d => by
IncrementMem::
    ld      bc,     SCRN_Y_B * SCRN_X_B
.checkLoop
    ; return if bc is 0: if (b == c && b == 0) return;
    ld      a,      c
    cp      b
    jr      nz,     .increment
    cp      0
    ret     z

.increment
    dec     bc
    ld      a,      [hl]
    add     d
    ld      [hl+],   a
    jr      .checkLoop

; hl => source
; de => dest
TilemapCopy::
    ; load into de (destination) _SCRN0 ($9800) and clear b & c
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
