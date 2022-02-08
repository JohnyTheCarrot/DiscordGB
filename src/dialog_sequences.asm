section "Dialog Sequences", rom0

DS_Test_CB::
    ld      hl,         Intro
    call    StartDialogSequence
    ret