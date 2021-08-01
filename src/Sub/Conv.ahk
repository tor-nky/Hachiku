; Copyright 2021 Satoru NAKAYA
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

; **********************************************************************
;	3キー同時押し配列 メインルーチン
; **********************************************************************


; ----------------------------------------------------------------------
; 本ファイルのみで使う変数
; ----------------------------------------------------------------------
; グローバル変数
KeyTime := 0		; キーを押した時間
; 入力バッファ
InBufsKey := []
InBufsTime := []	; 入力の時間
InBufReadPos := 0	; 読み出し位置
InBufWritePos := 0	; 書き込み位置
InBufRest := 15
; 仮出力バッファ
OutStrs := []
_usc := 0			; 保存されている文字数

; ----------------------------------------------------------------------
; メニューで使う変数
; ----------------------------------------------------------------------
SideShift0 := (SideShift = 0 ? 1 : 0)
SideShift1 := (SideShift = 1 ? 1 : 0)
SideShift2 := (SideShift = 2 ? 1 : 0)
EnterShift0 := (EnterShift = 0 ? 1 : 0)
EnterShift1 := (EnterShift = 1 ? 1 : 0)

; ----------------------------------------------------------------------
; メニュー表示
; ----------------------------------------------------------------------
	menu, tray, tip, Hachiku`n%Version%
	; タスクトレイメニューの標準メニュー項目を解除
	menu, tray, NoStandard
	; 縦書きモード切替を追加
	menu, tray, add, 縦書きモード, VerticalMode
	if (Vertical)
		menu, tray, Check, 縦書きモード	; “縦書きモード”にチェックを付ける
	; 「固有名詞」編集画面を追加
	menu, tray, add, 固有名詞, KoyuMenu
	; 設定画面を追加
	menu, tray, add, 設定..., PrefMenu
	; セパレーター
	menu, tray, add
	; 標準メニュー項目を追加
	menu, tray, Standard

	; バージョンアップ後、初めての起動時は設定画面を表示
	if (INIVersion != Version)
	{
		INIVersion := Version
		Gosub, PrefMenu
	}

exit	; 起動時はここまで実行

; ----------------------------------------------------------------------
; メニュー動作
; ----------------------------------------------------------------------
; 参考: https://rcmdnk.com/blog/2017/11/07/computer-windows-autohotkey/
ButtonOK:
	Gui, Submit
	if SideShift0 = 1
		SideShift := 0
	else if SideShift1 = 1
		SideShift := 1
	else
		SideShift := 2
	USKBSideShift := (USKB = 1 && SideShift > 0 ? 1 : 0)	; 更新
	EnterShift := (EnterShift0 = 1 ? 0 : 1)
	; 設定ファイル書き込み
	IniWrite, %Version%, %IniFilePath%, general, Version
	IniWrite, %Slow%, %IniFilePath%, general, Slow
	IniWrite, %USLike%, %IniFilePath%, general, USLike
	IniWrite, %SideShift%, %IniFilePath%, general, SideShift
	IniWrite, %EnterShift%, %IniFilePath%, general, EnterShift
	IniWrite, %ShiftDelay%, %IniFilePath%, general, ShiftDelay
	IniWrite, %CombDelay%, %IniFilePath%, general, CombDelay
	if TestMode > 0
		IniWrite, %DispTime%, %IniFilePath%, test, DispTime
	if USLike > 0
		Gosub, toUSLike
	else
		Gosub, toJIS
	Setting()	; 出力確定する定義に印をつける
ButtonCancel:
GuiClose:
	Gui, Destroy
	return

; 縦書きモード切替
VerticalMode:
	menu, tray, ToggleCheck, 縦書きモード
	Vertical ^= 1
	; 設定ファイル書き込み
	IniWrite, %Vertical%, %IniFilePath%, general, Vertical
return

; 設定画面
PrefMenu:
	Gui, Destroy
	Gui, Add, Text, , 設定
	Gui, Add, Text, x+0 W180 Right, %Version%

	Gui, Add, Checkbox, xm vSlow, ATOK対応
	if Slow = 1
		GuiControl, , Slow, 1

	Gui, Add, Checkbox, xm vUSLike, 記号をUSキーボード風にする
	if USLike = 1
		GuiControl, , USLike, 1
	Gui, Add, Text, xm+18 y+1, ※ 日本語キーボードの時のみ有効です
	Gui, Add, Text, xm+18 y+1, ※ 左右シフトかなに設定してください

	Gui, Add, Text, xm y+10, 左右シフト
	Gui, Add, Radio, xm+68 yp+0 Group vSideShift0, 英数
	if TestMode > 0
		Gui, Add, Radio, x+0 vSideShift1, 英数2
	Gui, Add, Radio, x+0 vSideShift2, かな
	if SideShift0 = 1
		GuiControl, , SideShift0, 1
	else if SideShift1 = 1
		GuiControl, , SideShift1, 1
	else
		GuiControl, , SideShift2, 1

	Gui, Add, Text, xm, エンター
	Gui, Add, Radio, xm+68 yp+0 Group vEnterShift0, 通常
	Gui, Add, Radio, x+0 vEnterShift1, 同時押しシフト
	if EnterShift0 = 1
		GuiControl, , EnterShift0, 1
	else
		GuiControl, , EnterShift1, 1

	Gui, Add, Text, xm y+15, 後置シフトの待ち時間
	Gui, Add, Edit, xm+128 yp-3 W45
	Gui, Add, UpDown, vShiftDelay Range0-200, %ShiftDelay%
	Gui, Add, Text, x+5 yp+3, ミリ秒

	Gui, Add, Text, xm y+15, シフト中の同時打鍵判定
	Gui, Add, Edit, xm+128 yp-3 W45
	Gui, Add, UpDown, vCombDelay Range0-200, %CombDelay%
	Gui, Add, Text, x+5 yp+3, ミリ秒
	Gui, Add, Text, xm+18 y+1, ※ 0 は無制限

	if TestMode > 0
	{
		Gui, Add, Checkbox, xm vDispTime, 変換時間表示
		if DispTime = 1
			GuiControl, , DispTime, 1
	}

	Gui, Add, Button, W60 xm+45 y+10 Default, OK
	Gui, Add, Button, W60 x+0, Cancel
	Gui, Show

	return


; ----------------------------------------------------------------------
; サブルーチン
; ----------------------------------------------------------------------

PSTimer:	; 後置シフトの判定期限タイマー
	; 入力バッファが空の時、保存
	InBufsKey[InBufWritePos] := "PSTimer", InBufsTime[InBufWritePos] := QPC()
		, InBufWritePos := (InBufRest = 15 ? ++InBufWritePos & 15 : InBufWritePos)
		, (InBufRest = 15 ? InBufRest-- : )
	Convert()	; 変換ルーチン
	return

CombTimer:	; 同時押しの判定期限タイマー
	; 入力バッファが空の時、保存
	InBufsKey[InBufWritePos] := "CombTimer", InBufsTime[InBufWritePos] := QPC()
		, InBufWritePos := (InBufRest = 15 ? ++InBufWritePos & 15 : InBufWritePos)
		, (InBufRest = 15 ? InBufRest-- : )
	Convert()	; 変換ルーチン
	return

RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
	return

; ----------------------------------------------------------------------
; 関数
; ----------------------------------------------------------------------

; タイマー関数
; 参照: https://www.autohotkey.com/boards/viewtopic.php?t=36016
QPCInit() {
	DllCall("QueryPerformanceFrequency", "Int64P", Freq)
	return Freq
}
QPC() {	; ミリ秒単位
	static Freq := QPCInit() / 1000.0
	DllCall("QueryPerformanceCounter", "Int64P", Count)
	Return, Count / Freq
}

; 文字列 Str1 を適宜ディレイを入れながら出力する
SendNeo(Str1, Delay:=0)
{
	global Slow
	static LastTickCount := QPC()
;	local len						; Str1 の長さ
;		, StrChopped, LenChopped	; 細切れにした文字列と、その長さを入れる変数
;		, i, c, bracket
;		, IMECheck, IMEConvMode		; IME入力モードの保存、復元に関するフラグと変数
;		, PreDelay, PostDelay		; 出力前後のディレイの値
;		, LastDelay					; 前回出力時のディレイの値
;		, SlowCopied

	SlowCopied := Slow
	IfWinActive, ahk_class CabinetWClass	; エクスプローラーにはゆっくり出力する
		Delay := (Delay < 10 ? 10 : Delay)
	else IfWinActive, ahk_class Hidemaru32Class	; 秀丸エディタ
		SlowCopied := (SlowCopied = 1 ? 0x11 : SlowCopied)
	SetKeyDelay, -1, -1

	LastDelay := QPC() - LastTickCount

	; 文字列を細切れにして出力
	PreDelay := 0
	PostDelay := Delay	; ディレイの初期値
	IMECheck := 0
	StrChopped := ""
	LenChopped := 0
	bracket := 0
	i := 1
	len := StrLen(Str1)
	while (i <= len)
	{
		c := SubStr(Str1, i, 1)
		if (c == "}" && bracket != 1)
			bracket := 0
		else if (c == "{" || bracket)
			bracket++
		StrChopped .= c
		LenChopped++
		if (!(bracket || c == "+" || c == "^" || c == "!" || c == "#")
			|| i = len )
		{
			; SendRaw(直接入力モード)にする時
			if (SubStr(StrChopped, LenChopped - 4, 5) = "{Raw}")
			{
				i++
				while (i <= len)
				{
					StrChopped := SubStr(Str1, i, 2)
					if (Asc(StrChopped) > 65535)	; ユニコード拡張領域
					{
						SendRaw, % StrChopped
						i += 2
					}
					else
					{
						SendRaw, % SubStr(Str1, i, 1)
						i++
					}
					; 出力直後のディレイ
					if PostDelay > 0
						Sleep, PostDelay
				}
				break
			}
			; 出力するキーを変換
			else if (StrChopped == "{確定}")
				StrChopped := "{Enter}"
			else if (StrChopped = "{IMEOff}")
			{
				IMECheck := 1			; IME入力モードを保存する必要あり
				StrChopped := "{vkF3}"	; 半角/全角
				PostDelay := 30
			}
			else if (SlowCopied = 0x11 && SubStr(StrChopped, 1, 6) = "{Enter")
			{
				PreDelay := 80
				PostDelay := 100	; 秀丸エディタ + ATOK 用
			}

			; 前回の出力からの時間が短ければ、ディレイを入れる
			if (LastDelay < PreDelay)
				Sleep, % PreDelay - LastDelay
			; IME入力モードを保存する
			if IMECheck = 1
			{
				IMEConvMode := IME_GetConvMode()
				IMECheck := 2	; 後で IME入力モードを回復する
			}
			; キー出力
			if (StrChopped != "{Null}")
			{
				Send, % StrChopped
				; 出力直後のディレイ
				if PostDelay > 0
					Sleep, PostDelay
				LastDelay := PostDelay	; 今回のディレイの値を保存
				PreDelay := 0
				PostDelay := Delay		; ディレイの初期値
			}

			StrChopped := ""
			LenChopped := 0
		}
		i++
	}

	; IME ON
	if IMECheck = 2
	{
		if SlowCopied = 0x11
		{
			PreDelay := 70
			PostDelay := 90	; 秀丸エディタ + ATOK 用
		}
		else if SlowCopied = 1
		{
			PreDelay := 50
			PostDelay := 70	; ATOK 用
		}
		; 前回の出力からの時間が短ければ、ディレイを入れる
		if (LastDelay < PreDelay)
			Sleep, % PreDelay - LastDelay
		; キー出力
		Send, {vkF3}	; 半角/全角
		; 出力直後のディレイ
		if PostDelay > 0
			Sleep, PostDelay
		; IME入力モードを回復する
		if IMEConvMode > 0
		{
			IME_SetConvMode(IMEConvMode)
			Sleep, Delay
		}
	}

	LastTickCount := QPC()	; 最後に出力した時間を記録

	return
}

; 仮出力バッファの先頭から i 個出力する
; i の指定がないときは、全部出力する
OutBuf(i:=2)
{
	global _usc, OutStrs, SideShift, Slow, KeyTime, DispTime
;	local Str1, StrBegin

	while (i > 0 && _usc > 0)
	{
		Str1 := OutStrs[1]
		StrBegin := SubStr(Str1, 1, 4)
		if (StrBegin == "{記号}" || StrBegin == "{直接}")
		{
			StringTrimLeft, Str1, Str1, 4
			if (StrBegin == "{直接}")
				Str1 := "{Raw}" . Str1
			if (IME_GET() = 1)		; IME ON の時
			{
				if (IME_GetSentenceMode() = 0)
					Str1 := "{IMEOff}" . Str1
				else
					Str1 := ":{確定}{BS}{IMEOff}" . Str1
			}
			if (SideShift > 1 || Slow = 1 || IME_GetConvMode() & 1)
				SendNeo(Str1, 10)
			else
				SendNeo(Str1, 30)	; 左右シフト英数モードの旧MS-IMEにはゆっくりと出力
		}
		else
			SendNeo(Str1)

		OutStrs[1] := OutStrs[2]
		_usc--
		i--

		; 直前のキー変化からの時間を表示
		if DispTime > 0
		{
			OutputTime := Round(QPC() - KeyTime, 1)
			ToolTip, %OutputTime% ms
			SetTimer, RemoveToolTip, 1000
		}
	}
	return
}

; 仮出力バッファを最後から nBack 回分を削除して、Str1 を保存
StoreBuf(nBack, Str1)
{
	global _usc, OutStrs

	if nBack > 0
	{
		_usc -= nBack
		if _usc <= 0
			_usc := 0	; バッファが空になる以上は削除しない
		else
			OutBuf(1)	; nBack の分だけ戻って、残ったバッファは出力する
	}
	else if _usc = 2	; バッファがいっぱいなので、1文字出力
		OutBuf(1)
	_usc++
	OutStrs[_usc] := Str1

	return
}

; 出力する文字列を選択
SelectStr(i)
{
	global Vertical, DefsTateStr, DefsYokoStr

	return (Vertical ? DefsTateStr[i] : DefsYokoStr[i])
}

; 変換、出力
Convert()
{
	global InBufsKey, InBufReadPos, InBufsTime, InBufRest, KeyTime
		, KC_SPC, JP_YEN, KC_INT1, R
		, DefsKey, DefsGroup, DefsKanaMode, DefsSetted, DefsRepeat, DefBegin, DefEnd
		, _usc
		, SideShift, EnterShift, ShiftDelay, CombDelay
	static ConvRest	:= 0	; 入力バッファに積んだ数/多重起動防止フラグ
		, NextKey	:= ""	; 次回送りのキー入力
		, RealBit	:= 0	; 今押している全部のキービットの集合
		, LastBit	:= 0	; 前回のキービット
		, Last2Bit	:= 0	; 前々回のキービット
		, LastKeyTime := 0	; 有効なキーを押した時間
		, OutStr	:= ""	; 出力する文字列
		, _lks		:= 0	; 前回、何キー同時押しだったか？
		, LastGroup	:= 0	; 前回、何グループだったか？ 0はグループAll
		, RepeatBit	:= 0	; リピート中のキーのビット
		, LastSetted := 0	; 出力確定したか(1 だと、後置シフトの判定期限到来で出力確定)
			; シフト用キーの状態 0: 押していない, 1: 単独押し, 2以上: シフト状態
		, spc		:= 0	; スペースキー
		, sft		:= 0	; 左右シフト
		, ent		:= 0	; エンター
;	local KanaMode			; 0: 英数入力, 1: かな入力
;		, Detect
;		, NowKey
;		, Term		; 入力の末端2文字
;		, NowBit	; 今回のキービット
;		, SearchBit	; いま検索しようとしているキーの集合
;		, i, imax, j, jmax	; カウンタ用
;		, nkeys		; 今回は何キー同時押しか

	if (ConvRest > 0 || NextKey != "")
		return	; 多重起動防止で戻る

	; 入力バッファが空になるまで
	while (ConvRest := 15 - InBufRest || NextKey != "")
	{
		SetTimer, PSTimer, Off		; 後置シフトの判定期限タイマー停止
		SetTimer, CombTimer, Off	; 同時押しの判定期限タイマー停止

		if (NextKey == "")
		{
			; 入力バッファから読み出し
			NowKey := InBufsKey[InBufReadPos], KeyTime := InBufsTime[InBufReadPos]
				, InBufReadPos := ++InBufReadPos & 15, InBufRest++
			; 後置シフトの判定期限到来
			if (NowKey == "PSTimer")
			{
				if (LastKeyTime + ShiftDelay <= KeyTime)
				{
					KeyTime := LastKeyTime	; 直前のキー変化の時間
					OutBuf()
				}
				else
					SetTimer, PSTimer, -10	; 10ミリ秒後に再判定
				continue
			}
			; 同時押しの判定期限到来(シフト時のみ)
			if (NowKey == "CombTimer")
			{
				if ((RealBit & KC_SPC) && LastKeyTime + CombDelay <= KeyTime)
				{
					KeyTime := LastKeyTime		; 直前のキー変化の時間
					OutBuf()
					Last2Bit := LastBit := 0
				}
				else
					SetTimer, CombTimer, -10	; 10ミリ秒後に再判定
				continue
			}
		}
		else
		{	; 前回の残りを読み出し
			NowKey := NextKey
			NextKey := ""
		}

		; 左右シフト処理
		if (Asc(NowKey) = 43)		; "+" から始まる
		{
			if sft = 0				; 左右シフトなし→あり
			{
				OutBuf()
				NextKey := NowKey
				NowKey := "sc39"	; シフト
				sft := 1
			}
			else
				StringTrimLeft, NowKey, NowKey, 1	; 先頭の "+" を消去
		}
		else if sft > 0				; 左右シフトあり→なし
		{
			if (spc = 0 && ent = 0)
			{
				NextKey := NowKey
				NowKey := "sc39 up"	; シフト押し上げ
			}
			sft := 0
		}
		; スペースキー処理
		else if (NowKey == "sc39")
		{
			if spc = 0
				spc := 1
;			if ent = 1
;				ent := 2	; 単独エンターではない
		}
		else if (NowKey == "sc39 up")
		{
			if (sft > 0 || ent > 0)
			{
				if spc = 1
					NowKey := "space "
				else
				{
					spc := 0
;					if ent = 1
;						ent := 2	; 単独エンターではない
					continue
				}
			}
			else if spc = 1
				NextKey := "space "	; スペースキー単独押し
			spc := 0
		}
		; エンターキー処理
		else if (NowKey == "Enter" && EnterShift > 0)
		{
			NowKey := "sc39"	; シフト
			if ent = 0
				ent := 1
;			if spc = 1
;				spc := 2		; 単独スペースではない
		}
		else if (NowKey == "Enter up")
		{
			NowKey := "sc39 up"		; シフト押上げ
			if (sft > 0 || spc > 0)
			{
				if ent = 1
					NowKey := "enter "
				else
				{
					ent := 0
;					if spc = 1
;						spc := 2	; 単独スペースではない
					continue
				}
			}
			else if ent = 1
				NextKey := "enter "	; エンターキー単独押し ※"Enter"としないこと
			ent := 0
		}

		IfWinExist, ahk_class #32768	; コンテキストメニューが出ている時
			KanaMode := 0
		else if (sft > 0 && SideShift = 1)
			KanaMode := 0
		else
		{
			; IME の状態を検出(失敗したら書き換えない)
			Detect := IME_GET()
			if Detect = 0 			; IME OFF の時
				KanaMode := 0
			else if Detect = 1		; IME ON の時
			{
				Detect := IME_GetConvMode()
				if (Detect != "")
					KanaMode := Detect & 1
			}
		}

		nkeys := 0	; 何キー同時押しか、を入れる変数
		StringRight, Term, NowKey, 2	; Term に入力末尾の2文字を入れる
		; キーが離れた時
		if (Term == "up")
			NowBit := "0x" . SubStr(NowKey, StrLen(NowKey) - 4, 2)
		; sc○○ で入力
		else
		{
			if (SubStr(NowKey, 1, 2) == "sc")
			{
				NowBit := "0x" . Term
				OutStr := "{sc" . Term . "}"
			}	; ここで NowBit に sc○○ から 0x○○ に変換されたものが入っているが、
				; Autohotkey は十六進数の数値としてそのまま扱える
			; sc○○ 以外で入力
			else
			{
				NowBit := 0
				OutStr := "{" . NowKey . "}"
				nkeys := -1	; 後の検索は不要なため
			}
			if (RealBit & KC_SPC)	; スペースキーが押されていたら、シフトを加える(SandSの実装)
				OutStr := "+" . OutStr
		}

		; ビットに変換
		if NowBit = 0x7D		; (JIS)\
			NowBit := JP_YEN
		else if NowBit = 0x73	; (JIS)_
			NowBit := KC_INT1
		else if NowBit != 0
			NowBit := 1 << NowBit

		; キーリリース時
		if (Term == "up")
		{
			OutBuf()
			RealBit &= NowBit ^ (-1)	; RealBit &= ~NowBit では
										; 32ビット計算になることがあり、不適切
			Last2Bit := LastBit := RealBit
			LastGroup := 0
			RepeatBit := 0	; リピート解除
		}
		; (キーリリース直後か、通常シフトまたは後置シフトの判定期限後に)スペースキーが押された時
		else if (NowBit = KC_SPC && !(RealBit & NowBit)
			&& (_usc = 0 || LastKeyTime + ShiftDelay <= KeyTime))
		{
			OutBuf()
			RealBit |= KC_SPC
			LastGroup := 0
			RepeatBit := 0	; リピート解除
		}
		; 押されていなかったキー、sc○○でないキー、リピートできるキー
		else if (!(RealBit & NowBit) || NowBit = RepeatBit)
		{
			; 同時押しの判定期限到来(シフト時のみ)
			if (CombDelay > 0 && (RealBit & KC_SPC) && LastKeyTime + CombDelay <= KeyTime)
			{
				OutBuf()
				Last2Bit := LastBit := 0
			}

			RealBit |= NowBit
			nBack := 0
			while (nkeys = 0)
			{
				; 3キー入力を検索
				if (_lks > 1 || Last2Bit != 0)
				{
					i := DefBegin[3]
					imax := DefEnd[3]	; 検索場所の設定
					SearchBit := (RealBit & KC_SPC) | NowBit | LastBit | Last2Bit
					while (i < imax)
					{
						if ((LastGroup = 0 || DefsGroup[i] = LastGroup)
							&& (DefsKey[i] & NowBit) 				; 今回のキーを含み
							&& (DefsKey[i] & SearchBit) = DefsKey[i]	; 検索中のキー集合が、いま調べている定義内にあり
							&& !((DefsKey[i] ^ SearchBit) & KC_SPC)	; ただしシフトの相違はなく
							&& DefsKanaMode[i] = KanaMode)			; 英数用、かな用の種別が一致していること
						{
							if (_lks = 3 && (RealBit & KC_SPC) && NowBit != KC_SPC)
							{	; 前回もシフト付き3キー入力だったら
								Last2Bit := LastBit := 0	; 1キー入力の検索へ
								break
							}
							if (_lks = 3 && NowBit != KC_SPC)	; 3キー同時→3キー同時 は仮出力バッファを全て出力
								OutBuf()
							else if _lks >= 2
								nBack := 1	; 前回が2キー、3キー同時押しだったら、1文字消して仮出力バッファへ
							else
								nBack := 2	; 前回が1キー入力だったら、2文字消して仮出力バッファへ
							nkeys := 3
							break, 2
						}
						i++
					}
				}
				; 2キー入力を検索
				if LastBit != 0
				{
					i := DefBegin[2]
					imax := DefEnd[2]	; 検索場所の設定
					SearchBit := (RealBit & KC_SPC) | NowBit | LastBit
					while (i < imax)
					{
						if ((LastGroup = 0 || DefsGroup[i] = LastGroup)
							&& (DefsKey[i] & NowBit)
							&& (DefsKey[i] & SearchBit) = DefsKey[i]
							&& !((DefsKey[i] ^ SearchBit) & KC_SPC)
							&& DefsKanaMode[i] = KanaMode)
						{
							if (_lks = 2 && (RealBit & KC_SPC) && NowBit != KC_SPC)
							{	; 前回もシフト付き2キー入力だったら
								Last2Bit := LastBit := 0	; 1キー入力の検索へ
								break
							}
							if (_lks >= 2 && NowBit != KC_SPC)	; 2キー以上同時→2キー同時 は仮出力バッファを全て出力
								OutBuf()
							nBack := 1
							nkeys := 2
							break, 2
						}
						i++
					}
				}
				; 1キー入力を検索
				i := DefBegin[1]
				imax := DefEnd[1]	; 検索場所の設定
				if (NowBit = KC_SPC)
					SearchBit := KC_SPC | LastBit
				else
					SearchBit := (RealBit & KC_SPC) | NowBit
				while (i < imax)
				{
					if ((LastGroup = 0 || DefsGroup[i] = LastGroup)
						&& DefsKey[i] = SearchBit
						&& DefsKanaMode[i] = KanaMode)
					{
						if _lks >= 2
							OutBuf()	; 前回が2キー、3キー同時押しだったら、仮出力バッファを全て出力
						else if (NowBit = KC_SPC)
							nBack := 1
						nkeys := 1
						break, 2
					}
					i++
				}
				if LastGroup = 0
					break
				LastGroup := 0	; 今の検索がグループありだったので、グループなしで再度検索
			}
			; スペースを押したが、定義がなかった時
			if (NowBit = KC_SPC && nkeys = 0)
			{
				RepeatBit := 0
				continue	; 次の入力へ
			}
			if spc = 1
				spc := 2	; 単独スペースではない
			if ent = 1
				ent := 2	; 単独エンターではない

			; 出力する文字列を選ぶ
			if nkeys > 0	; 定義が見つかった時
			{
				OutStr := SelectStr(i)		; 出力する文字列
				LastSetted := DefsSetted[i]	; 出力確定するか検索
			}
			else if nkeys = 0	; 定義が見つけられなかった時
			{
				; 出力確定するか検索
				SearchBit := DefsKey[i]
				LastSetted := 2	; 初期値は出力確定する
				j := DefBegin[3]
				jmax := (nkeys >= 1 ? DefEnd[nkeys] : DefEnd[1])
				while (j < jmax)
				{
					; SearchBit は DefsKey[j] に内包されているか
					if (DefsKey[j] != SearchBit && DefsKanaMode[j] = KanaMode && (DefsKey[j] & SearchBit) = SearchBit)
					{
						if ((DefsKey[j] & KC_SPC) = (SearchBit & KC_SPC))
						{	; シフトも一致
							LastSetted := 0	; 出力確定はしない
							break
						}
						else
							LastSetted := 1	; 後置シフトは出力確定しない
					}
					j++
				}
			}

			; 仮出力バッファに入れる
			StoreBuf(nBack, OutStr)
			; 次回に向けて変数を更新
			LastKeyTime := KeyTime	; 有効なキーを押した時間を保存
			_lks := nkeys			; 何キー同時押しだったかを保存
			Last2Bit := (nkeys >= 2 ? 0 : LastBit)			; 2、3キー入力のときは、この前のキービットを保存しない
			LastBit := (nkeys >= 1 ? DefsKey[i] : NowBit)	; 今回のキービットを保存
			LastGroup := (nkeys >= 1 ? DefsGroup[i] : 0)	; 何グループだったか保存
			if (nkeys >= 1 && DefsRepeat[i] & R)
				RepeatBit := NowBit		; キーリピートする

			; 出力確定文字か？
			if (nkeys < 0 || LastSetted > (ShiftDelay > 0 ? 1 : 0))
				OutBuf()	; 出力確定
			else if (InBufRest = 15 && NextKey == "")
			{
				; 同時押しの判定期限タイマー起動(シフト時のみ)
				if (CombDelay > 0 && (RealBit & KC_SPC))
					SetTimer, CombTimer, % - CombDelay
				; 後置シフトの判定期限タイマー起動
				if LastSetted = 1
					SetTimer, PSTimer, % - ShiftDelay
			}
		}
	}

	return
}


; ----------------------------------------------------------------------
; ホットキー
; ----------------------------------------------------------------------
#MaxThreadsPerHotkey 2	; 1つのホットキー・ホットストリングに多重起動可能な
						; 最大のスレッド数を設定

; キー入力部
#If (USKB = True)	; USキーボードの場合
sc29::	; (JIS)半角/全角	(US)`
#If		; End #If (USKB = True)
sc02::	; 1
sc03::	; 2
sc04::	; 3
sc05::	; 4
sc06::	; 5
sc07::	; 6
sc08::	; 7
sc09::	; 8
sc0A::	; 9
sc0B::	; 0
sc0C::	; -
sc0D::	; (JIS)^	(US)=
sc7D::	; (JIS)\
sc10::	; Q
sc11::	; W
sc12::	; E
sc13::	; R
sc14::	; T
sc15::	; Y
sc16::	; U
sc17::	; I
sc18::	; O
sc19::	; P
sc1A::	; (JIS)@	(US)[
sc1B::	; (JIS)[	(US)]
sc1E::	; A
sc1F::	; S
sc20::	; D
sc21::	; F
sc22::	; G
sc23::	; H
sc24::	; J
sc25::	; K
sc26::	; L
sc27::	; ;
sc28::	; (JIS):	(US)'
sc2B::	; (JIS)]	(US)＼
sc2C::	; Z
sc2D::	; X
sc2E::	; C
sc2F::	; V
sc30::	; B
sc31::	; N
sc32::	; M
sc33::	; ,
sc34::	; .
sc35::	; /
sc73::	; (JIS)_
sc39::	; Space
; キー入力部(左右シフト)
#If (USKBSideShift = True)	; USキーボードの場合
+sc29::	; (JIS)半角/全角	(US)`
#If		; End #If (USKBSideShift = True)
#If (SideShift > 0)
+sc02::	; 1
+sc03::	; 2
+sc04::	; 3
+sc05::	; 4
+sc06::	; 5
+sc07::	; 6
+sc08::	; 7
+sc09::	; 8
+sc0A::	; 9
+sc0B::	; 0
+sc0C::	; -
+sc0D::	; (JIS)^	(US)=
+sc7D::	; (JIS)\
+sc10::	; Q
+sc11::	; W
+sc12::	; E
+sc13::	; R
+sc14::	; T
+sc15::	; Y
+sc16::	; U
+sc17::	; I
+sc18::	; O
+sc19::	; P
+sc1A::	; (JIS)@	(US)[
+sc1B::	; (JIS)[	(US)]
+sc1E::	; A
+sc1F::	; S
+sc20::	; D
+sc21::	; F
+sc22::	; G
+sc23::	; H
+sc24::	; J
+sc25::	; K
+sc26::	; L
+sc27::	; ;
+sc28::	; (JIS):	(US)'
+sc2B::	; (JIS)]	(US)＼
+sc2C::	; Z
+sc2D::	; X
+sc2E::	; C
+sc2F::	; V
+sc30::	; B
+sc31::	; N
+sc32::	; M
+sc33::	; ,
+sc34::	; .
+sc35::	; /
+sc73::	; (JIS)_
#If		; End #If (SideShift > 0)
; SandS 用
Enter::
Up::	; ※小文字にしてはいけない
Left::
Right::
Down::
Home::
End::
PgUp::
PgDn::
	; 入力バッファへ保存
	; キーを押す方はいっぱいまで使わない
	InBufsKey[InBufWritePos] := A_ThisHotkey, InBufsTime[InBufWritePos] := QPC()
		, InBufWritePos := (InBufRest > 6 ? ++InBufWritePos & 15 : InBufWritePos)
		, (InBufRest > 6 ? InBufRest-- : )
	Convert()	; 変換ルーチン
	return

; キー押上げ
#If (USKB = True)	; USキーボードの場合
sc29 up::	; (JIS)半角/全角	(US)`
#If		; End #If (USKB = True)
sc02 up::	; 1
sc03 up::	; 2
sc04 up::	; 3
sc05 up::	; 4
sc06 up::	; 5
sc07 up::	; 6
sc08 up::	; 7
sc09 up::	; 8
sc0A up::	; 9
sc0B up::	; 0
sc0C up::	; -
sc0D up::	; (JIS)^	(US)=
sc7D up::	; (JIS)\
sc10 up::	; Q
sc11 up::	; W
sc12 up::	; E
sc13 up::	; R
sc14 up::	; T
sc15 up::	; Y
sc16 up::	; U
sc17 up::	; I
sc18 up::	; O
sc19 up::	; P
sc1A up::	; (JIS)@	(US)[
sc1B up::	; (JIS)[	(US)]
sc1E up::	; A
sc1F up::	; S
sc20 up::	; D
sc21 up::	; F
sc22 up::	; G
sc23 up::	; H
sc24 up::	; J
sc25 up::	; K
sc26 up::	; L
sc27 up::	; ;
sc28 up::	; (JIS):	(US)'
sc2B up::	; (JIS)]	(US)＼
sc2C up::	; Z
sc2D up::	; X
sc2E up::	; C
sc2F up::	; V
sc30 up::	; B
sc31 up::	; N
sc32 up::	; M
sc33 up::	; ,
sc34 up::	; .
sc35 up::	; /
sc73 up::	; (JIS)_
sc39 up::	; Space
; キー押上げ(左右シフト)
#If (USKBSideShift = True)	; USキーボードの場合
+sc29 up::	; (JIS)半角/全角	(US)`
#If		; End #If (USKBSideShift = True)
#If (SideShift > 0)
+sc02 up::	; 1
+sc03 up::	; 2
+sc04 up::	; 3
+sc05 up::	; 4
+sc06 up::	; 5
+sc07 up::	; 6
+sc08 up::	; 7
+sc09 up::	; 8
+sc0A up::	; 9
+sc0B up::	; 0
+sc0C up::	; -
+sc0D up::	; (JIS)^	(US)=
+sc7D up::	; (JIS)\
+sc10 up::	; Q
+sc11 up::	; W
+sc12 up::	; E
+sc13 up::	; R
+sc14 up::	; T
+sc15 up::	; Y
+sc16 up::	; U
+sc17 up::	; I
+sc18 up::	; O
+sc19 up::	; P
+sc1A up::	; (JIS)@	(US)[
+sc1B up::	; (JIS)[	(US)]
+sc1E up::	; A
+sc1F up::	; S
+sc20 up::	; D
+sc21 up::	; F
+sc22 up::	; G
+sc23 up::	; H
+sc24 up::	; J
+sc25 up::	; K
+sc26 up::	; L
+sc27 up::	; ;
+sc28 up::	; (JIS):	(US)'
+sc2B up::	; (JIS)]	(US)＼
+sc2C up::	; Z
+sc2D up::	; X
+sc2E up::	; C
+sc2F up::	; V
+sc30 up::	; B
+sc31 up::	; N
+sc32 up::	; M
+sc33 up::	; ,
+sc34 up::	; .
+sc35 up::	; /
+sc73 up::	; (JIS)_
#If		; End #If (SideShift > 0)
; エンター同時押しをシフトとして扱う場合
#If (EnterShift > 0)
Enter up::
#If		; End #If (EnterShift > 0)
; 入力バッファへ保存
	InBufsKey[InBufWritePos] := A_ThisHotkey, InBufsTime[InBufWritePos] := QPC()
		, InBufWritePos := (InBufRest ? ++InBufWritePos & 15 : InBufWritePos)
		, (InBufRest ? InBufRest-- : )
	Convert()	; 変換ルーチン
	return

#MaxThreadsPerHotkey 1	; 元に戻す
