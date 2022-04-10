P1F_BTN_A       = %00000001
P1F_BTN_B       = %00000010
P1F_BTN_SELECT  = %00000100
P1F_BTN_START   = %00001000
P1F_DPAD_RIGHT  = %00010000
P1F_DPAD_LEFT   = %00100000
P1F_DPAD_UP     = %01000000
P1F_DPAD_DOWN   = %10000000

def STR_TERM        equ $FF
def NEXT_DIALOG     equ $7F - $20 ; used to split the same text into multiple dialog boxes
def DELAY           equ $80 - $20
def SHAKE_SCREEN    equ $81 - $20
def NEXT_OPTION     equ $82 - $20 ; used to separate different options in a select dialog.
def NEWLINE         equ 95

def MAX_LINE_LENGTH     equ 18
def MAX_DIALOG_LINES    equ 4
def SCREEN_SHAKE_AMOUNT equ 2
def DEFAULT_SCREEN_X    equ 8
def DEFAULT_SCREEN_Y    equ 8

def MIN_TIMER_PERIOD equ 0.0625

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

macro wrapped_dialog_text
    def LAST_SPACE_POS = 0

    for i, strlen(\1)
        if (i + 1) % (SCRN_X_B - 2) == 0
            redef LAST_SPACE_POS = 0
            println ""
            db "\n"
        endc

        print charsub(\1, i + 1)
        db charsub(\1, i + 1)
    endr
    db STR_TERM
    println ""
    purge LAST_SPACE_POS
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


macro reset_screen_scroll
    ld      a,      DEFAULT_SCREEN_X
    ldh     [rSCX], a
    if DEFAULT_SCREEN_X != DEFAULT_SCREEN_Y
    ld      a,      DEFAULT_SCREEN_Y
    endc
    ldh     [rSCY], a
endm

macro db_term_string
    db \1, STR_TERM
endm

macro dialog_option
    dw \1 ; string pointer
    dw \2 ; select handler pointer
endm

macro dialog_option_string
    static_assert fatal, strlen(\1) <= MAX_LINE_LENGTH - 1, strfmt("\"%s\"'s length of %u is %u characters too long, and would not fit in the dialog.", \1, strlen(\1), strlen(\1) - (MAX_LINE_LENGTH - 1))
    db_term_string \1
endm

macro init_dialog

assert fatal, _NARG % 2 == 0, strfmt("init_dialog called in file %s was provided an odd number of arguments: %u arguments", __FILE__, _NARG)
assert fatal, _NARG >= 4, strfmt("init_dialog called in file %s was provided an even, but too small number of arguments. At least 4 are required (string1, selectCallbackPtr1, string2, selectCallbackptr2, ...), but %u were provided.", __FILE__, _NARG)
assert fatal, _NARG <= 8, strfmt("init_dialog in file %s called with too many arguments", __FILE__)

db _NARG / 2 ; for the code to know how many options to expect

if _NARG >= 4
    dialog_option :+, \2
    dialog_option :++, \4
endc

if _NARG >= 6
    dialog_option :+++, \6
endc

if _NARG == 8
    dialog_option :++++, \8
endc

for str, 1, _NARG+1, 2
:   dialog_option_string \<{u:str}>
endr

endm
