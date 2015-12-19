EditSettings(ProgName, Inifile, OwnedBy=0, DisableGui=0, HelpText=0) {
	static pos, ctrlTypes:={DateTime:"SysDateTimePick321",Hotkey:"msctls_hotkey",DropDown:"ComboBox1",CheckBox:"Button4",Text:"Edit1",File:"Edit1",Folder:"Edit1",Float:"Edit1",Integer:"Edit1","":"Edit1"}
	
	Loop, 99 {
		Gui %A_Index%:+LastFoundExist
		if (!WinExist()) {
			SettingsGuiID := A_Index
			break
		}
		else if (A_Index = 99)
			return	m("Can't open settings dialog.", "Error getting a unique GUI ID.", "ico:!")
	}
	Gui, %SettingsGuiID%:Default
	if (OwnedBy) {
		Gui, +ToolWindow +Owner%OwnedBy%
		if (DisableGui)
			Gui, %OwnedBy%:+Disabled
	}
	else
		DisableGui := False
	Gui, +Resize +LabelGuiEditSettings +MinSize
	Gui, Add, Statusbar
	Gui, Add, TreeView, x10 y75 w200 h282 0x400
	Gui, Add, Edit, x215 y114 w340 h20,                           ;ahk_class Edit1
	Gui, Add, Edit, x215 y174 w340 h160 ReadOnly,                 ;ahk_class Edit2
	Gui, Add, Button, x250 y375 w70 h30 gExitSettings, &Close     ;ahk_class Button1
	Gui, Add, Button, x505 y88 gBtnBrowseKeyValue Hidden, B&rowse ;ahk_class Button2
	Gui, Add, Button, x215 y334 gBtnDefaultValue, &Restore        ;ahk_class Button3
	Gui, Add, DateTime, x215 y114 w340 h20 Hidden,                ;ahk_class SysDateTimePick321
	Gui, Add, Hotkey, x215 y114 w340 h20 Hidden,                  ;ahk_class msctls_hotkey321
	Gui, Add, DropDownList, x215 y114 w340 h120 Hidden,           ;ahk_class ComboBox1
	Gui, Add, CheckBox, x215 y114 w340 h20 Hidden,                ;ahk_class Button4
	Gui, Add, GroupBox, x4 y63 w560 h303 ,                        ;ahk_class Button5
	Gui, Font, Bold
	Gui, Add, Text, x215 y93, Value                               ;ahk_class Static1
	Gui, Add, Text, x215 y154, Description                        ;ahk_class Static2	
	if (HelpText)
		Hotkeys("F1", "ShowHelp", ProgName " Settings")
	Gui, Add, Text, x45 y48 w480 h20 +Center, % "( All changes are Auto-Saved " (HelpText ? "- Press F1 for Help" : "") " )"
	Gui, Font, S16 CDefault Bold, Verdana
	Gui, Add, Text, x45 y13 w480 h35 +Center, Settings for %ProgName%
	
	Loop, Read, %Inifile%
	{
		CurrLine:=Trim(A_LoopReadLine), CurrLineLength:=CurrLine.Len
		if (!CurrLine)
			Continue
		if (CurrLine.Sub(1, 1) = ";") {
			chk2:=CurrLine.Sub(1, CurrLength+2), Des:=CurrLine.Sub(CurrLength+3)
			if (%CurrID%Sec=False && ";" CurrKey " "=chk2) {
				if (Des.InStr("Type: ") = 1) {
					Typ:=Des.Sub(7), Des:=""
					if (Typ.InStr("DropDown ") = 1)
						Format:=Typ.Sub(10), %CurrID%For:=Format, Typ:="DropDown", Des:=""
					else if (Typ.InStr("DateTime") = 1) {
						Format := Trim(Typ.Sub(10)) ? Typ.Sub(10) : "dddd MMMM d, yyyy HH:mm:ss tt"
						%CurrID%For:=Format, Typ:="DateTime", Des:=""
					}
					%CurrID%Typ := Typ
				}
				else if (InStr(Des,"Default: ") = 1)	;Default value
					Def:=SubStr(Des, 10), %CurrID%Def:="`n" Def
				else if (InStr(Des,"Options: ") = 1)	;Custom options
					Opt:=SubStr(Des, 10), %CurrID%Opt:=Opt, Des:=""
				else if (InStr(Des,"Hidden:") = 1)	;Hidden key
					TV_Delete(CurrID), Des:="", CurrID:=""
				else if (InStr(Des,"CheckboxName: ") = 1)	;Checkbox name
					ChkN:=SubStr(Des, 15), %CurrID%ChkN:=ChkN, Des:=""
				else if (InStr(Des, "Space:") = 1)	;Space/blank line
					Des := ""
				%CurrID%Des .= "`n" Des
			}
			else if (%CurrID%Sec=True && ";" CurrSec " "=chk2 ) {	;Description of section
				if (InStr(Des,"Hidden:") = 1)	;Hidden section
					TV_Delete(CurrID), Des:="", CurrSecID:=""
				else if (InStr(Des, "Space:") = 1)
					Des := ""
				%CurrID%Des .= "`n" Des
			}
			if (InStr(%CurrID%Des, "`n") = 1)	;remove leading and trailing whitespaces and new lines
				%CurrID%Des := SubStr(%CurrID%Des, 2)
			Continue
		}
		if (InStr(CurrLine, "[") = 1 And InStr(CurrLine, "]", "", 0) = CurrLineLength) {	;Section header
			CurrSec:=SubStr(CurrLine, 2,-1), CurrLength:=CurrSec.Len, CurrSecID:=TV_Add(CurrSec), CurrID:=CurrSecID,%CurrID%Sec:=True, CurrKey:=""
			Continue
		}
		Pos := InStr(CurrLine, "=")
		if (Pos && CurrSecID)	;Get key name & value
			RegExMatch(CurrLine, "^\s*(?P<Key>.+?)\s*=\s*(?P<Val>.*?)\s*$", Curr), CurrLength:=CurrKey.Len, CurrID:=TV_Add(CurrKey,CurrSecID),%CurrID%Val:=CurrVal,%CurrID%Sec:=False,%CurrID%Def:= CurrVal
	}
	TV_Modify(TV_GetChild(TV_GetNext()), "Select")
	Gui, Show,, %ProgName% Settings
	Gui, +LastFound
	GuiID := WinExist()
	
	Loop {
		CurrID := TV_GetSelection()
		if (SetDefault)
			%CurrID%Val:=Trim(%CurrID%Def, "`r`n-"), LastID:=0, SetDefault:=False, ValChanged:=True
		MouseGetPos,,, AWinID, ACtrl
		if (AWinID = GuiID)
			SB_SetText(ACtrl="Button3" ? "Restores Value to default (if specified), else restores it to initial value before change" : "")
		if (CurrID <> LastID) {
			for c, v in StrSplit(InvertedOptions, " ")
				GuiControl, %v%, %ControlUsed%
			
			Typ := %CurrID%Typ
			GuiControl, % (Typ="File"||Typ="Folder") ? "Show" : "Hide", Button2
			ControlUsed := ctrlTypes[Typ] ? ctrlTypes[Typ] : "Edit1"
			for c, v in StrSplit("SysDateTimePick321,msctls_hotkey321,ComboBox1,Button4,Edit1", ",")
				GuiControl, % ControlUsed = v ? "Show" : "Hide", %v%
			if (ControlUsed = "Button4")
				GuiControl,, Button4, % %CurrID%ChkN
			CurrOpt := %CurrID%Opt
			InvertedOptions := ""
			for c, v in StrSplit(CurrOpt, " ") {
				chk:=SubStr(A_LoopField, 1, 1), chk2:=SubStr(A_LoopField, 2)
				if (chk = "+" || chk = "-") {
					GuiControl, %A_LoopField%, %ControlUsed%
					InvertedOptions .= " " (chk="+" ? "-" : "+") chk2
				}
				else {
					GuiControl, +%A_LoopField%, %ControlUsed%
					InvertedOptions .= -%A_LoopField%
				}
			}
			if (%CurrID%Sec) { 	;Section selected
				CurrVal := ""
				GuiControl,, Edit1,
				GuiControl, Disable , Edit1,
				GuiControl, Disable , Button3,
			}
			else {	;Key selected
				CurrVal := %CurrID%Val
				GuiControl,, Edit1, %CurrVal%
				GuiControl, Text, SysDateTimePick321, % %CurrID%For
				GuiControl,, SysDateTimePick321, %CurrVal%
				GuiControl,, msctls_hotkey321, %CurrVal%
				GuiControl,, ComboBox1, % "|" %CurrID%For
				GuiControl, ChooseString, ComboBox1, %CurrVal%
				GuiControl,, Button4, %CurrVal%
				GuiControl, Enable, Edit1
				GuiControl, Enable, Button3
			}
			GuiControl,, Edit2, % %CurrID%Des
		}
		LastID := CurrID
		Sleep, 100
		if (!WinExist("ahk_id" GuiID))
			Break
		if (%CurrID%Sec = False) {	;Key selected, get value
			GuiControlGet, NewVal,, %ControlUsed%
			if (NewVal != CurrVal || ValChanged) {
				ValChanged := False
				if (Typ = "Integer")
					if (NewVal.Trim())
						if NewVal is not Integer
						{
							GuiControl,, Edit1, %CurrVal%
							Continue
						}
				if (Typ = "Float")
					if (NewVal.Trim())
						if NewVal is not Integer
							if (NewVal != ".")
								if NewVal is not Float
								{
									GuiControl,, Edit1, %CurrVal%
									Continue
								}
				%CurrID%Val:=NewVal, CurrVal:=NewVal, PrntID:=TV_GetParent(CurrID), TV_GetText(Selsec, PrntID), TV_GetText(SelKey, CurrID)
				if (Selsec && SelKey)
					IniWrite, %NewVal%, %Inifile%, %Selsec%, %SelKey%
			}
		}
	}
	
	
	BtnBrowseKeyValue:
	GuiControlGet, StartVal,, Edit1
	Gui, +OwnDialogs
	if (Typ = "File") {
		if (FileExist(A_ScriptDir "\" StartVal))
			StartFolder := A_ScriptDir
		else if (FileExist(StartVal))
			SplitPath, StartVal,, StartFolder
		else
			StartFolder := ""
		FileSelectFile, Selected,, %StartFolder%, Select file for %Selsec% - %SelKey%, Any file (*.*)
	}
	else if (Typ = "Folder") {
		StartFolder := FileExist(A_ScriptDir "\" StartVal) ? A_ScriptDir "\" StartVal : FileExist(StartVal) ? StartVal : ""
		FileSelectFolder, Selected, *%StartFolder%, 3, Select folder for %Selsec% - %SelKey%		
		if (SubStr(Selected, 0) = "\")
			Selected := Selected.SubStr(1, -1)
	}
	if (Selected) {
		GuiControl,, Edit1, % Selected.Replace(A_ScriptDir "\")
		%CurrID%Val := Selected
	}
	return
	
	BtnDefaultValue:
	SetDefault := True
	return
	
	GuiEditSettingsSize:
	Anchor("SysTreeView321", "h")
	Anchor("Static3", "x.5")        ; Sub title
	Anchor("Static4", "x.5")        ; Title
	Anchor("Edit1", "w")            ; Value - text
	Anchor("ComboBox1", "w")        ; Value - dropdown
	Anchor("Edit2", "wh")           ; Description
	Anchor("Button1", "x.5y", true) ; Exit
	Anchor("Button2", "x", true)    ; Browse
	Anchor("Button3", "y", true)    ; Restore
	Anchor("Button4", "x", true)    ; Checkbox
	Anchor("Button5", "wh", true)   ; GroupBox
	Anchor("SysDateTimePick321", "x")
	Anchor("msctls_Hotkey321", "x")
	return
	
	ShowHelp:
	MsgBox 4160, %ProgName% Settings Help, Help:`n`n%HelpText%
	return
	
	DeadEnd:
	return
	
	GuiEditSettingsEscape:
	GuiEditSettingsClose:
	ExitSettings:
	if (DisableGui) {
		Gui, %OwnedBy%:-Disabled
		Gui, %OwnedBy%:,Show
	}
	Gui, Destroy
	;~ Hotkeys("F1")
	;~ Hotkeys("Up")
	return
}