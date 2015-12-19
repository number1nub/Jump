decrementWidth() {
	settings.guiWidth -= settings.incPix
	Gui, Show, % "xCenter w " settings.guiWidth
	GuiControl, Move, Static1, % "w" settings.guiWidth
}