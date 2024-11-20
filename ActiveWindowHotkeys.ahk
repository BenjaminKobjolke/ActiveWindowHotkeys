;@Ahk2Exe-SetMainIcon icon.ico
;@Ahk2Exe-ExeName %A_ScriptDir%\bin\ActiveWindowHotkeys.exe

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance force
#Persistent ;Script nicht beenden nach der Auto-Execution-Section

SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2

; Load editor path from INI
IniRead, editorPath, settings.ini, Editor, Path, %A_Space%

if (!a_iscompiled) {
	Menu, tray, icon, icon.ico,0,1
	Menu, tray, add, Edit 
	Menu, tray, add  ; Creates a separator line.	
}
Menu, tray, NoStandard 

Menu, tray, add, Window informaton, WindowInformation
Menu, tray, add, Reload  	
Menu, tray, add, Exit

toolTipVisble := 0

#Include Hotkeys.ahk
#Include help.ahk
#Include utils.ahk

return
