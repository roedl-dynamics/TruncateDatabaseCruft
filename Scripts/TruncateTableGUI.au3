#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Scissors.ico
#AutoIt3Wrapper_Outfile=..\TruncateDatabaseCruft.exe
#AutoIt3Wrapper_Outfile_x64=..\TruncateDatabaseCruft.exe
#AutoIt3Wrapper_Res_Fileversion=1.0.0.40
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_CompanyName=Rödl Dynamics GmbH
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Henryk Ohls

 Script Function:
	GUI for truncating tables.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstantsEx.au3>
#include <Array.au3>

If (DirCreate(@TempDir & '\Scripts\')) Then
	FileInstall(".\TruncateTables.ps1", @TempDir & '\Scripts\TruncateTables.ps1')
	FileInstall(".\ProcedureTruncateCruft.sql", @TempDir & '\Scripts\ProcedureTruncateCruft.sql')
	FileInstall(".\TruncateTableGUI.au3", @TempDir & '\Scripts\TruncateTableGUI.au3')
	FileInstall(".\RödlPartnerLogo.jpg", @TempDir & '\Scripts\RödlPartnerLogo.jpg')
EndIf

InitGUI()

Func InitGUI()

	Local $tableEndings[1] = []

    ; Create a GUI with various controls.
    Local $hGUI 						= GUICreate("Truncate tables", 500, 600)

	; Buttons
    Local $idOK 						= GUICtrlCreateButton("Delete data", 100, 540, 75, 25)
	GUICtrlSetState($idOK, $GUI_DISABLE)
	Local $idCANCEL 					= GUICtrlCreateButton("Cancel", 300, 540, 75, 25)

	Local $idAdd						= GUICtrlCreateButton("Add", 350, 270, 100, 20)
	Local $idRemove						= GUICtrlCreateButton("Remove", 350, 370, 100, 20)

	; Input
	Local $guiServerName				= GUICtrlCreateInput("", 130, 170, 200, 20)
	Local $guiDatabaseName				= GUICtrlCreateInput("AxDB", 130, 220, 200, 20)
	Local $guiAddTableEnding			= GUICtrlCreateInput("", 130, 270, 200, 20)

	; Labels
	Local $guiDescription 				= GUICtrlCreateLabel("Truncate all tables from a given database ending with strings given in this form.", 20, 120, 460, 40);
	Local $guiServerNameLabel			= GUICtrlCreateLabel("Server name", 20, 170, 80, 20)
	Local $guiDatabaseNameLabel			= GUICtrlCreateLabel("Database name", 20, 220, 80, 20)
	Local $guiAddTableEndingLabel		= GUICtrlCreateLabel("Add table ending", 20, 270, 110, 20)
	Local $guiAddTableEndingConfirm		= GUICtrlCreateLabel("", 130, 320, 250, 20)
	Local $guiRemoveTableEndingLabel	= GUICtrlCreateLabel("Remove table ending", 20, 370, 110, 20)
	Local $guiRemoveTableEndingConfirm	= GUICtrlCreateLabel("", 130, 420, 250, 20)
	Local $guiTableEndings				= GUICtrlCreateLabel("Chosen tables: ", 20, 470, 460, 50)

	; ComboBox
	Local $guiRemoveTableEnding			= GUICtrlCreateCombo("", 130, 370, 200, 20)
	GUICtrlSetData($guiRemoveTableEnding, $tableEndings)

	; Logo
	Local $guiRoedlLogo					= GUICtrlCreatePic(@TempDir & '\Scripts\RödlPartnerLogo.jpg', 0, 0, 500, 75)

    ; Display the GUI.
    GUISetState(@SW_SHOW, $hGUI)

    ; Loop until the user exits.
    While 1
        Switch GUIGetMsg()
			Case $idAdd
				; check if characters are legal
				If StringRegExp(GUICtrlRead($guiAddTableEnding),"[^0-9,a-z,A-Z,',']","") Then
					GUICtrlSetData($guiRemoveTableEndingConfirm, "")
					GUICtrlSetData($guiAddTableEndingConfirm, "Illegal characters. Use only letters and numbers.")
				Else
					Local $newValues = StringSplit(GUICtrlRead($guiAddTableEnding), ",")
					_ArrayDelete($newValues, 0)

					Local $temp[0] =[]

					For $currentValue In $newValues
						If _ArraySearch($tableEndings, $currentValue) = -1 Then
							If Not $currentValue = "" Then
								_ArrayAdd($tableEndings, $currentValue)
								_ArrayAdd($temp, $currentValue)
								Local $pos = _ArraySearch($tableEndings, "")
								If $pos >= 0 Then
									_ArrayDelete($tableEndings, $pos)
								EndIf
							EndIf
						EndIf
					Next

					If UBound($temp) > 0 Then
						GUICtrlSetData($guiAddTableEndingConfirm, "")
						GUICtrlSetData($guiRemoveTableEndingConfirm, "")
						GUICtrlSetData($guiAddTableEndingConfirm, "Added: " & MakeList($temp, ","))

						GUICtrlSetData($guiRemoveTableEnding, "")
						GUICtrlSetData($guiRemoveTableEnding, MakeList($tableEndings))
						GUICtrlSetData($guiTableEndings, "Chosen tables: " & MakeList($tableEndings, ", ", "*"))
						GUICtrlSetState($idOK, $GUI_ENABLE)
					Else
						GUICtrlSetData($guiRemoveTableEndingConfirm, "")
						GUICtrlSetData($guiAddTableEndingConfirm, "Did not add new tables.")
					EndIf
					GUICtrlSetData($guiAddTableEnding, "")
				EndIf

			Case $idRemove
				Local $currentValue = GUICtrlRead($guiRemoveTableEnding)
				Local $pos = _ArraySearch($tableEndings, $currentValue)
				If $pos >= 0 Then
					_ArrayDelete($tableEndings, $pos)

					GUICtrlSetData($guiAddTableEndingConfirm, "")
					GUICtrlSetData($guiRemoveTableEndingConfirm, "")
					Local $temp = "Removed: " & $currentValue
					GUICtrlSetData($guiRemoveTableEndingConfirm, $temp)

					GUICtrlSetData($guiRemoveTableEnding, "")
					GUICtrlSetData($guiRemoveTableEnding, MakeList($tableEndings))
					GUICtrlSetData($guiTableEndings, "Chosen tables: " & MakeList($tableEndings, ", ", "*"))

					If (UBound($tableEndings) = 0) Or (UBound($tableEndings) = 1 And $tableEndings[0] = "") Then
						GUICtrlSetState($idOK, $GUI_DISABLE)
					EndIf
				EndIf
            Case $GUI_EVENT_CLOSE, $idCANCEL
				_DeleteTemp()
                ExitLoop
			Case $idOK
				If StringLen(GUICtrlRead($guiServerName)) = 0 Or StringLen(GUICtrlRead($guiDatabaseName)) = 0 Then
					If StringLen(GUICtrlRead($guiServerName)) = 0 And StringLen(GUICtrlRead($guiDatabaseName)) = 0 Then
						CreateNotice("No server and database chosen!")
					ElseIf StringLen(GUICtrlRead($guiServerName)) = 0 Then
						CreateNotice("No server chosen!")
					Else
						CreateNotice("No database chosen!")
					EndIf
				Else
					RunWait('powershell.exe -file ' & @TempDir & '\Scripts\TruncateTables.ps1 -server ' & GUICtrlRead($guiServerName) & ' -database ' & GUICtrlRead($guiDatabaseName) & ' -tableEnding ' & MakeList($tableEndings, ",", "[", "]"))
				EndIf
        EndSwitch
    WEnd

    ; Delete the previous GUI and all controls.
    GUIDelete($hGUI)
EndFunc   ;==>Example

Func MakeList($array, $separator="|", $startSymbol="", $endSymbol="")
	Local $sList = ""
	For $i = 0 To UBound($array) - 1
		If $i = 0 Then
			$sList = $startSymbol & $array[$i] & $endSymbol
		Else
			$sList &= $separator & $startSymbol & $array[$i] & $endSymbol
		EndIf
	Next
	Return $sList
EndFunc

Func CreateNotice($notice)
	Local $noticeGUI 	= GUICreate("Notice", 200, 100)
	Local $idOK 		= GUICtrlCreateButton("OK", 75, 60, 50, 30)
	Local $noticeLabel	= GUICtrlCreateLabel($notice, 20, 10, 160, 40)

	GUISetState(@SW_SHOW, $noticeGUI)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $idOK
				ExitLoop
		EndSwitch
	WEnd

	GUIDelete($noticeGUI)
EndFunc

Func _DeleteTemp($iDelay = 0)
    Local $sCmdFile
	;DirRemove(@ScriptDir & '\Scripts\', 1)
    FileDelete(@TempDir & "\Scripts\scratch.bat")
    $sCmdFile = 'ping -n ' & $iDelay & '127.0.0.1 > nul' & @CRLF _
            & ':loop' & @CRLF _
            & 'del /s /q "' & @TempDir & '\Scripts"' & @CRLF _
            & 'if exist "' & @TempDir & '\Scripts\Scripts" goto loop' & @CRLF _
            & 'del ' & @TempDir & '\Scripts\scratch.bat'
    FileWrite(@TempDir & "\Scripts\scratch.bat", $sCmdFile)
    Run(@TempDir & "\Scripts\scratch.bat", @TempDir, @SW_HIDE)
EndFunc
