P1F_BTN_A       = %00000001
P1F_BTN_B       = %00000010
P1F_BTN_SELECT  = %00000100
P1F_BTN_START   = %00001000
P1F_DPAD_RIGHT  = %00010000
P1F_DPAD_LEFT   = %00100000
P1F_DPAD_UP     = %01000000
P1F_DPAD_DOWN   = %10000000

def STR_TERM        = 0
def NEXT_DIALOG     = $7F ; used to split the same text into multiple dialog boxes
def DELAY           = $80

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

    def REQUIRED_TICKS = \1 * TIMER_HERTZ / 256

    assert REQUIRED_TICKS <= $ff

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
