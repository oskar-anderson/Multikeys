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
SetCapsLockState "AlwaysOff" ; (CapsLock) or (Shift + CapsLock) will not turn on CapsLock

; Alt key is        !
; Windows key is    #
; Shift key is      +
; Control key is    ^




class KeyMapping {
    __New() {
        this.skillBarModCounter := 1
        this.skillBarOneTimeInputModCounter := -1
        this.isSoftSuspended := false
    }

    FunctionChangeBarToPerm(skill) {
        this.skillBarModCounter := skill
        return
    }

    FunctionChangeBarToTmp(skill) {
        this.skillBarOneTimeInputModCounter := skill
        ; MsgBox "LabelChangeBarToTmp this.skillBarOneTimeInputModCounter is " . this.skillBarOneTimeInputModCounter
        return
    }

    FunctionSoftSuspend() {
        this.isSoftSuspended := !this.isSoftSuspended
        Hotkeys.ActivateMainHotkeys(this)
        msgs := "this.isSoftSuspended: " . this.isSoftSuspended
        MsgBox msgs
        return
    }

    Remap(keyarr) 
    {
        sendVal := ""
        if (this.skillBarOneTimeInputModCounter != -1) {
            sendVal := keyarr[this.skillBarOneTimeInputModCounter]
            this.skillBarOneTimeInputModCounter := -1
        } else {
            sendVal := keyarr[this.skillBarModCounter]
        }
        
        ; MsgBox "sendVal is " . sendVal
        return sendVal
    }

}

class Hotkeys {
    static ActivateDebugHotkeys()
    {
        fnSuspend(ThisHotkey) { 
            MsgBox A_ThisHotkey . " --- Suspend"
            Suspend
        }

        fnReload(ThisHotkey) { 
            MsgBox A_ThisHotkey . " --- Reloaded"
            Reload
        }   
        Hotkey "+Esc", fnSuspend
        Hotkey "^r", fnReload
        return
    }


    static ActivateAllHotkeys(_keyMapping) 
    {
        fnSoftSuspend(ThisHotkey) { 
            _keyMapping.FunctionSoftSuspend()
        }
        Hotkey "F9", fnSoftSuspend
        this.ActivateMainHotkeys(_keyMapping)
        return
    }

    static ActivateMainHotkeys(_keyMapping) 
    {
        activate := _keyMapping.isSoftSuspended ? "Off" : "On"

        ; A_ThisHotkey does not work here
        labels := [
            {detect: "x", values: ["x",    "{!}",   "="    ]},
            {detect: "c", values: ["c",    "?",     ":"    ]},
            {detect: "v", values: ["v",    "&",     "|"    ]},
            {detect: "s", values: ["s",    "`"",    "'"    ]},  ; IDE hightlighting fails here
            {detect: "d", values: ["d",    "<",     ">"    ]},
            {detect: "f", values: ["f",    "*",     "/"    ]},
            {detect: "w", values: ["w",    "(",     ")"    ]},
            {detect: "e", values: ["e",    "[",     "]"    ]},
            {detect: "r", values: ["r",    "{{}",   "{}}"  ]},
            {detect: "b", values: ["b",    "{!}",   "="    ]}
        ]

        for k, v in labels {
            fnPrimaryHotkeys(ThisHotkey, bindArr) 
            {
                 ; FROM DOCS: Note: Even if defined inside the loop body, a nested function which refers to a loop variable cannot see or change the current iteration's value. Instead, pass the variable explicitly or bind its value to a parameter.
                SendInput _keyMapping.Remap(bindArr)
            }
            Hotkey v.detect, fnPrimaryHotkeys.Bind(, v.values), activate
        }


        for k, v in [
            {detectTmp: "+1", detectPerm: "^1", value: "1"}, 
            {detectTmp: "+2", detectPerm: "^2", value: "2"}, 
            {detectTmp: "+3", detectPerm: "^3", value: "3"}
            ] {
            fnChangeBarToTmp(ThisHotkey, bindValue) { 
                _keyMapping.FunctionChangeBarToTmp(bindValue)
            }
            fnChangeBarToPerm(ThisHotkey, bindValue) {
                _keyMapping.FunctionChangeBarToPerm(bindValue)
            }
            Hotkey v.detectTmp, fnChangeBarToTmp.Bind(, v.value), activate
            Hotkey v.detectPerm, fnChangeBarToPerm.Bind(, v.value), activate

        }

        return
    }
}

class Programm {
    Main(){
        _keyMapping := KeyMapping()
        Hotkeys.ActivateDebugHotkeys()
        Hotkeys.ActivateAllHotkeys(_keyMapping)
    }
}



Programm().Main()