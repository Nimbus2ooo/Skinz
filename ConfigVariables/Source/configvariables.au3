#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ScrollBarConstants.au3>
#include <array.au3>
#include <GuiStatusBar.au3>
#include <GuiEdit.au3>
#include <GuiButton.au3>
#include <Misc.au3>
#include <String.au3>
#Include <File.au3>
Opt("TrayIconHide", 1)

$var = IniRead("cvsettings.inc", "Refresh", "Command","")
$var2 = IniRead("cvsettings.inc", "BackgroundColor", "Hex","")
$var3 = IniRead("cvsettings.inc", "Font", "FontFace","")
$var4 = IniRead("cvsettings.inc", "TaskbarTitle", "Title","")
$var5 = IniRead("cvsettings.inc", "PanelWidth", "Width","")
$var6 = IniRead("cvsettings.inc", "PanelHeight", "Height","")
$var7 = IniRead("cvsettings.inc", "DescriptionLines", "DescriptLines","")
$var8 = IniRead("cvsettings.inc", "FontSize", "FontHeight","")
$var9 = IniRead("cvsettings.inc", "HeaderImage", "Image","")

$Gui = GUICreate($var4, $var5, $var6, -1, -1, BitOR($WS_SYSMENU, $WS_POPUP, $WS_POPUPWINDOW, $WS_BORDER, $WS_CLIPSIBLINGS))
GUISetBkColor($var2)

$Drag = GUICtrlCreatePic($var9, 0, 0, $var5, 60, Default, $GUI_WS_EX_PARENTDRAG)

$VariableList = GUICtrlCreateList("", 15, 68, $var5-35, $var6-$var7*($var8*2)-91, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSetFont(-1, $var8, 400, 0, $var3)
$VariableDescripton = GUICtrlCreateLabel("", 15, $var6-$var7*($var8*2)-38, $var5-30, $var7*($var8*2))
GUICtrlSetFont(-1, $var8, 400, 0, $var3)
GUICtrlSetColor(-1, 0x000000)
$VariableInput = GUICtrlCreateInput("", 15, $var6-40, $var5-90, 32)
GUICtrlSetFont(-1, $var8-1, 400, 0, "Segoe UI")
$ExitButton = GUICtrlCreateLabel("x", $var5-20, 60, 20, 18, $SS_CENTER)
GUICtrlSetFont(-1, $var8-1, 400, 0, "Segoe UI")
GUICtrlSetCursor(-1, 0)
GUICtrlSetOnEvent($ExitButton, "clickedExit")
$SetButton = GUICtrlCreateButton("Set", $var5-70, $var6-41, 55, 33)
GUICtrlSetFont(-1, $var8-1, 400, 0, "Segoe UI")

GUISetState(@SW_SHOW)

Dim $VarName[200]
Dim $VarDescription[200]
Dim $iniFiles[200]
Dim $VarCount = 0
Dim $FilesCount = 0
Dim $EndIt = 0
Dim $Foundini = 0

$CfgFile = FileOpen ("RainConfigure.cfg", 0)
$VariableSection = FileReadLine ($CfgFile)

Do
	$VarCount = $VarCount + 1
	$VarName[$VarCount] = FileReadLine ($CfgFile)
	$VarDescription[$VarCount] = FileReadLine ($CfgFile)
	If $VarName[$VarCount] = "[Files]" Then $EndIt = 1
Until $EndIt = 1

$iniFiles[1] = $VarDescription[$VarCount]
$FilesCount = $FilesCount + 1

While @error <> -1
	$FilesCount = $FilesCount + 1
	$iniFiles[$FilesCount] = FileReadLine ($CfgFile)
WEnd

FileClose ($CfgFile)
$VarCount = $VarCount - 1
$FilesCount = $FilesCount - 1

For $ListCount = 1 to $VarCount
GUICtrlSetData($VariableList,$VarName[$ListCount] & "|")
Next

While 1

	$nMsg = GUIGetMsg()

	Switch $nMsg

		Case $GUI_EVENT_CLOSE
			FileClose($CfgFile)
			Exit

	Case $ExitButton
			FileClose($CfgFile)
			Sleep(300)
			Exit


		Case $VariableList
			$CurrentVarName = GUICtrlRead($VariableList)
			For $ListCount = 1 to $VarCount
				if $VarName[$ListCount] = $CurrentVarName Then
					$CurrentVarDescription = $VarDescription[$ListCount]
				EndIf
			Next
			GUICtrlSetData($VariableDescripton, $CurrentVarDescription)
			For $ListCount = 1 to $FilesCount
				$Temp = IniRead($iniFiles[$ListCount], "Variables", $CurrentVarName,"")
				If $Temp <> "" then
					$ini2Edit = $iniFiles[$ListCount]
					GUICtrlSetData($VariableInput, $Temp)
					ExitLoop
				EndIf
			Next

		Case $SetButton

			For $ListCount = 1 to $FilesCount
				$Temp = IniRead($iniFiles[$ListCount], "Variables", $CurrentVarName,"")
				ShellExecute("refresh.exe", $var)
				If $Temp <> "" then
					IniWrite ($iniFiles[$ListCount], "Variables", $CurrentVarName, GUICtrlRead($VariableInput))
				EndIf
			Next

EndSwitch
WEnd