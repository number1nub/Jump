GuiDropFiles(hwnd, files, ctlId) {
	IniRead, shortcut, %configFile%, shortcuts, %str%
	if (shortcut="ERROR") {
		if (str) {
			GuiControl,, MyText, ???
			sleep 400
		}
		ExitApp
	}
	Loop, parse, A_GuiEvent, `n
	{
		shortcut:=shortcutReplace(shortcut)		
		Run "%shortcut%" "%A_LoopField%"
		break
	}
	ExitApp
}