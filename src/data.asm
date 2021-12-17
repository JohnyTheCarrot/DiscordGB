include "hardware.inc"

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

section "Sine Lookup Table", rom0
SineLookupTable::
    def ANGLE = 0.0
    REPT 144
        db MUL(10, SIN(ANGLE))
        redef ANGLE = ANGLE + 1700.0
    ENDR
.end::

/*
============================
Variables
============================
*/

section "Variables", wram0
IsStartupFinished:: ds 1
CurrentDelayCount:: ds 1