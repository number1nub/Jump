#NoEnv
#SingleInstance, Force
SetWorkingDir %A_ScriptDir%

configFile=%1%
configFile := configFile ? configFile : FileExist(fpath:=A_AppData "\JumpLauncher\Settings.ini") ? fPath : ""


try {
	oCfg := new Config(configFile)
}
catch e {
	msgbox, 4144, Config Edit, % e
	ExitApp
}

secCount    := oCfg.sectionCount
keyCount    := 20
ChangesMade := 0



;{===== Build GUI ====>>>

Gui, Font, s10 cWhite, Arial
Gui, Color, 444444, 46468C
Gui,  +alwaysontop +LastFound +Resize
Gui, +MinSize
;==> MAIN IMAGE <==;
if FileExist(A_ScriptDir "\res\Config Edit.png")
	Gui, Add, Picture, x5 y5 w128 h128, % A_ScriptDir "\res\Config Edit.png"

;==> SECTION DROP-DOWN <==;
Gui, Add, Text, x140 y10 +right +backgroundtrans, Category:
;~ Gui, Add, DropDownList, x200 y10 w485 h25 Choose2 r%secCount% vThisSection gSection_Change, % oCfg.Sections
Gui, Add, ListBox, x+5 yp r7 vThisSection gSection_Change, % oCfg.Sections

;==> KEY EDIT BOX <==;
Gui, Add, Text, x+15 yp+2 h30 Section +right +backgroundtrans, Key:
Gui, Add, ComboBox, x+3 yp-2 w287 h30 r%keyCount% +Disabled +AltSubmit vThisKey gKey_Change,

;==> VALUE EDIT BOX <==;
Gui, Add, Text, xs-7 y+5 +right +backgroundtrans, Value:
Gui, Add, Edit, x+1 yp w287 h87 +Disabled +wrap +multi vThisValue gValue_Change,

;==> LISTVIEW <==;
Gui, Font, s9 cBlack, Arial
;~ Gui, Add, Text, x20 y+25 +backgroundtrans veditNote, *Note:  Press F2 to directly edit row content
Gui, Add, ListView, x20 y+3 w665 h450 cWhite hwndLVhandle +AltSubmit vlvItem gLV_Event, Key|Value

;==> BUTTONS <==;
Gui, Add, Button, x240 y+10 w110 h35 +Disabled +Default vbtnSave gButtonSave, Save
Gui, Add, Button, x360 yp w115 h35 vbtnClose gButtonClose, Close

;==> SHOW GUI <==;
Gui, Show, , Settings Editor

goto, Section_Change

return

;}<<<==== Build GUI =====



Section_Change:
Gui, Submit, NoHide
GuiControl, % "Enable" thisSection, thisKey
GuiControl, % "Enable" thisSection, thisValue
LV_Delete()
if (!thisSection)
	return
sectKeys := "|"
sectKeys .= oCfg.Entries(thisSection)
GuiControl,, ThisKey, %sectKeys%
guiControl, +grid, lvItem
loop, parse, sectKeys, |
	if Trim(a_loopfield)
		LV_Add("", A_LoopField, oCfg.Value(A_LoopField))
LV_ModifyCol()
return


Key_Change:
LV_Modify(thisKey, "-focus")
LV_Modify(thisKey, "-select")
gui, submit, nohide
LV_GetText(curValue, thisKey, 2)
GuiControl,, thisValue, % curValue
LV_Modify(thisKey, "focus"), LV_Modify(thisKey, "select")
return


Value_Change:
ChangesMade := true
GuiControl, -disabled, btnSave
return


LV_Event:
if (A_GuiEvent = "Normal") {
	GuiControl, Choose, thisKey, % A_EventInfo
	LV_GetText(curValue, A_EventInfo, 2)
	GuiControl,, thisValue, % curValue
}
else if (A_GuiEvent = "K") {
	ControlGet, lvTxt, list, selected, lvItem
	;~ ControlGet, lvTxt, list, focused, lvItem
	LV_GetText(curTxt, A_EventInfo, 1)
	GuiControl,, thisValue, % curtxt
}
return


ButtonSave:
m("Not yet implemented...")
return


GuiSize:
;~ anchor("thisSection", "w")
anchor("thisKey", "w")
anchor("thisValue", "w")
anchor("lvItem", "wh")
anchor("editNote", "w")
anchor("btnSave", "x0.5y", true)
anchor("btnClose", "x0.5y", true)
return


ButtonClose:
GuiEscape:
GuiClose:
if (ChangesMade)
	if (m("All unsaved changes will be lost.`n","Are you sure you want to exit?","btn:yn","ico:!")!="Yes")
		return
ExitApp


Class Config
{
	static curSection := ""
	
	__New(filePath) {
		if !fileExist(filePath)
			throw "Unable to find given config file."
		this.oIni := new Ini(filePath)
		secList   := this.oIni.Sections()
		this.oSections := []
		
		loop, parse, secList, `n, `r
		{
			this.Sections .= (this.Sections ? "|" : "") A_LoopField
			this.oSections.Insert(A_LoopField)
			this.SectionCount := A_Index
		}
	}
	
	
	/*!
		Method: Entries(Sect [, selectIndex])
		Returns a pipe-separated list of keys that are in the given section
		Parameters:
		Sect - Name of the section whose keys will be returned
		selectIndex - (Optional) Index number of the item to be selected if
		used in a list control (separated with 2 pipes)
		Returns:
		Pipe-delimited list of key names
	*/
	Entries(Sect) {
		this.curSection := sect
		sectionKeys := "", kCount := 0
		sectKeys := this.oIni.Keys(Sect)
		loop, parse, sectKeys, `n, `r
		{
			sectionKeys .= (sectionKeys ? "|" : "") A_LoopField
			kCount := A_Index
		}
		this.keyCount := kCount
		return sectionKeys
	}
	
	/*!
		Method: Value(Key)
		Returns the value of the kiven key in the current section
		Parameters:
		Key - Name of the key whose value is returned
		Returns:
		The value of the given key, as a string, if found; otherwise an empty value is returned
	*/
	Value(Key) {
		return trim(this.oIni[this.curSection][key])
	}
	
}


class Ini
{
    __New(File, Default = "") {
        if (FileExist(File)) and (RegExMatch(File, "\.ini$"))
            FileRead, Info, % File
        else
            Info := File
        Loop, Parse, Info, `n, `r
		{
            if (!A_LoopField)
                Continue
            if (SubStr(A_LoopField, 1, 1) = ";") {
                Comment .= A_LoopField . "`n"
                Continue
            }
            RegExMatch(A_LoopField, "(?:^\[(.+?)\]$|(.+?)=(.*))", Info) ; Info1 = Seciton, Info2 = Key, Info3 = Value\
            if (Info1)
                Saved_Section := Trim(Info1), this[Saved_Section] := { }, this[Saved_Section].__Comments := Comment, Comment := ""
            Info3 := (Info3) ? Info3 : Default
            if (Info2) and (Saved_Section)
                this[Saved_Section].Insert(Trim(Info2), Info3) ; Set the section name withs its keys and values.
        }
    }
	
    __Get(Section) {
        if (Section != "__Section")
            this[Section] := new this.__Section()
    }
	
    class __Section
    {
        __Set(Key, Value) {
            if (Key = "__Comment") {
                Loop, Parse, Value, `n
				{
                    if (SubStr(A_LoopField, 1, 1) != ";") {
                        NewValue .= "; " . A_LoopField . "`n"
                        Continue
                    }
                    NewValue .= A_LoopField . "`n"
                }
                this.__Comments := NewValue
                Return NewValue
            }
        }
		
        __Get(Name) {
            if (Name = "__Comment")
                Return this.__Comments
        }
		
    }
	
    ; Renames an entire section or just an individual key.
    Rename(Section, NewName, KeyName = "") { ; if KeyName is omited, rename the seciton, else rename key.
        Sections := this.Sections(",")
        if Section not in %Sections%
            Return 1
        else if ((this.HasKey(NewName)) and (!KeyName)) ; if the new section already exists.
            Return 1
        else if ((this[Section].HasKey(NewName)) and (KeyName)) ; if the section already contains the new key name.
            Return 1
        else if (!this[Section].HasKey(KeyName) and (KeyName)) ; if the section doesn't have the key to rename.
            Return 1
        else if (!KeyName) {
            this[NewName] := { }
            for key, value in this[Section]
                this[NewName].Insert(Key, Value)
            this[NewName].__Comment := this[Section].__Comment
            this.Remove(Section)
        }
        else {
            KeyValue := this[Section][KeyName]
            this[Section].Insert(NewName, KeyValue)
            this[Section].Remove(KeyName)
        }
        Return 0
    }
	
    ; Delete a whole section or just a specific key within a section.
    Delete(Section, Key = "") { ; Omit "Key" to delete the whole section.
        if (Key)
            this[Section].Remove(Key)
        else
            this.Remove(Section)
    }
	
    ; Returns a list of sections in the ini.
    Sections(Delimiter = "`n") {
        for Section, in this
            List .= (this.Keys(Section)) ? Section . Delimiter : ""
        Return SubStr(List, 1, -1)
    }
	
    ; Get all of the keys in the entire ini or just one section.
    Keys(Section = "") { ; Leave blank to retrieve all keys or specify a seciton to retrieve all of its keys.
        Sections := Section ? Section : this.Sections()
        Loop, Parse, Sections, `n
            for key, in this[A_LoopField]
                keys .= (key = "__Comments" or key = "__Comment") ? "" : key . "`n"
        Return SubStr(keys, 1, -1)
    }
	
    ; Saves everything to a file.
    Save(File) {
        Sections := this.Sections()
        loop, Parse, Sections, `n
		{
            NewIni .= (this[A_LoopField].__Comments)
            NewIni .= (A_LoopField) ? ("[" . A_LoopField . "]`n") : ""
            For key, value in this[A_LoopField]
                NewIni .= (key = "__Comments" or key = "__Comment") ? "" : key . "=" . value . "`n"
            NewIni .= "`n"
        }
        FileDelete, % File
        FileAppend, % SubStr(NewIni, 1, -1), % File
    }
	
}