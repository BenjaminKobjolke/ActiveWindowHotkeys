; ALL WINDOWS START
; Show help
F10::
	GoSub, generateHelp
return

; Reload Main script and Hotkeys.ahk
^F9::
	ToolTip, Reloading ActiveWindowHotkeys...
	Sleep, 1000
	ToolTip,
	Reload
return

; Edit Hotkey.ahk
!F9::
	GoSub, Edit
return

; Move mouse to current window
+F9::
    WinGetPos, winTopL_x, winTopL_y, width, height, A
    winCenter_x := winTopL_x + width/2
    winCenter_y := winTopL_y + height/2
    ;MouseMove, X, Y, 0 ; does not work with multi-monitor
    DllCall("SetCursorPos", int, winCenter_x, int, winCenter_y)
    ;Tooltip winTopL_x:%winTopL_x% winTopL_y:%winTopL_y% winCenter_x:%winCenter_x% winCenter_y:%winCenter_y%
return
; ALL WINDOWS END


#IfWinActive, - Evernote
;Focus on 1st entry in favorites / shortcuts
F1::
	Send, ^1	
return

;Focus on notes
F2::
	Send, !+^n
return

;Move note to another notebook
F4::
	Send, !+m
return


;Edit note tags
!t::
	Send, !^t
return


#IfWinActive, Mozilla Firefox
; Firefox
^!Tab::
;Switch Tabs
	Send, ^{PgDn}
return

^!+Tab::
;Switch Tabs Backwards
	Send, ^{PgUp}
return

#IfWinActive, - Google Chrome
; Chrome
^!Tab::
;Switch Tabs
	Send, ^{PgDn}
return

^!+Tab::
;Switch Tabs Backwards
	Send, ^{PgUp}
return


#IfWinActive, - IrfanView
; IrfanView
F1::
;Export to Photoshop
	Send, +e
return

#IfWinActive, ahk_class Photoshop
; Photoshop
F1::
;Export
	Send, ^+!w
return

#IfWinActive, - Notepad++
; Notepad++
^!Tab::
;Switch Tabs
	Send, ^{PgDn}
return

#IfWinActive, ahk_class Winamp v1.x
; Winamp
^!Tab::
; Start / Stop Playback
	Send, x
return