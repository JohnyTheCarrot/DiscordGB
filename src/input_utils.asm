include "hardware.inc"
include "consts.inc"

section "Input Utils", rom0
/*
    Assumes the joypad interrupt is enabled.
    Will block until one of the specified buttons is pressed, and until they are all released.

    c => input flags to wait for
*/
WaitForInput::
.waitForSet
    ld      a,      [hCurrentKeys]
    and     c
    jr      z,      .waitForSet
    push    af

.waitForReset
    ld      a,      [hCurrentKeys]
    and     c
    cp      0
    jr      nz,      .waitForReset

    pop     af
    ; a serves as return value of buttons pressed
    ret
