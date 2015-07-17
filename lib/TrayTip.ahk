TrayTip(t*) {
	static Version, appName
	;auto_version
	
	txt := "Jump Launcher" (Version ? " v" Version : "") " is Running..."
	for c, v in t
		txt .= "`n" v
	Menu, Tray, Tip, % txt
}

tt(t*) {
	if (!t.MaxIndex()) {
		SetTimer, tt, Off
		ToolTip
		TrayTip
		return
	}
	tray:="", opt:="", time:="", icons:={"i":1, "!":2, "x":3}
	for c, v in t {		
		if (RegExMatch(v, "im)^(?:ttl|title:(?P<title>.+)|(?P<tray>tray:?)|ico:(?P<icon>x|\i|\!)|time:(?P<time>\d+(?:\.\d{1,2})?|\.\d{1,2}))$", m_))
			tray:=m_tray?1:tray, opt:=m_icon?m_icon:opt, ttl:=m_title?m_title:ttl, time:=m_time?m_time:time
		else
			txt .= (txt ? "`n" : "") v
	}
	if (tray || title || ico) {
		TrayTip, % ttl ? ttl : RegExReplace(A_ScriptName, "\.(?:ahk|exe)$"), % txt,, % opt
		if (time)
			SetTimer, tt, % Round(time*1000)
		return
	}
	Tooltip, % txt
	SetTimer, tt, % Round((time ? time : 2.5)*1000)
}