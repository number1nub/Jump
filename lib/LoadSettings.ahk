LoadSettings() {
	initW  := 96
	incPix := 8
	
	settings := { cfgDir:   GetConfigDir()
				, cfgPath:  GetConfigDir() "\Settings.ini"
				, initGuiW: initW
				, incPix:   incPix
				, limit:    FindLimit(tmp.initGuiW, tmp.incPix)
				, guiWidth: 2*incPix + initW }
	
	globalSettings := { DefaultBrowser: "iexplore.exe"
					  , FadeOnShow:     "1"
					  , FadeOnExit:     "1"
					  , FadeSpeed:      "2"
					  , Transparency:   "210"
					  , BackColor:      "Black"
					  , TextColor:      "Aqua"
					  , Font:           "Arial"
					  , DClickAction:   "S"
					  , NoInputAction:  "L" }
	if (!FileExist(settings.cfgPath))
		CreateConfig()
	for settingName, defaultVal in globalSettings {
		IniRead, %settingName%, % settings.cfgPath, GlobalSettings, %settingName%, %defaultVal%
		settings.Insert(settingName, %settingName%)
	}
}