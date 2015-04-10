mainGuiClick(ctrlId, event) {
	if (event != "DoubleClick")
		return
	
	action := settings.DClickAction = "E" ? "*edit " A_ScriptFullPath
			: settings.DClickAction = "R" ? A_ScriptFullPath 
			: settings.DClickAction = "A" ? EditSettings("Jump Launcher", configFile, 1, 1)
			: "*edit " configFile
	run, % action ? action : A_ScriptFullPath
	ExitApp
}