HandleArgs() {
	if (%0% = 0)
		return m("No args")
	Loop %0%
		argStr .= " " %A_Index%
	p := Args(argStr)
	if (p.Set || p.S || p.Settings) {
		try
			Run, %  "*edit """ settings.cfgPath """"
		catch e
			m("Jump Launcher, Unable to open the settings file...", "ico:!")
		ExitApp
	}
}