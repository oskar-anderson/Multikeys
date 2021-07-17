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
; Git updated user.email test

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

global gKeyMappingInstance := new KeyMapping()
global IS_DEBUG_MODE := false

Programm.Main()
return


class Programm {
    Main(){
        this.ActivateDebugHotkeys()
        this.ActivateAllHotkeys(False)
    }

    ActivateDebugHotkeys()
    {
        Hotkey, +Esc, LabelSuspend
        Hotkey, ^r, LabelReload
        return
    }


    ActivateAllHotkeys(isDisable = False) 
    {
        Hotkey, F9, LabelSoftSuspend
        this.ActivateMainHotkeys(isDisable) 
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
}

class KeyMapping {
    __New() {
        this.skillBarModCounter := 1
        this.skillBarOneTimeInputModCounter := -1
        this.skillBarModDebug := false
        this.isSoftSuspended := false
    }

    FunctionChangeBarToDebug() {
        msg := "Debug"
        MsgBox, %msg%
        this.skillBarModDebug := true
    }

    FunctionChangeBarToPerm(skill) {
        this.skillBarModCounter := skill
        this.skillBarModDebug := false
        return
    }

    FunctionChangeBarToTmp(skill) {
        global IS_DEBUG_MODE
        this.skillBarModDebug := false
        this.skillBarOneTimeInputModCounter := skill
        if (IS_DEBUG_MODE) {  ; ahk does not like oneline -- if (condition) return
            msg := "LabelChangeBarToTmp this.skillBarOneTimeInputModCounter is " . this.skillBarOneTimeInputModCounter
            MsgBox, %msg%
        }
        return
    }

    FunctionSoftSuspend() {
        this.isSoftSuspended := !this.isSoftSuspended
        Programm.ActivateMainHotkeys(this.isSoftSuspended)
        msgs := "this.isSoftSuspended: " . this.isSoftSuspended
        MsgBox, %msgs%
        return
    }

    Remap(keyarr) 
    {
        global IS_DEBUG_MODE
        if (this.skillBarModDebug) {    ; Testing
            SendInput {!}               ; This does not work, check LabelNumpad1
            return
        }
        sendVal := ""
        if (this.skillBarOneTimeInputModCounter != -1) {
            sendVal := keyarr[this.skillBarOneTimeInputModCounter]
            if (IS_DEBUG_MODE) {
                msg := "this.skillBarOneTimeInputModCounter: " . this.skillBarOneTimeInputModCounter
                MsgBox, %msg%
            }
            this.skillBarOneTimeInputModCounter := -1
        } else {
            sendVal := keyarr[this.skillBarModCounter]
        }
        
        if (IS_DEBUG_MODE) {
            msg := "sendVal is " . sendVal
            MsgBox, %msg%
        }
        SendInput {%sendVal%}

        return
    }

}


; ########################
; ######   LABELS   ######
; ########################

; Debug
LabelSuspend:
    MsgBox %A_ThisHotkey% --- Suspend
    Suspend
    return
LabelReload:
    MsgBox %A_ThisHotkey%  --- Reloaded
    Reload
    return
LabelChangeBarToDebug:
    gKeyMappingInstance.FunctionChangeBarToDebug()
    return
; endDebug

LabelChangeBarTo1Perm:
    gKeyMappingInstance.FunctionChangeBarToPerm(1)
    return
LabelChangeBarTo2Perm:
    gKeyMappingInstance.FunctionChangeBarToPerm(2)
    return
LabelChangeBarTo3Perm:
    gKeyMappingInstance.FunctionChangeBarToPerm(3)
    return


LabelChangeBarTo1Tmp:
    gKeyMappingInstance.FunctionChangeBarToTmp(1)
    return

LabelChangeBarTo2Tmp:
    gKeyMappingInstance.FunctionChangeBarToTmp(2)
    return

LabelChangeBarTo3Tmp:
    gKeyMappingInstance.FunctionChangeBarToTmp(3)
    return

LabelSoftSuspend:
    gKeyMappingInstance.FunctionSoftSuspend()
    return

LabelNumpad1:
    gKeyMappingInstance.Remap(["1", "!", "="])   ; "!"" is funky - calls LabelChangeBarTo1Tmp because ! = shift + 1
    return
LabelNumpad2:
    gKeyMappingInstance.Remap(["2", "?", ":"])
    return
LabelNumpad3:
    gKeyMappingInstance.Remap(["3", "&", "|"])
    return
LabelNumpad4:
    gKeyMappingInstance.Remap(["4", """", "'"])   ; "" is ", """" is funky - calls LabelChangeBarTo2Tmp because " = shift + 2
    return
LabelNumpad5:
    gKeyMappingInstance.Remap(["5", "<", ">"])
    return
LabelNumpad6:
    gKeyMappingInstance.Remap(["6", "*", "/"])
    return
LabelNumpad7:
    gKeyMappingInstance.Remap(["7", "(", ")"])
    return
LabelNumpad8:
    gKeyMappingInstance.Remap(["8", "[", "]"])
    return
LabelNumpad9:
    gKeyMappingInstance.Remap(["9", "{", "}"])
    return

LabelNumpadDot:
    gKeyMappingInstance.Remap([".", "$", "\"])
    return
