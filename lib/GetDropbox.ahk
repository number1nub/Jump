GetDropbox() {
	RegRead, Key,  HKCU, Software\Dropbox, InstallPath
	FileReadLine, Key, % SubStr(Key, 1, -3) . "host.db",  2
	return InvBase64(key)
}
