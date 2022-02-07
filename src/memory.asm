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
    push    hl
    call    WaitVRAMAccessible
    pop     hl
    dec     bc
    ld      a,      h
    ld      [de],   a
    inc     de
    jr      MemSet

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
; Temp.nib1 => SCRN_X_B + Temp.nib1 = width of image
; Temp.nib2 => SCRN_Y_B + Temp.nib2 = height of image
TilemapCopy::
    ; clear b & c
    ld      b,      0
    ld      c,      0

    ; we push bc on the stack because the Y for loop pops and pushes each iteration
    ; if we don't push here, it'll pop too, but with an unexpected value.
    push    bc
    ; declare for loop for rows: for (; b < SCRN_Y_B + Temp.nib2; b++)
.forLoopY
    ; at the end of the y loop, we push bc.
    ; we do this pushing and popping to use the b register,
    ; but since it is modified in the x loop, we need to save bc before beginning the x loop
    ; and restore when resuming the y loop
    pop     bc

    ld      a,      b

    ; save hl and af
    push    hl
    push    af

    ; heightOffset = Temp.2;
    ; c = heightOffset + SCRN_Y_B;
    ; if (a == c) return;
    ; c = 0;
    ld      hl,     Temp.2
    ld      a,      [hl]
    add     SCRN_Y_B
    ld      c,      a
    pop     af ; restore af, we need the original value of a in the following compare instruction
    cp      c
    pop     hl ; pop hl now, because if we return, we won't get the chance again
    ret     z
    inc     b
    ; reset c before starting column for loop
    ld      c,      0

    push    bc

    ; declare for loop for columns: for (; c < SCRN_Y_B + Temp.nib1; c++)
.forLoopX
    ; load the widthOffset (Temp.1) into a, add the screen width in bytes to it, load a into b to use later in cp
    push    hl
    ld      hl,     Temp.1
    ld      a,      [hl]
    add     SCRN_X_B
    ld      b,      a
    pop     hl

    ; go to .createFiller if c == SCRN_X_B + Temp.nib1, .createFiller will return to .forLoopY when done
    ld      a,      c
    cp      b
    jr      z,     .createFiller
    
    ; *(de++) = *(hl++); c++;
    ld      a,     [hl+]
    ld      [de],  a
    inc     de
    inc     c

    ; repeat loop
    jr      .forLoopX

    ; we need to fill the non-visible part of VRAM (c > SCRN_X_B + Temp.1) with stuff,
    ; the tile index doesn't matter, but it's 0 here
.createFiller
    ld      c,      0

    push    hl

    ; load Temp.1 into b for use later in cp
    ld      hl,     Temp.1
    ld      a,      SCRN_VX_B - SCRN_X_B
    sub     [hl]
    ld      b,      a

    pop     hl

.forLoopFiller
    ld      a,      c
    cp      b
    jr      z,      .stopForLoop
    ld      a,      0
    ld      [de],   a
    inc     de
    inc     c
    jr      .forLoopFiller

.stopForLoop
    jr      .forLoopY
