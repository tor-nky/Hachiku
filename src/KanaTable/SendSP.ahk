; 特別出力
SendSP(strIn, ctrlName)	; (strIn: String, ctrlName: String) -> Void
{
	global koyuNumber, version, layoutName, layoutNameE, iniFilePath

	SetKeyDelay, -1, -1

	If (ctrlName == "ESCx3")
		SendESCx3()
	Else If (ctrlName == "そのまま")
		Send, % strIn
	Else If (ctrlName == "横書き")
		ChangeVertical(0)
	Else If (ctrlName == "縦書き")
		ChangeVertical(1)
	; 固有名詞ショートカットを切り替える
	Else If (ctrlName == "KoyuChange")
	{
		; 番号が変わらない時
		If (strIn == koyuNumber)
		{
			MsgBox, , , 固有名詞セット%koyuNumber%
			Return
		}
		MsgBox, 1, , 固有名詞 セット%koyuNumber% → %strIn%
		; キャンセル
		IfMsgBox, Cancel
			Return

		koyuNumber := strIn
		; 設定ファイル書き込み
		IniWrite, %koyuNumber%, %iniFilePath%, Naginata, KoyuNumber
		; ツールチップを変更する
		If (layoutNameE)
			Menu, TRAY, Tip, Hachiku %version%`n%layoutNameE%`n+ %layoutName%`n固有名詞セット%koyuNumber%
		Else
			Menu, TRAY, Tip, Hachiku %version%`n%layoutName%`n固有名詞セット%koyuNumber%

		; 固有名詞ショートカットの読み込み・登録
		KoyuReadAndRegist(koyuNumber)
		; 出力確定する定義に印をつける
		SettingLayout()
	}
	; その他、未定義のもの。念のため。
	Else
		SendEachChar(strIn)
}

SendESCx3()	; () -> Void
{
	global	usingKeyConfig, goodHwnd, IME_Get_Interval, lastSendTime
;	local	hwnd, process, imeName, delay

	WinGet, hwnd, ID, A
	WinGetClass, class, ahk_id %hwnd%
	WinGet, process, ProcessName, ahk_id %hwnd%
	imeName := DetectIME()

	If (usingKeyConfig
	 && imeName != "OldMSIME" && imeName != "NewMSIME" && class != "Hidemaru32Class")
		Send, +^{vk1D 2}	; ※ Shift+Ctrl+無変換
	; IME窓検出が当てになる時(入力中のかながないのと変換1回目の区別がつく)
	Else If (hwnd == goodHwnd)
	{
		delay := IME_Get_Interval - Floor(QPC() - lastSendTime)
		; 時間を空けてIME検出へ
		If (delay > 0)
			Sleep, %delay%
		If (IME_GET() && IME_GetSentenceMode())
		{
			;　IME ONだが、無変換ではない
			delay := 70 - Floor(QPC() - lastSendTime)
			; 時間を空けてIME窓検出へ
			If (delay > 0)
				Sleep, %delay%
			Loop, 5 {
				If (!IME_GetConverting())
					; IME窓がなければループ終了
					Break
				Send, {Esc}
				Sleep, %needDelay%
			}
		}
	}
	; その他
	Else
	{
		Send, {Esc 5}
		; 一太郎のメニューを消す
		If (SubStr(process, 1, 4) = "Taro")
		{
			Sleep, 500
			IfWinActive, ahk_class #32770
				Send, a
		}
	}
}
