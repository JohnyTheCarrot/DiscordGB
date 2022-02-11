include "consts.inc"

section "Dialog Sequences", rom0

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

IntroSeq::
    ; code
    ld      hl,         .text
    call    StartDialogSequence

    ret
.text
    db "...", DELAY, NEXT_DIALOG
    db "Am I..", DELAY, DELAY, " good enough?", NEXT_DIALOG
    db "Given all the time I've spent doing this.", NEXT_DIALOG
    db "You know, learning, growing.", NEXT_DIALOG
    db "But sometimes I feel like even with all this time", NEXT_DIALOG
    db "I'm really not far at all.", NEXT_DIALOG
    db "Sometimes I still struggle on simple things", NEXT_DIALOG
    db "Things that, after all this time, I shouldn't struggle with.", NEXT_DIALOG
    db "When people tell me something I did is impressive..", NEXT_DIALOG
    db "I quickly think to myself", NEXT_DIALOG
    db "is it?", NEXT_DIALOG
    db "People only really see the end product", NEXT_DIALOG
    db "Not the countless hours I spent on it", NEXT_DIALOG
    db "I just think I spent too long on it.", NEXT_DIALOG
    db "It really wasn't that hard, in retrospect.", NEXT_DIALOG
    db "Why did it take me so long?", NEXT_DIALOG
    db "And when it *was* hard I'd think", NEXT_DIALOG
    db "I think of the others of my age.", NEXT_DIALOG
    db "How some of them do this with such ease.", NEXT_DIALOG
    db "I feel like I'm climbing this endless mountain.", NEXT_DIALOG
    db "A mountain I can't ever hope to conquer.", NEXT_DIALOG
    db "A mountain with peaks that, once reached..", NEXT_DIALOG
    db "just reveal the next peak over the horizon.", NEXT_DIALOG
    db "When will I ever feel like I am good enough?", STR_TERM


DSeq_Test_Handler::
    ld      a,      [CurrentlySelectedDialogOption]
    cp      0
    jr      z,      .opt1
    cp      1
    jr      z,      .opt2

    ld      hl,     DialogOptions.o3
    jr      .show

.opt2
    ld      hl,     DialogOptions.o2
    jr      .show

.opt1
    ld      hl,     DialogOptions.o1
    jr      .show

.show
    call    StartDialogSequence
    ret