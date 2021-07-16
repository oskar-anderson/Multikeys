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

global skillBarModCounter := 1
global skillBarOneTimeInputModCounter := -1
global skillBarModDebug := false
global isSoftSuspended := false
global IS_DEBUG_MODE := false

ActivateDebugHotkeys()
ActivateAllHotkeys(False)

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

ActivateAllHotkeys(isDisable = False) 
{
    Hotkey, F9, LabelSoftSuspend
    ActivateMainHotkeys(isDisable) 
    return
}

ActivateMainHotkeys(isDisable = False) 
{
    state := isDisable ? "Off" : "On"
    Hotkey, ^1, LabelChangeBarTo1Perm, %state%
    Hotkey, ^2, LabelChangeBarTo2Perm, %state%
    Hotkey, ^3, LabelChangeBarTo3Perm, %state%
    Hotkey, ^4, LabelChangeBarToDebug, %state%

    Hotkey, +1, LabelChangeBarTo1Tmp, %state%
    Hotkey, +2, LabelChangeBarTo2Tmp, %state%
    Hotkey, +3, LabelChangeBarTo3Tmp, %state%

    Hotkey, Numpad1, LabelNumpad1, %state%
    Hotkey, Numpad2, LabelNumpad2, %state%
    Hotkey, Numpad3, LabelNumpad3, %state%
    Hotkey, Numpad4, LabelNumpad4, %state%
    Hotkey, Numpad5, LabelNumpad5, %state%
    Hotkey, Numpad6, LabelNumpad6, %state%
    Hotkey, Numpad7, LabelNumpad7, %state%
    Hotkey, Numpad8, LabelNumpad8, %state%
    Hotkey, Numpad9, LabelNumpad9, %state%
    Hotkey, NumpadDot, LabelNumpadDot, %state%
    
    return
}
; ########################
; ######   LABELS   ######
; ########################

LabelChangeBarTo1Perm:
    new KeyMapping().FunctionChangeBarToPerm(1)
    return
LabelChangeBarTo2Perm:
    new KeyMapping().FunctionChangeBarToPerm(2)
    return
LabelChangeBarTo3Perm:
    new KeyMapping().FunctionChangeBarToPerm(3)
    return
LabelChangeBarToDebug:
    new KeyMapping().FunctionChangeBarToDebug()
    return

class KeyMapping {
    FunctionChangeBarToDebug() {
        global skillBarModDebug
        msg := "Debug"
        MsgBox, %msg%
        skillBarModDebug := true
    }

    FunctionChangeBarToPerm(skill) {
        global skillBarModCounter
        global skillBarModDebug
        skillBarModCounter := skill
        skillBarModDebug := false
        return
    }

    FunctionChangeBarToTmp(skill) {
        global skillBarOneTimeInputModCounter
        global skillBarModDebug
        global IS_DEBUG_MODE
        skillBarModDebug := false
        skillBarOneTimeInputModCounter := skill
        if (IS_DEBUG_MODE) {  ; ahk does not like oneline -- if (condition) return
            msg := "LabelChangeBarToTmp skillBarOneTimeInputModCounter is " . skillBarOneTimeInputModCounter
            MsgBox, %msg%
        }
        return
    }

    FunctionSoftSuspend() {
        global isSoftSuspended

        isSoftSuspended := !isSoftSuspended
        ActivateMainHotkeys(isSoftSuspended)
        msgs := "isSoftSuspended: " . isSoftSuspended
        MsgBox, %msgs%
        return
    }

}


LabelChangeBarTo1Tmp:
    new KeyMapping().FunctionChangeBarToTmp(1)
    return

LabelChangeBarTo2Tmp:
    new KeyMapping().FunctionChangeBarToTmp(2)
    return

LabelChangeBarTo3Tmp:
    new KeyMapping().FunctionChangeBarToTmp(3)
    return

LabelSoftSuspend:
    new KeyMapping().FunctionSoftSuspend()
    return

LabelNumpad1:
    Remap(["1", "!", "="])   ; "!"" is funky - calls LabelChangeBarTo1Tmp because ! = shift + 1
    return
LabelNumpad2:
    Remap(["2", "?", ":"])
    return
LabelNumpad3:
    Remap(["3", "&", "|"])
    return
LabelNumpad4:
    Remap(["4", """", "'"])   ; "" is ", """" is funky - calls LabelChangeBarTo2Tmp because " = shift + 2
    return
LabelNumpad5:
    Remap(["5", "<", ">"])
    return
LabelNumpad6:
    Remap(["6", "*", "/"])
    return
LabelNumpad7:
    Remap(["7", "(", ")"])
    return
LabelNumpad8:
    Remap(["8", "[", "]"])
    return
LabelNumpad9:
    Remap(["9", "{", "}"])
    return

LabelNumpadDot:
    Remap([".", "$", "\"])
    return


Remap(keyarr)
{
    global skillBarOneTimeInputModCounter
    global skillBarModCounter
    global IS_DEBUG_MODE
    if (skillBarModDebug) {
        ; SendInput {!}
        return
    }
    sendVal := ""
    if (skillBarOneTimeInputModCounter != -1) {
        sendVal := keyarr[skillBarOneTimeInputModCounter]
        if (IS_DEBUG_MODE) {
            msg := "skillBarOneTimeInputModCounter: " . skillBarOneTimeInputModCounter
            MsgBox, %msg%
        }
        skillBarOneTimeInputModCounter := -1
    } else {
        sendVal := keyarr[skillBarModCounter]
    }
    
    if (IS_DEBUG_MODE) {
        msg := "sendVal is " . sendVal
        MsgBox, %msg%
    }
    SendInput {%sendVal%}

    return
}
