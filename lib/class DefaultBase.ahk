class DefaultBase
{
	class __PropImpl
	{
		__Call(ByRef aTarget, aName, aParams*)
		{
			if ObjHasKey(this, aName)
				return this[aName].(aTarget, aParams*)
		}
	}
	
	class __Get extends DefaultBase.__PropImpl
	{
		static Length := Func("StrLen")
		static Len := Func("StrLen")
	}
	
	class __Set extends DefaultBase.__PropImpl
	{
	}
	
	static Split := Func("StrSplit")
	static Replace := Func("StrReplace")
	static Find := Func("InStr")
	static SubStr := Func("SubStr")
	static Match := Func("RegExMatch")
	static MatchReplace := Func("RegExReplace")
	static ToLower := Func("__DefaultBase_StrLower")
	static ToUpper := Func("__DefaultBase_StrUpper")
	static Trim := Func("Trim")
	static LTrim := Func("LTrim")
	static RTrim := Func("RTrim")
	
	; Register default base objec
	static _ := IsObject("".base.base := DefaultBase)
}


__DefaultBase_StrReplace(ByRef t, searchText, replaceText := "", ByRef ovCount := "") {
	if IsByRef(ovCount)
	{
		StringReplace, q, t, % searchText, % replaceText, UseErrorLevel
		ovCount := ErrorLevel, ErrorLevel := 0
	} else
		StringReplace, q, t, % searchText, % replaceText, % ovCount = "" ? "A" : 1
	return q
}

__DefaultBase_StrLower(ByRef t, titleCase := false) {
	StringLower, q, t, % titleCase ? "T" : ""
	return q
}

__DefaultBase_StrUpper(ByRef t, titleCase := false) {
	StringUpper, q, t, % titleCase ? "T" : ""
	return q
}