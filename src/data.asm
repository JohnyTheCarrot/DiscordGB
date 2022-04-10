include "hardware.inc"
include "consts.inc"

/*
============================
Constants
============================
*/

section "Discord Tiles", rom0
DiscordClient::
    incbin "gfx/discord.2bpp"
.end::

section "Discord Tilemap", rom0
DiscordClientTilemap::
    incbin "gfx/discord.tilemap"
.end::

section "Discord Logo Tiles", rom0
DiscordLogo::
    incbin "gfx/discord_logo.2bpp"
.end::

section "Discord Logo Tilemap", rom0
DiscordLogoTilemap::
    incbin "gfx/discord_logo.tilemap"
.end::

section "Dialog Tiles", rom0
Dialog::
    incbin "gfx/dialog-box.2bpp"
.end::

section "Dialog Tilemap", rom0
DialogTilemap::
    incbin "gfx/dialog-box.tilemap"
.end::

section "Sine Lookup Table", rom0, align [8]
SineLookupTable::
    def ANGLE = 0.0
    REPT 144
        db MUL(10, SIN(ANGLE))
        redef ANGLE = ANGLE + 1700.0
    ENDR
.end::

section "Font", rom0
opt bX.

; created with help from https://github.com/nezticle/rgbds-template/blob/master/inc/ibmpc1.inc
Font::
    db %........
    db %........
    db %........
    db %........
    db %........
    db %........
    db %........
    db %........

    db %..XX....
    db %..XX....
    db %..XX....
    db %..XX....
    db %..XX....
    db %........
    db %..XX....
    db %..XX....
    
    db %........
    db %.XX.XX..
    db %.XX.XX..
    db %........
    db %........
    db %........
    db %........
    db %........

    db %.XX.XX..
    db %.XX.XX..
    db %XXXXXXX.
    db %.XX.XX..
    db %.XX.XX..
    db %XXXXXXX.
    db %.XX.XX..
    db %.XX.XX..

    db %..XX....
    db %.XXXXX..
    db %XX......
    db %.XXXX...
    db %....XX..
    db %XXXXX...
    db %..XX....
    db %........

    db %........
    db %XX...XX.
    db %XX..XX..
    db %...XX...
    db %..XX....
    db %.XX..XX.
    db %XX...XX.
    db %........

    db %..XXX...
    db %.XX.XX..
    db %..XXX...
    db %.XXX.XX.
    db %XX.XXX..
    db %XX..XX..
    db %.XXX.XX.
    db %........

    db %.XX.....
    db %.XX.....
    db %XX......
    db %........
    db %........
    db %........
    db %........
    db %........

    db %...XX...
    db %..XX....
    db %.XX.....
    db %.XX.....
    db %.XX.....
    db %..XX....
    db %...XX...
    db %........

    db %.XX.....
    db %..XX....
    db %...XX...
    db %...XX...
    db %...XX...
    db %..XX....
    db %.XX.....
    db %........

    db %........
    db %.XX..XX.
    db %..XXXX..
    db %XXXXXXXX & $FF
    db %..XXXX..
    db %.XX..XX.
    db %........
    db %........

    db %........
    db %..XX....
    db %..XX....
    db %XXXXXX..
    db %..XX....
    db %..XX....
    db %........
    db %........

    db %........
    db %........
    db %........
    db %........
    db %........
    db %..XX....
    db %..XX....
    db %.XX.....

    db %........
    db %........
    db %........
    db %XXXXXX..
    db %........
    db %........
    db %........
    db %........

    db %........
    db %........
    db %........
    db %........
    db %........
    db %..XX....
    db %..XX....
    db %........

    db %.....XX.
    db %....XX..
    db %...XX...
    db %..XX....
    db %.XX.....
    db %XX......
    db %X.......
    db %........

    db %.XXXXX..
    db %XX...XX.
    db %XX..XXX.
    db %XX.XXXX.
    db %XXXX.XX.
    db %XXX..XX.
    db %.XXXXX..
    db %........

    db %..XX....
    db %.XXX....
    db %..XX....
    db %..XX....
    db %..XX....
    db %..XX....
    db %XXXXXX..
    db %........

    db %.XXXX...
    db %XX..XX..
    db %....XX..
    db %..XXX...
    db %.XX.....
    db %XX..XX..
    db %XXXXXX..
    db %........

    db %.XXXX...
    db %XX..XX..
    db %....XX..
    db %..XXX...
    db %....XX..
    db %XX..XX..
    db %.XXXX...
    db %........

    db %...XXX..
    db %..XXXX..
    db %.XX.XX..
    db %XX..XX..
    db %XXXXXXX.
    db %....XX..
    db %...XXXX.
    db %........

    db %XXXXXX..
    db %XX......
    db %XXXXX...
    db %....XX..
    db %....XX..
    db %XX..XX..
    db %.XXXX...
    db %........

    db %..XXX...
    db %.XX.....
    db %XX......
    db %XXXXX...
    db %XX..XX..
    db %XX..XX..
    db %.XXXX...
    db %........

    db %XXXXXX..
    db %XX..XX..
    db %....XX..
    db %...XX...
    db %..XX....
    db %..XX....
    db %..XX....
    db %........

    db %.XXXX...
    db %XX..XX..
    db %XX..XX..
    db %.XXXX...
    db %XX..XX..
    db %XX..XX..
    db %.XXXX...
    db %........

    db %.XXXX...
    db %XX..XX..
    db %XX..XX..
    db %.XXXXX..
    db %....XX..
    db %...XX...
    db %.XXX....
    db %........

    db %........
    db %..XX....
    db %..XX....
    db %........
    db %........
    db %..XX....
    db %..XX....
    db %........

    db %........
    db %..XX....
    db %..XX....
    db %........
    db %........
    db %..XX....
    db %..XX....
    db %.XX.....

    db %...XX...
    db %..XX....
    db %.XX.....
    db %XX......
    db %.XX.....
    db %..XX....
    db %...XX...
    db %........

    db %........
    db %........
    db %XXXXXX..
    db %........
    db %........
    db %XXXXXX..
    db %........
    db %........

    db %.XX.....
    db %..XX....
    db %...XX...
    db %....XX..
    db %...XX...
    db %..XX....
    db %.XX.....
    db %........

    db %.XXXX...
    db %XX..XX..
    db %....XX..
    db %...XX...
    db %..XX....
    db %........
    db %..XX....
    db %........

    db %.XXXXX..
    db %XX...XX.
    db %XX.XXXX.
    db %XX.XXXX.
    db %XX.XXXX.
    db %XX......
    db %.XXXX...
    db %........

    db %..XX....
    db %.XXXX...
    db %XX..XX..
    db %XX..XX..
    db %XXXXXX..
    db %XX..XX..
    db %XX..XX..
    db %........

    db %XXXXXX..
    db %.XX..XX.
    db %.XX..XX.
    db %.XXXXX..
    db %.XX..XX.
    db %.XX..XX.
    db %XXXXXX..
    db %........

    db %..XXXX..
    db %.XX..XX.
    db %XX......
    db %XX......
    db %XX......
    db %.XX..XX.
    db %..XXXX..
    db %........

    db %XXXXX...
    db %.XX.XX..
    db %.XX..XX.
    db %.XX..XX.
    db %.XX..XX.
    db %.XX.XX..
    db %XXXXX...
    db %........

    db %.XXXXXX.
    db %.XX.....
    db %.XX.....
    db %.XXXX...
    db %.XX.....
    db %.XX.....
    db %.XXXXXX.
    db %........

    db %.XXXXXX.
    db %.XX.....
    db %.XX.....
    db %.XXXX...
    db %.XX.....
    db %.XX.....
    db %.XX.....
    db %........

    db %..XXXX..
    db %.XX..XX.
    db %XX......
    db %XX......
    db %XX..XXX.
    db %.XX..XX.
    db %..XXXXX.
    db %........

    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %XXXXXX..
    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %........

    db %.XXXX...
    db %..XX....
    db %..XX....
    db %..XX....
    db %..XX....
    db %..XX....
    db %.XXXX...
    db %........

    db %...XXXX.
    db %....XX..
    db %....XX..
    db %....XX..
    db %XX..XX..
    db %XX..XX..
    db %.XXXX...
    db %........

    db %XXX..XX.
    db %.XX..XX.
    db %.XX.XX..
    db %.XXXX...
    db %.XX.XX..
    db %.XX..XX.
    db %XXX..XX.
    db %........

    db %.XX.....
    db %.XX.....
    db %.XX.....
    db %.XX.....
    db %.XX.....
    db %.XX.....
    db %.XXXXXX.
    db %........

    db %XX...XX.
    db %XXX.XXX.
    db %XXXXXXX.
    db %XXXXXXX.
    db %XX.X.XX.
    db %XX...XX.
    db %XX...XX.
    db %........

    db %XX...XX.
    db %XXX..XX.
    db %XXXX.XX.
    db %XX.XXXX.
    db %XX..XXX.
    db %XX...XX.
    db %XX...XX.
    db %........

    db %..XXX...
    db %.XX.XX..
    db %XX...XX.
    db %XX...XX.
    db %XX...XX.
    db %.XX.XX..
    db %..XXX...
    db %........

    db %XXXXXX..
    db %.XX..XX.
    db %.XX..XX.
    db %.XXXXX..
    db %.XX.....
    db %.XX.....
    db %XXXX....
    db %........

    db %.XXXX...
    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %XX.XXX..
    db %.XXXX...
    db %...XXX..
    db %........

    db %XXXXXX..
    db %.XX..XX.
    db %.XX..XX.
    db %.XXXXX..
    db %.XX.XX..
    db %.XX..XX.
    db %XXX..XX.
    db %........

    db %.XXXX...
    db %XX..XX..
    db %XXX.....
    db %.XXXX...
    db %...XXX..
    db %XX..XX..
    db %.XXXX...
    db %........

    db %XXXXXX..
    db %..XX....
    db %..XX....
    db %..XX....
    db %..XX....
    db %..XX....
    db %..XX....
    db %........

    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %XXXXXX..
    db %........

    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %.XXXX...
    db %..XX....
    db %........

    db %XX...XX.
    db %XX...XX.
    db %XX...XX.
    db %XX.X.XX.
    db %XXXXXXX.
    db %XXX.XXX.
    db %XX...XX.
    db %........

    db %XX...XX.
    db %XX...XX.
    db %.XX.XX..
    db %..XXX...
    db %..XXX...
    db %.XX.XX..
    db %XX...XX.
    db %........

    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %.XXXX...
    db %..XX....
    db %..XX....
    db %.XXXX...
    db %........

    db %XXXXXXX.
    db %.....XX.
    db %....XX..
    db %...XX...
    db %..XX....
    db %.XX.....
    db %XXXXXXX.
    db %........

    db %.XXXX...
    db %.XX.....
    db %.XX.....
    db %.XX.....
    db %.XX.....
    db %.XX.....
    db %.XXXX...
    db %........

    db %XX......
    db %.XX.....
    db %..XX....
    db %...XX...
    db %....XX..
    db %.....XX.
    db %......X.
    db %........

    db %.XXXX...
    db %...XX...
    db %...XX...
    db %...XX...
    db %...XX...
    db %...XX...
    db %.XXXX...
    db %........

    db %...X....
    db %..XXX...
    db %.XX.XX..
    db %XX...XX.
    db %........
    db %........
    db %........
    db %........

    db %........
    db %........
    db %........
    db %........
    db %........
    db %........
    db %........
    db %XXXXXXXX & $FF

    db %..XX....
    db %..XX....
    db %...XX...
    db %........
    db %........
    db %........
    db %........
    db %........

    db %........
    db %........
    db %.XXXX...
    db %....XX..
    db %.XXXXX..
    db %XX..XX..
    db %.XXX.XX.
    db %........

    db %XXX.....
    db %.XX.....
    db %.XX.....
    db %.XXXXX..
    db %.XX..XX.
    db %.XX..XX.
    db %XX.XXX..
    db %........

    db %........
    db %........
    db %.XXXX...
    db %XX..XX..
    db %XX......
    db %XX..XX..
    db %.XXXX...
    db %........

    db %...XXX..
    db %....XX..
    db %....XX..
    db %.XXXXX..
    db %XX..XX..
    db %XX..XX..
    db %.XXX.XX.
    db %........

    db %........
    db %........
    db %.XXXX...
    db %XX..XX..
    db %XXXXXX..
    db %XX......
    db %.XXXX...
    db %........

    db %..XXX...
    db %.XX.XX..
    db %.XX.....
    db %XXXX....
    db %.XX.....
    db %.XX.....
    db %XXXX....
    db %........

    db %........
    db %........
    db %.XXX.XX.
    db %XX..XX..
    db %XX..XX..
    db %.XXXXX..
    db %....XX..
    db %XXXXX...

    db %XXX.....
    db %.XX.....
    db %.XX.XX..
    db %.XXX.XX.
    db %.XX..XX.
    db %.XX..XX.
    db %XXX..XX.
    db %........

    db %..XX....
    db %........
    db %.XXX....
    db %..XX....
    db %..XX....
    db %..XX....
    db %.XXXX...
    db %........

    db %....XX..
    db %........
    db %....XX..
    db %....XX..
    db %....XX..
    db %XX..XX..
    db %XX..XX..
    db %.XXXX...

    db %XXX.....
    db %.XX.....
    db %.XX..XX.
    db %.XX.XX..
    db %.XXXX...
    db %.XX.XX..
    db %XXX..XX.
    db %........

    db %.XXX....
    db %..XX....
    db %..XX....
    db %..XX....
    db %..XX....
    db %..XX....
    db %.XXXX...
    db %........

    db %........
    db %........
    db %XX..XX..
    db %XXXXXXX.
    db %XXXXXXX.
    db %XX.X.XX.
    db %XX...XX.
    db %........

    db %........
    db %........
    db %XXXXX...
    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %........

    db %........
    db %........
    db %.XXXX...
    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %.XXXX...
    db %........

    db %........
    db %........
    db %XX.XXX..
    db %.XX..XX.
    db %.XX..XX.
    db %.XXXXX..
    db %.XX.....
    db %XXXX....

    db %........
    db %........
    db %.XXX.XX.
    db %XX..XX..
    db %XX..XX..
    db %.XXXXX..
    db %....XX..
    db %...XXXX.

    db %........
    db %........
    db %XX.XXX..
    db %.XXX.XX.
    db %.XX..XX.
    db %.XX.....
    db %XXXX....
    db %........

    db %........
    db %........
    db %.XXXXX..
    db %XX......
    db %.XXXX...
    db %....XX..
    db %XXXXX...
    db %........

    db %...X....
    db %..XX....
    db %.XXXXX..
    db %..XX....
    db %..XX....
    db %..XX.X..
    db %...XX...
    db %........

    db %........
    db %........
    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %.XXX.XX.
    db %........

    db %........
    db %........
    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %.XXXX...
    db %..XX....
    db %........

    db %........
    db %........
    db %XX...XX.
    db %XX.X.XX.
    db %XXXXXXX.
    db %XXXXXXX.
    db %.XX.XX..
    db %........

    db %........
    db %........
    db %XX...XX.
    db %.XX.XX..
    db %..XXX...
    db %.XX.XX..
    db %XX...XX.
    db %........

    db %........
    db %........
    db %XX..XX..
    db %XX..XX..
    db %XX..XX..
    db %.XXXXX..
    db %....XX..
    db %XXXXX...

    db %........
    db %........
    db %XXXXXX..
    db %X..XX...
    db %..XX....
    db %.XX..X..
    db %XXXXXX..
    db %........

    db %...XXX..
    db %..XX....
    db %..XX....
    db %XXX.....
    db %..XX....
    db %..XX....
    db %...XXX..
    db %........

    db %...XX...
    db %...XX...
    db %...XX...
    db %........
    db %...XX...
    db %...XX...
    db %...XX...
    db %........

    db %XXX.....
    db %..XX....
    db %..XX....
    db %...XXX..
    db %..XX....
    db %..XX....
    db %XXX.....
    db %........

    db %.XXX.XX.
    db %XX.XXX..
    db %........
    db %........
    db %........
    db %........
    db %........
    db %........

    db %..X.....
    db %..XX....
    db %..XXX...
    db %..XXXX..
    db %..XXXX..
    db %..XXX...
    db %..XX....
    db %..X.....
.end::

charmap " ", 0
charmap "!", 1
charmap "\"", 2
charmap "#", 3
charmap "$", 4
charmap "%", 5
charmap "&", 6
charmap "'", 7
charmap "(", 8
charmap ")", 9
charmap "*", 10
charmap "+", 11
charmap ",", 12
charmap "-", 13
charmap ".", 14
charmap "/", 15
charmap "0", 16
charmap "1", 17
charmap "2", 18
charmap "3", 19
charmap "4", 20
charmap "5", 21
charmap "6", 22
charmap "7", 23
charmap "8", 24
charmap "9", 25
charmap ":", 26
charmap ";", 27
charmap "<", 28
charmap "=", 29
charmap ">", 30
charmap "?", 31
charmap "@", 32
charmap "A", 33
charmap "B", 34
charmap "C", 35
charmap "D", 36
charmap "E", 37
charmap "F", 38
charmap "G", 39
charmap "H", 40
charmap "I", 41
charmap "J", 42
charmap "K", 43
charmap "L", 44
charmap "M", 45
charmap "N", 46
charmap "O", 47
charmap "P", 48
charmap "Q", 49
charmap "R", 50
charmap "S", 51
charmap "T", 52
charmap "U", 53
charmap "V", 54
charmap "W", 55
charmap "X", 56
charmap "Y", 57
charmap "Z", 58
charmap "[", 59
charmap "\\", 60
charmap "]", 61
charmap "^", 62
charmap "_", 63
charmap "`", 64
charmap "a", 65
charmap "b", 66
charmap "c", 67
charmap "d", 68
charmap "e", 69
charmap "f", 70
charmap "g", 71
charmap "h", 72
charmap "i", 73
charmap "j", 74
charmap "k", 75
charmap "l", 76
charmap "m", 77
charmap "n", 78
charmap "o", 79
charmap "p", 80
charmap "q", 81
charmap "r", 82
charmap "s", 83
charmap "t", 84
charmap "u", 85
charmap "v", 86
charmap "w", 87
charmap "x", 88
charmap "y", 89
charmap "z", 90
charmap "\{", 91
charmap "|", 92
charmap "}", 93
charmap "~", 94
charmap "\n", NEWLINE

section "Dialog Text", rom0

; Text
Intro::
    db "Your day is going pretty great, when", "suddenly.", DELAY, ".", DELAY, NEXT_DIALOG
    db DELAY, ".", DELAY, ".", DELAY, ".", DELAY, "@everyone", SHAKE_SCREEN, DELAY, NEXT_DIALOG
    db "You: What was that?", NEXT_DIALOG
    db DELAY, SHAKE_SCREEN, DELAY, "Oh damn, they're  back aren't they..", NEXT_DIALOG
    db "???: Free distribution of discord nitro for 3 months from steam!!", NEXT_DIALOG
    db "You: Shit.", NEXT_DIALOG
    db "???: https://discord.com/notro", STR_TERM
.end::

OptionDialogQuestion:: wrapped_dialog_text "Your day is going pretty great, when suddenly."

OptionDialog::
    init_dialog \ 
        "Yes", DSeq_Test_Handler, \
        "Yes!", DSeq_Test_Handler

DialogOptions::
.o1:: wrapped_dialog_text "oohoho he do be a stinker doe"
.o2:: wrapped_dialog_text "oh shit man I can smell him from here"
.o3:: wrapped_dialog_text "jesus man, does he not have a shower?"

/*
; screen shake test dialog
Intro::
    db NEXT_DIALOG
    rept 18 * 4
    db "A"
    endr
    rept 300
    db SHAKE_SCREEN
    endr
    db STR_TERM
.end::
*/

/*
============================
Variables
============================
*/

section "Variables", wram0
IsStartupFinished:: ds 1
Temp::
    .1:: ds 1
    .2:: ds 1
