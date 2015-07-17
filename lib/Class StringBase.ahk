class StringBase
{
	static Split     := Func("StrSplit")
	static Replace   := Func("StrReplace")
	static Find      := Func("InStr")
	static SubStr    := Func("SubStr")
	static Sub       := Func("SubStr")
	static Match     := Func("RegExMatch")
	static REReplace := Func("RegExReplace")
	static Trim      := Func("Trim")
	static LTrim     := Func("LTrim")
	static RTrim     := Func("RTrim")
	
	
	class __Get extends StringBase.PropBase
	{
		static Len := Func("StrLen")
	}
	
	
	class PropBase
	{
		__Call(ByRef aTarget, aName, aParams*) {
			if ObjHasKey(this, aName)
				return this[aName].(aTarget, aParams*)
		}
	}
	
	static _ := IsObject("".base.base := StringBase)
}