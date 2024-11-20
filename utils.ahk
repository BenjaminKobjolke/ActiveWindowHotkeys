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

Edit:
    ; Check if we have a valid editor path
    if (editorPath = "" || !FileExist(editorPath)) {
        ; Ask user to select an editor
        FileSelectFile, selectedPath, 3, , Select your text editor, Applications (*.exe)
        if (selectedPath = "") {
            MsgBox, No editor was selected. Using default Notepad.
            editorPath := "notepad.exe"
        } else {
            editorPath := selectedPath
            ; Save the selected path to INI
            IniWrite, %editorPath%, settings.ini, Editor, Path
        }
    }
    
    ; Run the editor with Hotkeys.ahk instead of the current script
    Run, %editorPath% "%A_ScriptDir%\Hotkeys.ahk"
return

Reload:
	Reload
return 

Exit:
	ExitApp
return
