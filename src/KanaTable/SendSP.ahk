; 特別出力
SendSP(Str1, CtrlNo)
{
	global KoyuNumber, Version, LayoutName, IniFilePath

	SetKeyDelay, -1, -1

	if (CtrlNo == "ESCx3")
		SendESCx3()
	else if (CtrlNo == "そのまま")
		Send, % Str1
	else if (CtrlNo == "横書き")
		ChangeVertical(0)
	else if (CtrlNo == "縦書き")
		ChangeVertical(1)
	; 固有名詞ショートカットを切り替える
	else if (CtrlNo == "KoyuChange")
	{
		if (Str1 == KoyuNumber)	; 番号が変わらない
		{
			MsgBox, , , 固有名詞セット%KoyuNumber%
			return
		}
		MsgBox, 1, , 固有名詞 セット%KoyuNumber% → %Str1%
		IfMsgBox, Cancel	; キャンセル
			return

		KoyuNumber := Str1
		; 設定ファイル書き込み
		IniWrite, %KoyuNumber%, %IniFilePath%, Naginata, KoyuNumber
		; ツールチップを変更する
		menu, tray, tip, Hachiku %Version%`n%LayoutName%`n固有名詞セット%KoyuNumber%

		KoyuReadAndRegist(KoyuNumber)	; 固有名詞ショートカットの読み込み・登録
		SettingLayout()					; 出力確定する定義に印をつける
	}
	else	; その他、未定義のもの。念のため。
		SendEachChar(Str1)

	return
}

SendESCx3()
{
	global	GoodHwnd, IME_Get_Interval, LastSendTime
;	local	Hwnd, process, IMEName, Delay, NeedDelay

	WinGet, Hwnd, ID, A
	WinGet, process, ProcessName, ahk_id %Hwnd%
	IMEName := DetectIME()

	if (WinExist("ahk_class #32768"))
	{	; コンテキストメニューは消えるまで Esc キーを押す
		Loop, 4 {
			Send, {Esc}
		} until (!WinExist("ahk_class #32768"))
	}
	else if (Hwnd == GoodHwnd)
	{	; IME窓検出が当てになる(入力中のかながないのと変換1回目の区別がつく)
		Delay := IME_Get_Interval - Floor(QPC() - LastSendTime)
		if (Delay > 0)	; 時間を空けてIME検出へ
			Sleep, %Delay%
		if (IME_GET() && IME_GetSentenceMode())
		{	;　IME ONだが、無変換ではない
			NeedDelay := (IMEName == "Google" ? 30 : (IMEName == "ATOK" ? 90 : 70))
			Delay := NeedDelay - Floor(QPC() - LastSendTime)
			if (Delay > 0)	; 時間を空けてIME窓検出へ
				Sleep, %Delay%
			Loop, 4 {
				if (!IME_GetConverting())
					break	; IME窓がなければループ終了
				Send, {Esc}
				Sleep, %NeedDelay%
			}
		}
	}
	else	; その他
		Send, {Esc 4}

	if (SubStr(process, 1, 4) = "Taro")
	{	; 一太郎のメニューを消す
		if (IMEName == "Google")
			Sleep, 160
		else if (IMEName == "OldMSIME" || IMEName == "MSIME")
			Sleep, 240
		else if (IMEName == "ATOK")
			Sleep, 260
		else
			Sleep, 310
		IfWinActive, ahk_class #32770
			Send, a
	}

	return
}
