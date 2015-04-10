decrementWidth() {
	guiWidth := guiWidth - incPixPerChar
	initGuiWidth := initGuiWidth - incPixPerChar
	Gui, Show, w%guiWidth% xCenter
	GuiControl, Move, MyText, W%guiWidth%
}