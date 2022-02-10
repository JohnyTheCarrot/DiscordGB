section "Dialog Sequences", rom0

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