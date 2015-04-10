#NoEnv
#SingleInstance, force
SetWorkingDir, %A_ScriptDir%


menu, tray, add, Launch Jump, Launch
menu, tray, Default, Launch Jump

if (A_IsCompiled)
	menu, tray, icon, %A_scriptfullpath%, -159
else
	menu, tray, icon, % FileExist(mIco := (A_ScriptDir "\res\Jump.ico")) ? mIco : ""


Launch:
!`::Run, Jump.ahk
