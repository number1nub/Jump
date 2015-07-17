InputChar() {
	Input, char, L1 M,{enter}{space}{backspace}
	length := char.Len
	if (length = 0) {	;Typed an escape char
		if GetKeyState("Backspace","P")
			Backspace()
		else	;pressed enter or space
			breakLoop := true
	}
	charNumber := Asc(char)
	if (charNumber = 27)	; Escape
		ExitApp
	if (charNumber = 22) {	;<Ctrl + V> -- Paste input
		str := str clipboard
		if (str.Len > settings.limit) {		;Input is longer than GUI
			if (str.Len-clipboard.Len) < settings.limit	;Exceeds original %limit%
				overFlowChars := str.Len-settings.limit
			else if (str.Len-clipboard.Len) > settings.limit		;Additional extension to %limi%
				overFlowChars := clipboard.Len
			loop %overFlowChars%
				IncrementWidth()
		}
		GuiControl,, InputTxt, %str% 	 ;Show change
	}
	else if (charNumber = 3) {	;<Ctrl + C> -- Copy input
		clipboard := str
		str = copied
		GuiControl,, InputTxt, %str%
		sleep 600
		ExitApp
	}
	else if (charNumber > 31) {	; Normal input
		str := str char
		if str.Len > settings.limit		;Input is longer than GUI
			IncrementWidth()
		GuiControl,, InputTxt, %str% 		;update GUI
	}
	return
}