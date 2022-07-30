/*

Notes:
-shift turns numlock off

│─
┌┴┐
┤┼├
└┬┘
*/

InstallKeybdHook(Install := true, Force := false)
#Warn  ; Enable warnings to assist with detecting common errors.
#InputLevel 1  ; Prevent remapping chains
#SingleInstance Force  ; Running the script forces older insance of the same script to be overridden

SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
; SetCapsLockState("AlwaysOff") ; (CapsLock) or (Shift + CapsLock) will not turn on CapsLock

; Alt key is        !
; Windows key is    #
; Shift key is      +
; Control key is    ^




#include "KeyMapping.ahk"
#include "Hotkeys.ahk"

class Programm {
    Main(){
        _keyMapping := KeyMapping()
        _hotkeys := Hotkeys()
        _hotkeys.ActivateDebugHotkeys()
        Hotkeys.ActivateAllHotkeys(_keyMapping)

        ; TESTING:
        ; Programm.fnMsgStatic()
        ; this.fnMsgInstance()
    }

    static fnMsgStatic() {  ; cannot find any info on static functions, but they seem to exist
        MsgBox("Hello from static")
    }
    fnMsgInstance() {
        MsgBox("Hello instance method")
    }
}

Programm().Main()