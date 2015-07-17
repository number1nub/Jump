FadeInGUI(instant:="") {
	Gui, Margin, 0, 5
	Gui, Color, % settings.BackColor
	Gui, Font, % "s11 w550 c" settings.TextColor, % settings.Font
	Gui +LastFound +AlwaysOnTop -Caption +ToolWindow +Border +hwndhwnd
	
	Gui, Add, Text, % "w550 gmainGuiClick center hwndInputHwnd vInputTxt c" settings.TextColor " w" settings.guiWidth,
	Winset, Transparent, % settings.Transparency
	
	if (settings.FadeOnShow && !instant) {
		Gui, Show, y-50
		WinGetPos,,,, height
		Y := -height
		Gui, Show, % "xCenter y" Y " w" settings.guiWidth
		while (Y < -settings.FadeSpeed) {
			Y += settings.FadeSpeed
			Gui, Show, y%Y%
			sleep 20
		}
	}
	Gui, Show, y0 NA, Jump Launcher
	Gui, Flash
	return hwnd
}