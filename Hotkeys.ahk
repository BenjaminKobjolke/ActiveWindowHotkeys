; ALL WINDOWS START
; Show help
F10::
	GoSub, generateHelp
return

; Move mouse to current window
F9::
    WinGetPos, winTopL_x, winTopL_y, width, height, A
    winCenter_x := winTopL_x + width/2
    winCenter_y := winTopL_y + height/2
    DllCall("SetCursorPos", int, winCenter_x, int, winCenter_y)
return
; ALL WINDOWS END

#IfWinActive, Mozilla Firefox
; ctrl and right arrow to go to the next tab
^Right::
	Send, ^{PgDn}
return

; ctrl and left arrow to go to the previous tab
^Left::
	Send, ^{PgUp}
return

; Reload page
!r::
    Send, F5
return

#IfWinActive, - Google Chrome
; new tab
F1::
    Send, ^t
return
; ctrl and right arrow to go to the next tab
^Right::
	Send, ^{PgDn}
return

; ctrl and left arrow to go to the previous tab
^Left::
	Send, ^{PgUp}
return

#IfWinActive, - Mozilla Thunderbird
;Get all emails
F1::
	Send, +{F5}
return

;New E-Mail
F2::
	Send, ^n
return

#IfWinActive, ahk_class Chrome_WidgetWin_1
; test shortcut 3
#z::
	Send, 3
return

#IfWinActive, Notepad++
; ctrl and right arrow to go to the next tab
^Right::
	Send, ^{PgDn}
return

; ctrl and left arrow to go to the previous tab
^Left::
	Send, ^{PgUp}
return
