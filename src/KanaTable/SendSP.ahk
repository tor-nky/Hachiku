; 特別出力
SendSP(strIn, ctrlNo)
{
	global koyuNumber, version, layoutName, iniFilePath

	SetKeyDelay, -1, -1

	If (ctrlNo == "ESCx3")
		SendESCx3()
	Else If (ctrlNo == "そのまま")
		Send, % strIn
	Else If (ctrlNo == "横書き")
		ChangeVertical(0)
	Else If (ctrlNo == "縦書き")
		ChangeVertical(1)
	; 固有名詞ショートカットを切り替える
	Else If (ctrlNo == "KoyuChange")
	{
		If (strIn == koyuNumber)	; 番号が変わらない
		{
			MsgBox, , , 固有名詞セット%koyuNumber%
			Return
		}
		MsgBox, 1, , 固有名詞 セット%koyuNumber% → %strIn%
		IfMsgBox, Cancel	; キャンセル
			Return

		koyuNumber := strIn
		; 設定ファイル書き込み
		IniWrite, %koyuNumber%, %iniFilePath%, Naginata, KoyuNumber
		; ツールチップを変更する
		menu, TRAY, Tip, Hachiku %version%`n%layoutName%`n固有名詞セット%koyuNumber%

		KoyuReadAndRegist(koyuNumber)	; 固有名詞ショートカットの読み込み・登録
		SettingLayout()					; 出力確定する定義に印をつける
	}
	Else	; その他、未定義のもの。念のため。
		SendEachChar(strIn)

	Return
}

SendESCx3()
{
	global	goodHwnd, IME_Get_Interval, lastSendTime
;	local	hwnd, process, imeName, delay, needDelay

	WinGet, hwnd, ID, A
	WinGet, process, ProcessName, ahk_id %hwnd%
	imeName := DetectIME()

	If (WinExist("ahk_class #32768"))
	{	; コンテキストメニューは消えるまで Esc キーを押す
		Loop, 5 {
			Send, {Esc}
		} Until (!WinExist("ahk_class #32768"))
	}
	Else If (hwnd == goodHwnd)
	{	; IME窓検出が当てになる(入力中のかながないのと変換1回目の区別がつく)
		delay := IME_Get_Interval - Floor(QPC() - lastSendTime)
		If (delay > 0)	; 時間を空けてIME検出へ
			Sleep, %delay%
		If (IME_GET() && IME_GetSentenceMode())
		{	;　IME ONだが、無変換ではない
			needDelay := (imeName == "Google" ? 30 : (imeName == "ATOK" ? 90 : 70))
			delay := needDelay - Floor(QPC() - lastSendTime)
			If (delay > 0)	; 時間を空けてIME窓検出へ
				Sleep, %delay%
			Loop, 5 {
				If (!IME_GetConverting())
					Break	; IME窓がなければループ終了
				Send, {Esc}
				Sleep, %needDelay%
			}
		}
	}
	Else	; その他
		Send, {Esc 5}

	If (SubStr(process, 1, 4) = "Taro")
	{	; 一太郎のメニューを消す
		If (imeName == "Google")
			Sleep, 160
		Else If (imeName == "OldMSIME" || imeName == "MSIME")
			Sleep, 240
		Else If (imeName == "ATOK")
			Sleep, 260
		Else
			Sleep, 310
		IfWinActive, ahk_class #32770
			Send, a
	}

	Return
}
