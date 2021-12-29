# Multikeys

AutoHotkey v2 script for mapping multiple characters to single keyboard button. Result depends on active character set.

Useful for:
* remapping frequently used symbols in programming
* fix bad keyboard layout
* ASCII art

## Quick example:
```
Mapping for x and c keys:

{ detect: "x", values: ["x", "{!}", "=", "└"]}
{ detect: "c", values: ["c", "?", ":", "┴"]},

Ctrl + 1 activates values at index 1*: x:="x" and c:="c"
Ctrl + 2 activates values at index  2: x:="!" and c:="?"
Ctrl + 3 activates values at index  3: x:="=" and c:=":"
...

*AHK is a indexes start with 1 kind of language.
```

## Legend
```
┌───────┬───────┬───────┬───────┬───────┬───────┬───────┬───────┬ 
│ ˇ     │ 1     │ 2     │ 3     │ 4     │ 5     │ 6     │ 7     │
│       │       │       │       │       │       │       │       │
│       │ CB1   │ CB2   │ CB3   │ CB4   │       │       │       │
├───────┴───┬───┴───┬───┴───┬───┴───┬───┴───┬───┴───┬───┴───┬───┴───┬ 
│ TAB       │ Q     │ W(/┌  │ E)|┬  │ R[\┐  │ T]*   │       │       │
│           │       │       │       │       │       │       │       │
│           │       │       │       │       │       │       │       │
├───────────┴─┬─────┴─┬─────┴─┬───────┬─────┴─┬─────┴─┬─────┴─┬─────┴─┬
│ CAPS        │ A     │ S<"├  │ D>'┼  │ F{`┤  │ G} ─  │       │       │
│             │       │       │       │       │       │       │       │
│             │       │       │       │       │       │       │       │
├─────────────┴────┬──┴─────┬─┴─────┬─┴─────┬─┴─────┬─┴─────┬─┴─────┬─┴─────┬───────┬
│ SHIFT            │ Z      │ X!?└  │ C=:┴  │ V& ┘  │ B  │  │       │       │       │
│                  │        │       │       │       │       │       │       │       │
│                  │        │       │       │       │       │       │       │       │
├──────────┬───────┴──┬─────┴────┬──┴───────┴───────┴───────┴───────┴───────┴────┬───
│ CTRL     │ WIN      │ ALT      │                     SPACE                     │
│          │          │          │                                               │
└──────────┴──────────┴──────────┴───────────────────────────────────────────────┘
```

## Setup

Set hotkeys to run on startup:
1. Download the project
2. Create a folder "C:\Program Files\Multikeys" and paste project files there
3. Create a shortcut of `Main.ahk`
4. Open Run(`Ctrl + R`) and execute command
```
shell:startup
```
5. A folder should have opened, move the shortcut there