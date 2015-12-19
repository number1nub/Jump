Backspace() {
	GuiControlGet, InputTxt
	GuiControl,, InputTxt, % (str:=SubStr(InputTxt, 1, -1))
	if (str.Len >= settings.limit)
		DecrementWidth()
	return
}