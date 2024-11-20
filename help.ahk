replaceHotkeySymbols(shortcut) {
    ; First collect all modifiers
    modifiers := ""
    if (InStr(shortcut, "^"))
        modifiers .= "Ctrl+"
    if (InStr(shortcut, "!"))
        modifiers .= "Alt+"
    if (InStr(shortcut, "+"))
        modifiers .= "Shift+"
    if (InStr(shortcut, "#"))
        modifiers .= "Win+"
    
    ; Remove all modifier symbols from the original shortcut
    shortcut := RegExReplace(shortcut, "[!+^#]", "")
    
    ; Combine modifiers with the remaining key
    return modifiers . shortcut
}

generateHelpForCurrentWindow(endString, targetLineNum) {
	outputString = 
	currentHint = 
	shouldGenerateHelp := 0
	exitLoops := 0
	
	Loop, read, Hotkeys.ahk
	{
		if(A_Index < targetLineNum) {
			continue
		}

		targetLineNum := A_Index
		
		Loop, parse, A_LoopReadLine, `n, `r
		{
			if(exitLoops > 0) {
				break
			}			
			foundPos := InStr(A_LoopReadLine, endString)
			if(foundPos = 1) {
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
					currentHint = %windowTitle%
				}
			} else {		
				
				foundPos := InStr(A_LoopReadLine, "::")
				if(foundPos > 1) {
					FileReadLine, shortcut, Hotkeys.ahk, targetLineNum			
					shortcutArray := StrSplit(shortcut, "::") 
					shortcut = % shortcutArray[1]
					shortcut := replaceHotkeySymbols(shortcut)					
					outputString = %outputString%%shortcut% - %currentHint%`n
					currentHint = 
					shouldGenerateHelp := 0
				}
			}	

			if(exitLoops > 0) {
				break
			}				
		}
		
	}
	
	return outputString
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
	
	;first get the general help for shortcuts available to all windows
	Loop, read, Hotkeys.ahk
	{
		LineNumber := A_Index
		Loop, parse, A_LoopReadLine, `n, `r
		{
			foundPos := InStr(A_LoopReadLine, "; ALL WINDOWS START")
			
			if(foundPos = 1) {		
				; now we continue until we find the "; ALL WINDOWS END" line
				targetLineNum := LineNumber + 1
				outputStringAll := generateHelpForCurrentWindow("; ALL WINDOWS END", targetLineNum)							
				break				
			}        
		}
	}
	
	outputStringCurrent := ""
	Loop, read, Hotkeys.ahk
	{
		LineNumber := A_Index		
		Loop, parse, A_LoopReadLine, `n, `r
		{
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
				} else {
					foundTitle := foundString
				}
				
				found := 0
				if(foundType = "ahk_class") {					
					found := InStr(currentClass, foundTitle)
				} else if( foundType = "ahk_exe") {
					found := InStr(currentExe, foundTitle)					
				} else {					
					found := InStr(currentTitle, foundTitle)	
				}	
				
				if(found > 0) {
					; now we continue until we find the next #IfWinActive line					
					targetLineNum := LineNumber + 1
					output := generateHelpForCurrentWindow("#IfWinActive,", targetLineNum)		
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

RemoveToolTip:
	ToolTip
	toolTipVisble := 0
return
