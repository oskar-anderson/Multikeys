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

InstallKeybdHook(Install := true, Force := false)
#Warn  ; Enable warnings to assist with detecting common errors.
#InputLevel 1  ; Prevent remapping chains

SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

; Alt key is        !
; Windows key is    #
; Shift key is      +
; Control key is    ^

SetCapsLockState "AlwaysOff" ; (CapsLock) or (Shift + CapsLock) will not turn on CapsLock


; Debug
LabelSuspend(ThisHotkey) { 
    MsgBox A_ThisHotkey . " --- Suspend"
    Suspend
    return
}

LabelReload(ThisHotkey) { 
    MsgBox A_ThisHotkey . " --- Reloaded"
    Reload
    return
}

LabelChangeBarToDebug(ThisHotkey) { 
    gKeyMappingInstance.FunctionChangeBarToDebug()
    return
}
; endDebug

LabelChangeBarTo1Perm(ThisHotkey) { 
    gKeyMappingInstance.FunctionChangeBarToPerm(1)
    return
}

LabelChangeBarTo2Perm(ThisHotkey) { 
    gKeyMappingInstance.FunctionChangeBarToPerm(2)
    return
}

LabelChangeBarTo3Perm(ThisHotkey) { 
    gKeyMappingInstance.FunctionChangeBarToPerm(3)
    return
}


LabelChangeBarTo1Tmp(ThisHotkey) { 
    gKeyMappingInstance.FunctionChangeBarToTmp(1)
    return
}

LabelChangeBarTo2Tmp(ThisHotkey) { 
    gKeyMappingInstance.FunctionChangeBarToTmp(2)
    return
}

LabelChangeBarTo3Tmp(ThisHotkey) { 
    gKeyMappingInstance.FunctionChangeBarToTmp(3)
    return
}

LabelSoftSuspend(ThisHotkey) { 
    gKeyMappingInstance.FunctionSoftSuspend()
    return
}

Label1(ThisHotkey) { 
    SendInput gKeyMappingInstance.Remap([A_ThisHotkey, "{!}", "="])
    return
}


Label2(ThisHotkey) { 
    SendInput gKeyMappingInstance.Remap([A_ThisHotkey, "?", ":"])
    return
}

Label3(ThisHotkey) { 
    SendInput gKeyMappingInstance.Remap([A_ThisHotkey, "&", "|"])
    return
}

Label4(ThisHotkey) { 
    SendInput gKeyMappingInstance.Remap([A_ThisHotkey, "`"", "'"])  ; syntax highlighting does not seem to understand escaped double quote mark
    return
}

Label5(ThisHotkey) { 
    SendInput gKeyMappingInstance.Remap([A_ThisHotkey, "<", ">"])
    return
}

Label6(ThisHotkey) { 
    SendInput gKeyMappingInstance.Remap([A_ThisHotkey, "*", "/"])
    return
}

Label7(ThisHotkey) { 
    SendInput gKeyMappingInstance.Remap([A_ThisHotkey, "(", ")"])
    return
}

Label8(ThisHotkey) { 
    SendInput gKeyMappingInstance.Remap([A_ThisHotkey, "[", "]"])
    return
}

Label9(ThisHotkey) { 
    SendInput gKeyMappingInstance.Remap([A_ThisHotkey, "{{}", "{}}"])
    return
}

Label10(ThisHotkey) { 
    SendInput gKeyMappingInstance.Remap([A_ThisHotkey, "{!}", "="])
    return
}


class KeyMapping {
    __New() {
        this.skillBarModCounter := 1
        this.skillBarOneTimeInputModCounter := -1
        this.skillBarModDebug := false
        this.isSoftSuspended := false
    }

    FunctionChangeBarToDebug() {
        MsgBox "Debug"
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
            MsgBox msg
        }
        return
    }

    FunctionSoftSuspend() {
        this.isSoftSuspended := !this.isSoftSuspended
        Programm.ActivateMainHotkeys(this.isSoftSuspended)
        msgs := "this.isSoftSuspended: " . this.isSoftSuspended
        MsgBox msgs
        return
    }

    Remap(keyarr) 
    {
        global IS_DEBUG_MODE
        sendVal := ""
        if (this.skillBarOneTimeInputModCounter != -1) {
            sendVal := keyarr[this.skillBarOneTimeInputModCounter]
            this.skillBarOneTimeInputModCounter := -1
        } else {
            sendVal := keyarr[this.skillBarModCounter]
        }
        
        if (IS_DEBUG_MODE) {
            msg := "sendVal is " . sendVal
            MsgBox msg
        }
        return sendVal
    }

}

class Programm {
    Main(){
        this.ActivateDebugHotkeys()
        this.ActivateAllHotkeys()
    }

    ActivateDebugHotkeys()
    {
        Hotkey "+Esc", LabelSuspend
        Hotkey "^r", LabelReload
        return
    }


    ActivateAllHotkeys() 
    {
        Hotkey "F9", LabelSoftSuspend
        this.ActivateMainHotkeys() 
        return
    }

    ActivateMainHotkeys() 
    {
        Hotkey "^1", LabelChangeBarTo1Perm
        Hotkey "^2", LabelChangeBarTo2Perm
        Hotkey "^3", LabelChangeBarTo3Perm
        Hotkey "^4", LabelChangeBarToDebug

        Hotkey "+1", LabelChangeBarTo1Tmp
        Hotkey "+2", LabelChangeBarTo2Tmp
        Hotkey "+3", LabelChangeBarTo3Tmp

        Hotkey "x", Label1
        Hotkey "c", Label2
        Hotkey "v", Label3
        Hotkey "s", Label4
        Hotkey "d", Label5
        Hotkey "f", Label6
        Hotkey "w", Label7
        Hotkey "e", Label8
        Hotkey "r", Label9
        Hotkey "b", Label10
        return
    }
}



global gKeyMappingInstance := KeyMapping()
global IS_DEBUG_MODE := true

Programm().Main()