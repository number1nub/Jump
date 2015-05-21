MainGuiClick(ctrlId, event) {
	if (event != "DoubleClick")
		return
	action := settings.DClickAction = "E" ? "*edit """ A_ScriptFullPath """"
			: settings.DClickAction = "R" ? A_ScriptFullPath
			: settings.DClickAction = "A" ? EditSettings("Jump Launcher", settings.cfgPath, 1, 1)
			: settings.DClickAction = "S" ? "*edit """ settings.cfgPath """"
			: ""
	Run, % action ? action : A_ScriptFullPath
	ExitApp
}