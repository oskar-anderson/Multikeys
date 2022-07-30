class Hotkeys {

    GetFuncReload() {
        ; I am not sure why the function delegate cannot be defined directly
        f(ThisHotkey) {
            MsgBox(A_ThisHotkey . " --- Reloaded" . ThisHotkey)
            Reload()
        }
        return f
    }

    ActivateDebugHotkeys()
    {
        funcSuspend(ThisHotkey) { 
            MsgBox(A_ThisHotkey . " --- Suspend")
            Suspend()
        }


        Hotkey("+Esc", funcSuspend)
        Hotkey("^r", this.GetFuncReload())
        return
    }


    static ActivateAllHotkeys(_keyMapping) 
    {
        fnSoftSuspend(ThisHotkey) { 
            _keyMapping.FunctionSoftSuspend()
        }
        Hotkey("F9", fnSoftSuspend)
        Hotkeys.ActivateMainHotkeys(_keyMapping)
        return
    }

    static ActivateMainHotkeys(_keyMapping) 
    {
        activate := _keyMapping.isSoftSuspended ? "Off" : "On"
        
        ; A_ThisHotkey does not work here
        ; AHK HAS no null concept unfortunately
        labels := [
            {detect: "x", values: ["",    "{!}",   "?",    "└"     ]},
            {detect: "c", values: ["",    "=",     " ",    "┴"     ]},
            {detect: "v", values: ["",    "{+}",   "*",    "┘"     ]},
            {detect: "b", values: ["",    "-",     ":",    "│"     ]},
            {detect: "s", values: ["",    "<",     "`"",   "├"     ]},  ; IDE hightlighting fails here
            {detect: "d", values: ["",    ">",     "'",    "┼"     ]},
            {detect: "f", values: ["",    "{{}",   "``",   "┤"     ]},
            {detect: "g", values: ["",    "{}}",   " ",    "─"     ]},
            {detect: "w", values: ["",    "(",     "/",    "┌"     ]},
            {detect: "e", values: ["",    ")",     "|",    "┬"     ]},
            {detect: "r", values: ["",    "[",     "\",    "┐"     ]},
            {detect: "t", values: ["",    "]",     "&",     " "    ]}
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