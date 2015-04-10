FadeOutGUI() {
	if (FadeOnExit) {
		Y:=0
		while(Y>(0-height)) {
			Y:=Y-FadeSpeed
			Gui, Show, y%Y% NoActivate
			sleep 20
		}
	}
	ExitApp
}