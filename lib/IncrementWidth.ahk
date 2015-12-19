IncrementWidth() {
	settings.guiWidth += settings.incPix
	settings.initGuiW += settings.incPix
	Gui, Show, % "xCenter w" settings.guiWidth
	GuiControl, Move, InputTxt, % "w" settings.guiWidth
	return
}