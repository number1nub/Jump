#SingleInstance Force
SetControlDelay, 0
Setworkingdir %A_ScriptDir%
SetTitleMatchMode, 2
OnExit("FadeOutGUI")

global settings, limit, guiWidth, initGuiWidth, guiHwnd, incPixPerChar, breakLoop, configFile:=GetConfigDir() "\Settings.ini"

BuildTrayMenu()
LoadSettings()
HandleArgs()

Gui +LastFound +AlwaysOnTop -Caption +ToolWindow +border
Gui, margin, 0, 5
Gui, Color, %BackColor%
Gui, Font, s11 w550 c%TextColor%, %font%
Gui, Add, Text, vMyText w550 c%TextColor% w%guiWidth% gmainGuiClick center,
Winset, Transparent, %Transparency%
FadeInGUI()

loop
	Gosub, inputChar
until breakLoop

GoSub, evaluate
ExitApp
return

evaluate:
if (!str) {	; Blank input --> perform action specified by NoInputAction setting		
	if (NoInputAction = "S")a
		run, edit %configFile%
	else if (NoInputAction = "E")
		run, edit %A_ScriptFullPath%
	else {
		IniRead, str, %configFile%, InternalSettings, LastTrigger, Err
		if (str = "Err") {
			GuiControl,, MyText, ???
			sleep 400
			ExitApp
		}
	}
}

if (fromHistory) {
	origStr := LastTrigger
	str := LastInputLabel
	str .= LastInput
	if (str.Len > limit) {
		if ((str.Len - LastInput.Len) < limit)
			overFlowChars := str.Len - limit
		else
			overFlowChars := LastInput.Len
		Loop, %overFlowChars%
			gosub,incrementWidth
	}
	GuiControl,, MyText, %str%
	lookup := SubStr(str, lookupLabel.Len+1)
}
else {
	IniRead, lookupLabel, %configFile%, lookups, %str%, ERROR
	origStr := str
	if (lookupLabel != "ERROR") {
		IniRead, lookupInput, %configFile%, lookupSettings, %str%_input, %A_Space%
		IniRead, lookupPath, %configFile%, lookupSettings, %str%_path, %A_Space%	
		showLabel(lookupLabel)
	}
}

isURLinput := false

;{````  Lookup  ````}
if (lookupLabel != "ERROR") {
	GoSub inputLookup
	
	if (lookup) {
		historyExecute:
		position:=InStr(lookupInput, "[lookup]"), position-=1, before:=SubStr(lookupInput, 1, position), position+=9, after:=SubStr(lookupInput, position,999)
		lookupInput:=before lookup after
		lookupInput := shortcutReplace(lookupInput)
		if (!lookupPath) {
			lookupPath := DefaultBrowser
			isURLinput := true
		}	
		if lookupPath contains iexplore,chrome,firefox,www.,http://,.com,.net,.org
			isURLinput := true						
		SplitPath, lookupPath, ,workingDir, , ,outDrive						
		; Note that the "\" can't be included at the beginning of lookuppath in the ini file-- it must be added here
		if (!outDrive)
			workingDir := A_workingDir . "\" . workingDir 							
		lookupPath := shortcutReplace(lookupPath)
		; Handle encoding HTML characters for URLs
		if (isURLinput) {
			Transform, lookupInput, HTML, %lookupInput%
			StringReplace, lookupInput, lookupInput, #, `%23
		}
		LastInput := "", FromHistory := false
		IniWrite, %origStr%, %configFile%, InternalSettings, LastTrigger
		IniWrite, "%lookupLabel%", %configFile%, InternalSettings, LastLookupLabel
		IniWrite, %lookupInput%, %configFile%, InternalSettings, LastInput
		IniWrite, L, %configFile%, InternalSettings, LastType
		Run %lookupPath% `"%lookupInput%`"
	}
}
;}	
;{````  Shortcut  ````}
else {
	IniRead, shortcut, %configFile%, shortcuts, %str%, ERROR
	if (shortcut="ERROR") {
		if (str) {
			GuiControl,, MyText, ???
			sleep 400
		}
		ExitApp
	}
	IniRead, shortcutSettings, %configFile%, shortcutSettings, %str%, 0
	if (shortcutSettings) {
		cancelRun := false
		bp:="-bp", wa:="-wa", ie:="-ie", wd:="-wd"
		if InStr(shortcutSettings, bp) {
			IniRead, bPath, %configFile%, shortcutSettings, %str%_Browser, Err
			shortcut := (bPath = "Err" ? DefaultBrowser : bPath) " " shortcut
		}
		if InStr(shortcutSettings, wa) {
			IniRead, title, %configFile%, shortcutSettings, %str%_title, Err
			if (title = "Err") {
				msgbox Error. No title specified for activating %shortcut%
				ExitApp
			}
			else {
				TTMbu := A_TitleMatchMode					
				SetTitleMatchMode, RegEx					
				IfWinExist, i)%title%
				{
					WinActivate
					cancelRun := true
				}
				SetTitleMatchMode, %TTMbu%
			}
		}
		if InStr(shortcutSettings, ie) {
			If !FileExist(shortcut := shortcutReplace(shortcut)) {
				cancelRun := true
				msgbox This path does not exist:`r%shortcut%
			}
		}
		if InStr(shortcutSettings, wd) {
			IniRead, workingDir, %configFile%, shortcutSettings, %str%_WorkingDir
			if (workingDir = "ERROR")	;choose WorkingDir automoatically. This does not work if you use parameters.
				SplitPath, shortcut, ,workingDir
			shortcut := shortcutReplace(shortcut)
			Run, %shortcut%, %workingDir%
			cancelRun := true
		}
	}
	if (!cancelRun) {
		shortcut := shortcutReplace(shortcut)
		run, %shortcut%
	}
	IniWrite, %str%, %configFile%, InternalSettings, LastTrigger	
	IniWrite, % "", %configFile%, InternalSettings, LastLookupLabel
	IniWrite, % "", %configFile%, InternalSettings, LastInput
	IniWrite, S, %configFile%, InternalSettings, LastType
}
;}
ExitApp


inputChar:
Hotkey, Up, InsertHistory, On
Input, char, L1 M,{enter}{space}{backspace}
length := char.Len
if (length = 0) {	;Typed an escape char
	if GetKeyState("Backspace","P")
		goSub, Backspace
	else						;a.k.a the user pressed enter, or space
		breakLoop := true
}
charNumber := Asc(char)		
if (charNumber = 27)	; Escape
	ExitApp	
if (charNumber = 22) {	;<Ctrl + V> -- Paste input
	str := str . clipboard
	if (str.Len > limit) {		;Input is longer than GUI
		if (str.Len-clipboard.Len) < limit	;Exceeds original %limit%
			overFlowChars := str.Len-limit
		else if (str.Len-clipboard.Len) > limit		;Additional extension to %limi%
			overFlowChars := clipboard.Len
		loop %overFlowChars%
			GoSub, incrementWidth
	}
	GuiControl,, MyText, %str% 	 ;Show change
}
else if (charNumber = 3) {	;<Ctrl + C> -- Copy input 
	clipboard := str
	str = copied 
	GuiControl,, MyText, %str%
	sleep 600
	ExitApp
}
else if (charNumber > 31) {	; Normal input
	str := str . char
	if str.Len > limit		;Input is longer than GUI
		GoSub, incrementWidth
	GuiControl,, MyText, %str% 		;update GUI
}
return


backspace:
StringTrimRight, str, str, 1
GuiControl,, MyText, %str%
if (str.Len >= limit)
	decrementWidth()
return


incrementWidth:
guiWidth := guiWidth + incPixPerChar
initGuiWidth := initGuiWidth + incPixPerChar
Gui, Show, w%guiWidth% xCenter
GuiControl, Move, MyText, W%guiWidth%
return


InsertHistory:
IniRead, lastType, %configFile%, InternalSettings, LastType, Err
IniRead, str, %configFile%, InternalSettings, LastTrigger, Err	
if (str != "Err") {
	if (lastType = "L"){
		IniRead, LastInput, %configFile%, InternalSettings, LastInput, % ""
		IniRead, LastInputLabel, %configFile%, InternalSettings, LastLookupLabel, % ""
		fromHistory := (LastInput && LastInputLabel) ? 1 : ""
	}
	GuiControl,, MyText, % fromHistory ? LastInputLabel : str
	if (str.Len >= limit)
		gosub, incrementWidth
	goto, evaluate
}
return


inputChar4Lookup:
Input, char, L1 M,{enter}{backspace}	;input a single character in %char%
length := char.Len
if (length = 0){		;if true, the user has pressed enter, because enter is the escape character for the "Input" command
	if GetKeyState("Backspace","P")
		goSub, Backspace
	else {
		StringRight, lookup, str, str.Len - lookupLabel.Len	;remove the label from %str% and output to %lookup%
		breakLoop := true
		Goto, end_of_subroutine
	}
}			
charNumber := Asc(char)			;this returns whatever ascii # goes to the character in %char%	
if (charNumber = 27) 				;if the character is the ESC key
	ExitApp	
else if (charNumber = 22) {			;control-v			this section performs as paste from %clipboard%
	str .= clipboard
	if (str.Len > limit) {		;if user's input is longer than the gui. (width of a Courier character = 8pixels)
		if (clipboard.Len>1000) {
			m("clipboard is too large", "ico:!")
			ExitApp
		}
		if (str.Len-clipboard.Len) < limit			;pasting caused the string to exceed original %limit% (%limit% never changes after initial creation)
			overFlowChars := str.Len-limit
		else if (str.Len-clipboard.Len) > limit		;pasting caused the string to add to the extension of the %limit%
			overFlowChars := clipboard.Len
		loop %overFlowChars%
			GoSub, incrementWidth
	}
	GuiControl,, MyText, %str% 		;updates the gui so change is seen immediately
}
else if (charNumber < 31)
	goSub, end_of_subroutine
else {
	str .= char
	if str.Len > limit			;if user's input is longer than the gui. (width of a Courier character = 8pixels)
		GoSub, incrementWidth
	GuiControl,, MyText, %str% 		;updates the gui so change is seen immediately
	;check if activated lookup if char = space
}
end_of_subroutine:
return


inputLookup:
breakLoop := false
loop {
	GoSub inputChar4Lookup
	if breakLoop
		break
}
return




#Include <Anchor>
#Include <BuildTrayMenu>
#Include <class DefaultBase>
#Include <CreateConfig>
#Include <decrementWidth>
#Include <EditSettings>
#Include <Exit>
#Include <ExpandEnv>
#Include <FadeInGUI>
#Include <FadeOutGUI>
#Include <FindLimit>
#Include <GetConfigDir>
#Include <GetDropbox>
#Include <GuiContextMenu>
#Include <GuiDropFiles>
#Include <HandleArgs>
#Include <InvBase64>
#Include <JumpMenu>
#Include <LoadSettings>
#Include <LoadUserVars>
#Include <m>
#Include <mainGuiClick>
#Include <params>
#Include <ShortcutReplace>
#Include <showLabel>