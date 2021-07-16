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
global SkillBarOneTimeInputModIsActive := false
global SkillBarOneTimeInputModCounter := 1
global IsSoftSuspended := false
global SkillBarModDebug := false
global IsDebugMode := false

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
    Hotkey, ^1, LabelChangeBarTo1Perm
    Hotkey, ^2, LabelChangeBarTo2Perm
    Hotkey, ^3, LabelChangeBarTo3Perm
    Hotkey, ^4, LabelChangeBarToDebug

    Hotkey, +1, LabelChangeBarTo1Tmp
    Hotkey, +2, LabelChangeBarTo2Tmp
    Hotkey, +3, LabelChangeBarTo3Tmp

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

    Hotkey, F9, SoftSuspend
    
    return
}

LabelChangeBarTo1Perm:
    FunctionChangeBarToPerm(1)
    return
LabelChangeBarTo2Perm:
    FunctionChangeBarToPerm(2)
    return
LabelChangeBarTo3Perm:
    FunctionChangeBarToPerm(3)
    return
LabelChangeBarToDebug:
    FunctionChangeBarToDebug()
    return

FunctionChangeBarToDebug() {
    global IsSoftSuspended
    global SkillBarModDebug
    if (IsSoftSuspended) {
        return
    }
    msg := "Debug"
    MsgBox, %msg%
    SkillBarModDebug := true
}

FunctionChangeBarToPerm(skill) {
    global IsSoftSuspended
    global SkillBarModCounter
    global SkillBarModDebug
    if (IsSoftSuspended) { 
        return 
    }
    SkillBarModCounter := skill
    SkillBarModDebug := false
    return
}

LabelChangeBarTo1Tmp:
    FunctionChangeBarToTmp(1)
    return

LabelChangeBarTo2Tmp:
    FunctionChangeBarToTmp(2)
    return

LabelChangeBarTo3Tmp:
    FunctionChangeBarToTmp(3)
    return

FunctionChangeBarToTmp(skill) {
    global IsSoftSuspended
    global SkillBarOneTimeInputModIsActive
    global SkillBarOneTimeInputModCounter
    global SkillBarModDebug
    global IsDebugMode
    if (IsSoftSuspended) { ; ahk does nopt like oneline -- if (IsSoftSuspended) return
        return 
    }
    SkillBarModDebug := false
    SkillBarOneTimeInputModIsActive := true
    SkillBarOneTimeInputModCounter := skill
    if (IsDebugMode) {
        msg := "LabelChangeBarToTmp SkillBarModCounter is " . SkillBarOneTimeInputModCounter
        MsgBox, %msg%
    }
    return
}

SoftSuspend:
    IsSoftSuspended := !IsSoftSuspended
    return


LabelNumpad1:
    Remap(["1", "!", "="])   ; "!"" is funky - calls LabelChangeBarTo1Tmp
    Return
LabelNumpad2:
    Remap(["2", "?", ":"])
    Return
LabelNumpad3:
    Remap(["3", "&", "|"])
    Return
LabelNumpad4:
    Remap(["4", """", "'"])   ; "" is ", """" is funky - calls LabelChangeBarTo2Tmp
    Return
LabelNumpad5:
    Remap(["5", "<", ">"])
    Return
LabelNumpad6:
    Remap(["6", "*", "/"])
    Return
LabelNumpad7:
    Remap(["7", "(", ")"])
    Return
LabelNumpad8:
    Remap(["8", "[", "]"])
    Return
LabelNumpad9:
    Remap(["9", "{", "}"])
    Return

LabelNumpadDot:
    Remap([".", "$", "\"])
    Return


Remap(keyarr)
{
    global IsDebugMode
    if (IsSoftSuspended) {
        SendInput %A_ThisHotkey%
        return
    }
    if (SkillBarModDebug) {
        SendInput {!}
        return
    }
    sendVal := ""
    if (SkillBarOneTimeInputModIsActive) {
        sendVal := keyarr[SkillBarOneTimeInputModCounter]
        SkillBarOneTimeInputModIsActive := false
        if (IsDebugMode) {
            msgs := "SkillBarOneTimeInputModIsActive"
            MsgBox, %msgs%
        }
    } else {
        sendVal := keyarr[SkillBarModCounter]
    }
    
    if (IsDebugMode) {
        msgs := "sendVal is " . sendVal
        MsgBox, %msgs%
    }
    SendInput {%sendVal%}

    return
}
