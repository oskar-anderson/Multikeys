# Multikeys

AutoHotkey v2 script for mapping multiple characters to single keyboard button.

Useful for:
* Remapping frequently used programming symbols
* One layout for different language settings[^1]
* One layout for laptop and external desktop keyboards
* ASCII art

Can cause problems with games not registering remapped keys anymore. 

[^1]: Result depends on active character set. But common Latin letters [a-zA-Z] should stay the same.
 
## Quick example:
```
Mapping for x and c keys:

some new changes
{ detect: "x", values: ["x", "{!}", "=", "└"]}
{ detect: "c", values: ["c", "?",   ":", "┴"]}


Empty string (null in AHK) gets mapped to itself, case-sensitive
Ctrl + 1 activates values at index 1: x:="x" and c:="c"
Ctrl + 2 activates values at index 2: x:="!" and c:="?"
Ctrl + 3 activates values at index 3: x:="=" and c:=":"
...

AHK is a indexes start with 1 kind of language.
```

## Legend
```
┌───────┬───────┬───────┬───────┬───────┬───────┬───────┬───────┬ 
│ ˇ     │ 1     │ 2     │ 3     │ 4     │ 5     │ 6     │ 7     │
│       │ CB1   │ CB2   │ CB3   │ CB4   │       │       │       │
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

CB - Change bar, Ctrl + CB# changes active character set to number #
```

## Setup

Set hotkeys to run on startup:
1. Download the project
2. Create a folder "C:\Program Files\Multikeys" and paste project files there
3. Create a shortcut of `Main.ahk`
4. Open Run(`Ctrl + R`) and execute command `shell:startup`
5. A folder should have opened, move the shortcut there
