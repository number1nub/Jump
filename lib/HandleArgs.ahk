HandleArgs() {
	loop %0%
		paramList .= (paramList ? " " : "") %a_index%
	p := params(paramList)
	if (p.Set || p.S || p.Settings) {
		try run, %  "*edit " settings.cfgPath
		catch e
			m("Jump Launcher, Unable to open the settings file...", "ico:!")
		ExitApp
	}
}