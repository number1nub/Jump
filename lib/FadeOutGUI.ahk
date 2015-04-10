FadeOutGUI() {
	if (settings.FadeOnExit) {
		Y:=0
		while(Y>(0-height)) {
			Y:=Y-settings.FadeSpeed
			Gui, Show, y%Y% NoActivate
			sleep 20
		}
	}
	ExitApp
}