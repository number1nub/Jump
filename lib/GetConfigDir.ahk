GetConfigDir() {
	RegRead, configDir, HKCU, Software\WSNHapps\JumpLauncher, ConfigPath
	if (!configDir)
		RegWrite, REG_SZ, HKCU,Software\WSNHapps\JumpLauncher, ConfigPath, % (configDir := A_AppData "\JumpLauncher")
	return configDir
}