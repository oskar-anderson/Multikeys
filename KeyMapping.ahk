class KeyMapping {
    __New() {
        this.profile := 1
        this.isSoftSupressed := True
    }

    ChangeProfile(profile) {
        this.profile := profile
    }

    Remap(keyarr) 
    {
        sendVal := keyarr[this.profile]

        if (sendVal == "") {
            sendVal := GetKeyState("Capslock", "T") ? StrUpper(A_ThisHotkey) : A_ThisHotkey ; 1 if CapsLock is ON, 0 otherwise
        }
        
        ; MsgBox("sendVal is '" . sendVal . "', A_ThisHotkey: '" . A_ThisHotkey . "'")
        return sendVal
    }

}
