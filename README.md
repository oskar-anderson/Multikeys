# Multikeys

Map inconvenient keyboard characters to user-friendly positions. Allows multiple character set profiles for more flexibility.

## Purpose:
* Remap keyboard keys (programming symbols, ASCII art or anything else) to more convenient positions
* One layout for different keyboards
* No more switching between different keyboard languages


## Setup
Made with AutoHotkey v2, supports Windows 7 and later. **AutoHotkey v2** needs to be installed for this script to work. Check AutoHotkey v2 installation instructions at [this link](https://www.autohotkey.com/v2/).

Once AutoHotkey v2 is installed:
1. Download the project
2. Create a folder `"C:\Program Files\Multikeys"` and paste project files there.
3. You should now be able to double click on `"Main.ahk"` and the programm should start running in the background as a system tray icon.

It is rather inconvenient having to manually run the file after every restart. To make the script run on startup:
1. Create a shortcut of `Main.ahk`
2. Open Run(`Ctrl + R`) and execute command `shell:startup`
3. A folder should have opened, move the shortcut there

Custom remapping can be achieved by changing the `Hotkeys.ahk` file. Default remapping is using the schema described in chapter [Legend](#Legend).


## Legend
```
┌───────┬───────┬───────┬───────┬───────┬───────┬───────┬───────┬ 
│ ˇ     │ 1     │ 2     │ 3     │ 4     │ 5     │ 6     │ 7     │
│       │ Prfl1 │ Prfl2 │ Prfl3 │ Prfl4 │       │       │       │
├───────┴───┬───┴───┬───┴───┬───┴───┬───┴───┬───┴───┬───┴───┬───┴───┬ 
│ TAB       │ Q     │ W(/┌  │ E)|┬  │ R[\┐  │ T]&   │       │       │
│           │       │       │       │       │       │       │       │
├───────────┴─┬─────┴─┬─────┴─┬───────┬─────┴─┬─────┴─┬─────┴─┬─────┴─┬
│ CAPS        │ A     │ S<"├  │ D>'┼  │ F{`┤  │ G} ─  │       │       │
│             │       │       │       │       │       │       │       │
├─────────────┴────┬──┴─────┬─┴─────┬─┴─────┬─┴─────┬─┴─────┬─┴─────┬─┴─────┬───────┬
│ SHIFT            │ Z      │ X!?└  │ C= ┴  │ V+*┘  │ B-:│  │       │       │       │
│                  │        │       │       │       │       │       │       │       │
├──────────┬───────┴──┬─────┴────┬──┴───────┴───────┴───────┴───────┴───────┴────┬───
│ CTRL     │ WIN      │ ALT      │                     SPACE                     │
│          │          │          │                                               │
└──────────┴──────────┴──────────┴───────────────────────────────────────────────┘
```
Prfl# - Profile index, Ctrl + Prfl# changes character set to index #. Index 1 will use regular keys.
Keymappings are specified in `Hotkeys.ahk` file.

Example:
* `Ctrl + 1` activates values at index 1: `w->w` and `e->e` and `r->r`
* `Ctrl + 2` activates values at index 2: `w->(` and `e->)` and `r->[`
* `Ctrl + 3` activates values at index 3: `w->/` and `e->|` and `r->\`
