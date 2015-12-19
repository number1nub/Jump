InputChar4Lookup(lookupPrompt) {
	Input, char, L1 M,{enter}{backspace}	;input a single character in %char%
	length := char.Len
	if (length = 0) {		;if true, the user has pressed enter, because enter is the escape character for the "Input" command
		if GetKeyState("Backspace","P")
			Backspace()
		else {
			StringRight, lookup, str, str.Len - lookupPrompt.Len	;remove the label from %str% and output to %lookup%
			breakLoop := true
			return lookup
		}
	}
	charNumber := Asc(char)			;this returns whatever ascii # goes to the character in %char%
	if (charNumber = 27) 				;if the character is the ESC key
		ExitApp
	else if (charNumber = 22) {			;control-v			this section performs as paste from %clipboard%
		str .= clipboard
		if (str.Len > settings.limit) {		;if user's input is longer than the gui. (width of a Courier character = 8pixels)
			if (clipboard.Len>1000) {
				m("clipboard is too large", "ico:!")
				ExitApp
			}
			if (str.Len-clipboard.Len) < settings.limit			;pasting caused the string to exceed original %limit% (%limit% never changes after initial creation)
				overFlowChars := str.Len-settings.limit
			else if (str.Len-clipboard.Len) > settings.limit		;pasting caused the string to add to the extension of the %limit%
				overFlowChars := clipboard.Len
			loop %overFlowChars%
				IncrementWidth()
		}
		GuiControl,, InputTxt, %str% 		;updates the gui so change is seen immediately
	}
	else if (charNumber < 31)
		return
	else {
		str .= char
		if str.Len > settings.limit			;if user's input is longer than the gui. (width of a Courier character = 8pixels)
			IncrementWidth()
		GuiControl,, InputTxt, %str% 		;updates the gui so change is seen immediately
		;check if activated lookup if char = space
	}
}