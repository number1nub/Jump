EditSettings(ProgName, Inifile, OwnedBy=0, DisableGui=0, HelpText=0) {
	static pos		
	Loop, 99
	{	;Find a GUI ID that does not exist yet
		Gui %A_Index%:+LastFoundExist
		if (!WinExist()) {
			SettingsGuiID = %A_Index%
			break
		}
		else if (A_Index = 99) {
			MsgBox, 4112, Error in EditSettings function, Can't open settings dialog,`nsince no GUI ID was available.
			return 0
		}
	}
	Gui, %SettingsGuiID%:Default
	if (OwnedBy) {	;apply options to settings GUI
		Gui, +ToolWindow +Owner%OwnedBy%
		if DisableGui
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
	HelpTip = ( All changes are Auto-Saved )
	if (HelpTxt) {
		HelpTip = ( All changes are Auto-Saved - Press F1 for Help )
		Hotkey, ifWinActive, %ProgName% Settings
		Hotkey, F1, ShowHelp
	}
	Gui, Add, Text, x45 y48 w480 h20 +Center, %HelpTip%
	Gui, Font, S16 CDefault Bold, Verdana
	Gui, Add, Text, x45 y13 w480 h35 +Center, Settings for %ProgName%
	Loop, Read, %Inifile%
	{	;read data from ini file, build tree and store values and description in arrays
		CurrLine = %A_LoopReadLine%
		CurrLineLength := CurrLine.Len
		if CurrLine is space
			Continue
		if (InStr(CurrLine,";") = 1) {	;description (comment) line
			StringLeft, chk2, CurrLine, % CurrLength + 2
			StringTrimLeft, Des, CurrLine, % CurrLength + 2			
			if (%CurrID%Sec = False && ";" CurrKey A_Space = chk2) {	;description of key				
				if (InStr(Des,"Type: ") = 1) {	;handle key types
					StringTrimLeft, Typ, Des, 6
					Typ = %Typ%
					Des=					
					if (InStr(Typ,"DropDown ") = 1) {	;handle format or list
						StringTrimLeft, Format, Typ, 9
						%CurrID%For = %Format%
						Typ = DropDown
						Des =
					}
					else if (InStr(Typ,"DateTime") = 1) {
						StringTrimLeft, Format, Typ, 9
						if Format is space
							Format = dddd MMMM d, yyyy HH:mm:ss tt
						%CurrID%For = %Format%
						Typ = DateTime
						Des =
					}
					%CurrID%Typ := Typ
				}
				else if (InStr(Des,"Default: ") = 1) {	;remember default value
					StringTrimLeft, Def, Des, 9
					%CurrID%Def = `n%Def%
					
				}
				else if (InStr(Des,"Options: ") = 1) {	;remember custom options
					StringTrimLeft, Opt, Des, 9
					%CurrID%Opt = %Opt%
					Des =					
				}
				else if (InStr(Des,"Hidden:") = 1) {	;remove hidden keys from tree
					TV_Delete(CurrID)
					Des =
					CurrID =					
				}
				else if (InStr(Des,"CheckboxName: ") = 1) {	;handle checkbox name
					StringTrimLeft, ChkN, Des, 14
					%CurrID%ChkN = %ChkN%
					Des =
				}
				else if (InStr(Des, "Space:") = 1) {	; Add blank line
					Des =
				}
				%CurrID%Des := %CurrID%Des "`n" Des				
			}
			else if (%CurrID%Sec = True AND ";" CurrSec A_Space = chk2 ) {	;description of section				
				if (InStr(Des,"Hidden:") = 1) {	;remove hidden section from tree
					TV_Delete(CurrID)
					Des =
					CurrSecID =
				}
				;set description
				%CurrID%Des := %CurrID%Des "`n" Des
			}				
			if (InStr(%CurrID%Des, "`n") = 1)	;remove leading and trailing whitespaces and new lines
				StringTrimLeft, %CurrID%Des, %CurrID%Des, 1
			Continue
		}			
		if (InStr(CurrLine, "[") = 1 And InStr(CurrLine, "]", "", 0) = CurrLineLength) {	;section line
			;extract section name
			StringTrimLeft, CurrSec, CurrLine, 1
			StringTrimRight, CurrSec, CurrSec, 1
			CurrSec = %CurrSec%
			CurrLength := CurrSec.Len  ;to easily trim name off of following comment lines			
			CurrSecID := TV_Add(CurrSec)	; Add to tree
			CurrID = %CurrSecID%
			%CurrID%Sec := True
			CurrKey =
			Continue
		}		
		;key line
		Pos := InStr(CurrLine, "=")
		if (Pos AND CurrSecID) {	;extract key name and its value			
			StringLeft, CurrKey, CurrLine, % Pos - 1
			StringTrimLeft, CurrVal, CurrLine, %Pos%
			CurrKey = %CurrKey%	;remove whitespaces
			CurrVal = %CurrVal%
			CurrLength := CurrKey.Len			
			CurrID := TV_Add(CurrKey,CurrSecID)	; Add to tree and store value
			%CurrID%Val := CurrVal
			%CurrID%Sec := False			
			;store initial value as default for restore function will be overwritten if default is specified later on comment line
			%CurrID%Def := CurrVal
		}
	}		
	TV_Modify(TV_GetChild(TV_GetNext()), "Select")	;select first key of first section and expand section	
	;show Gui and get UniqueID
	Gui, Show, , %ProgName% Settings
	Gui, +LastFound
	GuiID := WinExist()
	Loop {	;check for changes in GUI		
		CurrID := TV_GetSelection()	;get current tree selection
		if (SetDefault) {
			%CurrID%Val := Trim(%CurrID%Def, "`r`n-")
			LastID = 0
			SetDefault:=False, ValChanged:=True
		}		
		MouseGetPos,,, AWinID, ACtrl
		if (AWinID = GuiID) {
			if (ACtrl = "Button3")
				SB_SetText("Restores Value to default (if specified), else restores it to initial value before change")
		}
		else
			SB_SetText("")
		if (CurrID <> LastID) {	;change GUI content if tree selection changed			
			Loop, Parse, InvertedOptions, %A_Space%		;remove custom options from last control
				GuiControl, %A_Loopfield%, %ControlUsed%			
			;hide/show browse button depending on key type
			Typ := %CurrID%Typ
			if Typ in File,Folder
				GuiControl, Show , Button2,
			else
				GuiControl, Hide , Button2,			
			;set the needed value control depending on key type
			if (Typ = "DateTime")
				ControlUsed = SysDateTimePick321
			else if (Typ = "Hotkey" )
				ControlUsed = msctls_hotkey321
			else if (Typ = "DropDown")
				ControlUsed = ComboBox1
			else if (Typ = "CheckBox")
				ControlUsed = Button4
			else                    ;e.g. Text,File,Folder,Float,Integer or No Tyo (e.g. Section)
				ControlUsed = Edit1			
			;hide/show the value controls
			Controls = SysDateTimePick321,msctls_hotkey321,ComboBox1,Button4,Edit1
			Loop, Parse, Controls, `,
				if (ControlUsed = A_LoopField )
					GuiControl, Show , %A_LoopField%,
				else
					GuiControl, Hide , %A_LoopField%,
			
			if (ControlUsed = "Button4" )
				GuiControl,  , Button4, % %CurrID%ChkN			
			;get current options
			CurrOpt := %CurrID%Opt			
			InvertedOptions =
			Loop, Parse, CurrOpt, %A_Space%
			{	;apply current custom options to current control and memorize them inverted				
				StringLeft, chk, A_LoopField, 1
				StringTrimLeft, chk2, A_LoopField, 1
				if chk In +,-
				{
					GuiControl, %A_LoopField%, %ControlUsed%
					if (chk = "+")
						InvertedOptions = %InvertedOptions% -%chk2%
					else
						InvertedOptions = %InvertedOptions% +%chk2%
				}
				else {
					GuiControl, +%A_LoopField%, %ControlUsed%
					InvertedOptions = %InvertedOptions% -%A_LoopField%
				}
			}			
			if (%CurrID%Sec) { 	;section got selected
				CurrVal =
				GuiControl, , Edit1,
				GuiControl, Disable , Edit1,
				GuiControl, Disable , Button3,
			}
			else {	;new key got selected
				CurrVal := %CurrID%Val   ;get current value
				GuiControl, , Edit1, %CurrVal%   ;put current value in all value controls
				GuiControl, Text, SysDateTimePick321, % %CurrID%For
				GuiControl, , SysDateTimePick321, %CurrVal%
				GuiControl, , msctls_hotkey321, %CurrVal%
				GuiControl, , ComboBox1, % "|" %CurrID%For
				GuiControl, ChooseString, ComboBox1, %CurrVal%
				GuiControl, , Button4 , %CurrVal%
				GuiControl, Enable , Edit1,
				GuiControl, Enable , Button3,
			}
			GuiControl, , Edit2, % %CurrID%Des
		}
		LastID = %CurrID%                   ;remember last selection		
		Sleep, 100		
		if not WinExist("ahk_id" GuiID)	;exit endless loop, when settings GUI closes
			Break			
		if (%CurrID%Sec = False) {	;if key is selected, get value
			GuiControlGet, NewVal, , %ControlUsed%
			;save key value when it has been changed
			if (NewVal <> CurrVal OR ValChanged) {
				ValChanged := False								
				if (Typ = "Integer")	;consistency check if type is integer or float
					if NewVal is not space
						if NewVal is not Integer
						{
							GuiControl, , Edit1, %CurrVal%
							Continue
						}
				if (Typ = "Float")
					if NewVal is not space
						if NewVal is not Integer
							if (NewVal <> ".")
								if NewVal is not Float
								{
									GuiControl, , Edit1, %CurrVal%
									Continue
								}								
				%CurrID%Val := NewVal	;set new value and save it to INI
				CurrVal = %NewVal%
				PrntID := TV_GetParent(CurrID)
				TV_GetText(Selsec, PrntID)
				TV_GetText(SelKey, CurrID)
				if (Selsec AND SelKey)
					IniWrite, %NewVal%, %Inifile%, %Selsec%, %SelKey%
			}
		}
	}

	GuiEscape:
	GuiClose:
	ExitSettings:
		if (DisableGui) {
			Gui, %OwnedBy%:-Disabled
			Gui, %OwnedBy%:,Show
		}
		Gui, Destroy
		ifNotEqual, HelpText, 0
			Hotkey, F1, Off
		return

	BtnBrowseKeyValue:
		GuiControlGet, StartVal, , Edit1
		Gui, +OwnDialogs
		if (Typ = "File") {
			ifExist %A_ScriptDir%\%StartVal%
				StartFolder = %A_ScriptDir%
			else ifExist %StartVal%
				SplitPath, StartVal, , StartFolder
			else
				StartFolder =
			FileSelectFile, Selected,, %StartFolder%, Select file for %Selsec% - %SelKey%, Any file (*.*)
		}
		else if (Typ = "Folder") {
			;get StartFolder
			ifExist %A_ScriptDir%\%StartVal%
				StartFolder = %A_ScriptDir%\%StartVal%
			else ifExist %StartVal%
				StartFolder = %StartVal%
			else
				StartFolder =
			FileSelectFolder, Selected, *%StartFolder% , 3, Select folder for %Selsec% - %SelKey%
			StringRight, LastChar, Selected, 1
			if (LastChar = "\")
				StringTrimRight, Selected, Selected, 1
		}		
		if (Selected) {	;if file or folder got selected, remove A_ScriptDir (since it's redundant) and set it into GUI
			StringReplace, Selected, Selected, %A_ScriptDir%\
			GuiControl, , Edit1, %Selected%
			%CurrID%Val := Selected
		}
		return

	BtnDefaultValue:
		SetDefault := True
		return

	GuiEditSettingsSize:
		Anchor("SysTreeView321"      , "h")
		Anchor("Static3"             , "x.5")		; Sub title
		Anchor("Static4"             , "x.5")		; Title
		Anchor("Edit1"               , "w")		; Value - text
		Anchor("ComboBox1"           , "w")		; Value - dropdown
		Anchor("Edit2"               , "wh")	; Description
		Anchor("Button1"             , "x.5y",true)	; Exit
		Anchor("Button2"             , "x",true)	; Browse
		Anchor("Button3"             , "y",true)	; Restore
		Anchor("Button4"             , "x",true)	; Checkbox
		Anchor("Button5"             , "wh",true)	; GroupBox
		Anchor("SysDateTimePick321"  , "x")
		Anchor("msctls_Hotkey321"    , "x")				
		return

	ShowHelp:
		MsgBox, 64, %ProgName% Settings Help, %HelpText%
		return
}