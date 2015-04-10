JumpMenu() {
	Menu, JumpMenu, Add
	Menu, JumpMenu, Delete
	Menu, JumpMenu, Add, Application Settings, jumpMenuCmd
	Menu, JumpMenu, Add, Edit Shortcuts, jumpMenuCmd
	Menu, JumpMenu, Add, Open Settings.ini, jumpMenuCmd
	Menu, JumpMenu, Color, %BackColor%
	Menu, JumpMenu, Show
	return
}
jumpMenuCmd() {
	if (A_ThisMenuItem="Application Settings") {
		EditSettings("Jump Launcher", configFile, 1, 1)
	}
	else if (A_ThisMenuItem="Open Settings.ini") {
		Run, *edit "%configFile%"
	}
	else if (A_ThisMenuItem="Edit Shortcuts") {
		if (FileExist("Config Edit.ahk"))
			Run, "Config Edit.ahk" "%configFile%"
		else {
			m("Missing shortcut editor addin...")
			Run, *edit "%configFile%"
		}
	}
}