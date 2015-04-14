decrementWidth() {
	settings.guiWidth -= settings.incPix
	;~ settings.initGuiW -= settings.incPix
	Gui, Show, % "xCenter w " settings.guiWidth
	GuiControl, Move, MyText, % "w" settings.guiWidth
}