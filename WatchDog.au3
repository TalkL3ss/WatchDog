#include <MsgBoxConstants.au3>
;#include <AutoItConstants.au3>
#include <TrayConstants.au3>

Global $bWatch = True

Local $sFilePath = "Settings.ini"
Local $FileToRun = IniRead ($sFilePath, "Main", "AppToWatch", "Hook.exe" )
Local $ProcToCheck = IniRead ($sFilePath, "Main", "ProcToCheck", "Hook.exe" )
Local $WindowCLS =  IniRead ($sFilePath, "Main", "WindowCLS", "[CLASS:ConsoleWindowClass]" )

TrayTip("Watchdog","Running!!!",5)
Opt("TrayMenuMode",1);
TraySetState($TRAY_ICONSTATE_SHOW)
Local $iWatch = TrayCreateItem("Pause Watchdog!")
TrayCreateItem("")
Local $iSettings = TrayCreateItem("Create Settings File")
Local $iPresist = TrayCreateItem("Create Registry Presist")
TrayCreateItem("")
Local $iAbout = TrayCreateItem("About!")
Local $iExit = TrayCreateItem("Exit...")

While 1
   Sleep(1)
   TrayItemSetState ($iSettings, $TRAY_UNCHECKED)
   TrayItemSetState ($iAbout, $TRAY_UNCHECKED)
   TrayItemSetState ($iPresist, $TRAY_UNCHECKED)
   $msg = TrayGetMsg()
   Select
   Case $msg = 0
	  WatchDog()
	  ContinueLoop
   Case $msg = $iAbout
	  MsgBox($MB_SYSTEMMODAL + $MB_ICONASTERISK,"WatchDog!!", "Simple Program just to Watch my hours recorded"&@CRLF&"Run .\hook.exe" _
	  &@CRLF&"You Can watch other exe file by press create settings file and fill it")
   Case $msg = $iExit
	  ExitLoop
   Case $msg = $iWatch
	  if $bWatch Then
		 $bWatch = False
	  Else
		 $bWatch = True
	  EndIf
	  TrayTip("Watchdog","Watchdog Status is: " & $bWatch & " State!",2)
   Case $msg = $iSettings
	  If Not (FileExists ( $sFilePath )) Then
		 IniWrite($sFilePath, "Main", "AppToWatch", "Hook.exe" )
		 IniWrite($sFilePath, "Main", "ProcToCheck", "Hook.exe" )
		 IniWrite($sFilePath, "Main", "WindowCLS", "[CLASS:ConsoleWindowClass]")
	  EndIf
	  ShellExecute ($sFilePath)
   Case $msg = $iPresist
	 RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "WatchDog", "REG_SZ", '"'&@AutoItExe&'"')
   EndSelect
WEnd

Func WatchDog()
   if $bWatch Then
	  if (ProcessExists($ProcToCheck)) Then
		 $hWnd = WinWait($WindowCLS, "", 10)
	  Else
		 Run($FileToRun)
	  EndIf
   EndIf
EndFunc
