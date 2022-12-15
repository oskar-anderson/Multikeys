class Hotkeys {

    static ActivateDebugHotkeys()
    {
        funcSuspend(ThisHotkey) { 
            MsgBox(A_ThisHotkey . " --- Suspend")
            Suspend()
        }
        funcReload(ThisHotkey) {
            MsgBox(A_ThisHotkey . " --- Reloaded" . ThisHotkey)
            Reload()
        }
        
        ; No lambda ???
        Hotkey("+Esc", funcSuspend)
        Hotkey("^r", funcReload)
    }


    static ActivateAllHotkeys(_keyMapping) 
    {
        Hotkeys.ActivateDebugHotkeys()
        Hotkeys.ActivateMainHotkeys(_keyMapping)
    }

    static ActivateMainHotkeys(_keyMapping) 
    {
        ; AHK HAS no null concept unfortunately so "" empty string is used
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
            {detect: "t", values: ["",    "]",     "&",    " "     ]}
        ]

        for k, v in labels {
            fnPrimaryHotkeys(ThisHotkey, bindArr) 
            {
                Send(_keyMapping.Remap(bindArr))
            }
            ; No lambda ???
            Hotkey(v.detect, fnPrimaryHotkeys.Bind(, v.values), _keyMapping.isSoftSupressed ? "Off" : "On")
        }


        for k, v in [
            { detect: "^1", value: "1"}, 
            { detect: "^2", value: "2"}, 
            { detect: "^3", value: "3"},
            { detect: "^4", value: "4"}
        ] {
            fnChangeProfile(ThisHotkey, bindValue) {
                if (_keyMapping.profile != bindValue) {
                    _keyMapping.isSoftSupressed := bindValue == 1
                    _keyMapping.ChangeProfile(bindValue)
                    Hotkeys.ActivateMainHotkeys(_keyMapping)
                    return
                }
            }
            Hotkey(v.detect, fnChangeProfile.Bind(, v.value))

        }
    }
}