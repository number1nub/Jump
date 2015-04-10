FadeInGUI() {
	if (settings.FadeOnShow && settings.FadeSpeed > 0) {
		Gui, Show, y-50
		WinGetPos,,,,height, A
		Y := -height
		Gui, Show, xCenter y%Y% w%guiWidth%, %A_ScriptFullPath%
		while (Y < -settings.FadeSpeed) {
			Y := Y + settings.FadeSpeed
			Gui, Show, y%Y%
			sleep 20
		}
	}
	Gui, Show, y0 NoActivate
	gui, flash
	return WinExist()
}