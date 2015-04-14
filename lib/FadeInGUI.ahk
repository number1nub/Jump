FadeInGUI() {
	if (settings.FadeOnShow) {
		Gui, Show, y-50
		WinGetPos,,,, height, A
		Y := -height
		Gui, Show, % "xCenter y" Y " w" settings.guiWidth, % settings.Title
		while (Y < -settings.FadeSpeed) {
			Y += settings.FadeSpeed
			Gui, Show, y%Y%
			sleep 20
		}
	}
	Gui, Show, y0 NoActivate
	gui, flash
	return WinExist()
}