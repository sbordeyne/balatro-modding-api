# Balatro Modding API

BMAPI is a project to inject a mod loader into the balatro source code.
It's pretty easy to do as Balatro uses the love game engine, written entirely in LUA.

The modloader will load mods from the `mods` folder in the Balatro game directory.
Each mod will need a dedicated folder (named after the mod name) and a `main.lua` file inside

Mods are loaded at the start of the game.

## Installation instructions

1. Clone the repository `git clone git@github.com:sbordeyne/balatro-modding-api`
2. Run `poetry install`
3. Run the command `poetry run python3 -m patcher`
4. Balatro will be patched with the mod loader

These steps should be done again whenever the game is updated

## Writing a mod

1. Create the `mods` directory if it does not exist, in your Balatro game directory
2. Create a folder named `mymod`, which will allow the mod loader to find your mod
3. Create a file names `main.lua` exactly, in that folder
4. Resources can be added to a subdirectory called `resources`
