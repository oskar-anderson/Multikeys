/*
Numpad mapping:
┌───┬───┬───┬───┐
│NL │ / │ * │ - │
├───┼───┼───┼───┤
│ 7 │ 8 │ 9 │   │
├───┼───┼───┤ + │
│ 4 │ 5 │ 6 │   │
├───┼───┼───┼───┤
│ 1 │ 2 │ 3 │   │
├───┴───┼───┤ENT│
│ MODIF | 0 │   │
└───────┴───┴───┘

┌───┬───┬───┬───┐
│NL │ / │ * │ - │
├───┼───┼───┼───┤
│ ( │ [ │ { │   │
├───┼───┼───┤ + │
│ " │ < │ * │   │
├───┼───┼───┼───┤
│ ! │ ? │ & │   │
├───┴───┼───┤ENT│
│ MODIF | $ │   │
└───────┴───┴───┘

┌───┬───┬───┬───┐
│NL │ / │ * │ - │
├───┼───┼───┼───┤
│ ) │ ] │ } │   │
├───┼───┼───┤ + │
│ ' │ > │ / │   │
├───┼───┼───┼───┤
│ = │ : │ | │   │
├───┴───┼───┤ENT│
│ MODIF | \ │   │
└───────┴───┴───┘

Unfortunately shift modifier does not work:
-shift turns numlock off
-modifies keys after AutoHotKey
-result depends on keyboard language

│─
┌┴┐
┤┼├
└┬┘
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#InstallKeybdHook
#CommentFlag ;
#Warn  ; Enable warnings to assist with detecting common errors.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Alt key is        !
; Windows key is    #
; Shift key is      +
; Control key is    ^

SetCapsLockState, alwaysoff ; (CapsLock) or (Shift + CapsLock) will not turn on CapsLock

global SkillBarModCounter := 1
global SkillBarModDiv := 3

ActivateDebugHotkeys()
ActivateHotkeys()

return

; region debughotkeys
ActivateDebugHotkeys()
{
    Hotkey, +Esc, LabelSuspend
    Hotkey, ^r, LabelReload
    return
}

LabelSuspend:
    MsgBox %A_ThisHotkey% --- Suspend
    Suspend
    return
LabelReload:
    MsgBox %A_ThisHotkey%  --- Reloaded
    Reload
    return
; endregion

ActivateHotkeys() 
{
    Hotkey, ^Numpad1, LabelChangeBarTo1Perm
    Hotkey, ^Numpad2, LabelChangeBarTo2Temp
    Hotkey, ^Numpad3, LabelChangeBarTo3Temp

    Hotkey, Numpad1, LabelNumpad1
    Hotkey, Numpad2, LabelNumpad2
    Hotkey, Numpad3, LabelNumpad3
    Hotkey, Numpad4, LabelNumpad4
    Hotkey, Numpad5, LabelNumpad5
    Hotkey, Numpad6, LabelNumpad6
    Hotkey, Numpad7, LabelNumpad7
    Hotkey, Numpad8, LabelNumpad8
    Hotkey, Numpad9, LabelNumpad9
    Hotkey, NumpadDot, LabelNumpadDot

    Hotkey, F9, LabelChangeSkillBar
    
    return
}

LabelChangeBarTo1Perm:
    SkillBarModCounter := 1
    return

LabelChangeBarTo2Temp:
    SkillBarModCounter := 2
    sleep 1000
    if (GetKeyState("shift")) {
        return
    }
    SkillBarModCounter := 1
    return

LabelChangeBarTo3Temp:
    SkillBarModCounter := 3
    sleep 1000
    if (GetKeyState("shift")) {
        return
    }
    SkillBarModCounter := 1
    return

LabelChangeSkillBar:
    SkillBarModCounter := Mod(SkillBarModCounter, SkillBarModDiv)
    SkillBarModCounter++
    msg := "SkillBarModCounter is " . SkillBarModCounter
    MsgBox, %msg%
    return


LabelNumpad1:
    switch SkillBarModCounter 
    {
        case 1:
            Remap("1")
        case 2:
            Remap("!")
        case 3:
            Remap("=")
    }
    return
LabelNumpad2:
    switch SkillBarModCounter 
    {
        case 1:
            Remap("2")
        case 2:
            Remap("?")
        case 3:
            Remap(":")
    }
    return
LabelNumpad3:
    switch SkillBarModCounter 
    {
        case 1:
            Remap("3")
        case 2:
            Remap("&")
        case 3:
            Remap("|")
    }
    Return
LabelNumpad4:
    switch SkillBarModCounter 
    {
        case 1:
            Remap("4")
        case 2:
            Remap("""") ; Parameter is "
        case 3:
            Remap("'")
    }
    Return
LabelNumpad5:
    switch SkillBarModCounter 
    {
        case 1:
            Remap("5")
        case 2:
            Remap("<")
        case 3:
            Remap(">")
    }
    Return
LabelNumpad6:
    switch SkillBarModCounter 
    {
        case 1:
            Remap("6")
        case 2:
            Remap("*")
        case 3:
            Remap("/")
    }
    Return
LabelNumpad7:
    switch SkillBarModCounter 
    {        
        case 1:
            Remap("7")
        case 2:
            Remap("(")
        case 3:
            Remap(")")
    }
    Return
LabelNumpad8:
    switch SkillBarModCounter 
    {
        case 1:
            Remap("8")
        case 2:
            Remap("[")
        case 3:
            Remap("]")
    }
    Return
LabelNumpad9:
    switch SkillBarModCounter 
    {
        case 1:
            Remap("9")
        case 2:
            Remap("{")
        case 3:
            Remap("}")
    }
    Return
LabelNumpadDot:
    switch SkillBarModCounter 
    {
        case 1:
            Remap(".")
        case 2:
            Remap("$")
        case 3:
            Remap("\")
    }
    Return

Remap(key)
{
    SendInput {%key%}
}
