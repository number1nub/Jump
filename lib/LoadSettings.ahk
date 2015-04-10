LoadSettings() {
	initGuiWidth  := 96
	incPixPerChar := 8
	limit         := findLimit(initGuiWidth, incPixPerChar)
	guiWidth      := (incPixPerChar*2) + initGuiWidth
	breakLoop     := false
	settingList   := {DefaultBrowser:"iexplore.exe"
					, FadeOnShow:"1"
					, FadeOnExit:"1"
					, FadeSpeed:"2"
					, Transparency:"210"
					, BackColor:"Black"
					, TextColor:"Aqua"
					, Font:"Arial"
					, DClickAction:"S"
					, NoInputAction:"L"}
	
	if (!FileExist(configFile)) {
		try CreateConfig(configFile)
			catch e {
			m("Error: " e.message "`n`nDuring: " e.what "`n`nExitting app...", "ico:!")
			ExitApp
		}
	}
	for entry, defVal in settingList {
		IniRead, %entry%, %configFile%, GlobalSettings, %entry%, %defVal%
		settings.Insert(entry, %entry%)
	}
}