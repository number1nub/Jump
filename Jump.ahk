#NoTrayIcon
#SingleInstance, Ignore
SetBatchLines, -1
SetControlDelay, 0
SetTitleMatchMode, 2
SetWorkingDir, %A_ScriptDir%

global settings:=[], breakLoop, WinID, Version, InputTxt, InputHwnd, str

TrayMenu()
LoadSettings()
OnExit("FadeOutGUI")
WinID := FadeInGUI()
Hotkeys("Up", "InsertHistory")
Hotkeys("Up", "DeadEnd", "Jump Launcher Settings")

loop
	InputChar()
until breakLoop
GoSub, evaluate
ExitApp



Anchor(ctrl, anchor="", redraw=false) {
	Static Ptr, PtrSize, GetParent, GetWindowInfo, SetWindowPos, RedrawWindow, c, cs, cl=0, g, gs, gl=0, gi, gpi, gw, gh
	if (!Ptr)
		Ptr:=A_PtrSize?"Ptr":"UInt",PtrSize:=A_PtrSize?A_PtrSize:4,AStr:=A_IsUnicode?"AStr":"Str",Module:=DllCall("GetModuleHandle","Str","user32",Ptr),GetParent:=DllCall("GetProcAddress",Ptr,Module,AStr,"GetParent",Ptr),GetWindowInfo:=DllCall("GetProcAddress",Ptr,Module,AStr,"GetWindowInfo",Ptr),SetWindowPos:=DllCall("GetProcAddress",Ptr,Module,AStr,"SetWindowPos",Ptr),RedrawWindow:=DllCall("GetProcAddress",Ptr,Module,AStr,"RedrawWindow",Ptr),cs:=PtrSize+8,gs:=PtrSize+4,VarSetCapacity(c,cs * 255,0),VarSetCapacity(g,gs * 99,0),VarSetCapacity(gi,60,0),NumPut(60,gi,0,"UInt")
	if !WinExist("ahk_id " ctrl) {
		GuiControlGet, t, Hwnd, %ctrl%
		if (!ErrorLevel)
			ctrl:=t
		else, ControlGet, ctrl, Hwnd, , %ctrl%
	}
	DllCall(GetWindowInfo,Ptr,gp:=DllCall(GetParent,Ptr,ctrl,Ptr),Ptr,&gi,"Int"),giw:=NumGet(gi,28,"Int")-NumGet(gi,20,"Int"),gih:=NumGet(gi,32,"Int")-NumGet(gi,24,"Int")
	if (gp != gpi) {
		gpi:=gp
		Loop, %gl%
			if (NumGet(g,cb:=gs*(A_Index-1),Ptr)==gp) {
				gw:=NumGet(g, cb + PtrSize, "Short"), gh:=NumGet(g, cb + PtrSize + 2, "Short"), gf:=1
				break
			}
		if (!gf)
			NumPut(gp,g,gl,Ptr),NumPut(gw:=giw,g,gl+PtrSize,"Short"),NumPut(gh:=gih,g,gl+PtrSize+2,"Short"),gl+=gs
	}
	ControlGetPos,dx,dy,dw,dh,,ahk_id %ctrl%
	Loop,%cl%
	{
		if (NumGet(c, cb := cs * (A_Index - 1), Ptr) == ctrl) {
			if (anchor = "") {
				cf = 1
				break
			}
			giw-=gw,gih-=gh,as:=1,dx:=NumGet(c,cb+PtrSize,"Short"),dy:=NumGet(c,cb+PtrSize+2,"Short"),cw:=dw,dw:=NumGet(c,cb+PtrSize+4,"Short"),ch:=dh,dh:=NumGet(c,cb+PtrSize+6,"Short")
			Loop, Parse, anchor, xywh
				if (A_Index > 1)
					av:=SubStr(anchor,as,1),as+=1+A_LoopField.Len,d%av%+=(InStr("yh",av)?gih:giw)*(A_LoopField+0?A_LoopField:1)
			DllCall(SetWindowPos,Ptr,ctrl,Ptr,0,"Int",dx,"Int",dy,"Int",InStr(anchor,"w")?dw:cw,"Int",InStr(anchor,"h")?dh:ch,"UInt",0x0004,"Int")
			if (redraw)
				DllCall(RedrawWindow,Ptr,ctrl,Ptr,0,Ptr,0,"UInt",0x0001|0x0100,"Int")
			return
		}
	}
	if (cf != 1)
		cb:=cl,cl+=cs
	bx:=NumGet(gi,48,"UInt"),by:=NumGet(gi,16,"Int")-NumGet(gi,8,"Int")-gih-NumGet(gi,52,"UInt")
	if (cf = 1)
		dw-=giw-gw,dh-=gih-gh
	NumPut(ctrl,c,cb,Ptr),NumPut(dx-bx,c,cb+PtrSize,"Short"),NumPut(dy-by,c,cb+PtrSize+2,"Short"),NumPut(dw,c,cb+PtrSize+4,"Short"),NumPut(dh,c,cb+PtrSize+6,"Short")
	return,True
}
Args(argStr) {
	static regex := "(?<=[-|/])([a-zA-Z0-9]*)[ |:|=|""|']*([\w|.|@|?|#|$|`%|=|*|,|<|>|^|{|}|\[|\]|;|(|)|_|&|+| |:|!|~|\\]*)[""| |']*(.*)"
	count:=0, options:=[], argStr:=argStr.REReplace("(?:([^\s])-|(\s+)-(\s+))", "$1$2<dash>$3").REReplace("(?:([^\s])/|(\s+)/(\s+))", "$1$2<slash>$3")
	while (argStr) {
		count++
		argStr.Match(regex, data)
		value := data2.REReplace("<dash>", "-").REReplace("<slash>", "/")
		options[data1] := value ? value : 1
		argStr := data3
	}
	ErrorLevel := count
	return options
}
Backspace() {
	GuiControlGet, InputTxt
	GuiControl,, InputTxt, % (str:=SubStr(InputTxt, 1, -1))
	if (str.Len >= settings.limit)
		DecrementWidth()
	return
}
class StringBase
{
	static Split     := Func("StrSplit")
	static Replace   := Func("StrReplace")
	static Find      := Func("InStr")
	static SubStr    := Func("SubStr")
	static Sub       := Func("SubStr")
	static Match     := Func("RegExMatch")
	static REReplace := Func("RegExReplace")
	static Trim      := Func("Trim")
	static LTrim     := Func("LTrim")
	static RTrim     := Func("RTrim")
	
	
	class __Get extends StringBase.PropBase
	{
		static Len := Func("StrLen")
	}
	
	
	class PropBase
	{
		__Call(ByRef aTarget, aName, aParams*) {
			if ObjHasKey(this, aName)
				return this[aName].(aTarget, aParams*)
		}
	}
	
	static _ := IsObject("".base.base := StringBase)
}
CreateConfig() {
	try {
		if (!FileExist(settings.cfgDir))
			FileCreateDir, % settings.cfgDir
		if (A_IsCompiled)
			FileInstall, Template.ini, % settings.cfgDir
		else {
			FileRead, tmp, Template.ini
			FileAppend, %tmp%, % settings.cfgPath
		}
	}
	catch e {
		m("Error creating config file...", "Error: " e.message "`n`nDuring: " e.what "`n`nExitting app...", "ico:!")
		ExitApp
	}
}
decrementWidth() {
	settings.guiWidth -= settings.incPix
	Gui, Show, % "xCenter w " settings.guiWidth
	GuiControl, Move, Static1, % "w" settings.guiWidth
}
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
Evaluate:
{
	if (!str) {		;Blank input --> Perform action specified by NoInputAction
		if (NoInputAction = "S")
			run, % "*edit " settings.cfgPath
		else if (NoInputAction = "E")
			run, % "*edit " A_ScriptFullPath
		else {
			IniRead, str, % settings.cfgPath, InternalSettings, LastTrigger, Err
			if (str = "Err") {
				SetTxt("???")
				sleep 400
				ExitApp
			}
		}
	}
	if (fromHistory) {
		origStr:=LastTrigger, str:=LastInputLabel, str.=LastInput
		if (str.Len > settings.limit) {
			if ((str.Len-LastInput.Len) < settings.limit)
				overFlowChars := str.Len-settings.limit
			else
				overFlowChars := LastInput.Len
			Loop, %overFlowChars%
				IncrementWidth()
		}
		SetTxt(str)
		lookup := SubStr(str, lookupLabel.Len+1)
	}
	else {
		IniRead, lookupLabel, % settings.cfgPath, lookups, %str%, ERROR
		origStr := str
		if (lookupLabel != "ERROR") {
			IniRead, lookupInput, % settings.cfgPath, lookupSettings, %str%_input, %A_Space%
			IniRead, lookupPath, % settings.cfgPath, lookupSettings, %str%_path, %A_Space%
			showLabel(lookupLabel)
		}
	}
	isURLinput := false
	if (lookupLabel != "ERROR") {	; Lookup
		if (lookup:=InputLookup(lookupLabel)) {
			historyExecute:
			position    := InStr(lookupInput, "[lookup]") - 1
			before      := SubStr(lookupInput, 1, position)
			position += 9
			after       := SubStr(lookupInput, position,999)
			lookupInput := shortcutReplace(before lookup after)
			if (!lookupPath) {
				lookupPath := settings.DefaultBrowser
				isURLinput := true
			}
			if lookupPath contains iexplore,chrome,firefox,www.,http://,.com,.net,.org
				isURLinput := true
			SplitPath, lookupPath,,workingDir,,,outDrive
			; Note that the "\" can't be included at the beginning of lookuppath in the ini file-- it must be added here
			if (!outDrive)
				workingDir := A_workingDir "\" workingDir
			lookupPath := shortcutReplace(lookupPath)
			; Handle encoding HTML characters for URLs
			if (isURLinput) {
				Transform, lookupInput, HTML, %lookupInput%
				StringReplace, lookupInput, lookupInput, #, `%23
			}
			LastInput := ""
			FromHistory := false
			IniWrite, %origStr%, % settings.cfgPath, InternalSettings, LastTrigger
			IniWrite, "%lookupLabel%", % settings.cfgPath, InternalSettings, LastLookupLabel
			IniWrite, %lookupInput%, % settings.cfgPath, InternalSettings, LastInput
			IniWrite, L, % settings.cfgPath, InternalSettings, LastType
			Run %lookupPath% `"%lookupInput%`"
		}
	}
	else {	; Shortcut
		IniRead, shortcut, % settings.cfgPath, shortcuts, %str%, ERROR
		if (shortcut="ERROR") {
			if (str) {
				SetTxt("???")
				sleep 400
			}
			ExitApp
		}
		IniRead, shortcutSettings, % settings.cfgPath, shortcutSettings, %str%, 0
		if (shortcutSettings) {
			cancelRun := false
			bp:="-bp", wa:="-wa", ie:="-ie", wd:="-wd"
			if InStr(shortcutSettings, bp) {
				IniRead, bPath, % settings.cfgPath, shortcutSettings, %str%_Browser, Err
				shortcut := (bPath = "Err" ? settings.DefaultBrowser : bPath) " " shortcut
			}
			if InStr(shortcutSettings, wa) {
				IniRead, title, % settings.cfgPath, shortcutSettings, %str%_title, Err
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
				IniRead, workingDir, % settings.cfgPath, shortcutSettings, %str%_WorkingDir
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
		IniWrite, %str%, % settings.cfgPath, InternalSettings, LastTrigger
		IniWrite, % "", % settings.cfgPath, InternalSettings, LastLookupLabel
		IniWrite, % "", % settings.cfgPath, InternalSettings, LastInput
		IniWrite, S, % settings.cfgPath, InternalSettings, LastType
	}
	ExitApp
}
Exit(reason) {
	ExitApp
}
ExpandEnv(str) {
	VarSetCapacity(dest, 2000)
	DllCall("ExpandEnvironmentStrings", "str", str, "str", dest, int, 1999, "Cdecl int")
	return dest
}
FadeInGUI(instant:="") {
	Gui, Margin, 0, 5
	Gui, Color, % settings.BackColor
	Gui, Font, % "s11 w550 c" settings.TextColor, % settings.Font
	Gui +LastFound +AlwaysOnTop -Caption +ToolWindow +Border +hwndhwnd
	
	Gui, Add, Text, % "w550 gmainGuiClick center hwndInputHwnd vInputTxt c" settings.TextColor " w" settings.guiWidth,
	Winset, Transparent, % settings.Transparency
	
	if (settings.FadeOnShow && !instant) {
		Gui, Show, y-50
		WinGetPos,,,, height
		Y := -height
		Gui, Show, % "xCenter y" Y " w" settings.guiWidth
		while (Y < -settings.FadeSpeed) {
			Y += settings.FadeSpeed
			Gui, Show, y%Y%
			sleep 20
		}
	}
	Gui, Show, y0 NA, Jump Launcher
	Gui, Flash
	return hwnd
}
FadeOutGUI(reload:="") {
	if (settings.FadeOnExit) {
		WinGetPos,,,, height, ahk_id %WinID%
		Y := 0
		while(Y > (0-height)) {
			Y := Y - settings.FadeSpeed
			Gui, Show, y%Y% NoActivate
			sleep 20
		}
	}
	if (!reload)
		ExitApp
}
GetConfigDir(def:="%APPDATA%\WSNHapps\Jump Launcher", overwrite:="") {
	static regPath := "Software\WSNHapps\JumpLauncher"
	RegRead, cfgDir, HKCU, %regPath%, ConfigPath
	if (ErrorLevel || !cfgDir || (cfgDir!=default && overwrite))
		RegWrite, REG_SZ, HKCU, %regPath%, ConfigPath, % (cfgDir:=def)
	return cfgDir
}
GetDropbox() {
	RegRead, Key,  HKCU, Software\Dropbox, InstallPath
	FileReadLine, Key, % SubStr(Key, 1, -3) . "host.db",  2
	return InvBase64(key)
}

GetTxt() {
	GuiControlGet, InputTxt
	return InputTxt
}
GuiContextMenu(hwnd, ctlId, eventinfo) {
	if (hwnd = WinID)
		JumpMenu()
}
GuiDropFiles(hwnd, files) {	
	GuiControlGet, str,, Static1
	IniRead, shortcut, % settings.cfgPath, shortcuts, %str%
	if (shortcut="ERROR") {
		if (str) {
			SetTxt("???")
			sleep 400
		}
		ExitApp
	}	
	shortcut := """" ShortcutReplace(shortcut) """"
	for c, file in files
		Run, % shortcut " """ file """"
	ExitApp
}
Hotkeys(key:="", item:="", win:="") {
	static hkList := []
	if (!key)
		return hkList
	launch := RegExReplace(RegExReplace(item,"&")," ","_")
	if (!launch && ObjHasKey(hkList, key)) {
		Hotkey, %key%, Toggle
		hkList[key].state := !hkList[key].state
		return hkList[key].state
	}
	if (!launch)
		return
	if (win) {
		if (SubStr(win, 1, 1) = "!")
			Hotkey, IfWinNotActive, % SubStr(win, 2)
		else
			Hotkey, IfWinActive, %win%
	}
	Hotkey, %key%, %launch%, On
	hkList[key] := {state:1, launch:launch}
	Hotkey, IfWinActive
	return
}
IncrementWidth() {
	settings.guiWidth += settings.incPix
	settings.initGuiW += settings.incPix
	Gui, Show, % "xCenter w" settings.guiWidth
	GuiControl, Move, InputTxt, % "w" settings.guiWidth
	return
}
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
inputLookup(prompt) {
	breakLoop := false
	loop {
		retVal := InputChar4Lookup(prompt)
		if (breakLoop)
			return retVal
	}
}
InsertHistory:
{
	sect := "InternalSettings"
	cfgFPath := settings.cfgPath
	IniRead, lastType, %cfgFPath%, %sect%, LastType
	IniRead, str, %cfgFPath%, %sect%, LastTrigger
	if (str != "ERROR") {
		if (Format("{1:U}", lastType) == "L") {
			IniRead, LastInput, %cfgFPath%, %sect%, LastInput, % ""
			IniRead, LastInputLabel, %cfgFPath%, %sect%, LastLookupLabel, % ""
			fromHistory := (LastInput && LastInputLabel) ? 1 : ""
		}
		GuiControl,, InputTxt, % fromHistory ? LastInputLabel : str
		if (str.Len >= settings.limit)
			IncrementWidth()
		goto, evaluate
	}
	return
}
InvBase64(B64val) {
	Chars := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" 
	StringReplace B64val, B64val, =,,All 
	Loop Parse, B64val 
	{
		If Mod(A_Index,4) = 1 
			buffer := InStr(Chars,A_LoopField,1) - 1 << 18
		Else If Mod(A_Index,4) = 2 
			buffer += InStr(Chars,A_LoopField,1) - 1 << 12 
		Else If Mod(A_Index,4) = 3 
			buffer +=  InStr(Chars,A_LoopField,1) - 1<< 6 
		Else { 
			buffer +=  InStr(Chars,A_LoopField,1) - 1
			out := out . Chr(buffer>>16) . Chr(255 & buffer>>8) . Chr(255 & buffer)
		} 
	}
	If Mod(B64val.Len,4) = 0 
		Return out 
	If Mod(B64val.Len,4) = 2 
		Return out . Chr(buffer>>16) 
	Return out . Chr(buffer>>16) . Chr(255 & buffer>>8) 
}

JumpMenu() {	
	Menu, JumpMenu, Add, Application Settings, MenuAction
	Menu, JumpMenu, Add
	Menu, JumpMenu, Add, Quick Shortcut Editor, MenuAction
	Menu, JumpMenu, Add, Open Settings.ini File, MenuAction
	Menu, JumpMenu, Show
	Menu, JumpMenu, Delete	
}
LoadSettings(fPath:="") {
	initW  := 96
	incPix := 8
	dir    := ExpandEnv(fPath ? GetConfigDir(fPath):GetConfigDir())
	
	settings := { cfgDir:   dir
				, cfgPath:  dir "\Settings.ini"
				, initGuiW: initW
				, incPix:   incPix
				, limit:    ((initW/incPix)-Round(initW/incPix)=0 ? (initW/incPix) : (initW/incPix-1))
				, guiWidth: (2*incPix+initW) }
	
	defaults := { DefaultBrowser: "iexplore.exe"
				, FadeOnShow:     1
				, FadeOnExit:     1
				, FadeSpeed:      2
				, Transparency:   210
				, BackColor:      "Black"
				, TextColor:      "Aqua"
				, Font:           "Arial"
				, DClickAction:   "S"
				, NoInputAction:  "L" }
	
	if (!FileExist(settings.cfgPath))
		CreateConfig()
	
	for settingName, defaultVal in defaults {
		IniRead, %settingName%, % settings.cfgPath, GlobalSettings, %settingName%, %defaultVal%
		settings.Insert(settingName, %settingName%)
	}
}
LoadUserVars() {
	uVars := {SETTINGS:settings.cfgPath, ME:A_ScriptFullPath}
	
	IniRead, userVars, % settings.cfgPath, UserVars
	Loop, Parse, userVars, `n, `r
		if (RegExMatch(A_LoopField, "i)^\s*\$?(?P<Name>[^\s].*?)\s*=\s*(?P<Val>.*)\s*$", var))
			uVars.Insert(varName, RegExReplace(varVal, "\\$"))
	return uVars
}
m(t*) {
	opt:=4096, cnt:=0, icons:={x:16,"?":32,"!":48,i:64}, btns:={c:1,oc:1,co:1,ync:3,nyc:3,cyn:3,cny:3,yn:4,ny:4,rc:5,cr:5}
	for c, v in t {
		btn1:=ico1:=ttl1:=""
		if RegExMatch(v, "i)btn:(c|\w{2,3})", btn)||RegExMatch(v, "i)ico:(x|\?|\!|i)", ico)||RegExMatch(v, "i)(?:ttl|title):(.+)", ttl)
			opt+=btn1?btns[btn1]:ico1?icons[ico1]:0, title.=ttl1?ttl1:""
		else
			txt .= (txt ? "`n" : "") (v ? v : "")
	}
	MsgBox, % opt, % title, % txt
	IfMsgBox,OK
		return "OK"
	else IfMsgBox,Yes
		return "YES"
	else IfMsgBox,No
		return "NO"
	else IfMsgBox,Cancel
		return "CANCEL"
	else IfMsgBox,Retry
		return "RETRY"
}
MainGuiClick(ctrlId, event) {
	if (event != "DoubleClick")
		return
	action := settings.DClickAction = "E" ? "*edit """ A_ScriptFullPath """"
			: settings.DClickAction = "R" ? A_ScriptFullPath
			: settings.DClickAction = "A" ? EditSettings("Jump Launcher", settings.cfgPath, 1, 1)
			: settings.DClickAction = "S" ? "*edit """ settings.cfgPath """"
			: ""
	Run, % action ? action : A_ScriptFullPath
	ExitApp
}
MenuAction() {
	if (A_ThisMenuItem = "Application Settings") {
		EditSettings("Jump Launcher", settings.cfgPath, 1, 1)
		Run, % A_ScriptFullPath
		ExitApp
	}
	else if (A_ThisMenuItem = "Open Settings.ini File") {
		Run, % "*edit " settings.cfgPath
		ExitApp
	}
	else if (A_ThisMenuItem = "Quick Shortcut Editor") {
		if (FileExist("Config Edit.ahk"))
			Run, % """Config Edit.ahk"" """ settings.cfgPath """"
		else {
			m("Missing shortcut editor addin...")
			Run, % "*edit " settings.cfgPath
		}
	}
}
SetTxt(txt) {
	GuiControl,, InputTxt, %txt%
}
shortcutReplace(v) {
	uVarObj := LoadUserVars()
	while (RegExMatch(v, "i)\$(?P<Name>\w+)", var))
		StringReplace, v, v, % "$" varName, % uVarObj[varName], All
	return ExpandEnv(v)
}

showLabel(luLbl) {
	global str := luLbl
	GuiControl,, Static1, %str%
}
TrayMenu() {
	Menu, DefaultAHK, Standard
	Menu, Tray, NoStandard
	
	Menu, Tray, Add, Application Settings, MenuAction
	Menu, Tray, Add, Open Settings.ini File, MenuAction
	if (!A_IsCompiled) {
		Menu, Tray, Add
		Menu, Tray, Add, Default AHK Menu, :DefaultAHK
	}
	Menu, Tray, Add
	Menu, Tray, Add, Exit
	Menu, Tray, Default, % settings.DClickAction="A" ? "Application Settings" : "Open Settings.ini File"
	
	if (A_IsCompiled)
		Menu, Tray, Icon, % A_ScriptFullpath, -159
	else {
		if (!FileExist(ico:="Jump.ico")) {
			UrlDownloadToFile, http://files.wsnhapps.com/jump/Jump.ico, %ico%
			if (ErrorLevel)
				FileDelete, %ico%
		}
		Menu, Tray, Icon, % FileExist(ico) ? ico : ""
	}
	
	TrayTip()
}
TrayTip(t*) {
	static Version, appName
	
	Version:="1.3.5"
	txt := "Jump Launcher" (Version ? " v" Version : "") " is Running..."
	for c, v in t
		txt .= "`n" v
	Menu, Tray, Tip, % txt
}