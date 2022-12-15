/*

Notes:
-shift turns numlock off

│─
┌┴┐
┤┼├
└┬┘

Alt key is        !
Windows key is    #
Shift key is      +
Control key is    ^

*/

InstallKeybdHook(Install := true, Force := false)
#Warn  ; Enable warnings to assist with detecting common errors.
#InputLevel 1  ; Prevent remapping chains
#SingleInstance Force  ; Running the script forces older insance of the same script to be overridden

SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
; SetCapsLockState("AlwaysOff") ; (CapsLock) or (Shift + CapsLock) will not turn on CapsLock


#include "KeyMapping.ahk"
#include "Hotkeys.ahk"

class Programm {
    static Main(){
        ; have to prepend _, otherwise "local variable has the same name as a global variable" error
        _keyMapping := KeyMapping()
        Hotkeys.ActivateAllHotkeys(_keyMapping)
    }
}

; SetKeyDelay(1000) ; does not work in SendMode("Input")
Programm.Main()