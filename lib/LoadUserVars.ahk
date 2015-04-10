/*!
	Function: LoadUserVars()
		Gets the userVvars from the config file & returns an object containing
		the userVar replacements located at keys matching their uverVar names.
		For example:
		> varsObj := LoadUserVars()
		> replacement := varsObj.UserVarName
*/
LoadUserVars() {
	; Add default built-ins here
	uVars := { SETTINGS: configFile, ME: A_ScriptFullPath }
	
	IniRead, userVars, %configFile%, UserVars
	Loop, Parse, userVars, `n, `r
		if (RegExMatch(A_LoopField, "i)^\s*\$?(?P<Name>[^\s].*?)\s*=\s*(?P<Val>.*)\s*$", var))
			uVars.Insert(varName, RegExReplace(varVal, "\\$"))
	return uVars
}