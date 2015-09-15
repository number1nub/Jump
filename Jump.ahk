#NoTrayIcon
#SingleInstance, Ignore
SetWorkingDir, %A_ScriptDir%
SetTitleMatchMode, 2
SetControlDelay, 0
SetBatchLines, -1

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



#Include Lib\Anchor.ahk
#Include lib\Args.ahk
#Include lib\Backspace.ahk
#Include lib\Class StringBase.ahk
#Include lib\CreateConfig.ahk
#Include lib\DecrementWidth.ahk
#Include lib\EditSettings.ahk
#Include lib\Evaluate.ahk
#Include lib\Exit.ahk
#Include Lib\ExpandEnv.ahk
#Include lib\FadeInGUI.ahk
#Include lib\FadeOutGUI.ahk
#Include lib\GetConfigDir.ahk
#Include lib\GetDropbox.ahk
#Include lib\GetTxt.ahk
#Include lib\GuiContextMenu.ahk
#Include lib\GuiDropFiles.ahk
#Include lib\Hotkeys.ahk
#Include lib\IncrementWidth.ahk
#Include lib\InputChar4Lookup.ahk
#Include lib\InputChar.ahk
#Include lib\InputLookup.ahk
#Include lib\InsertHistory.ahk
#Include lib\InvBase64.ahk
#Include lib\JumpMenu.ahk
#Include lib\LoadSettings.ahk
#Include lib\LoadUserVars.ahk
#Include lib\m.ahk
#Include lib\MainGuiClick.ahk
#Include lib\MenuAction.ahk
#Include lib\SetTxt.ahk
#Include lib\ShortcutReplace.ahk
#Include lib\ShowLabel.ahk
#Include lib\TrayMenu.ahk
#Include lib\TrayTip.ahk