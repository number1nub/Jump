InsertHistory:
{
	sect := "InternalSettings"
	cfgFPath := settings.cfgPath
	IniRead, lastType, %cfgFPath%, %sect%, LastType
	IniRead, str, %cfgFPath%, %sect%, LastTrigger
	if (str != "ERROR") {
		if (Format("{1:U}", lastType) == "L") {
			IniRead, LastInput, %cfgFPath%, %sect%, LastInput, % ""
			IniRead, LastInputLabel, %cfgFPath%, %sect%, LastLookupLabel, % ""
			fromHistory := (LastInput && LastInputLabel) ? 1 : ""
		}
		GuiControl,, InputTxt, % fromHistory ? LastInputLabel : str
		if (str.Len >= settings.limit)
			IncrementWidth()
		goto, evaluate
	}
	return
}