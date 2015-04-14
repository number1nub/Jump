LoadUserVars() {
	uVars := {SETTINGS:settings.cfgPath, ME:A_ScriptFullPath}
	
	IniRead, userVars, % settings.cfgPath, UserVars
	Loop, Parse, userVars, `n, `r
		if (RegExMatch(A_LoopField, "i)^\s*\$?(?P<Name>[^\s].*?)\s*=\s*(?P<Val>.*)\s*$", var))
			uVars.Insert(varName, RegExReplace(varVal, "\\$"))
	return uVars
}