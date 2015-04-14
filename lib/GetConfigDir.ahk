GetConfigDir(regPath="Software\WSNHapps\JumpLauncher", default="%APPDATA%\JumpLauncher") {
	RegRead, cfgDir, HKCU, %regPath%, ConfigPath
	if (ErrorLevel || !cfgDir)
		RegWrite, REG_SZ, HKCU, %regPath%, ConfigPath, % (cfgDir:=ExpandEnv(default))
	return cfgDir
}