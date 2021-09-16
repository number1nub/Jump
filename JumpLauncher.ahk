#NoEnv
#SingleInstance, force
SetWorkingDir, %A_ScriptDir%

menu, tray, add, Launch Jump, Launch
menu, tray, Default, Launch Jump
menu, tray, icon, % A_IsCompiled ? A_scriptfullpath : (FileExist(mIco:=(A_ScriptDir "\res\Jump.ico")) ? mIco:""), % A_IsCompiled ? "-159":""

Launch:
	!`::Run, Jump.ahk