# ActiveWindowHotkeys
Windows application that makes the same hotkey trigger a unique action for the active window.

Most of the time the F keys on your keyboard (F1 - F12) are unused.

## Why

Because usually the developers place functions for first time users on those keys.
Like F1 opens the help files most of the time.
But how often do you actually use that?

What if you could finally use those keys for those shortcuts you use all the time?
Maybe for those shortcuts that are hard to remembers and require multiple keys to be pressed at once?

**Here is the solution**

This application allows you to create new hotkeys.

---

## Installation
Run install.bat
This will copy Hotkeys_example.ahk to Hotkeys.ahk

## Configuration
Open Hotkeys.ahk in a text editor

---
### Global hotkeys
Global hotkeys are defined between
> ; ALL WINDOWS START

and

> ; ALL WINDOWS END

Default hotkeys:
- `F10` Show a popup with the available shortcuts for the current window
- `shift F9` move the mouse cursor to the center of the current window
- `alt F9` open a text editor with Hotkeys.ahk
- `ctrl F9` to reload the main script and Hotkeys.ahk

---

### Hotkeys for a specific window 
Hotkeys that work on a specific window are defined this way

1.  Find the name of the window 

    Note that you just need the part of the window title that stays the same.       
    For example chrome and firefox always add "- Browsername" at the end of the window title. Examples "- Google Chrome" and "- Mozilla Firefox"

2. add a new section to Hotkeys.ahk

    ```#IfWinActive, Mozilla Firefox```

3. add your hotkeys
    
    For example you want alt and r to trigger F5 in firefox

    ```
    ; Reload page
    !r::    
        Send, F5
    return
    ```

    **Explanation**

    `; Reload page` is for the help window when you press F10

    `!r::` is the hotkey combination that you need to press

    `Send, F5` is the command that you want to send to the application

    `return` the end of your hotkey




4. restart ActiveWindowHotkeys.exe

---

### How do I find out the syntax for the hotkeys?
This application is based on [Autohotkey](https://www.autohotkey.com).

You can find the documentation for the hotkey syntax here: 

[Autohotkey Hotkeys](https://www.autohotkey.com/docs/Hotkeys.htm)

#### Most important hotkeys

**F keys**
Example
F1 to open a new tab in chrome

```
F1::
; new tab
    Send, ^+t
return
```


**\# = winkey**

Example
Windows + b to show bookmarks in chrome

```
#b::
; open bookmarks
    Send, ^+o
return
```

---

**! = alt**

Example
alt + s to open a new window in chrome

```
!s::
; open a new window
    Send, ^n
return
```

**+ = shift**

Example
shift + 1 to open a new tab in chrome
```
+1::
; open a new tab
    Send, ^t
return
```

---
You can combine all those hotkeys.

Example
winkey aand shift and x to open cache settings in chrome
```
#+x::
; open cache settings
    Send, ^+{Del}
return
```

---
### What can I send with the `send` command?
Have a look at the autohotkey documentation

[Autohotkey Send](https://www.autohotkey.com/docs/commands/Send.htm)

### Are there other ways than the window title to assign hotkeys for a specific window
Yes, you can also use the class of the window.

To create a hotkey for the windows file explorer to create a new folder with ctrl and n you could do this
```
#IfWinActive, ahk_class CabinetWClass
^n::
; new folder
	Send, ^+n
return
```

### How to find the class of the window
Use the try icon menu entry "Window information"

![plot](./media/screenshot_01.png)

After selecting it click the window you want to get the information from.
A message box will open.

When you close the message box the information will be copied to your clipboard

Example notepad++

![plot](./media/screenshot_02.png)

You can then use this information for your hotkeys.

**using the title** 

```
#IfWinActive, - Notepad++
; Notepad++
^Right::
; ctrl and right arrow to go to the next tab
	Send, ^{PgDn}
return
```

**using the ahk_class** 

```
#IfWinActive, ahk_class Notepad++
; Notepad++
^Right::
; ctrl and right arrow to go to the next tab
	Send, ^{PgDn}
return
```

**using the ahk_exe** 

```
#IfWinActive, ahk_exe notepad++.exe
; Notepad++
^Right::
; ctrl and right arrow to go to the next tab
	Send, ^{PgDn}
return
```