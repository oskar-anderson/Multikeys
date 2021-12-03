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
        MsgBox(msgs)
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
        
        ; MsgBox("sendVal is " . sendVal)
        return sendVal
    }

}
