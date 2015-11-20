GetConfigDir(def:="%APPDATA%\WSNHapps\Jump Launcher", overwrite:="") {
	static regPath := "Software\WSNHapps\JumpLauncher"
	RegRead, cfgDir, HKCU, %regPath%, ConfigPath
	if (ErrorLevel || !cfgDir || (cfgDir!=default && overwrite))
		RegWrite, REG_SZ, HKCU, %regPath%, ConfigPath, % (cfgDir:=def)
	return cfgDir
}