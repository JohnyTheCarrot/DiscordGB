section "String Utils", rom0

/*
    Loads the pointer of the text **after** the first match of the character in the a register
    into the de register.

    hl  => str pointer, keeps reading until null terminator or character in the a register
    c   => character to split from
*/
StringSplit::
    ; we're saving hl so the caller keeps an idea of where the string is
    push    hl

.loop
    ld      a,      [hl]
    ; if [hl] == c, return the pointer in the de register
    cp      c
    jr      z,      .returnMatchPointer
    ; otherwise, check if hl points at a null terminator, if so, stop the loop regardless and load end of string into de
    ; we can use the same branch destination as if [hl] were c, as hl in this case would be the end of the string
    cp      0
    jr      z,      .returnMatchPointer
    ; increment hl, and continue
    inc     hl
    jr      .loop

    ; hl => de; pop hl from stack; return
.returnMatchPointer
    ld      d,      h
    ld      e,      l
    pop     hl
    ret


    
/*
    Determines the length of a string by counting the number of bytes until de character in e is found.

    hl  => str pointer (modified during call)
    e   => char to stop counting at
    bc  <= string length
*/
StringLen::
    ld      bc,     0

.loop
    ld      a,      [hl+]
    cp      e
    ret     z
    cp      0
    ret     z
    inc     bc
    jr      .loop
