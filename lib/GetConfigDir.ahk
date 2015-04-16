GetConfigDir(default:="%APPDATA%\WSNHapps\JumpLauncher", overwrite:="") {
	regPath := "Software\WSNHapps\JumpLauncher"
	RegRead, cfgDir, HKCU, %regPath%, ConfigPath
	if (ErrorLevel || !cfgDir || (cfgDir!=default && overwrite))
		RegWrite, REG_SZ, HKCU, %regPath%, ConfigPath, % (cfgDir:=default)
	return cfgDir
}