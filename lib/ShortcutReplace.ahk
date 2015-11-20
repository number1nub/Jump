shortcutReplace(v) {
	uVarObj := LoadUserVars()
	while (RegExMatch(v, "i)\$(?P<Name>\w+)", var))
		StringReplace, v, v, % "$" varName, % uVarObj[varName], All
	return ExpandEnv(v)
}
