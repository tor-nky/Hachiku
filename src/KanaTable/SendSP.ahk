; Copyright 2021-2024 Satoru NAKAYA
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
;	  http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.

; 特別出力
SendSP(strIn, ctrlName)	; (strIn: String, ctrlName: String) -> Void
{
	global lastSendTime

	SetTimer JudgeHwnd, 0	; IME窓検出タイマー停止
;	SetKeyDelay, -1, -1

	SendKeyUp()		; 押し下げ出力中のキーを上げる

	If (ctrlName == "ESCx3")
		SendESCx3()
	Else If (ctrlName == "そのまま")
	{
		Send strIn
		lastSendTime := QPC.Read()	; 出力した時間を記録
	}
	Else If (ctrlName == "横書き")
		ChangeVertical(0)
	Else If (ctrlName == "縦書き")
		ChangeVertical(1)
	; 固有名詞ショートカットを切り替える
	Else If (ctrlName == "KoyuChange")
	{
		; 番号が変わらない時
		If (strIn == pref.koyuNumber)
		{
			MsgBox ("固有名詞セット" . pref.koyuNumber)
			Return
		}
		MsgBox ("固有名詞 セット" . pref.koyuNumber . " → " . strIn)
		; キャンセル
		; IfMsgBox, Cancel
		; 	Return

		pref.koyuNumber := strIn
		; 設定ファイル書き込み
		Try
			IniWrite pref.koyuNumber, pref.iniFilePath, "Naginata", "KoyuNumber"
		Catch OSError
			TrayTip ".ini ファイルに書き込めません"
		; ツールチップを変更する
		If (layoutNameE)
			A_IconTip := "Hachiku " . version . "`n" . layoutNameE . "`n+ " . layoutName . "`n固有名詞セット" . pref.koyuNumber
		Else
			A_IconTip := "Hachiku " . version . "`n" . layoutName . "`n固有名詞セット" . pref.koyuNumber

		; 固有名詞ショートカットの読み込み・登録
		koyu.Read(pref.koyuNumber)	; 固有名詞ショートカットの読み込み・登録
		; 出力確定する定義に印をつける
		SettingLayout()
	}
	; その他、未定義のもの。念のため。
	Else
		SendEachChar(strIn)
}

SendESCx3()	; () -> Void
{
	global lastSendTime
;	local hwnd		; Int型
;		, class		; String型
;		, process	; String型
;		, imeName	; String型
;		, delay		; Int型
;		, escInterval ; Int型

	hwnd := WinExist("A")
	If (hwnd)
	{
		class := WinGetClass("A")
		process := WinGetProcessName("A")
	}
	Else
		class := process := ""
	imeName := DetectIME()

	; Shift+Ctrl+無変換 のキー設定利用して良いか
	; (秀丸エディタ、あるいはPC-9801キーボードでは使えないので除外)
	If (pref.usingKeyConfig
	 && imeName != "OldMSIME" && imeName != "NewMSIME"
	 && class != "Hidemaru32Class" && OSInfo.keyDriver != "kbdnec.dll")
	{
		SendEachChar("+^{vk1D 2}")	; ※ Shift+Ctrl+無変換
		lastSendTime := QPC.Read()		; 出力した時間を記録
	}
	; IME窓検出が当てになる(入力中のかながないのと変換1回目の区別がつく)なら
	; IME窓が出ていたらEscを出力、を5回まで繰り返す
	Else If (hwnd == goodHwnd)
	{
		delay := imeNeedDelay - Floor(QPC.Read() - lastSendTime)
		; 時間を空けてIME検出へ
		If (delay > 0)
			Sleep delay
		;　IME ONだが、無変換ではない
		If (IME_GET() && IME_GetSentenceMode())
		{
			; Escを出力する間隔 ※ 新MS-IME の予測候補窓は消えにくいので時間をかける
			If (imeName != "NewMSIME")	; 新MS-IME以外
				escInterval := imeGetConvertingInterval
			Else If (OSInfo.build >= 20000 && class == "Notepad")	; Win11メモ帳+新MS-IME
				escInterval := 150
			Else	; 新MS-IME
				escInterval := 120
			; 時間を空けてIME窓検出へ
			delay := imeGetConvertingInterval - Floor(QPC.Read() - lastSendTime)
			If (delay > 0)
				Sleep delay
			Loop 5
			{
				; IME窓がなければループ終了
				If (!IME_GetConverting())
					Break
				Send "{Esc}"
				lastSendTime := QPC.Read()	; 出力した時間を記録
				Sleep escInterval
			}
		}
	}
	; その他
	Else
	{
		SendEachChar("{Esc 5}")
		; 一太郎のメニューを消す
		If (SubStr(process, 1, 4) = "Taro")
		{
			Sleep 500
			If (WinActive("ahk_class #32770"))
				Send "a"
		}
		lastSendTime := QPC.Read()	; 出力した時間を記録
	}
}
