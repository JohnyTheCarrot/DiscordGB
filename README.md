# DiscordGB

A pretend Discord client for the Nintendo GameBoy.

## Downloads

Click [here](https://github.com/JohnyTheCarrot/DiscordGB/releases) to find the downloads.

## Plans for the Future

The current set plans for the future are to build a sort of story-based
game. I'll be working with a friend of mine who'll help me with the writing. Once I have more information, I'll be sure to share it here.

## Todo (In No Particular Order):

- When shaking the screen, the random guff that is the VRAM outside of the initially visible window is visible.
  This should be fixed.
  The player should not be seeing the random VRAM at any point.
- Write a story, and implement features as the story requires them.
- We can probably optimise dialog_init's string pointers to be relative to the dialog's pointer using an unsigned byte
