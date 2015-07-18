TrayMenu() {
	Menu, DefaultAHK, Standard
	Menu, Tray, NoStandard
	
	Menu, Tray, Add, Application Settings, MenuAction
	Menu, Tray, Add, Open Settings.ini File, MenuAction
	if (!A_IsCompiled) {
		Menu, Tray, Add
		Menu, Tray, Add, Default AHK Menu, :DefaultAHK
	}
	Menu, Tray, Add
	Menu, Tray, Add, Exit
	Menu, Tray, Default, % settings.DClickAction="A" ? "Application Settings" : "Open Settings.ini File"
	
	if (A_IsCompiled)
		Menu, Tray, Icon, % A_ScriptFullpath, -159
	else
		Menu, Tray, Icon, % FileExist(ico:=A_ScriptDir "\Jump.ico") ? ico : ""
	
	TrayTip()
}