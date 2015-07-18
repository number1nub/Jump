TrayTip(t*) {
	static Version, appName
	;auto_version
	
	txt := "Jump Launcher" (Version ? " v" Version : "") " is Running..."
	for c, v in t
		txt .= "`n" v
	Menu, Tray, Tip, % txt
}