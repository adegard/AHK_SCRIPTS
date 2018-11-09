#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.uytu
#SingleInstance Force ; Allow only one running instance of script.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

posX := []
posY := []
i := 0
Var:=""
recording := true
FormatTime, TimeString,, HHmmss
CoordMode, Mouse, Screen


;whatfile :="macro_" TimeString ".ahk"
whatfile :="macro.ahk"
;MsgBox The current time and date (time first) is %whatfile%.


TMI := 70	  ;in recording
TMR := 100  ;Replay
;MsgBox,0,res,%TMR%
MouseSpeed := 2

;**************
;STRAT RECORDING
^r:: 

; TOOLTIP
CustomColor = FFFFFF  ; Can be any RGB color (it will be made transparent below).

Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, %CustomColor%
Gui, Font, s32  ; Set a large font size (32-point).
Gui, Add, Text, vMyText cLime, Recording...Ctrl+d to STOP  ; XX & YY serve to auto-size the window.
WinSet, TransColor, %CustomColor% 150
Gui, Show, x100 y400 NoActivate  ; NoActivate avoids deactivating the currently active window.



recording := true
while(recording = true)
{
	
	
	if(i=0)
	{
		FileDelete, %whatfile%
		
		FileAppend, 
			(
			`n#NoEnv
			`nSetWorkingDir %A_ScriptDir%
			`nCoordMode, Mouse, Screen
			`nSendMode Input
			`n#SingleInstance Force
			`nSetTitleMatchMode 2
			`n#WinActivateForce
			`nSetControlDelay 1
			`nSetWinDelay 0
			`nSetKeyDelay -1
			`nSetMouseDelay -1
			`nSetBatchLines -1
			), %whatfile% 
		
		run, recorde_keys.ahk	
	}
	
	
	MouseGetPos, x, y
	posX[i] := x
	posY[i] := y
	

	; check click 
	if(GetKeyState("LButton", "P"))
	{
		FileAppend, 
			(
			`nMouseMove, %x%, %y%, %MouseSpeed%
			`nsleep %TMR%
			`nsleep 4
			`nClick, down
			`nsleep 23
			`nClick, up
			`nsleep 15
			), %whatfile% 
		
	}
	
	
	;check mouse moves
	FileAppend, 
		(
		 `nMouseMove, %x%, %y%, %MouseSpeed%
		 `nsleep %TMR%
		), %whatfile% 
	
	
	
	sleep %TMI%
	i++
	
	
}
return

;***************** NOT USED (ONLY MOUSE MOVES)************
^e:: ; replay
		recording := false
		i := 0
		l := posX.Length()
		while(i <=l)
		{
			x := posX[i]
			y := posY[i]
			MouseMove, %x%, %y%
			sleep %TMR%
			i := i+1
}

return

;************************
^d::  ;exit
recording := false

;fullScriptPath = C:\Users\degar_000\Google Drive\Web Marketing\script\growth hacking\recorde_keys.ahk  ; edit with your full script path

DetectHiddenWindows, On 
WinClose, %A_ScriptDir%\recorde_keys.ahk ahk_class AutoHotkey


FileAppend, 
		(
		`nEsc:: ExitApp
		`nExitApp
		), %whatfile% 
Gui, cancel	
Reload
return
;********************************

