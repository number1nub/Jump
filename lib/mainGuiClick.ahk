mainGuiClick(ctrlId, event) {
	if (event != "DoubleClick")
		return
	IniRead, dClickAction, %configFile%, GlobalSettings, DClickAction, Err
	dClickAction := dClickAction="E" ? "*edit " A_ScriptFullPath : "*edit " configFile
	run, % dClickAction
	ExitApp
}