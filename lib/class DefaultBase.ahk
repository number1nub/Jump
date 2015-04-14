class DefaultBase
{
	static _ := IsObject("".base.base := DefaultBase)
	static Split := Func("StrSplit")
	static Replace := Func("StrReplace")
	static Find := Func("InStr")
	static SubStr := Func("SubStr")
	static Match := Func("RegExMatch")
	static MatchReplace := Func("RegExReplace")
	static Trim := Func("Trim")
	static LTrim := Func("LTrim")
	static RTrim := Func("RTrim")
	
	class __Get extends DefaultBase.__PropImpl
	{
		static Len := Func("StrLen")
	}
	
	class __PropImpl
	{
		__Call(ByRef aTarget, aName, aParams*) {
			if ObjHasKey(this, aName)
				return this[aName].(aTarget, aParams*)
		}
	}
}