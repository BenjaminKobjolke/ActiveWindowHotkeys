;@Ahk2Exe-SetMainIcon icon.ico
;@Ahk2Exe-ExeName %A_ScriptDir%\bin\ActiveWindowHotkeys.exe

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance force
#Persistent ;Script nicht beenden nach der Auto-Execution-Section

SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2

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


return

WindowInformation:
	hCursor := DllCall("LoadImage", "Uint", 0, "Uint", 32515, "Uint", 2, "Uint", 0, "Uint", 0, "Uint", 0x8000)

	; And than we set all the default system cursors to be our choosen cursor. CopyImage is necessary as SetSystemCursor destroys the cursor we pass to it after using it.
	Cursors = 32650,32512,32515,32649,32651,32513,32648,32646,32643,32645,32642,32644,32516,32514
	Loop, Parse, Cursors, `,
	{
		DllCall("SetSystemCursor", "Uint", DllCall("CopyImage", "Uint", hCursor, "Uint", 2, "Int", 0, "Int", 0, "Uint", 0), "Uint", A_LoopField)
	}

	KeyWait, LButton, D
	RestoreCursors()
	WinGetTitle, winTitle, A
	WinGetClass, winClass, A
	WinGet, winExe, ProcessName, A		
	output = %winTitle%`nahk_class %winClass%`nahk_exe %winExe%
	MsgBox, ,  Window information, title: %output%
	clipboard := output
return

RestoreCursors() 
{
	SPI_SETCURSORS := 0x57
	DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
}

generateHelp:
	global toolTipVisble
	if(toolTipVisble = 1) {
		GoSub, RemoveToolTip
		return
	}
	
	
	outputStringAll := ""	
	WinGetActiveTitle, currentTitle
	WinGetClass, currentClass, A
	WinGet, currentExe, ProcessName, A
	;M sgBox, %currentTitle% %currentClass% %currentExe%
	;M sgBox, %currentClass%	
	
	;first get the general help for shortcuts available to all windows
	Loop, read, Hotkeys.ahk
	{
		LineNumber := A_Index
		;M sgBox, Line %LineNumber%
		Loop, parse, A_LoopReadLine, `n, `r
		{
			;M sgBox, 4, , Field %LineNumber%-%A_Index% is:`n%A_LoopField%`n`nContinue?
			foundPos := InStr(A_LoopReadLine, "; ALL WINDOWS START")
			
			if(foundPos = 1) {		
				; now we continue until we find the "; ALL WINDOWS END" line
				
				targetLineNum := LineNumber + 1
				outputStringAll := generateHelpForCurrentWindow("; ALL WINDOWS END", targetLineNum)							
				break				
			}        
		}
	}
	
	;for debug
	;currentTitle = - Remember The Milk
	outputStringCurrent := ""
	Loop, read, Hotkeys.ahk
	{
		LineNumber := A_Index		
		Loop, parse, A_LoopReadLine, `n, `r
		{
			;MsgBox, 4, , Field %LineNumber%-%A_Index% is:`n%A_LoopField%`n`nContinue?
			foundPos := InStr(A_LoopReadLine, "#IfWinActive,")
			if(foundPos = 1) {
				compactText := RegExReplace(A_LoopReadLine, "S) +", A_Space)
				cArray := StrSplit(compactText, "#IfWinActive,")
				foundString := cArray[2]
				foundType = ""
				foundTitle = ""
				hasType := InStr(foundString, "ahk_class")
				if(hasType < 1) {
					hasType := InStr(foundString, "ahk_exe")
				}				
				if(hasType > 0) {															
					cArray := StrSplit(foundString, A_SPACE, A_Space)				
					foundType := cArray[2]
					foundTitle := cArray[3]
					;M sgBox, has type %foundType% | %foundTitle%
				} else {
					foundTitle := foundString
				}
				
				
				found := 0
				if(foundType = "ahk_class") {					
					found := InStr(currentClass, foundTitle)
					/*
					if(found > 0) {
						MsgBox, found class %LineNumber% %currentClass% %foundTitle%
					}
					*/
				} else if( foundType = "ahk_exe") {
					;M sgBox, %currentExe% %foundTitle%
					found := InStr(currentExe, foundTitle)					
					/*
					if(found > 0) {
						MsgBox, found exe %LineNumber% %currentExe% %foundTitle%
					}
					*/					
				} else {					
					found := InStr(currentTitle, foundTitle)	
					/*
					if(found > 0) {					
						MsgBox, found title %LineNumber% %currentTitle% title:%foundTitle% type:%foundType%
					}
					*/
				}	
				
				if(found > 0) {
					; now we continue until we find the next #IfWinActive line					
					targetLineNum := LineNumber + 1
					;MsgBox, Line %targetLineNum%
					output := generateHelpForCurrentWindow("#IfWinActive,", targetLineNum)		
					;M sgBox, %output%					
					outputStringCurrent = %outputStringCurrent%%output%
				}
			}        
		}
	}

	toolTipVisble := 1
	length1 := StrLen(outputStringAll)
	length2 := StrLen(outputStringCurrent)
	if(length1 > 0 || length2 > 0) {
		if(length2 < 1) {
			ToolTip, HOTKEYS`n`n%outputStringAll%
		} else {
			ToolTip, HOTKEYS`n`n%outputStringAll%`nActive window`n%outputStringCurrent%
		}
	} else {
		ToolTip, No hotkeys available for this window
	}
	SetTimer, RemoveToolTip, -5000			
return

generateHelpForCurrentWindow(endString, targetLineNum) {
	outputString = 
	currentHint = 
	shouldGenerateHelp := 0
	exitLoops := 0
	;M sgBox, %targetLineNum%
	Loop, read, Hotkeys.ahk
	{
		;M sgBox, index is %A_Index%
		if(A_Index < targetLineNum) {
			continue
		}

		;M sgBox, inside loop %targetLineNum%
		targetLineNum := A_Index
		
		;M sgBox, Line %LineNumber%
		Loop, parse, A_LoopReadLine, `n, `r
		{
			if(exitLoops > 0) {
				break
			}			
			;M sgBox, checking line: %A_LoopReadLine%
			foundPos := InStr(A_LoopReadLine, endString)
			if(foundPos = 1) {
				;M sgBox, We are out
				exitLoops := 1
				break
			}
			if(exitLoops > 0) {
				break
			}
			if(shouldGenerateHelp = 0) {
				foundPos := InStr(A_LoopReadLine, ";")				
				if(foundPos > 0) {
					shouldGenerateHelp := 1
					windowTitleArray := StrSplit(A_LoopReadLine, ";")
					windowTitle = % Trim(windowTitleArray[2])
					;outputString = %outputString%%windowTitle%`n		
					currentHint = %windowTitle%
				}
				;MsgBox, %outputString%
			} else {		
				
				foundPos := InStr(A_LoopReadLine, "::")
				if(foundPos > 1) {
					FileReadLine, shortcut, Hotkeys.ahk, targetLineNum			
					shortcutArray := StrSplit(shortcut, "::") 
					shortcut = % shortcutArray[1]					
					/*
					targetLineNum += 1
					FileReadLine, comment, Hotkeys.ahk, targetLineNum
					StringTrimLeft, comment, comment, 1
					outputString = %outputString%%shortcut% : %comment%`n
					*/
					outputString = %outputString%%shortcut% - %currentHint%`n
					currentHint = 
					shouldGenerateHelp := 0
					;M sgBox, %outputString%
				}
			}	

			if(exitLoops > 0) {
				break
			}				
		}
		
	}
	
	return outputString
}



RemoveToolTip:
	ToolTip
	toolTipVisble := 0
return

Reload:
	Reload
return 

Edit:
	Run, C:\Program Files (x86)\Notepad++\notepad++.exe "%A_ScriptFullPath%"
return

Exit:
	ExitApp
return


	

