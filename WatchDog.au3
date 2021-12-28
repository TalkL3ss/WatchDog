#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <TrayConstants.au3>

Global $bWatch = True

TrayTip("Watchdog","Running!!!",10)
Opt("TrayMenuMode",3);
TraySetState($TRAY_ICONSTATE_SHOW)
Local $iWatch = TrayCreateItem("Pause Watchdog!",-1,-1,1)
TrayCreateItem("")
Local $iAbout = TrayCreateItem("About!",-1,-1,0)
Local $iExit = TrayCreateItem("Exit...",-1,-1,0)

While 1
   Sleep(1)
   $msg = TrayGetMsg()
   Select
   Case $msg = 0
	  WatchDog()
	  ContinueLoop
   Case $msg = $iAbout
	  MsgBox($MB_SYSTEMMODAL + $MB_ICONASTERISK,"WatchDog!!", "Simple Program just to Watch my hours recorded"&@CRLF&"Run c:\temp\hook.exe")
   Case $msg = $iExit
	  ExitLoop
   Case $msg = $iWatch
	  if $bWatch Then
		 $bWatch = False
	  Else
		 $bWatch = True
	  EndIf
	  TrayTip("Watchdog","Status is: " & $bWatch & " State!",5)
   EndSelect
WEnd

Func WatchDog()
   if $bWatch Then
	  if (ProcessExists("Hook.exe")) Then
		 $hWnd = WinWait("[CLASS:Notepad]", "", 10)
	  Else
		 Run("c:\temp\hook.exe")
	  EndIf
   EndIf
EndFunc
