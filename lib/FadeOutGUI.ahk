FadeOutGUI(reload:="") {
	if (settings.FadeOnExit) {
		WinGetPos,,,, height, ahk_id %WinID%
		Y := 0
		while(Y > (0-height)) {
			Y := Y - settings.FadeSpeed
			Gui, Show, y%Y% NoActivate
			sleep 20
		}
	}
	if (!reload)
		ExitApp
}