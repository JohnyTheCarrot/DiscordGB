P1F_BTN_A       = %00000001
P1F_BTN_B       = %00000010
P1F_BTN_SELECT  = %00000100
P1F_BTN_START   = %00001000
P1F_DPAD_RIGHT  = %00010000
P1F_DPAD_LEFT   = %00100000
P1F_DPAD_UP     = %01000000
P1F_DPAD_DOWN   = %10000000

def STR_TERM        = $FF
def NEXT_DIALOG     = $7F - $20 ; used to split the same text into multiple dialog boxes
def DELAY           = $80 - $20
def SHAKE_SCREEN    = $81 - $20

/*
Sleeps using the specified clock speed.

\1 * Hz / 256
\2 = clock speed
*/
macro sleep
    def TIMER_HERTZ = 4096
    def TIMER_MODE  = TACF_4KHZ

    if \2 == 1
        redef TIMER_HERTZ = 16384
        redef TIMER_MODE  = TACF_16KHZ
    endc

    def REQUIRED_TICKS = div(mul(\1, TIMER_HERTZ), 256) >> 16

    println strfmt("Adding sleep in file %s for %f seconds, which at %uHz is %u ticks.", __FILE__, \1, TIMER_HERTZ, REQUIRED_TICKS)

    assert fatal, REQUIRED_TICKS <= $ff, strfmt("Final amount of ticks required is higher than 255. Hint: Make sure the amount of seconds specified is a fixed point number! Number specified: %f, did you mean: %f (don't forget the '.0' if you're just wanting to use %u seconds)", \1, \1 << 16, \1)
    assert fatal, REQUIRED_TICKS > 0, strfmt("A delay ticks amount of 0? That can't have been intentional. Hint: Make sure the amount of seconds specified is a fixed point number! Number specified: %f, did you mean: %f (don't forget the '.0' if you're just wanting to use %u seconds)", \1, \1 << 16, \1)

    push    hl
    push    af
    ; set timer speed and start it
    ld      a,          TACF_START | TIMER_MODE
    ld      hl,         rTAC
    ldh     [rTAC],     a

    ld      hl,     DelayGoal
    ld      [hl],   REQUIRED_TICKS
    call    Sleep
    pop     af
    pop     hl
endm

/*
Sleeps using the slowest timer speed.

\1 * 4096Hz / 256
*/
macro sleep_slow
    sleep \1, 0
endm

/*
Sleeps using the second slowest timer speed.

\1 * 16384Hz / 256
*/
macro sleep_fast
    sleep \1, 1
endm
