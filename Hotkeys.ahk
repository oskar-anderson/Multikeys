class Hotkeys {

    ActivateDebugHotkeys()
    {
        fnSuspend(ThisHotkey) { 
            MsgBox(A_ThisHotkey . " --- Suspend")
            Suspend()
        }


        Hotkey("+Esc", fnSuspend)
        v := CallbackActionInsideClassOutSideFunctionNotCallingHack.Bind(, this.fnReload)
        Hotkey("^r", v)
        return
    }

    fnReload(ThisHotkey) { 
        MsgBox(A_ThisHotkey . " --- Reloaded" . ThisHotkey)
        Reload()
    }


    ActivateAllHotkeys(_keyMapping) 
    {
        fnSoftSuspend(ThisHotkey) { 
            _keyMapping.FunctionSoftSuspend()
        }
        Hotkey("F9", fnSoftSuspend)
        this.ActivateMainHotkeys(_keyMapping)
        return
    }

    ActivateMainHotkeys(_keyMapping) 
    {
        activate := _keyMapping.isSoftSuspended ? "Off" : "On"
        
        ; A_ThisHotkey does not work here
        labels := [
            {detect: "x", values: ["x",    "{!}",   "?",    "└"     ]},
            {detect: "c", values: ["c",    "=",     " ",    "┴"     ]},
            {detect: "v", values: ["v",    "+",     "*",    "┘"     ]},
            {detect: "b", values: ["b",    "-",     ":",    "│"     ]},
            {detect: "s", values: ["s",    "<",     "`"",   "├"     ]},  ; IDE hightlighting fails here
            {detect: "d", values: ["d",    ">",     "'",    "┼"     ]},
            {detect: "f", values: ["f",    "{{}",   "``",   "┤"     ]},
            {detect: "g", values: ["g",    "{}}",   " ",    "─"     ]},
            {detect: "w", values: ["w",    "(",     "/",    "┌"     ]},
            {detect: "e", values: ["e",    ")",     "|",    "┬"     ]},
            {detect: "r", values: ["r",    "[",     "\",    "┐"     ]},
            {detect: "t", values: ["t",    "]",     "&",     " "    ]}
        ]

        for k, v in labels {
            fnPrimaryHotkeys(ThisHotkey, bindArr) 
            {
                 ; FROM DOCS: Note: Even if defined inside the loop body, a nested function which refers to a loop variable cannot see or change the current iteration's value. Instead, pass the variable explicitly or bind its value to a parameter.
                SendInput(_keyMapping.Remap(bindArr))
            }
            Hotkey(v.detect, fnPrimaryHotkeys.Bind(, v.values), activate)
        }


        for k, v in [
            {detectTmp: "F1 & 1", detectPerm: "^1", value: "1"}, 
            {detectTmp: "F1 & 2", detectPerm: "^2", value: "2"}, 
            {detectTmp: "F1 & 3", detectPerm: "^3", value: "3"},
            {detectTmp: "F1 & 4", detectPerm: "^4", value: "4"}
            ] {
            fnChangeBarToTmp(ThisHotkey, bindValue) { 
                _keyMapping.FunctionChangeBarToTmp(bindValue)
            }
            fnChangeBarToPerm(ThisHotkey, bindValue) {
                _keyMapping.FunctionChangeBarToPerm(bindValue)
            }
            Hotkey(v.detectTmp, fnChangeBarToTmp.Bind(, v.value), activate)
            Hotkey(v.detectPerm, fnChangeBarToPerm.Bind(, v.value), activate)

        }

        return
    }
}