#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.uytu
#SingleInstance Force ; Allow only one running instance of script.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

whatfile :="macro.ahk"

   Loop,
   {
	  Input, Var, L1 V E, {LButton},{enter}
	  
	  text:="`nSend {" Var "} `n"  
	  text2:="Sleep, " 20 "`n"
	  
	  	FileAppend, 
		(
		 %text%
		 %text2%
		), %whatfile% 

   }
