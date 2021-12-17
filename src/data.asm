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

/*
============================
Variables
============================
*/

section "Variables", wram0
IsStartupFinished:: ds 1
CurrentDelayCount:: ds 1