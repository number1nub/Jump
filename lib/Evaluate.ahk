Evaluate:
{
	if (!str) {		;Blank input --> Perform action specified by NoInputAction
		if (NoInputAction = "S")
			run, % "*edit " settings.cfgPath
		else if (NoInputAction = "E")
			run, % "*edit " A_ScriptFullPath
		else {
			IniRead, str, % settings.cfgPath, InternalSettings, LastTrigger, Err
			if (str = "Err") {
				SetTxt("???")
				sleep 400
				ExitApp
			}
		}
	}
	if (fromHistory) {
		origStr:=LastTrigger, str:=LastInputLabel, str.=LastInput
		if (str.Len > settings.limit) {
			if ((str.Len-LastInput.Len) < settings.limit)
				overFlowChars := str.Len-settings.limit
			else
				overFlowChars := LastInput.Len
			Loop, %overFlowChars%
				IncrementWidth()
		}
		SetTxt(str)
		lookup := SubStr(str, lookupLabel.Len+1)
	}
	else {
		IniRead, lookupLabel, % settings.cfgPath, lookups, %str%, ERROR
		origStr := str
		if (lookupLabel != "ERROR") {
			IniRead, lookupInput, % settings.cfgPath, lookupSettings, %str%_input, %A_Space%
			IniRead, lookupPath, % settings.cfgPath, lookupSettings, %str%_path, %A_Space%
			showLabel(lookupLabel)
		}
	}
	isURLinput := false
	if (lookupLabel != "ERROR") {	; Lookup
		if (lookup:=InputLookup(lookupLabel)) {
			historyExecute:
			position    := InStr(lookupInput, "[lookup]") - 1
			before      := SubStr(lookupInput, 1, position)
			position += 9
			after       := SubStr(lookupInput, position,999)
			lookupInput := shortcutReplace(before lookup after)
			if (!lookupPath) {
				lookupPath := settings.DefaultBrowser
				isURLinput := true
			}
			if lookupPath contains iexplore,chrome,firefox,www.,http://,.com,.net,.org
				isURLinput := true
			SplitPath, lookupPath,,workingDir,,,outDrive
			; Note that the "\" can't be included at the beginning of lookuppath in the ini file-- it must be added here
			if (!outDrive)
				workingDir := A_workingDir "\" workingDir
			lookupPath := shortcutReplace(lookupPath)
			; Handle encoding HTML characters for URLs
			if (isURLinput) {
				Transform, lookupInput, HTML, %lookupInput%
				StringReplace, lookupInput, lookupInput, #, `%23
			}
			LastInput := ""
			FromHistory := false
			IniWrite, %origStr%, % settings.cfgPath, InternalSettings, LastTrigger
			IniWrite, "%lookupLabel%", % settings.cfgPath, InternalSettings, LastLookupLabel
			IniWrite, %lookupInput%, % settings.cfgPath, InternalSettings, LastInput
			IniWrite, L, % settings.cfgPath, InternalSettings, LastType
			Run %lookupPath% `"%lookupInput%`"
		}
	}
	else {	; Shortcut
		IniRead, shortcut, % settings.cfgPath, shortcuts, %str%, ERROR
		if (shortcut="ERROR") {
			if (str) {
				SetTxt("???")
				sleep 400
			}
			ExitApp
		}
		IniRead, shortcutSettings, % settings.cfgPath, shortcutSettings, %str%, 0
		if (shortcutSettings) {
			cancelRun := false
			bp:="-bp", wa:="-wa", ie:="-ie", wd:="-wd"
			if InStr(shortcutSettings, bp) {
				IniRead, bPath, % settings.cfgPath, shortcutSettings, %str%_Browser, Err
				shortcut := (bPath = "Err" ? settings.DefaultBrowser : bPath) " " shortcut
			}
			if InStr(shortcutSettings, wa) {
				IniRead, title, % settings.cfgPath, shortcutSettings, %str%_title, Err
				if (title = "Err") {
					msgbox Error. No title specified for activating %shortcut%
					ExitApp
				}
				else {
					TTMbu := A_TitleMatchMode
					SetTitleMatchMode, RegEx
					IfWinExist, i)%title%
					{
						WinActivate
						cancelRun := true
					}
					SetTitleMatchMode, %TTMbu%
				}
			}
			if InStr(shortcutSettings, ie) {
				If !FileExist(shortcut := shortcutReplace(shortcut)) {
					cancelRun := true
					msgbox This path does not exist:`r%shortcut%
				}
			}
			if InStr(shortcutSettings, wd) {
				IniRead, workingDir, % settings.cfgPath, shortcutSettings, %str%_WorkingDir
				if (workingDir = "ERROR")	;choose WorkingDir automoatically. This does not work if you use parameters.
					SplitPath, shortcut, ,workingDir
				shortcut := shortcutReplace(shortcut)
				Run, %shortcut%, %workingDir%
				cancelRun := true
			}
		}
		if (!cancelRun) {
			shortcut := shortcutReplace(shortcut)
			run, %shortcut%
		}
		IniWrite, %str%, % settings.cfgPath, InternalSettings, LastTrigger
		IniWrite, % "", % settings.cfgPath, InternalSettings, LastLookupLabel
		IniWrite, % "", % settings.cfgPath, InternalSettings, LastInput
		IniWrite, S, % settings.cfgPath, InternalSettings, LastType
	}
	ExitApp
}