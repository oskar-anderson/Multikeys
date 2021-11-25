#Warn  ; Enable warnings to assist with detecting common errors.
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

#UseHook ; is necessary if the script uses the Send command to send the keys that comprise the hotkey itself

; --------------------------------------------------------------------------------------------------------------------
; This autohotkey script loops/repeats keypresses when holding down a key. Also with modifers!

; This script loops numbers 0-9 with Shift, Ctrl, Alt modifers
; Also loops letters q, e, r, t, f, g, z, x, c, v with Shift, Ctrl, Alt modifiers

; Example: 1, Shift+1, Ctrl+1, Alt+1
; Example: q, Shift+q, Ctrl+q, Alt+q

; Below are key modifers that we put before a number or letter
; + = Shift, ^ = Ctrl, ! = Alt

; Will only do comments the first number and modifer to get an idea of what it does
; ---------------------------------------------------------------------------------------------------------------------
keyList := "0,1,2,3,4,5,6,7,8,9"                     ; Numbers 0 - 9
		. ",q,e,r,t,f,g,z,x,c,v"                     ; Letters q, e, r, t, f, g, z, x, c, v   
	   
Loop Parse keyList, "CSV"
{
	key := 				  A_LoopField
	ctrlPlusKey := 	"^" . A_LoopField
	altPlusKey := 	"!" . A_LoopField
	shiftPlusKey := "+" . A_LoopField

	Hotkey key, 			spamKey
	Hotkey ctrlPlusKey, 	spamKey
	Hotkey altPlusKey, 		spamKey
	Hotkey shiftPlusKey, 	spamKey
}
; ---------------------------------------------------------------------------------------------------------------------

spamKey(ThisHotkey) {
	checkKey := RegExReplace(A_ThisHotkey, "[*^!+]")
	While(GetKeyState(checkKey, "P"))                       ; Starts the loop script below
	{
		Send A_ThisHotkey                  					; Sends and repeats the hotkey
		sleep 30                             				; How fast it repeats the keypress in milliseconds
	}
	return
}

+Esc::Suspend  ; Suspend hotkeys