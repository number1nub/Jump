MenuAction() {
	if (A_ThisMenuItem = "Application Settings") {
		EditSettings("Jump Launcher", settings.cfgPath, 1, 1)
		Run, % A_ScriptFullPath
		ExitApp
	}
	else if (A_ThisMenuItem = "Open the User Settings File") {
		Run, % "*edit " settings.cfgPath
		ExitApp
	}
	else if (A_ThisMenuItem = "Quick Shortcut Editor") {
		if (FileExist("Config Edit.ahk"))
			Run, % """Config Edit.ahk"" """ settings.cfgPath """"
		else {
			m("Missing shortcut editor addin...")
			Run, % "*edit " settings.cfgPath
		}
	}
}