CreateConfig() {
	try {
		if (A_IsCompiled)
			FileInstall, Template.ini, % settings.cfgDir
		else {
			FileRead, tmp, Template.ini
			if (!FileExist(settings.cfgDir))
				FileCreateDir, % settings.cfgDir
			FileAppend, %tmp%, % settings.cfgPath
		}
	}
	catch e {
		m("Error creating config file...", "Error: " e.message "`n`nDuring: " e.what "`n`nExitting app...", "ico:!")
		ExitApp
	}
}