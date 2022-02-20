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
; サブルーチン
; ----------------------------------------------------------------------

KeyTimer:	; 後置シフトの判定期限タイマー
	; 入力バッファが空の時、保存
	InBufsKey[InBufWritePos] := "KeyTimer", InBufsTime[InBufWritePos] := QPC()
		, InBufWritePos := (InBufRest == 31 ? ++InBufWritePos & 31 : InBufWritePos)
		, (InBufRest == 31 ? InBufRest-- : )
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
	static Coefficient := 1000.0 / QPCInit()
	DllCall("QueryPerformanceCounter", "Int64P", Count)
	Return Count * Coefficient
}

; 配列定義をすべて消去する
DeleteDefs()
{
	global DefsKey, DefsGroup, DefsKanaMode, DefsTateStr, DefsYokoStr, DefsCtrlNo
		, DefBegin, DefEnd

	; かな配列の入れ物
	DefsKey := []		; キービットの集合
	DefsGroup := []		; 定義のグループ番号 ※0はグループなし
	DefsKanaMode := []	; 0: 英数入力用, 1: かな入力用
	DefsTateStr := []	; 縦書き用定義
	DefsYokoStr := []	; 横書き用定義
	DefsCtrlNo := []	; 0: なし, 1: リピートできる, 2以上: 特別出力(かな定義ファイルで操作)
	DefsCombinableBit := []	; 0: 出力確定しない,
						; 1: 通常シフトのみ出力確定, 2: どちらのシフトも出力確定
	DefBegin := [1, 1, 1]	; 定義の始め 1キー, 2キー同時, 3キー同時
	DefEnd	:= [1, 1, 1]	; 定義の終わり+1 1キー, 2キー同時, 3キー同時
}

; 何キー同時か数える
CountBit(KeyComb)
{
	global KC_SPC
;	local count, i

	KeyComb &= KC_SPC ^ (-1)	; スペースキーは数えない

	count := 0
	i := 0
	while (i < 64 && count < 3)	; 3になったら、それ以上数えない
	{
		count += KeyComb & 1
		KeyComb >>= 1
		i++
	}
	return count
}

; 縦書き用定義から横書き用に変換
ConvTateYoko(Str1)
{
	StringReplace, Str1, Str1, {Up,		{Temp,	A
	StringReplace, Str1, Str1, {Right,	{Up,	A
	StringReplace, Str1, Str1, {Down,	{Right,	A
	StringReplace, Str1, Str1, {Left,	{Down,	A
	StringReplace, Str1, Str1, {Temp,	{Left,	A

	return Str1
}

; 機能置き換え処理 - DvorakJ との互換用
ControlReplace(Str1)
{
	StringReplace, Str1, Str1, {→,			{Right,		A
	StringReplace, Str1, Str1, {->,			{Right,		A
	StringReplace, Str1, Str1, {右,			{Right,		A
	StringReplace, Str1, Str1, {←,			{Left,		A
	StringReplace, Str1, Str1, {<-,			{Left,		A
	StringReplace, Str1, Str1, {左,			{Right,		A
	StringReplace, Str1, Str1, {↑,			{Up,		A
	StringReplace, Str1, Str1, {上,			{Up,		A
	StringReplace, Str1, Str1, {↓,			{Down,		A
	StringReplace, Str1, Str1, {下,			{Down,		A
	StringReplace, Str1, Str1, {ペースト},	^v,			A
	StringReplace, Str1, Str1, {貼付},		^v,			A
	StringReplace, Str1, Str1, {貼り付け},	^v,			A
	StringReplace, Str1, Str1, {カット},	^x,			A
	StringReplace, Str1, Str1, {切取},		^x,			A
	StringReplace, Str1, Str1, {切り取り},	^x,			A
	StringReplace, Str1, Str1, {コピー},	^c,			A
	StringReplace, Str1, Str1, {無変換,		{vk1D,		A
	StringReplace, Str1, Str1, {変換,		{vk1C,		A
	StringReplace, Str1, Str1, {ひらがな,	{vkF2,		A
	StringReplace, Str1, Str1, {カタカナ,	{vkF1,		A
	StringReplace, Str1, Str1, {改行,		{Enter,		A
	StringReplace, Str1, Str1, {後退,		{BS,		A
	StringReplace, Str1, Str1, {取消,		{Esc,		A
	StringReplace, Str1, Str1, {削除,		{Del,		A
	StringReplace, Str1, Str1, {全角,		{vkF3,		A
	StringReplace, Str1, Str1, {タブ,		{Tab,		A
	StringReplace, Str1, Str1, {空白,		{vk20,		A
	StringReplace, Str1, Str1, {メニュー,	{AppsKey,	A

	StringReplace, Str1, Str1, {Caps Lock,	{vkF0,		A
	StringReplace, Str1, Str1, {Back Space,	{BS,		A

	return Str1
}

; ASCIIコードでない文字が入っていたら、"{確定}""{NoIME}"を書き足す
; "{直接}"は"{Raw}"に書き換え
Analysis(Str1)
{
;	local i		; カウンタ
;		, len1, StrChopped, LenChopped, Str2, c, bracket, Kakutei, NoIME

	if (Str1 = "{Raw}" || Str1 = "{直接}")
		return ""	; 有効な文字列がないので空白を返す

	Kakutei := NoIME := False
	Str2 := ""			; 変換後文字列
	StrChopped := ""
	LenChopped := 0
	bracket := 0
	i := 1
	len1 := StrLen(Str1)
	while (i <= len1)
	{
		c := SubStr(Str1, i, 1)
		if (c == "}" && bracket != 1)
			bracket := 0
		else if (c == "{" || bracket)
			bracket++
		StrChopped .= c
		LenChopped++
		if (!(bracket || c == "+" || c == "^" || c == "!" || c == "#")
			|| i == len1 )
		{
			if (SubStr(StrChopped, LenChopped - 4, 5) = "{Raw}")
				return Str2 . SubStr(Str1, i - LenChopped + 1)	; 残り全部を出力
			else if (SubStr(StrChopped, LenChopped - 3, 4) = "{直接}")
			{
				if (!NoIME)
				{
					if (!Kakutei)
						Str2 .= "{確定}"
					Str2 .= "{NoIME}"
				}
				return Str2 . "{Raw}" . SubStr(Str1, i + 1)	; 残り全部を出力
			}

			StrChopped := ControlReplace(StrChopped)
			; ASCIIコードでない
			if (!NoIME && (Asc(StrChopped) > 127
				|| SubStr(StrChopped, 1, 3) = "{U+"
				|| (SubStr(StrChopped, 1, 5) = "{ASC " && SubStr(StrChopped, 6, len2 - 6) > 127)))
			{
				if (!Kakutei)
					Str2 .= "{確定}"
				Str2 .= "{NoIME}" . StrChopped
				Kakutei := NoIME := True	; ASCIIコード以外の文字は IMEをオフにして出力する
			}
			else if (StrChopped = "{NoIME}")
			{
				if (!Kakutei)
					Str2 .= "{確定}"
				if (!NoIME)
					Str2 .= "{NoIME}"
				Kakutei := NoIME := True
			}
			else if (StrChopped = "{確定}")
			{
				if (!NoIME && !Kakutei)
					Str2 .= "{確定}"
				Kakutei := True
			}
			else if (SubStr(StrChopped, 1, 6) = "{Enter")
			{
				Str2 .= StrChopped
				Kakutei := True	; "{Enter" で確定状態
			}
			else if (Str1 != "^v" && StrChopped == "^v")	; "^v" 単独は除外
			{
				if (!NoIME && !Kakutei)
					Str2 .= "{確定}"
				Str2 .= StrChopped
				Kakutei := True
			}
			else if (StrChopped = "{UndoIME}")	; IME入力モードの回復
			{
				if (NoIME)
					Str2 .= "{UndoIME}"
				NoIME := False
			}
			else if (StrChopped = "{IMEOFF}")
			{
				Str2 .= StrChopped
				Kakutei := True
				NoIME := False
			}
			else if (StrChopped = "{IMEON}"
				|| StrChopped == "{全英}" || StrChopped == "{半ｶﾅ}")
			{
				Str2 .= StrChopped
				NoIME := False
			}
			else if (StrChopped == " ")
			{
				Str2 .= "{vk20}"
				Kakutei := False
			}
			else
			{
				Str2 .= StrChopped
				Kakutei := False
			}

			StrChopped := ""
			LenChopped := 0
		}
		i++
	}

	return Str2
}

; 定義登録
; KanaMode	0: 英数, 1: かな
; KeyComb	キーをビットに置き換えたものの集合
; ConvYoko	False: Str1 - 縦書き定義, Str2 - 横書き定義
;			True:  Str1 - 縦書き定義, Str2 - Str1から変換必要
; CtrlNo	0: リピートなし, R: リピートあり, それ以外: かな配列ごとの特殊コード
SetDefinition(KanaMode, KeyComb, ConvYoko, Str1, Str2, CtrlNo)
{
	global DefsKey, DefsGroup, DefsKanaMode, DefsTateStr, DefsYokoStr, DefsCtrlNo
		, DefBegin, DefEnd
		, KanaGroup, R
;	local nkeys		; 何キー同時押しか
;		, i, imax	; カウンタ用

	if (!CtrlNo || CtrlNo == R)
	{
		; 機能を置き換え、ASCIIコードでない文字が入っていたら、"{確定}""{NoIME}"を書き足す
		; "{直接}"は"{Raw}"に書き換え
		Str1 := Analysis(Str1)
		if (ConvYoko)
			Str2 := ConvTateYoko(Str1)	; 縦横変換
		else
			Str2 := Analysis(Str2)
	}
	else if (ConvYoko)
		Str2 := ConvTateYoko(Str1)	; 縦横変換

	; 登録
	nkeys := CountBit(KeyComb)	; 何キー同時押しか
	i := DefBegin[nkeys]		; 始まり
	imax := DefEnd[nkeys]			; 終わり
	while (i < imax)
	{
		; 定義の重複があったら、古いのを消す
		; 参考: https://so-zou.jp/software/tool/system/auto-hot-key/expressions/
		if (DefsKey[i] == KeyComb && DefsKanaMode[i] == KanaMode)
		{
			DefsKey.RemoveAt(i)
			DefsGroup.RemoveAt(i)
			DefsKanaMode.RemoveAt(i)
			DefsTateStr.RemoveAt(i)
			DefsYokoStr.RemoveAt(i)
			DefsCtrlNo.RemoveAt(i)

			DefEnd[1]--
			if (nkeys > 1)
				DefBegin[1]--, DefEnd[2]--
			if (nkeys > 2)
				DefBegin[2]--, DefEnd[3]--
			break
		}
		i++
	}
	if ((CtrlNo && CtrlNo != R) || Str1 != "" || Str2 != "")
	{
		; 定義あり
		i := DefEnd[nkeys]
		DefsKey.InsertAt(i, KeyComb)
		DefsGroup.InsertAt(i, KanaGroup)
		DefsKanaMode.InsertAt(i, KanaMode)
		DefsTateStr.InsertAt(i, Str1)
		DefsYokoStr.InsertAt(i, Str2)
		DefsCtrlNo.InsertAt(i, CtrlNo)

		DefEnd[1]++
		if (nkeys > 1)
			DefBegin[1]++, DefEnd[2]++
		if (nkeys > 2)
			DefBegin[2]++, DefEnd[3]++
	}
	return
}

; かな定義登録
SetKana(KeyComb, Str1, CtrlNo:=0)	; 横書き用は自動変換
{
	SetDefinition(1, KeyComb, True, Str1, "", CtrlNo)
	return
}
SetKana2(KeyComb, Str1, Str2, CtrlNo:=0)
{
	SetDefinition(1, KeyComb, False, Str1, Str2, CtrlNo)
	return
}
; 英数定義登録
SetEisu(KeyComb, Str1, CtrlNo:=0)	; 横書き用は自動変換
{
	global EisuSandS, KC_SPC

	if (!EisuSandS && (KeyComb & KC_SPC))	; 英数入力時のSandSが無効の時
		Str1 := ""
	SetDefinition(0, KeyComb, True, Str1, "", CtrlNo)
	return
}
SetEisu2(KeyComb, Str1, Str2, CtrlNo:=0)
{
	global EisuSandS, KC_SPC

	if (!EisuSandS && (KeyComb & KC_SPC))	; 英数入力時のSandSが無効の時
		Str1 := Str2 := ""
	SetDefinition(0, KeyComb, False, Str1, Str2, CtrlNo)
	return
}

; 一緒に押すと同時押しになるキーを探す
FindCombinableBit(SearchBit, KanaMode, nkeys)
{
	global DefsKey, DefsKanaMode, DefBegin, DefEnd
		, KC_SPC
;	local j, jmax	; カウンタ用
;		, Bit
;		, DefKeyCopy

	Bit := (nkeys > 1 ? 0 : KC_SPC)
	j := DefBegin[3]
	jmax := (nkeys >= 1 && nkeys <= 3 ? DefEnd[nkeys] : DefEnd[1])
	while (j < jmax)
	{
		DefKeyCopy := DefsKey[j]
		if (KanaMode == DefsKanaMode[j] && (DefKeyCopy & SearchBit) == SearchBit)
			Bit |= DefKeyCopy
		j++
	}
;	Bit &= SearchBit ^ (-1)	; 検索中のキーを削除

	return Bit
}

; 一緒に押すと同時押しになるキーを DefsCombinableBit[] に記録
SettingLayout()
{
	global DefsKey, DefsKanaMode, DefsCombinableBit, DefBegin, DefEnd
;	local i, imax	; カウンタ用
;		, SearchBit

	; 出力確定するか検索
	i := DefBegin[3]
	imax := DefEnd[1]
	while (i < imax)
	{
		SearchBit := DefsKey[i]
		DefsCombinableBit[i] := FindCombinableBit(SearchBit, DefsKanaMode[i], CountBit(SearchBit))
		i++
	}
	return
}

; 使用している MS-IME を調べる。10秒経過していれば再調査。
; 戻り値	"MSIME": 新MS-IME登場以前のもの,
;			"NewMSIME":	新MS-IME, "OldMSIME": 以前のバージョンのMS-IMEを選んでいる
;			"ATOK": ATOK
DetectMSIME()
{
	global IMESelect, GoodHwnd, BadHwnd
	static IMEName := ""
		, LastSearchTime := 0
;	local Value, NowIME

	NowIME := IMEName

	if (IMESelect)
		NowIME := "ATOK"
	else if (A_TickCount < LastSearchTime || LastSearchTime + 10000 < A_TickCount)
	{
		LastSearchTime := A_TickCount
		; 「以前のバージョンの Microsoft IME を使う」がオンになっているか調べる
		; 参考: https://registry.tomoroh.net/archives/11547
		RegRead, Value, HKEY_CURRENT_USER
			, SOFTWARE\Microsoft\Input\TSF\Tsf3Override\{03b5835f-f03c-411b-9ce2-aa23e1171e36}
			, NoTsf3Override2
		NowIME := (ErrorLevel == 1 ? "MSIME" : (Value ? "OldMSIME" : "NewMSIME"))
	}

	if (NowIME != IMEName)
		GoodHwnd := BadHwnd := ""
	return (IMEName := NowIME)
}

; 文字列 Str1 を適宜ディレイを入れながら出力する
SendEachChar(Str1, Delay:=0)
{
	global IMESelect, GoodHwnd, BadHwnd, LastSendTime
	static flag := 0	; 変換1回目のIME窓検出用	0: 検出済みか文字以外, 1: 文字入力中, 2: 変換1回目
;	local Hwnd
;		, len1						; Str1 の長さ
;		, StrChopped, LenChopped	; 細切れにした文字列と、その長さを入れる変数
;		, i, c, bracket
;		, NoIME, IMEConvMode		; IME入力モードの保存、復元に関するフラグと変数
;		, PreDelay, PostDelay		; 出力前後のディレイの値
;		, FinalDelay
;		, LastDelay					; 前回出力時のディレイの値
;		, Slow
;		, ClipSaved
;		, KakuteiIsEnter	; 文字確定させるのにエンターのみで良ければ True

;ToolTip, %Str1%
;SetTimer, RemoveToolTip, 2000
	KakuteiIsEnter := False
	WinGet, Hwnd, ID, A

	Slow := IMESelect
	IfWinActive, ahk_class CabinetWClass	; エクスプローラーにはゆっくり出力する
		Delay := (Delay < 10 ? 10 : Delay)
	else IfWinActive, ahk_class Hidemaru32Class	; 秀丸エディタ
		Slow := (IMESelect ? 0x11 : Slow)
;	SetKeyDelay, -1, -1

	LastDelay := Floor(QPC() - LastSendTime)

	; 文字列を細切れにして出力
	NoIME := False
	StrChopped := Str2 := ""
	LenChopped := 0
	bracket := 0
	i := 1
	len1 := StrLen(Str1)
	while (i <= len1)
	{
		; ディレイの初期値
		PreDelay := 0
		PostDelay := Delay

		c := SubStr(Str1, i, 1)
		if (c == "}" && bracket != 1)
			bracket := 0
		else if (c == "{" || bracket)
			bracket++
		StrChopped .= c
		LenChopped++
		if (!(bracket || c == "+" || c == "^" || c == "!" || c == "#")
			|| i == len1 )
		{
			; "{Raw}"からの残りは全部出力する
			if (SubStr(StrChopped, LenChopped - 4, 5) = "{Raw}")
			{
				i++
				while (i <= len1)
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
					if (PostDelay > 0)
						Sleep, PostDelay
				}
				StrChopped := ""	; 後で誤作動しないように消去
				LastDelay := (PostDelay > 0 ? PostDelay : 0)
			}

			; 出力するキーを変換
			else if (StrChopped = "{vkF2}" || StrChopped == "{vkF3}")
			{	; ひらがなキー、半角/全角キー
				Str2 := StrChopped
				PostDelay := 30
			}
			else if (StrChopped == "{確定}")
			{
				if (LastDelay < 30)
					Sleep, % 30 - LastDelay	; 前回の出力から 30ミリ秒経ってから IME_GET()
				if (IME_GET() && IME_GetSentenceMode())	; 変換モード(無変換)ではない
				{
					if (DetectMSIME() = "OldMSIME" && PostDelay < 30)
						PostDelay := 30
					else if (PostDelay < 10)
						PostDelay := 10

					if (Hwnd != GoodHwnd || LastDelay < (IMESelect ? 90 : 40))
						; IME窓の検出を当てにできない
						; あるいは文字確定から時間が経っていない(IME窓消失まで、旧MS-IMEは最大40ms、ATOKは最大90ms)
					{
						Send, =
						Sleep, PostDelay
						Send, {Enter}
						Sleep, PostDelay
						Str2 := "{BS}"
						PostDelay := 0
					}
					else if (KakuteiIsEnter	|| IME_GetConverting())
						; 文字確定させるのにエンターのみで良い、またはIME窓あり
						Str2 := "{Enter}"
				}
			}
			else if (StrChopped = "{NoIME}" && IME_GET())	; IMEをオフにするが後で元に戻せるようにする
			{
				NoIME := True
				IMEConvMode := IME_GetConvMode()	; IME入力モードを保存する
				Str2 := "{vkF3}"	; 半角/全角
				PostDelay := 30
			}
			else if (StrChopped = "{IMEOFF}")
			{
				NoIME := False
				PreDelay := 50
				if (LastDelay < PreDelay)
					Sleep, % PreDelay - LastDelay
				IME_SET(0)			; IMEオフ
				LastDelay := 0
			}
			else if (StrChopped = "{IMEON}")
			{
				NoIME := False
				IME_SET(1)			; IMEオン
				LastDelay := 0
			}
			else if (StrChopped == "{全英}")
			{
				NoIME := False
				IME_SET(1)			; IMEオン
				IME_SetConvMode(24)	; IME 入力モード	全英数
				LastDelay := 0
			}
			else if (StrChopped == "{半ｶﾅ}")
			{
				NoIME := False
				IME_SET(1)			; IMEオン
				IME_SetConvMode(19)	; IME 入力モード	半ｶﾅ
				LastDelay := 0
			}
			; ATOK+秀丸エディタで、文字列途中のエンターをゆっくり出力する
			else if (Slow == 0x11
			 && i != StrChopped && SubStr(StrChopped, 1, 6) = "{Enter")
			{
				Str2 := StrChopped
				PreDelay := 80
				PostDelay := 100	; 秀丸エディタ + ATOK 用
			}
			else if (StrChopped = "{C_Clr}")
				clipboard =					;クリップボードを空にする
			else if (SubStr(StrChopped, 1, 7) = "{C_Wait")
			{
				Wait := SubStr(StrChopped, 9)		; 例: {C_Wait 0.5} は 0.5秒クリップボードの更新を待つ
				ClipWait, (Wait ? Wait : 0.2), 1
			}
			else if (StrChopped = "{C_Bkup}")
				ClipSaved := ClipboardAll	;クリップボードの全内容を保存
			else if (StrChopped = "{C_Rstr}")
			{
				Clipboard := ClipSaved		;クリップボードの内容を復元
				ClipSaved =					;保存用変数に使ったメモリを開放
			}
			else if (StrChopped != "{Null}" && StrChopped != "{UndoIME}")
				Str2 := StrChopped

			; 変換1回目を検出
			if (Hwnd != BadHwnd && Hwnd != GoodHwnd && IME_GET())
			{
				if (DetectMSIME() = "NewMSIME")
					BadHwnd := Hwnd
				else if (flag && (Str2 = "{vk20}" || Str2 = "{Space down}"))
				{	; 変換1回目
					PostDelay := 70	; IME_GetConverting() が確実に変化する時間
					flag++
				}
				else if (LenChopped == 1)	; 文字が入力されたとき(ほぼローマ字変換された文字に相当)
					flag := 1
				else
					flag := 0
			}
			else
				flag := 0

			; キー出力
			if (Str2)
			{
				; 前回の出力からの時間が短ければ、ディレイを入れる
				if (LastDelay < PreDelay)
					Sleep, % PreDelay - LastDelay
				Send, % "{Blind}" . Str2
				; 出力直後のディレイ
				if (PostDelay > 0)
					Sleep, % (LastDelay := PostDelay)
				else
					LastDelay := 0
			}

			; 変換1回目でIME窓が検出できれば良し。できなければIME窓の検出は当てにしない
			if (flag > 1)
			{
				if (IME_GetConverting())
					GoodHwnd := Hwnd
				else
					BadHwnd := Hwnd
				flag := 0
			}

			; 文字確定させるのにエンターのみで良いか検出
			if (LenChopped == 1 || (LenChopped == 3 && Asc(Str2) == 123))
				KakuteiIsEnter := True	; 1文字、または { で始まる3文字ならエンターのみで良い
			else
				KakuteiIsEnter := False

			; 必要なら IME の状態を元に戻す
			if (NoIME && (i >= len1 || StrChopped = "{UndoIME}"))
			{
				NoIME := False
				if (Slow == 0x11)
				{
					PreDelay := 70
					PostDelay := 90	; 秀丸エディタ + ATOK 用
				}
				else if (Slow == 1)
				{
					PreDelay := 50
					PostDelay := 70	; ATOK 用
				}
				else
					PostDelay := 30	; 新MS-IME用
				; 前回の出力からの時間が短ければ、ディレイを入れる
				if (LastDelay < PreDelay)
					Sleep, % PreDelay - LastDelay
				Send, {vkF3}	; 半角/全角
				Sleep, % (LastDelay := PostDelay)
				; IME入力モードを回復する
				if (IMEConvMode)
				{
					IME_SetConvMode(IMEConvMode)
					Sleep, % (LastDelay := Delay)
				}
			}

			StrChopped := Str2 := ""
			LenChopped := 0
		}
		i++
	}

	LastSendTime := QPC() - LastDelay	; 最後に出力した時間を記録
	return
}

; 押し下げを出力中のキーを上げ、別のに入れ替え
SendKeyUp(Str1:="")
{
	global RestStr

	if (RestStr != "")
		SendEachChar(RestStr)
	RestStr := Str1

	return
}

; キーの上げ下げを分離
;	返り値: 下げるキー
;	RestStr: 後で上げるキー
SplitKeyUpDown(Str1)
{
	global RestStr	; まだ上げていないキー
	static KeyDowns := Object("{Space}", "{Space down}"
;			, "{Home}", "{Home down}", "{End}", "{End down}", "{PgUp}", "{PgUp down}", "{PgDn}", "{PgDn down}"
			, "{Up}", "{Up down}", "{Left}", "{Left down}", "{Right}", "{Right down}", "{Down}", "{Down down}")
		, KeyUps := Object("{Space}", "{Space up}"
;			, "{Home}", "{Home up}", "{End}", "{End up}", "{PgUp}", "{PgUp up}", "{PgDn}", "{PgDn up}"
			, "{Up}", "{Up up}", "{Left}", "{Left up}", "{Right}", "{Right up}", "{Down}", "{Down up}")
;	local Str2, KeyDown, KeyUp


	if (Asc(Str1) == 43)	; "+" から始まる
	{
		Str2 := SubStr(Str1, 2)	; 先頭の "+" を消去
		KeyDown := KeyDowns[Str2]
		if (KeyDown == "")	; キーの上げ下げを分離しない時
		{
			SendKeyUp()	; 押し下げを出力中のキーを上げる
			return Str1
		}
		KeyUp := KeyUps[Str2] . "{ShiftUp}"
		if (RestStr != KeyUp)
		{
			SendKeyUp(KeyUp)	; 押し下げを出力中のキーを入れ替え
			KeyDown := "{ShiftDown}" . KeyDown
		}
	}
	else
	{
		KeyDown := KeyDowns[Str1]
		if (KeyDown == "")	; キーの上げ下げを分離しない時
		{
			SendKeyUp()	; 押し下げを出力中のキーを上げる
			return Str1
		}
		KeyUp := KeyUps[Str1]
		if (RestStr != KeyUp)
			SendKeyUp(KeyUp)	; 押し下げを出力中のキーを入れ替え
	}
	return KeyDown
}

; 仮出力バッファの先頭から i 個出力する
; i の指定がないときは、全部出力する
OutBuf(i:=2)
{
	global _usc, OutStrs, OutCtrlNos, R
;	local Str1, CtrlNo, EnterPos

	while (i > 0 && _usc > 0)
	{
		Str1 := OutStrs[1]
		CtrlNo := OutCtrlNos[1]
		if (!CtrlNo || CtrlNo == R)
		{
			Str1 := SplitKeyUpDown(Str1)	; キーの上げ下げを分離
			StringGetPos, EnterPos, Str1, {Enter, R			; 右から "{Enter" を探す
			if (InStr(Str1, "{NoIME}") || EnterPos >= 1)	; "{NoIME}" が入っているか、"{Enter" が途中にある
			{
				if (DetectMSIME() = "OldMSIME" && EnterPos >= 0)
					; 新旧MSIMEが選べる環境で旧MSIMEを使い、改行が含まれる時
					SendEachChar(Str1, 30)	; ゆっくりと出力
				else
					SendEachChar(Str1, 10)	; 1文字ごとに 10ms のスリープ
			}
			else
				SendEachChar(Str1)
		}
		else
		{
			SendKeyUp()				; 押し下げを出力中のキーを上げる
			SendSP(Str1, CtrlNo)	; 特別出力(かな定義ファイルで操作)
		}

		OutStrs[1] := OutStrs[2]
		OutCtrlNos[1] := OutCtrlNos[2]
		_usc--
		i--
	}
	DispStr()	; 表示待ち文字列表示
	return
}

; 仮出力バッファを最後から nBack 回分を削除して、Str1 と OutCtrlNos を保存
StoreBuf(nBack, Str1, CtrlNo:=0)
{
	global _usc, OutStrs, OutCtrlNos

	if (nBack > 0)
	{
		_usc -= nBack
		if (_usc < 0)
			_usc := 0	; バッファが空になる以上は削除しない
	}
	else if (_usc == 2)	; バッファがいっぱいなので、1文字出力
		OutBuf(1)
	_usc++
	OutStrs[_usc] := Str1
	OutCtrlNos[_usc] := CtrlNo
	DispStr()	; 表示待ち文字列表示
	return
}

; 出力する文字列を選択
SelectStr(i)
{
	global Vertical, DefsTateStr, DefsYokoStr

	return (Vertical ? DefsTateStr[i] : DefsYokoStr[i])
}

; TimeA からの時間を表示[ミリ秒単位]
DispTime(TimeA, Str1:="")
{
	global TestMode
;	local TimeAtoB

	if (TestMode == 1)
	{
		TimeAtoB := Round(QPC() - TimeA, 1)
		ToolTip, %TimeAtoB% ms%Str1%
		SetTimer, RemoveToolTip, 1000
	}
}

; 表示待ち文字列表示
DispStr()
{
	global TestMode, _usc, OutStrs

	if (TestMode == 2)
	{
		if (!_usc)
			ToolTip
		else
		{
			if (_usc == 1)
				Str1 := OutStrs[1]
			else
				Str1 := OutStrs[1] . "`n" . OutStrs[2]
			ToolTip, %Str1%
		}
	}
}

; 変換、出力
Convert()
{
	global InBufsKey, InBufReadPos, InBufsTime, InBufRest
		, KC_SPC, JP_YEN, KC_INT1, R
		, DefsKey, DefsGroup, DefsKanaMode, DefsCombinableBit, DefsCtrlNo, DefBegin, DefEnd
		, _usc, LastSendTime
		, SideShift, EnterShift, ShiftDelay, CombDelay, SpaceKeyRepeat
		, CombLimitN, CombStyleN, CombKeyUpN, CombLimitS, CombStyleS, CombKeyUpS, CombLimitE, CombKeyUpSPC
		, KeyUpToOutputAll, EisuSandS
	static ConvRest	:= 0	; 入力バッファに積んだ数/多重起動防止フラグ
		, LastKey	:= ""	; 前回のキー入力
		, NextKey	:= ""	; 次回送りのキー入力
		, RealBit	:= 0	; 今押している全部のキービットの集合
		, LastBit	:= 0	; 前回のキービット
		, Last2Bit	:= 0	; 前々回のキービット
		, ReuseBit	:= 0	; 復活したキービット
		, LastKeyTime := 0	; 有効なキーを押した時間
		, EndOfTime := 0.0	; タイマーを止めたい時間
		, KanaMode	:= 0	; 0: 英数入力, 1: かな入力
		, OutStr	:= ""	; 出力する文字列
		, LastStr	:= ""	; 前回、出力した文字列(リピート、後置シフト用)
		, _lks		:= 0	; 前回、何キー同時押しだったか？
		, LastGroup	:= 0	; 前回、何グループだったか？ 0はグループなし
		, RepeatBit	:= 0	; リピート中のキーのビット
		; シフト用キーの状態 0: 押していない, 1: 単独押し, 2: シフト継続中, 3: リピート中
		, spc		:= 0	; スペースキー
		, sft		:= 0	; 左右シフト
		, ent		:= 0	; エンター
		, CombinableBit := -1 ; 押すと同時押しになるキー (-1 は次の入力で即確定しないことを意味する)
;	local KeyTime	; キーを押した時間
;		, PreDelay
;		, IMEState, IMEConvMode
;		, NowKey, len
;		, Term		; 入力の末端2文字
;		, nkeys		; 今回は何キー同時押しか
;		, NowBit	; 今回のキービット
;		, BitMask
;		, nBack
;		, SearchBit	; いま検索しようとしているキーの集合
;		, ShiftStyle
;		, i, imax		; カウンタ用
;		, DefKeyCopy
;		, CtrlNo
;		, OutOfCombDelay
;		, EnableComb

	if (ConvRest || NextKey != "")
		return	; 多重起動防止で戻る

	; 入力バッファが空になるまで
	while (ConvRest := 31 - InBufRest || NextKey != "")
	{
		SetTimer, KeyTimer, Off		; 判定期限タイマー停止

		if (NextKey == "")
		{
			; 入力バッファから読み出し
			NowKey := InBufsKey[InBufReadPos], KeyTime := InBufsTime[InBufReadPos]
				, InBufReadPos := ++InBufReadPos & 31, InBufRest++
			if (NowKey != LastKey)
				LastKey := NowKey

			; 判定期限到来
			if (NowKey == "KeyTimer")
			{
				if (InBufRest != 31)	; タイマー割込みとキー割込みの行き違い防止 https://github.com/tor-nky/Hachiku/issues/19
					continue
				if (KeyTime > EndOfTime)
				{
					OutBuf()
					DispTime(LastKeyTime, "`n判定期限")	; キー変化からの経過時間を表示
				}
				else
					SetTimer, KeyTimer, -10	; 10ミリ秒後に再判定
				continue
			}
		}
		else
		{	; 前回の残りを読み出し
			NowKey := NextKey
			NextKey := ""
		}

		; IME の状態を更新
		IfWinExist, ahk_class #32768	; コンテキストメニューが出ている時
			KanaMode := 0
		else if (Asc(NowKey) == 43 && SideShift == 1)	; 左右シフト英数２
			KanaMode := 0
		else
		{
			IMEState := IME_GET()
			IMEConvMode := IME_GetConvMode()
			if (IMEState == 0 && LastSendTime + 50.0 <= QPC())
				KanaMode := 0	; 英数入力中なら、前回の出力から 50ミリ秒経っていたら変数を更新
			else if (IMEState == 1 && IMEConvMode != "")	; かな入力中
				KanaMode := IMEConvMode & 1
		}

		; 左右シフト処理
		if (Asc(NowKey) == 43)		; "+" から始まる
		{
			if (!sft && GetKeyState("Shift", "P"))	; 左右シフトなし→あり
			{
				OutBuf()
				NextKey := NowKey
				NowKey := "sc39"	; スペース押す→押したキー
				sft := 1
			}
			else
				NowKey := SubStr(NowKey, 2)	; 先頭の "+" を消去
		}
		else if (sft)			; 左右シフトあり→なし
		{
			if (!spc && !ent)
			{
				NextKey := NowKey
				NowKey := "sc39 up"	; スペース上げ→押したキー
			}
			sft := 0
		}
		; スペースキー処理
		else if (NowKey == "sc39")
		{
			if ((!IMEConvMode && DetectMSIME() != "NewMSIME")	; Firefox と Thunderbird のスクロール対応(新MS-IMEは除外)
				|| (!EisuSandS && !KanaMode))		; SandSなしの設定で英数入力時
			{
				StoreBuf(0, "{Space}", R)
				OutBuf()
				DispTime(KeyTime)	; キー変化からの経過時間を表示
				continue
			}
			else if (SpaceKeyRepeat && (spc & 1))	; スペースキーの長押し
			{
				if (SpaceKeyRepeat == 1)	; スペースキーの長押し	1: 空白キャンセル
					spc := 2	; シフト継続中
				else
				{
					spc := 3	; 空白をリピート中
					StoreBuf(0, "{Space}", R)
					OutBuf()
				}
				DispTime(KeyTime, "`nスペース長押し")	; キー変化からの経過時間を表示
				continue
			}
			else if (!spc)
				spc := 1	; 単独押し
		}
		else if (NowKey == "sc39 up")
		{
			if (sft || ent)		; 他のシフトを押している時
			{
				if (spc == 1)
					NowKey := "vk20"	; スペース単独押しのみ
				else
				{
					spc := 0
					SendKeyUp()			; 押し下げを出力中のキーを上げる
					DispTime(KeyTime)	; キー変化からの経過時間を表示
					continue
				}
			}
			else if (spc == 1)
				NextKey := "vk20"	; スペース単独押し→スペース上げ
			spc := 0
		}
		; エンターキー処理
		else if (NowKey == "Enter")
;		else if (NowKey == "Enter" && (EisuSandS || KanaMode))	; 英数入力のSandSなし設定でエンターシフトも止めたい時
		{
			if (!GetKeyState("Shift", "P"))	; 本当にシフトキーを押していない時
			{
				NowKey := "sc39"	; スペース押す
				if (!ent)
					ent := 1
			}
		}
		else if (NowKey == "Enter up")
		{
			NowKey := "sc39 up"	; スペース上げ
			if (sft || spc)		; 他のシフトを押している時
			{
				if (ent == 1)
					NowKey := "vk0D"	; エンター単独押しのみ
				else
				{
					ent := 0
					SendKeyUp()			; 押し下げを出力中のキーを上げる
					DispTime(KeyTime)	; キー変化からの経過時間を表示
					continue
				}
			}
			else if (ent == 1)
				NextKey := "vk0D"	; エンター単独押し→スペース上げ ※"Enter"としないこと
			ent := 0
		}
		else if (spc == 3)		; スペースのリピートを止める
		{
			if (KanaMode)
			{
				NextKey := NowKey
				NowKey := "vk1B"	; Shiftが付け加えられて Shift+Esc(変換取消)→シフト側文字
			}
			spc := 2	; シフト継続中
		}

		nkeys := 0	; 何キー同時押しか、を入れる変数
		len := StrLen(NowKey)
		Term := SubStr(NowKey, len - 1)	; Term に入力末尾の2文字を入れる
		; キーが離れた時
		if (Term == "up")
		{
			if (SubStr(NowKey, 1, 2) == "sc")
				NowBit := "0x" . SubStr(NowKey, len - 4, 2)
			else
				NowBit := 0
		}
		else
		{
			; sc** で入力
			if (SubStr(NowKey, 1, 2) == "sc")
			{
				NowBit := "0x" . Term
				OutStr := "{sc" . Term . "}"
			}	; ここで NowBit に sc○○ から 0x○○ に変換されたものが入っているが、
				; Autohotkey は十六進数の数値としてそのまま扱える
			; sc** 以外で入力
			else
			{
				NowBit := SearchBit := 0
				OutStr := "{" . NowKey . "}"
				nkeys := -1	; 後の検索は不要
			}
			; スペースキーが押されていたら、シフトを加えておく(SandSの実装)
			if (RealBit & KC_SPC)
				OutStr := "+" . OutStr
		}

		; ビットに変換
		if (NowBit == 0x7D)			; (JIS)\
			NowBit := JP_YEN
		else if (NowBit == 0x73)	; (JIS)_
			NowBit := KC_INT1
		else if (NowBit)
			NowBit := 1 << NowBit

		; キーリリース時
		if (Term == "up")
		{
			BitMask := NowBit ^ (-1)	; RealBit &= ~NowBit では32ビット計算になることがあるので
			RealBit &= BitMask

			; 文字キーによるシフトの適用範囲
			if (CombKeyUpSPC && NowBit == KC_SPC)
				ShiftStyle := CombKeyUpS	; スペースキーを離した時は、スペース押下時の設定
			else
				ShiftStyle := ((RealBit & KC_SPC) ? CombKeyUpS : CombKeyUpN)

			if (KeyUpToOutputAll || (LastBit & NowBit) || NowBit == 0)
			{	; 「キーを離せば常に全部出力する」がオン、または直近の検索結果のキーを離した
				OutBuf()
				SendKeyUp()	; 押し下げを出力中のキーを上げる
;				LastStr := ""
				_lks := 0
			}
			else if (_usc == 2 && _lks == 1 && NowBit == Last2Bit)
			{	; 同時押しにならなくなった
				OutBuf(1)	; 1個出力
				CombinableBit |= NowBit ; 次の入力で即確定しないキーに追加
			}
			RepeatBit := 0
			ReuseBit := (ShiftStyle ? 0 : RealBit)	; 文字キーシフト全復活
			if (ShiftStyle >= 2)	; 全解除
				Last2Bit := LastBit := 0
			else					; 他
			{
				Last2Bit &= BitMask
				LastBit &= BitMask
			}
			DispTime(KeyTime)	; キー変化からの経過時間を表示
		}
		; (キーリリース直後か、通常シフトまたは後置シフトの判定期限後に)スペースキーが押された時
		else if (NowBit == KC_SPC && !(RealBit & NowBit)
			&& (!_usc || LastKeyTime + ShiftDelay < KeyTime))
		{
			OutBuf()
			RealBit |= KC_SPC
			RepeatBit := 0		; リピート解除
			DispTime(KeyTime)	; キー変化からの経過時間を表示
		}
		; 押されていなかったキー、sc**以外のキー
		else if !(RealBit & NowBit)
		{
			RealBit |= NowBit
			; 文字キーによるシフトの適用範囲
			if (CombLimitE && !KanaMode)
				ShiftStyle := 3	; 英数入力時に判定期限ありなら、文字キーシフトは1回のみ
			else
				ShiftStyle := ((RealBit & KC_SPC) ? CombStyleS : CombStyleN)
;			LastGroup := (ShiftStyle == 0 ? 0 : LastGroup)	; かわせみ2用と同じ動作にするなら有効に

			; 同時押しの判定期限到来
			EnableComb := True
			if (NowBit != KC_SPC && CombDelay > 0 && LastKeyTime + CombDelay < KeyTime
			 && ((CombLimitN && !(RealBit & KC_SPC)) || (CombLimitS && (RealBit & KC_SPC)) || (CombLimitE && !KanaMode)))
			{
				OutOfCombDelay := True
				if ((ShiftStyle == 2 && !LastGroup) || ShiftStyle >= 3)
					EnableComb := False	; 同時押しを一時停止
			}
			else
				OutOfCombDelay := False
			; 今押したキーで同時押しにならない
			if !(CombinableBit & NowBit)
				OutBuf()

			nBack := 0
			while (!nkeys)
			{
				; 3キー入力を検索
				if ((Last2Bit | ReuseBit) && EnableComb)
				{
					i := DefBegin[3]
					imax := DefEnd[3]	; 検索場所の設定
					SearchBit := (!ShiftStyle ? RealBit : (RealBit & KC_SPC) | NowBit | LastBit | Last2Bit | ReuseBit)
						; 文字キーによるシフトの適用範囲
					while (i < imax)
					{
						DefKeyCopy := DefsKey[i]
						if ((DefKeyCopy & NowBit) ; 今回のキーを含み
							&& (DefKeyCopy & SearchBit) == DefKeyCopy ; 検索中のキー集合が、いま調べている定義内にあり
							&& (DefKeyCopy & KC_SPC) == (SearchBit & KC_SPC) ; シフトの相違はなく
							&& DefsKanaMode[i] == KanaMode)	; 英数用、かな用の種別が一致していること
						{
							; 文字キーシフト「1回のみ」で2回目なら、1キー入力の検索へ
							if (ShiftStyle >= 3 && _lks >= 3 && NowBit != KC_SPC)
							{
								EnableComb := False
								break
							}
							; 見つかった!
							else if (!LastGroup || LastGroup == DefsGroup[i] || NowBit == KC_SPC
								|| (_lks < 3 && !OutOfCombDelay))
							{
								; 前回が2キー、3キー同時押しだったら、1文字消して仮出力バッファへ
								; 前回が1キー入力だったら、2文字消して仮出力バッファへ
								nBack := (_lks >= 2 ? 1 : 2)
								nkeys := 3
								break
							}
							; 文字キーシフト「同グループのみ継続」で同グループでなければ次を検索する
						}
						i++
					}
				}
				; 2キー入力を検索
				if (!nkeys && (LastBit | ReuseBit) && EnableComb)
				{
					i := DefBegin[2]
					imax := DefEnd[2]	; 検索場所の設定
					SearchBit := (!ShiftStyle ? RealBit : (RealBit & KC_SPC) | NowBit | LastBit | ReuseBit)
						; 文字キーによるシフトの適用範囲
					while (i < imax)
					{
						DefKeyCopy := DefsKey[i]
						if ((DefKeyCopy & NowBit) ; 今回のキーを含み
							&& (DefKeyCopy & SearchBit) == DefKeyCopy ; 検索中のキー集合が、いま調べている定義内にあり
							&& (DefKeyCopy & KC_SPC) == (SearchBit & KC_SPC) ; シフトの相違はなく
							&& DefsKanaMode[i] == KanaMode)	; 英数用、かな用の種別が一致していること
						{
							; 文字キーシフト「1回のみ」で2回目なら、1キー入力の検索へ
							if (ShiftStyle >= 3 && _lks >= 2 && NowBit != KC_SPC)
							{
								EnableComb := False
								break
							}
							; 見つかった!
							else if (!LastGroup || LastGroup == DefsGroup[i] || NowBit == KC_SPC
								|| (_lks < 2 && !OutOfCombDelay))
							{
								if (_usc == 2)
									OutBuf(1)	; 3キー前の入力は出力決定
								nBack := (_lks >= 2 && NowBit != KC_SPC ? 0 : 1)
								nkeys := 2
								break
							}
							; 文字キーシフト「同グループのみ継続」で同グループでなければ次を検索する
						}
						i++
					}
				}
				; 1キー入力を検索
				if (!nkeys)
				{
					i := DefBegin[1]
					imax := DefEnd[1]	; 検索場所の設定
					if (NowBit == KC_SPC)
						SearchBit := KC_SPC | LastBit
					else
						SearchBit := (RealBit & KC_SPC) | NowBit
					while (i < imax)
					{
						if (SearchBit == DefsKey[i] && KanaMode == DefsKanaMode[i])
						{
							; 見つかった!
							if (!LastGroup || LastGroup == DefsGroup[i] || NowBit == KC_SPC)
							{
								if (NowBit == KC_SPC)
									nBack := 1
								nkeys := 1
								break
							}
						}
						i++
					}
				}
				; 検索終了
				if (!LastGroup || nkeys)
					break
				; グループなしで再度検索
				LastGroup := 0
				if (ShiftStyle == 2)	; (同グループのみ継続)同グループが見つからなかった
					EnableComb := False
			}
			if (!EnableComb)	; 同時押しを一時停止中
				ReuseBit := Last2Bit := LastBit := 0

			; スペースを押したが、定義がなかった時
			if (NowBit == KC_SPC && !nkeys)
			{
				if (!_usc)	; 仮出力バッファが空の時
				{
					RepeatBit := 0		; リピート解除
					DispTime(KeyTime)	; キー変化からの経過時間を表示
					continue
				}
				else
				{
					OutStr := "+" . LastStr	; 後置シフト
					nBack := 1
				}
			}
			if (spc == 1)
				spc := 2	; 単独スペースではない
			if (ent == 1)
				ent := 2	; 単独エンターではない

			; 出力する文字列を選ぶ
			CtrlNo := 0
			if (nkeys > 0)	; 定義が見つかった時
			{
				OutStr := SelectStr(i)					; 出力する文字列
				CombinableBit := DefsCombinableBit[i]	; 一緒に押すと同時押しになるキーを探す
				CtrlNo := DefsCtrlNo[i]
			}
			else if (!nkeys)	; 定義が見つけられなかった時
				; 一緒に押すと同時押しになるキーを探す
				CombinableBit := FindCombinableBit(SearchBit, KanaMode, nkeys)
			else
				CombinableBit := 0
			; 仮出力バッファに入れる
			StoreBuf(nBack, OutStr, CtrlNo)

			; 次回の検索用に変数を更新
			LastStr := OutStr		; 今回の文字列を保存
			LastKeyTime := KeyTime	; 有効なキーを押した時間を保存
			_lks := nkeys			; 何キー同時押しだったかを保存
			ReuseBit := 0	; 復活したキービットを消去
			if (nkeys >= 2)	; 2、3キー入力のときは今回のキービットを保存
				Last2Bit := LastBit := DefsKey[i]
			else if (nBack)	; 1キー入力で今はスペースキーを押した
				LastBit := SearchBit
			else			; 繰り上げ
			{
				Last2Bit := LastBit
				LastBit := SearchBit
			}
			LastGroup := (nkeys >= 1 ? DefsGroup[i] : 0)	; 何グループだったか保存
			if (CtrlNo == R)
				RepeatBit := NowBit		; キーリピートする
			else
				RepeatBit := 0

			; 出力確定文字か？
			CombinableBit &= (KeyUpToOutputAll ? RealBit : LastBit) ^ (-1)
				; 「キーを離せば常に全部出力する」がオンなら、現在押されているキーを除外
				; オフなら、いま検索したキーを除外
			if (CombinableBit == 0 || (ShiftDelay <= 0 && CombinableBit == KC_SPC))
				OutBuf()	; 出力確定
			else if (InBufRest == 31 && NextKey == "")
			{
				EndOfTime := 0.0
				; 同時押しの判定期限
				if (CombDelay > 0
				 && ((CombLimitN && !(RealBit & KC_SPC)) || (CombLimitS && (RealBit & KC_SPC)) || (CombLimitE && !KanaMode)))
					EndOfTime := KeyTime + CombDelay	; 期限の時間
				; 後置シフトの判定期限
				if ((CombinableBit == KC_SPC || (EndOfTime > 0.0 && ShiftDelay > 0 && (CombinableBit & KC_SPC)))	; 後者は、同時押しの判定期限があるなら後置シフトの判定期限を待つの意
				 && (EndOfTime == 0.0 || ShiftDelay > CombDelay))
					EndOfTime := KeyTime + ShiftDelay
				; タイマー起動
				if (EndOfTime != 0.0)
					SetTimer, KeyTimer, % QPC() - EndOfTime	; 1回のみのタイマー
			}
			DispTime(KeyTime)	; キー変化からの経過時間を表示
		}
		; リピートできるキー
		else if (NowBit == RepeatBit)
		{	; 前回の文字列を出力
			if (!_usc)
				StoreBuf(0, LastStr)
			OutBuf()
			DispTime(KeyTime, "`nリピート")	; キー変化からの経過時間を表示
		}
	}

	return
}


; ----------------------------------------------------------------------
; ホットキー
; ----------------------------------------------------------------------
#MaxThreadsPerHotkey 3	; 1つのホットキー・ホットストリングに多重起動可能な
						; 最大のスレッド数を設定

; キー入力部
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
Up::	; ※小文字にしてはいけない
Left::
Right::
Down::
Home::
End::
PgUp::
PgDn::
; USキーボードの場合
#If (USKB)
sc29::	; (JIS)半角/全角	(US)`
; キー入力部(左右シフト)
#If (USKBSideShift || !GetKeyState("Shift", "P"))
+sc29::	; (JIS)半角/全角	(US)`
#If (SideShift || !GetKeyState("Shift", "P"))
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
+Up::	; ※小文字にしてはいけない
+Left::
+Right::
+Down::
;+Home::
;+End::
;+PgUp::
;+PgDn::
; エンター同時押しをシフトとして扱う場合
#If (EnterShift)
Enter::
+Enter::
#If		; End #If ()
	; 入力バッファへ保存
	; キーを押す方はいっぱいまで使わない
	InBufsKey[InBufWritePos] := A_ThisHotkey, InBufsTime[InBufWritePos] := QPC()
		, InBufWritePos := (InBufRest > 16 ? ++InBufWritePos & 31 : InBufWritePos)
		, (InBufRest > 16 ? InBufRest-- : )
	Convert()	; 変換ルーチン
	return

; キー押上げ
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
Up up::	; ※小文字にしてはいけない
Left up::
Right up::
Down up::
;Home up::
;End up::
;PgUp up::
;PgDn up::
; USキーボードの場合
#If (USKB)
sc29 up::	; (JIS)半角/全角	(US)`
; キー押上げ(左右シフト)
#If (USKBSideShift || !GetKeyState("Shift", "P"))
+sc29 up::	; (JIS)半角/全角	(US)`
#If (SideShift || !GetKeyState("Shift", "P"))
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
+Up up::	; ※小文字にしてはいけない
+Left up::
+Right up::
+Down up::
;+Home up::
;+End up::
;+PgUp up::
;+PgDn up::
; エンター同時押しをシフトとして扱う場合
#If (EnterShift)
Enter up::
+Enter up::
#If		; End #If ()
; 入力バッファへ保存
	InBufsKey[InBufWritePos] := A_ThisHotkey, InBufsTime[InBufWritePos] := QPC()
		, InBufWritePos := (InBufRest ? ++InBufWritePos & 31 : InBufWritePos)
		, (InBufRest ? InBufRest-- : )
	Convert()	; 変換ルーチン
	return

#MaxThreadsPerHotkey 1	; 元に戻す
