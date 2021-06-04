#NoEnv
#SingleInstance Force
OnClipboardChange("CBC")
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
SendMode Input
Gui OSD:New,+AlwaysOnTop +ToolWindow
Gui Font,s9,Consolas
WPX:=900,WPY:=500,WPD:=0
Gui Add,Edit,x-2 y-2 w1900 h154 vTXT ReadOnly VScroll,Clipboard Empty...
Gui Show,NoActivate x%WPX% y%WPY% w150 h140,Preview:
WinSet Transparent,200,Preview:
If !WPD
  Gui OSD:Hide
Clipboard:=Clipboard

; ### Initialise Ctrl+_ and __/ Hotkeys|strings ###
Loop 10
  HotKey % "^" SubStr(A_Index,0),HKY
Loop 99
  Hotstring(":X*:" A_Index "/","HKY",On) ;<- Change the backslash!
Return

; ### Controls Toggle Preview/Quit ###
^F1::Gui % (WPD:=!WPD)?"OSD:Show":"OSD:Hide",NoActivate   ;Ctrl+F1
^Esc::                                                    ;Ctrl+Esc
  WinGetPos,WGX,WGY,,,Preview:
  FileCopy % A_ScriptName,% A_ScriptName ".bak"
  FileRead TMP,% A_ScriptName
  TMP:=RegExReplace(TMP,"`am)^WPX:=.*$","WPX:=" WGX ",WPY:=" WGY ",WPD:=" WPD)
  FileDelete % A_ScriptName
  FileAppend % TMP,% A_ScriptName
  ExitApp
OSDGuiClose:
  Gui OSD:Hide
  WPD:=0
Return

; ### Process Clipboard ###
CBC(Type){
  Global
  If (Type=1){
    ARR:=[],OSD:="",WPD:=1
    Loop Parse,Clipboard,`n,`r
    {
      ARR[A_Index]:=A_Loopfield
      OSD.=SubStr("00" A_Index,-1) ":" ARR[A_Index]"`n"
    }
    Gui OSD:Show,NoActivate
    GuiControl OSD:,TXT,% RegExReplace(OSD,"`n$")
  }
}

; ### Main Send Code ###
HKY:
  If (SubStr(A_ThisHotkey,1,1)="^")
    CNT:=SubStr(A_ThisHotkey,0)
  Else If (SubStr(A_ThisHotkey,1,1)=":")
    CNT:=SubStr(A_ThisHotkey,5,StrLen(A_ThisHotkey)-5)
    CNT:=% !CNT?10:CNT
  If ARR[CNT]{
    Send % "{Raw}"ARR[CNT]
    Send {Enter}
  }
Return
