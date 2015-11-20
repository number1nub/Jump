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



#Include <Anchor>
#Include <Args>
#Include <Backspace>
#Include <Class StringBase>
#Include <CreateConfig>
#Include <DecrementWidth>
#Include <EditSettings>
#Include <Evaluate>
#Include <Exit>
#Include <ExpandEnv>
#Include <FadeInGUI>
#Include <FadeOutGUI>
#Include <GetConfigDir>
#Include <GetDropbox>
#Include <GetTxt>
#Include <GuiContextMenu>
#Include <GuiDropFiles>
#Include <Hotkeys>
#Include <IncrementWidth>
#Include <InputChar4Lookup>
#Include <InputChar>
#Include <InputLookup>
#Include <InsertHistory>
#Include <InvBase64>
#Include <JumpMenu>
#Include <LoadSettings>
#Include <LoadUserVars>
#Include <m>
#Include <MainGuiClick>
#Include <MenuAction>
#Include <SetTxt>
#Include <ShortcutReplace>
#Include <ShowLabel>
#Include <TrayMenu>
#Include <TrayTip>