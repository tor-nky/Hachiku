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

; 後置シフトの判定期限タイマー
KeyTimer:
	; 参考: 鶴見惠一；6809マイコン・システム 設計手法，CQ出版社 p.114-121
	; 入力バッファが空の時だけ保存する
	inBufsKey[inBufWritePos] := "KeyTimer", inBufsTime[inBufWritePos] := QPC()
		, inBufWritePos := (inBufRest == 31 ? ++inBufWritePos & 31 : inBufWritePos)
		, (inBufRest == 31 ? inBufRest-- : )
	Convert()	; 変換ルーチン
	Return

; IME窓検出タイマー
JudgeHwnd:
	; 原理は、変換1回目でIME窓が検出できれば良しというもの
	SetTimer, JudgeHwnd, Off
	WinGet, hwnd, ID, A			; hwnd: Int型
	If (IME_GET() && (IME_GetConvMode() & 1))
	{
		If (IME_GetConverting())
			goodHwnd := hwnd
		Else
			badHwnd := hwnd
	}
	Return

RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
	Return

; ----------------------------------------------------------------------
; 関数
; ----------------------------------------------------------------------

; タイマー関数
; 参照: https://www.autohotkey.com/boards/viewtopic.php?t=36016
QPCInit() {	; () -> Int64
	DllCall("QueryPerformanceFrequency", "Int64P", freq)	; freq: Int64型
	Return freq
}
QPC() {	; () -> Double	ミリ秒単位
	static coefficient := 1000.0 / QPCInit()			; Double型
	DllCall("QueryPerformanceCounter", "Int64P", count)	; count: Int64型
	Return count * coefficient
}

; str をツールチップに表示し、time ミリ秒後に消す(デバッグ用)
ToolTip2(str, time:=1000)	; (str: String, time: Int) -> Void
{
	ToolTip, %str%
	; str が空でなく、time が0でないとき
	If (str && time != 0)
		SetTimer, RemoveToolTip, %time%
}

; 配列定義をすべて消去する
DeleteDefs()	; () -> Void
{
	global defsKey, defsGroup, defsKanaMode, defsTateStr, defsYokoStr, defsCtrlName, defsCombinableBit
		, defBegin, defEnd

	; かな配列の入れ物
	defsKey := []		; キービットの集合
	defsGroup := []		; 定義のグループ名 ※0または空はグループなし
	defsKanaMode := []	; 0: 英数入力用, 1: かな入力用
	defsTateStr := []	; 縦書き用定義
	defsYokoStr := []	; 横書き用定義
	defsCtrlName := []	; NR: リピートなし, R: リピートできる, 他: 特別出力(かな定義ファイルで操作)
	defsCombinableBit := []	; 0: 出力確定しない,
							; 1: 通常シフトのみ出力確定, 2: どちらのシフトも出力確定
	defBegin := [1, 1, 1]	; 定義の始め 1キー, 2キー同時, 3キー同時
	defEnd	:= [1, 1, 1]	; 定義の終わり+1 1キー, 2キー同時, 3キー同時
}

; 何キー同時か数える
CountBit(keyComb)	; (keyComb: Int64) -> Int
{
	global KC_SPC
;	local count, i	; Int型

	; スペースキーは数えない
	keyComb &= KC_SPC ^ (-1)

	count := 0
	i := 0
	; 3になったら、それ以上数えない
	While (i < 64 && count < 3)
	{
		count += keyComb & 1
		keyComb >>= 1
		i++
	}
	Return count
}

; 縦書き用定義から横書き用に変換
ConvTateYoko(str)	; (str: String) -> String
{
	StringReplace, str, str, {Up,		{Temp,	A
	StringReplace, str, str, {Right,	{Up,	A
	StringReplace, str, str, {Down,		{Right,	A
	StringReplace, str, str, {Left,		{Down,	A
	StringReplace, str, str, {Temp,		{Left,	A

	Return str
}

; 機能置き換え処理
ControlReplace(str)	; (str: String) -> String
{
	; DvorakJ との互換用
	StringReplace, str, str, {→,			{Right,		A
	StringReplace, str, str, {->,			{Right,		A
	StringReplace, str, str, {右,			{Right,		A
	StringReplace, str, str, {←,			{Left,		A
	StringReplace, str, str, {<-,			{Left,		A
	StringReplace, str, str, {左,			{Left,		A
	StringReplace, str, str, {↑,			{Up,		A
	StringReplace, str, str, {上,			{Up,		A
	StringReplace, str, str, {↓,			{Down,		A
	StringReplace, str, str, {下,			{Down,		A
	StringReplace, str, str, {ペースト},	^v,			A
	StringReplace, str, str, {貼付},		^v,			A
	StringReplace, str, str, {貼り付け},	^v,			A
	StringReplace, str, str, {カット},		^x,			A
	StringReplace, str, str, {切取},		^x,			A
	StringReplace, str, str, {切り取り},	^x,			A
	StringReplace, str, str, {コピー},		^c,			A
	StringReplace, str, str, {無変換,		{vk1D,		A
	StringReplace, str, str, {変換,			{vk1C,		A
	StringReplace, str, str, {ひらがな,		{vkF2,		A
	StringReplace, str, str, {改行,			{Enter,		A
	StringReplace, str, str, {後退,			{BS,		A
	StringReplace, str, str, {取消,			{Esc,		A
	StringReplace, str, str, {削除,			{Del,		A
	StringReplace, str, str, {全角,			{vkF3,		A
	StringReplace, str, str, {タブ,			{Tab,		A
	StringReplace, str, str, {空白,			{vk20,		A
	StringReplace, str, str, {メニュー,		{AppsKey,	A
	StringReplace, str, str, {Caps Lock,	{vkF0,		A
	StringReplace, str, str, {Back Space,	{BS,		A

	; 追加
	StringReplace, str, str, {カタカナ,		{vkF1,		A
	StringReplace, str, str, {漢字,			{vk19,		A
	StringReplace, str, str, {英数,			{vkF0,		A
	StringReplace, str, str, {一時半角},	{NoIME},	A
	StringReplace, str, str, {IME戻す},		{UndoIME},	A
	StringReplace, str, str, {Space,		{vk20,		A

	Return str
}

; ASCIIコードでない文字が入っていたら、"{確定}""{NoIME}"を書き足す
; "{直接}"は"{Raw}"に書き換え
; convYoko が True だったら縦書き用から横書き用に変換
Analysis(str, convYoko := False)	; (str: String, convYoko: Bool) -> String
{
	global imeSelect
;	local strLength, strSubLength	; Int型
;		, strSub, ret, c			; String型
;		, i, bracket				; Int型
;		, kakutei, noIME			; Bool型

	If (str = "{Raw}" || str = "{直接}")
		; 有効な文字列がないので空白を返す
		Return ""

	ret := ""	; 変換後文字列
	i := 1
	strLength := StrLen(str)

	; アルファベット、数字、ハイフンだけなら、"{? down}{? up}" 形式に変換
	If (RegExMatch(str, "^[a-z\d\-]+$"))
	{
		While (i <= strLength)
		{
			c := SubStr(str, i, 1)
			; down を出力している文字は一旦 up する
			If (InStr(SubStr(str, 1, i - 1), c))
				ret .= "{" . c . " up}"
			ret .= "{" . c . " down}"
			i++
		}
		; 押した順番でキーを上げる
		i := 1
		While (i <= strLength)
		{
			c := SubStr(str, i, 1)
			; あとで up がくるなら今は up しない
			If (!InStr(SubStr(str, i + 1), c))
				ret .= "{" . c . " up}"
			i++
		}
		Return ret
	}
	; "{sc○○}" を "{sc○○ down}{sc○○ up}" の形式へ
	Else If (RegExMatch(str, "i)^\{sc[\da-f]+\}$"))
	{
		strSub := SubStr(str, 1, strLength - 1)	; "{sc○○}" の "{sc○○" を取り出し
		ret := strSub . " down}" . strSub . " up}"
		Return ret
	}

	kakutei := noIME := False
	strSub := ""
	strSubLength := 0
	bracket := 0
	While (i <= strLength)
	{
		c := SubStr(str, i++, 1)
		If (c == "}" && bracket != 1)
			bracket := 0
		Else If (c == "{" || bracket)
			bracket++
		strSub .= c
		strSubLength++
		If (!(bracket || c == "+" || c == "^" || c == "!" || c == "#")
			|| i > strLength)
		{
			If (RegExMatch(strSub, "i)\{Raw\}$"))
				; 残り全部を出力
				Return ret . SubStr(str, i - strSubLength)
			Else If (RegExMatch(strSub, "\{直接\}$"))
			{
				If (!kakutei)
					ret .= "{確定}"
				If (!noIME)
					ret .= "{NoIME}"
				; 残り全部を出力
				Return ret . "{Raw}" . SubStr(str, i)
			}

			strSub := ControlReplace(strSub)
			; 縦書き用から横書き用に変換
			If (convYoko)
				strSub := ConvTateYoko(strSub)

			If (Asc(strSub) > 127 || RegExMatch(strSub, "i)^\{U\+")
				|| (RegExMatch(strSub, "i)^\{ASC\s(\d+)\}$", code) && code1 > 127))
			{
				; ASCIIコード以外の文字に変化したとき
				If (!kakutei)
					ret .= "{確定}"
				If (!noIME)
					ret .= "{NoIME}"
				ret .= strSub
				kakutei := noIME := True
			}
			Else If (strSub = "{NoIME}")
			{
				If (!kakutei)
					ret .= "{確定}"
				If (!noIME)
					ret .= "{NoIME}"
				kakutei := noIME := True
			}
			Else If (strSub == "{確定}")
			{
				If (!kakutei)
					ret .= "{確定}"
				kakutei := True
			}
			Else If (RegExMatch(strSub, "^\{Enter"))
			{
				; "{Enter" で確定状態
				ret .= strSub
				kakutei := True
			}
			Else If (str != "^v" && strSub == "^v")
			{
				; "^v" 単独は除外
				If (!kakutei)
					ret .= "{確定}"
				ret .= strSub
				kakutei := True
			}
			Else If (strSub = "{UndoIME}")
			{
				; IME入力モードの回復
				If (noIME)
					ret .= "{UndoIME}"
				noIME := False
			}
			Else If (strSub = "{IMEOFF}")
			{
				ret .= strSub
				kakutei := True
				noIME := False
			}
			Else If (strSub = "{IMEON}"
				|| strSub = "{vkF3}"		|| strSub = "{vkF4}"	; 半角/全角
				|| strSub = "{vk19}"								; 漢字	Alt+`
				|| strSub = "{vkF0}"								; 英数
				|| InStr(strSub, "{vk16")							; (Mac)かな
				|| InStr(strSub, "{vk1A")							; (Mac)英数
				|| InStr(strSub, "{vkF2")							; ひらがな
				|| InStr(strSub, "{vkF1")							; カタカナ
				|| strSub == "{全英}"		|| strSub == "{半ｶﾅ}")
			{
				ret .= strSub
				noIME := False
			}
			Else If (InStr(strSub, "{BS")		|| InStr(strSub, "{Del")
				|| InStr(strSub, "{Esc")
				|| InStr(strSub, "{Up")		|| InStr(strSub, "{Left")
				|| InStr(strSub, "{Right")	|| InStr(strSub, "{Down")
				|| InStr(strSub, "{Home")		|| InStr(strSub, "{End")
				|| InStr(strSub, "{PgUp")		|| InStr(strSub, "{PgDn"))
				ret .= strSub
			Else
			{
				; 空白は {vk20} に変える
				ret .= (strSub == " " ? "{vk20}" : strSub)
				If (!noIME)
					kakutei := False
			}

			strSub := ""
			strSubLength := 0
		}
	}

	; ATOKで"{確定}"から始まるときは、"{確定}"を2度出力する
	If (imeSelect == 1 && RegExMatch(ret, "^\{確定\}"))
		ret := "{確定}" . ret

	Return ret
}

; 定義登録
; kanaMode	0: 英数, 1: かな
; keyComb	キーをビットに置き換えたものの集合
; tate		縦書き定義
; yoko		横書き定義
; ctrlName	NR: リピートなし, R: リピートあり, 他: かな配列ごとの特殊コード
SetDefinition(kanaMode, keyComb, tate, yoko, ctrlName)	; (kanaMode: Bool, keyComb: Int64, tate: String, yoko: String, ctrlName: String) -> Void
{
	global defsKey, defsGroup, defsKanaMode, defsTateStr, defsYokoStr, defsCtrlName
		, defBegin, defEnd
		, kanaGroup, NR, R
		, eisuRepeat
;	local keyCount	; Int型	何キー同時押しか
;		, i, imax	; Int型	カウンタ用

	; 何キー同時押しか
	keyCount := CountBit(keyComb)

	i := defBegin[keyCount]			; 始まり
	imax := defEnd[keyCount]		; 終わり
	While (i < imax)
	{
		; 定義の重複があったら、古いのを消す
		; 参考: https://so-zou.jp/software/tool/system/auto-hot-key/expressions/
		If (defsKey[i] == keyComb && defsKanaMode[i] == kanaMode)
		{
			defsKey.RemoveAt(i)
			defsGroup.RemoveAt(i)
			defsKanaMode.RemoveAt(i)
			defsTateStr.RemoveAt(i)
			defsYokoStr.RemoveAt(i)
			defsCtrlName.RemoveAt(i)

			defEnd[1]--
			If (keyCount > 1)
				defBegin[1]--, defEnd[2]--
			If (keyCount > 2)
				defBegin[2]--, defEnd[3]--
			Break
		}
		i++
	}
	; 定義を登録
	If ((ctrlName != NR && ctrlName != R) || tate != "" || yoko != "")
	{
		i := defEnd[keyCount]
		defsKey.InsertAt(i, keyComb)
		defsGroup.InsertAt(i, kanaGroup)
		defsKanaMode.InsertAt(i, kanaMode)
		defsTateStr.InsertAt(i, tate)
		defsYokoStr.InsertAt(i, yoko)
		defsCtrlName.InsertAt(i, ctrlName)

		defEnd[1]++
		If (keyCount > 1)
			defBegin[1]++, defEnd[2]++
		If (keyCount > 2)
			defBegin[2]++, defEnd[3]++
	}
}

; リピートの好みを ctrlName に反映させる
; ctrlName が特別出力の時はそのまま返す(全てリピートさせるのは、関数Convet()内でも行う)
RepeatStyleToCtrlName(ctrlName:="")	; (ctrlName: String) -> String
{
	global NR, R, repeatStyle

	; リピート 常に無制限
	If (!repeatStyle)
		Return (ctrlName && ctrlName != NR ? ctrlName : R)
	; リピート 基本する
	Else If (repeatStyle == 1)
		Return (ctrlName ? ctrlName : R)
	; リピート 基本しない
	Else If (repeatStyle == 2)
		Return (ctrlName ? ctrlName : NR)
	; リピート 全くしない
	Else
		Return (ctrlName && ctrlName != R ? ctrlName : NR)
}

; かな定義登録
SetKana(keyComb, str, ctrlName:="")	; (keyComb: Int64, str: String, ctrlName: String) -> Void
{
	global NR, R
;	local tate, yoko	; String型

	ctrlName := RepeatStyleToCtrlName(ctrlName)
	If (ctrlName == NR || ctrlName == R)
	{
		; 機能等を書き換え
		tate := Analysis(str)
		yoko := Analysis(str, True)	; 縦横変換あり
		SetDefinition(1, keyComb, tate, yoko, ctrlName)
	}
	Else
		SetDefinition(1, keyComb, str, str, ctrlName)
}
SetKana2(keyComb, tate, yoko, ctrlName:="")	; (keyComb: Int64, tate: String, yoko: String, ctrlName: String) -> Void
{
	global NR, R

	ctrlName := RepeatStyleToCtrlName(ctrlName)
	If (ctrlName == NR || ctrlName == R)
		SetDefinition(1, keyComb, Analysis(tate), Analysis(yoko), ctrlName)
	Else
		SetDefinition(1, keyComb, tate, yoko, ctrlName)
}
; 英数定義登録
SetEisu(keyComb, str, ctrlName:="")	; (keyComb: Int64, str: String, ctrlName: String) -> Void
{
	global NR, R, eisuRepeat
;	local tate, yoko	; String型

	; 英数単打のリピートありの処理
	If (eisuRepeat && CountBit(keyComb) == 1 && ctrlName == "")
		ctrlName := R
	Else
		ctrlName := RepeatStyleToCtrlName(ctrlName)

	If (ctrlName == NR || ctrlName == R)
	{
		; 機能等を書き換え
		tate := Analysis(str)
		yoko := Analysis(str, True)	; 縦横変換あり
		SetDefinition(0, keyComb, tate, yoko, ctrlName)
	}
	Else
		SetDefinition(0, keyComb, str, str, ctrlName)
}
SetEisu2(keyComb, tate, yoko, ctrlName:="")	; (keyComb: Int64, tate: String, yoko: String, ctrlName: String) -> Void
{
	global NR, R, eisuRepeat

	; 英数単打のリピートありの処理
	If (eisuRepeat && CountBit(keyComb) == 1 && ctrlName == "")
		ctrlName := R
	Else
		ctrlName := RepeatStyleToCtrlName(ctrlName)

	If (ctrlName == NR || ctrlName == R)
		SetDefinition(0, keyComb, Analysis(tate), Analysis(yoko), ctrlName)
	Else
		SetDefinition(0, keyComb, tate, yoko, ctrlName)
}

; 一緒に押すと同時押しになるキーを探す
FindCombinableBit(searchBit, kanaMode, keyCount, group:="")	; (searchBit: Int64, kanaMode: Bool, keyCount: Int, group: String) -> Int64
{
	global defsKey, defsKanaMode, defsGroup, defBegin, defEnd
		, KC_SPC
;	local i, imax		; Int型		カウンタ用
;		, bit			; Int64型

	bit := 0
	i := defBegin[3]
	imax := (!group && keyCount >= 1 && keyCount <= 3 ? defEnd[keyCount] : defEnd[1])
	While (i < imax)
	{
		; グループが「なし」か同じ、「かな」モードも同じで、判定中のキーを含むのを登録
		If ((!group || group == defsGroup[i])
			&& (defsKey[i] & searchBit) == searchBit && kanaMode == defsKanaMode[i])
		{
			bit |= defsKey[i]
		}
		i++
	}
;	bit &= searchBit ^ (-1)	; 検索中のキーを削除

	Return bit
}

; 一緒に押すと同時押しになるキーを defsCombinableBit[] に記録
SettingLayout()	; () -> Void
{
	global defsKey, defsKanaMode, defsCombinableBit, defBegin, defEnd
;	local i, imax	; Int型	カウンタ用
;		, searchBit	; Int64型

	; 出力確定するか検索
	i := defBegin[3]
	imax := defEnd[1]
	While (i < imax)
	{
		searchBit := defsKey[i]
		defsCombinableBit[i] := FindCombinableBit(searchBit, defsKanaMode[i], CountBit(searchBit))
		i++
	}
}

ExistNewMSIME()	; () -> Bool
{
;	local build	; Int型

	; 参考: https://www.autohotkey.com/docs/Variables.htm#OSVersion
	If A_OSVersion in WIN_8.1,WIN_8,WIN_7,WIN_VISTA,WIN_2003,WIN_XP,WIN_2000	; Note: No spaces around commas.
		Return False

	; 参考: https://docs.microsoft.com/ja-jp/windows/release-health/supported-versions-windows-client
	; [requires v1.1.20+]
	build := SubStr(A_OSVersion, 6)	; 例えば 10.0.19043 は Windows 10 build 19043 (21H2)
		; 備考：スタティック変数の初期化で呼び出された時、グローバル変数の osBuild はまだ初期化前
	If (build <= 18363)	; Windows 10 1909 以前
		Return False
	Else
		Return True
}

; 使用している IME を調べる。MS-IME は 10秒経過していれば再調査。
; 戻り値	"NewMSIME":	新MS-IME, "OldMSIME": 以前のバージョンのMS-IMEを選んでいる
;			"CustomMSIME": 以前のバージョンのMS-IMEをキー設定して使用中
;			"ATOK": ATOK
DetectIME()	; () -> String
{
	global imeSelect, goodHwnd, badHwnd, imeNeedDelay, imeGetConvertingInterval
	static existNewMSIME := ExistNewMSIME()
		, imeName := "", lastSearchTime := 0
;	local value, nowIME	; String型

	If (imeSelect == 1)
		nowIME := "ATOK"
	Else If (imeSelect)
		nowIME := "Google"
	; 10秒経過したか、
	; 他の IME から設定変更したとき(10秒以内に他のIMEに変えてまた戻すのは現実的ではないが)
	Else If (A_TickCount < lastSearchTime || lastSearchTime + 10000 < A_TickCount
		|| SubStr(imeName, StrLen(imeName) - 4, 5) != "MSIME")
	{
		lastSearchTime := A_TickCount
;		nowIME := ""
		If (existNewMSIME)
		{
			; 「以前のバージョンの Microsoft IME を使う」がオンになっているか調べる
			; 参考: https://registry.tomoroh.net/archives/11547
			RegRead, value, HKEY_CURRENT_USER
				, SOFTWARE\Microsoft\Input\TSF\Tsf3Override\{03b5835f-f03c-411b-9ce2-aa23e1171e36}
				, NoTsf3Override2
			If (ErrorLevel == 1 || !value)
				nowIME := "NewMSIME"
		}
		If (nowIME != "NewMSIME")
		{
			RegRead, value, HKEY_CURRENT_USER, SOFTWARE\Microsoft\IME\15.0\IMEJP\MSIME, keystyle
			If (value == "Custom")
				nowIME := "CustomMSIME"
			Else
				nowIME := "OldMSIME"
		}
	}
	Else
		Return imeName

	If (nowIME != imeName)
	{
		imeName := nowIME
		goodHwnd := badHwnd := 0
		; Send から IME_GET() までに Sleep で必要な時間(ミリ秒)
		imeNeedDelay := (imeName == "Google" || imeName == "ATOK" ? 30 : 70)
		; Send から IME_GetConverting() までに Sleep で必要な時間(ミリ秒)
		imeGetConvertingInterval := (imeName == "Google" ? 30
			: (imeName == "OldMSIME" || imeName == "CustomMSIME" ? 100 : 70))
	}
	Return imeName
}

SendBlind(str)	; (str: String) -> Void
{
;	SetKeyDelay, -1, -1

	; Microsoft OneNote 対策
	; 参考: http://chaboneko.wp.xdomain.jp/?p=583
	; 参考: https://benizara.hatenablog.com/entry/2023/07/08/101901
	If (WinActive("ahk_class Framework::CFrame"))	; Process: ONENOTE.EXE
	{																			; void keybd_event(BYTE bVk, BYTE bScan, DWORD dwFlags, ULONG_PTR dwExtraInfo);
		If (str = "{Up down}")
			DllCall("keybd_event", UChar, 0x26, UChar, 0x48, UInt, 1, UInt, 0)	; keybd_event(VK_UP, 0x48, KEYEVENTF_EXTENDEDKEY, 0)
		Else If (str = "{Down down}")
			DllCall("keybd_event", UChar, 0x28, UChar, 0x50, UInt, 1, UInt, 0)	; keybd_event(VK_DOWN, 0x50, KEYEVENTF_EXTENDEDKEY, 0)
		Else If (str = "{Up up}")
			DllCall("keybd_event", UChar, 0x26, UChar, 0x48, UInt, 3, UInt, 0)	; keybd_event(VK_UP, 0x48, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP, 0)
		Else If (str = "{Down up}")
			DllCall("keybd_event", UChar, 0x28, UChar, 0x50, UInt, 3, UInt, 0)	; keybd_event(VK_DOWN, 0x50, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP, 0)
		Else
			Send, % "{Blind}" . str
	}
	Else
		Send, % "{Blind}" . str
}

; 下げたままのキーを上げる
SendKeyUp()	; () -> Void
{
	global restStr	; 今まで下げていたキー 例: +{Up}

	If (restStr == "")
		Return

	; "+" から始まっていた
	If (Asc(restStr) == 43)
	{
		; まず "+" より後に書かれたキーを上げる
		SendBlind(SubStr(restStr, 2, StrLen(restStr) - 2) . " up}")
		; シフトを上げる
		Send, {ShiftUp}
	}
	Else
		SendBlind(SubStr(restStr, 1, StrLen(restStr) - 1) . " up}")

	; 変数更新
	restStr := ""
}

; キーを下げたままにする
; 下げたままのキーは上げる
SendKeyDown(newStr:="", delay:=-2)	; (str: String, delay: Int) -> Void
{
	global restStr	; 今まで下げていたキー 例: +{Up}
		, lastSendTime
;	local oldShifted, newShifted	; Bool型
;		, oldKey, newKey			; String型

	; "+" から始まるか
	oldShifted := (Asc(restStr) == 43 ? True : False)
	newShifted := (Asc(newStr) == 43 ? True : False)
	; "+" 抜き
	oldKey := (oldShifted ? SubStr(restStr, 2) : restStr)
	newKey := (newShifted ? SubStr(newStr, 2) : newStr)

	; 下げたままのキーとは別のキーに変わる
	If (oldKey != "" && oldKey != newKey)
		SendBlind(SubStr(oldKey, 1, StrLen(oldKey) - 1) . " up}")
	; シフト あり→なし
	If (oldShifted && !newShifted)
		; シフトを上げる
		Send, {ShiftUp}
	; シフト なし→あり
	Else If (!oldShifted && newShifted)
		Send, {ShiftDown}

	If (newKey != "")
	{
		; キーを下げる
		SendBlind(SubStr(newKey, 1, StrLen(newKey) - 1) . " down}")
		lastSendTime := QPC()	; 最後に出力した時間を記録
		; ディレイ
		If (delay > -2)
			Sleep, % delay
	}

	; 変数更新
	restStr := newStr
}

; スペースキー、矢印系キーを上げ下げを模倣して出力
EmulateKeyDownUp(str, delay:=-2)	; (str: String, delay: Int) -> Void
{
	global osBuild, repeatCount, repeatStyle, vertical
;	local hwnd				; Int型
;		, class, process	; String型
;		, count, count1		; Int型
;		, key				; String型	矢印系キーだったらそのキー名
;		, moveLines			; Bool型	行移動があるか

	; リピート時の行移動は最大〇打
	MAX_MOVE_LINES := 5		; Int型定数

	WinGet, hwnd, ID, A
	WinGetClass, class, ahk_id %hwnd%
	WinGet, process, ProcessName, ahk_id %hwnd%

	; スペースキー、矢印系キーの回数検出(count1 に入る)と、行移動の判定
	key := ""
	If (RegExMatch(str, "i)^\+?\{Space\}$|^\+?\{Space\s(\d+)\}$", count))
	{
		key := "{Space}"
		moveLines := False
	}
	Else If (RegExMatch(str, "i)^\+?\{Up\}$|^\+?\{Up\s(\d+)\}$", count))
	{
		key := "{Up}"
		moveLines := !vertical
	}
	Else If (RegExMatch(str, "i)^\+?\{Down\}$|^\+?\{Down\s(\d+)\}$", count))
	{
		key := "{Down}"
		moveLines := !vertical
	}
	Else If (RegExMatch(str, "i)^\+?\{Left\}$|^\+?\{Left\s(\d+)\}$", count))
	{
		key := "{Left}"
		moveLines := vertical
	}
	Else If (RegExMatch(str, "i)^\+?\{Right\}$|^\+?\{Right\s(\d+)\}$", count))
	{
		key := "{Right}"
		moveLines := vertical
	}
	Else If (RegExMatch(str, "i)^\+?\{PgUp\}$|^\+?\{PgUp\s(\d+)\}$", count))
	{
		key := "{PgUp}"
		moveLines := True
	}
	Else If (RegExMatch(str, "i)^\+?\{PgDn\}$|^\+?\{PgDn\s(\d+)\}$", count))
	{
		key := "{PgDn}"
		moveLines := True
	}

	; 矢印系キーがなければ普通に出力して退出
	If (!key)
	{
		SendKeyUp()		; 押し下げ出力中のキーを上げる
		If (delay > -1)
			SetKeyDelay, delay, -1
		Send, % str
		SetKeyDelay, -1, -1
		Return
	}

	; リピート時はキー押しの回数を制限する（全てリピートする設定の時は、制限しない）
	If (repeatCount && repeatStyle)
	{
		; Word
		If (process == "WINWORD.EXE")
			count1 := 1	; リピート中は1個ずつ
		; Windows 11 以降のメモ帳ではリピート中の移動は最大3個ずつ
		Else If (osBuild >= 20000 && class == "Notepad" && count1 > 3)
			count1 := 3
		; 秀丸エディタとジャストシステム製品の行移動
		Else If (moveLines
		 && (class == "Hidemaru32Class" || SubStr(class, 1, 3) == "js:"))
			count1 := 1	; リピート中は1行ずつ
		; ジャストシステム製品の文字移動
		Else If (SubStr(class, 1, 3) == "js:")
			count1 := 2	; リピート中は2字ずつ
		; リピート時の行移動は最大〇打
		Else If (moveLines && count1 > MAX_MOVE_LINES)
			count1 := MAX_MOVE_LINES
	}

	; "+" から始まるか
	If (Asc(str) == 43)
		key := "+" . key
	; ループして出力
	Loop % count1 - 1
	{
		SendKeyDown(key, delay)	; キーを下げる
		; "+" から始まるか
		If (Asc(str) == 43)
			SendKeyDown("+")	; 押し下げ出力中のシフト以外のキーを上げる
		Else
			SendKeyUp()	; 押し下げ出力中のキーを上げる
	}
	; 最後の1回の出力
	SendKeyDown(key, delay)	; キーを下げる
}

; 文字列 str を適宜スリープを入れながら出力する
SendEachChar(str)	; (str: String) -> Void
{
	global osBuild, usingKeyConfig, sideShift, imeNeedDelay, imeGetConvertingInterval
		, goodHwnd, badHwnd, lastSendTime, kanaMode, repeatCount
		, imeState, imeSentenceMode
	static romanChar := False	; Bool型	ローマ字になり得る文字の出力中か(変換1回目のIME窓検出用)
;	local romanCharForNoIME		; Bool型	一時IMEをオフにしている間にローマ字(アスキー文字)を出力したか
;		, hwnd					; Int型
;		, title, class, process	; String型
;		, strLength				; Int型		str の長さ
;		, strSub				; String型	細切れにした文字列
;		, strSubLength			; Int型 	と、その長さを入れる変数
;		, out					; String型
;		, outSub, outSub1		; String?型
;		, outSub2				; Int?型
;		, i, bracket			; Int型
;		, c						; String型
;		, noIME					; Bool型	IME入力モードの保存、復元に関するフラグ
;		, preDelay, postDelay	; Int型		出力前後のディレイの値
;		, lastDelay				; Int型		前回出力時のディレイの値
;		, clipSaved				; Any?型
;		, imeName				; String型
;		, count, wait			; Int?型
;		, inShifted				; Bool型
;		, imeConvMode			; Int?型	IME 入力モード	IME_GetConvMode()用

	SetTimer, JudgeHwnd, Off	; IME窓検出タイマー停止
;	SetKeyDelay, -1, -1
	WinGet, hwnd, ID, A
;	WinGetTitle, title, ahk_id %hwnd%
	WinGetClass, class, ahk_id %hwnd%
	WinGet, process, ProcessName, ahk_id %hwnd%
	imeName := DetectIME()

	; ディレイの初期値
	;	-1未満	Sleep をなるべく入れない
	;	ほか	Sleep, % delay が基本的に1文字ごとに入る
	delay := preDelay := postDelay := -2
	If (class == "CabinetWClass")	; エクスプローラー
		delay := 10
	Else If (osBuild >= 20000 && class == "Notepad")	; Windows 11 以降のメモ帳
		delay := (imeName == "NewMSIME" ? 30 : 10)
	Else If (class == "Hidemaru32Class")	; 秀丸エディタ
		delay := -1	; 文末の [EOF] の表示が乱れるのを防止
	Else If (!romanChar && SubStr(process, 1, 6) = "ptedit")	; brother P-touch Editor
		postDelay := 30	; かな入力の1文字目をゆっくり出力
	lastDelay := Floor(QPC() - lastSendTime)

	; 文字列を細切れにして出力
	noIME := romanCharForNoIME := False
	strSub := out := ""
	strSubLength := 0
	bracket := 0
	i := 1
	strLength := StrLen(str)
	While (i <= strLength)
	{
		c := SubStr(str, i++, 1)
		If (c == "}" && bracket != 1)
			bracket := 0
		Else If (c == "{" || bracket)
			bracket++
		strSub .= c
		strSubLength++
		If (!(bracket || c == "+" || c == "^" || c == "!" || c == "#")
			|| i > strLength)
		{
			; スペースキー、矢印系キーの上げ下げを模倣して出力
			If (SubStr(strSub, 1, 6) = "{Space" || SubStr(strSub, 1, 7) = "+{Space"
				|| SubStr(strSub, 1, 3) = "{Up" || SubStr(strSub, 1, 4) = "+{Up"
				|| SubStr(strSub, 1, 5) = "{Down" || SubStr(strSub, 1, 6) = "+{Down"
				|| SubStr(strSub, 1, 5) = "{Left" || SubStr(strSub, 1, 6) = "+{Left"
				|| SubStr(strSub, 1, 6) = "{Right" || SubStr(strSub, 1, 7) = "+{Right"
				|| SubStr(strSub, 1, 5) = "{PgUp" || SubStr(strSub, 1, 6) = "+{PgUp"
				|| SubStr(strSub, 1, 5) = "{PgDn" || SubStr(strSub, 1, 6) = "+{PgDn")
			{
				; Windows 11 以降のメモ帳、"{確定}"の直後、キー設定使用の旧MS-IME
				; には間を空けてから
				If (osBuild >= 20000 && class == "Notepad"
				 && SubStr(str, i - strSubLength - 4, 4) = "{確定}"
				 && usingKeyConfig && imeName == "CustomMSIME")
				{
					preDelay := imeNeedDelay
					If (lastDelay < preDelay)
						Sleep, % preDelay - lastDelay
				}
				EmulateKeyDownUp(strSub, delay)	; 矢印系キーを出力
				lastDelay := delay
				; スペースキー、矢印系キーだけの定義でなかったら
				If (strSubLength != strLength)
					SendKeyUp()		; 押し下げ出力中のキーを上げる
			}
			; その他のキー
			Else
			{
				SendKeyUp()		; 押し下げ出力中のキーを上げる

				; "{Raw}"からの残りは全部出力する
				If (SubStr(strSub, strSubLength - 4, 5) = "{Raw}")
				{
					; Windows 11 以降のメモ帳へはゆっくりと
					If (osBuild >= 20000 && class == "Notepad" && postDelay < 30)
						postDelay := 30
					Else
						postDelay := 10
					postDelay := (postDelay > delay ? postDelay : delay)

					While (i <= strLength)
					{
						SendRaw, % SubStr(str, i++, 1)
						If (i > strLength)
							lastSendTime := QPC()	; 出力した時間を記録
						; 出力直後のディレイ
						Sleep, % postDelay
					}
					; 後で誤作動しないように消去
					strSub := ""
				}

				; 出力するキーを変換
				Else If (strSub == "{確定}")
				{
					; アスキー文字→{確定} のような定義でなく
					; Shift+Ctrl+変換 に割り当てた「全確定」が使える時
					If (!(imeSentenceMode && romanChar && i > 5)
					 && usingKeyConfig
					 && (imeName == "CustomMSIME" || imeName == "ATOK" || imeName == "Google"))
					{
						; IME_GET() には早すぎるか、通常 0 にならない IME_GetConvMode() の値が 0 の時
						If (lastDelay < imeNeedDelay || !IME_GetConvMode())
							out := "+^{vk1C}"
						; IMEオンで変換モードが無変換ではない時
						Else If (IME_GET() && IME_GetSentenceMode())
						{
							out := "+^{vk1C}"
							; 直後の定義によってはそれも処理してカウンタを進める
							If (SubStr(str, i, 7) = "{NoIME}")
							{
								Send, % out
								; IMEをオフにするが後で元に戻せるようにしておく
								i += 7
								noIME := True
								out := "{vkF3}"		; 半角/全角
							}
						}
					}
					; 未変換文字があったらエンターを押す
					Else If (imeState != 0 && imeSentenceMode != 0)
					{
						; IME_GET() の前に一定時間空ける
						If (lastDelay < imeNeedDelay
							&& !(imeState && imeSentenceMode && romanChar && i > 5))
						{
							Sleep, % imeNeedDelay - lastDelay
							lastDelay := imeNeedDelay
						}
						; IMEオンで変換モードが無変換ではない時
						If (imeState && imeSentenceMode
							|| IME_GET() && IME_GetSentenceMode())
						{
							; アスキー文字→{確定} のような定義の時
							; あるいは文字出力から一定時間経っていて、IME窓を検出できた時
							If ((romanChar && i > 5)
							 || (lastDelay >= imeGetConvertingInterval && IME_GetConverting()))
								; 確定のためのエンター
								out := "{Enter}"
							; かな入力中か、Google 日本語入力以外で「左右シフトかな」設定の時
							; ※ Shift+英数 を押して一時英数になったのは除外する
							Else If (((imeConvMode := IME_GetConvMode()) & 1)	; IME入力モードを保存し、かな入力か
								|| (sideShift == 2 && imeName != "Google"))
							{
								Send, {vkF3}	; 半角/全角
								Sleep, % imeNeedDelay
								lastDelay := imeNeedDelay
								; 「半角/全角」でIMEオンのままだったら未変換文字あり
								If (IME_GET())
								{
									; IME入力モードを元に戻す
									If (imeName != "Google")
										IME_SetConvMode(imeConvMode)
									Else If ((imeConvMode & 0xF) == 9)
										Send, {vkF2}	; ひらがな
									Else
										Send, {vkF1}	; カタカナ
									; 確定のためのエンター
									out := "{Enter}"
								}
								; 未変換文字がない
								; 直後の定義によってはIMEオフのままで良いのでカウンタを進めその先へ
								Else If (SubStr(str, i, 7) = "{NoIME}")
								{
									i += 7
									noIME := True
								}
								Else If (SubStr(str, i, 6) = "{vkF3}" || SubStr(str, i, 6) = "{vkF4}"
									|| SubStr(str, i, 6) = "{vk19}")
								{
									i += 6
									noIME := False
								}
								Else If (SubStr(str, i, 8) = "{IMEOFF}")
								{
									i += 8
									noIME := False
									kanaMode := 0
								}
								; 「半角/全角」で元に戻す
								Else
									out := "{vkF3}"
							}
							; 未変換文字があるか不明なら "_{Enter}{BS}" を出力する
							; ※ 左右シフト英数に設定時の全角英数モード
							Else If (hwnd != goodHwnd || lastDelay < imeGetConvertingInterval)
							{
								; Visual Studio Code で 新MS-IME を使い
								; "{End}{Enter}" が続く場合
								; ※ 定義 "{確定}{End}{改行}[]{確定}{↑}" への対策
								If (process == "Code.exe" && imeName == "NewMSIME"
									&& SubStr(str, i, 12) = "{End}{Enter}")
								{
									Send, _
									Sleep, 60
									Send, {Enter}
									preDelay := 30
									out := "{BS}"
									postDelay := 60
								}
								; Win11メモ帳+新MS-IME
								Else If (osBuild >= 20000 && class == "Notepad" && imeName == "NewMSIME")
								{
									Send, _
									Sleep, 30
									Send, {Enter}
									Sleep, 30
									out := "{BS}"
								}
								Else
								{
									Send, _
									Sleep, 30
									Send, {Enter}
									out := "{BS}"
								}
							}

							If (out == "{Enter}")
							{
								; 直後の定義によってはそれも処理してカウンタを進める
								If (SubStr(str, i, 7) = "{NoIME}")
								{
									Send, % out
									; IMEをオフにするが後で元に戻せるようにしておく
									i += 7
									noIME := True
									out := "{vkF3}"		; 半角/全角
								}
								; 新MS-IME
								Else If (imeName == "NewMSIME")
									; Win11メモ帳へは確実に文字確定するため
									; 他へは入力予測窓を残さないため
									preDelay := (osBuild >= 20000 && class == "Notepad" ? 60 : 30)
							}
						}
					}
				}
				Else If (strSub = "{NoIME}")	; IMEをオフにするが後で元に戻せるようにしておく
				{
					If (lastDelay < imeNeedDelay)
					{
						; 前回の出力から一定時間空けて IME_GET() へ
						Sleep, % imeNeedDelay - lastDelay
						lastDelay := imeNeedDelay
					}
					If (IME_GET())
					{
						noIME := True
						out := "{vkF3}"		; 半角/全角
					}
				}
				Else If (strSub = "{IMEOFF}")
				{
					noIME := False
					preDelay := 50
					If (lastDelay < preDelay)
						Sleep, % preDelay - lastDelay
					IME_SET(kanaMode := 0)	; IMEオフ
					lastDelay := imeNeedDelay
					lastSendTime := 0.0
				}
				Else If (strSub = "{IMEON}")
				{
					noIME := False
					IME_SET(1)		; IMEオン
					lastDelay := imeNeedDelay
					lastSendTime := 0.0
				}
				Else If (strSub = "{vkF3}"	|| strSub = "{vkF4}"	; 半角/全角
					|| strSub = "{vk19}"							; 漢字	Alt+`
					|| strSub = "{vkF0}")							; 英数
				{
					noIME := False
					out := strSub
				}
				Else If (SubStr(strSub, 1, 5) = "{vkF2"		; ひらがな
					|| SubStr(strSub, 1, 5) = "{vk16")		; (Mac)かな
				{
					noIME := False
					; 他の IME からGoogle日本語入力に切り替えた時、ひらがなキーを押しても
					; IME_GetConvMode() の戻り値が変わらないことがあるのを対策
					IME_SetConvMode(25)	; IME 入力モード	ひらがな
					out := (imeName == "NewMSIME" ? "{vk16}" : "{vkF2 2}")

					; 直後の定義が「半角/全角」「漢字」だったら、それも出力してカウンタを進める
					If (SubStr(str, i, 6) = "{vkF3}" || SubStr(str, i, 6) = "{vkF4}"
						|| SubStr(str, i, 6) = "{vk19}")
					{
						Send, % out
						out := SubStr(str, i, 6)
						i += 6
						kanaMode := 0
					}
					Else
						kanaMode := 1
				}
				Else If (SubStr(strSub, 1, 5) = "{vkF1"		; カタカナ
					|| SubStr(strSub, 1, 6) = "+{vk16")		; Shift + (Mac)かな
				{
					noIME := False
					If (imeName == "NewMSIME")
						Send, {vk16}
					Else
						Send, {vkF2}
					out := "{vkF1}"		; カタカナ
					kanaMode := 1
				}
				Else If (SubStr(strSub, 1, 5) = "{vk1A}")	; (Mac)英数
				{
					noIME := False
					out := strSub
					kanaMode := 0
				}
				Else If (strSub == "{全英}")
				{
					noIME := False
					If (imeName != "Google" && IME_GetConvMode())
					{
						IME_SET(1)			; IMEオン
						IME_SetConvMode(24)	; IME 入力モード	全英数
						lastDelay := imeNeedDelay
						lastSendTime := 0.0
					}
					Else
					{
						If (imeName == "NewMSIME")
							Send, {vk16}
						Else
							Send, {vkF2}
						out := "+{vk1D}"	; シフト+無変換
					}
					kanaMode := 0
				}
				Else If (strSub == "{半ｶﾅ}")
				{
					noIME := False
					If (imeName == "Google")
						TrayTip, , Google 日本語入力では`n配列定義に {半ｶﾅ} は使えません
					Else If (!IME_GetConvMode())
						TrayTip, , {半ｶﾅ} にはマウスで切り替えてください
					Else
					{
						IME_SET(1)			; IMEオン
						IME_SetConvMode(19)	; IME 入力モード	半ｶﾅ
						lastDelay := imeNeedDelay
						lastSendTime := 0.0
						kanaMode := 1
					}
				}
				; エンター ※ただし、リピートさせて使うことがあるエンター単独の定義は除外
				Else If (str != "{Enter}" && SubStr(strSub, 1, 6) = "{Enter")
				{
					out := strSub
					; Visual Studio Code で 新MS-IME を使う場合
					; ※ 定義 "　　　×　　　×　　　×" への対策
					If (process == "Code.exe" && imeName == "NewMSIME")
						postDelay := 0
					; Win11メモ帳+新MS-IME
					Else If (osBuild >= 20000 && class == "Notepad" && imeName == "NewMSIME")
						postDelay := 50
					; 秀丸エディタ
					Else If (class == "Hidemaru32Class")
					{
						If (imeName == "Google" || imeName == "ATOK")
						{
							preDelay := 10
							postDelay := 60
						}
						Else If (imeName != "NewMSIME")
							postDelay := 60
					}
				}
				Else If (strSub = "^x")
				{
					out := strSub
					preDelay := (imeName == "NewMSIME" ? 100 : 70)
					postDelay := 40
				}
				Else If (strSub = "^v")
				{
					out := strSub
					preDelay := 40
					postDelay := 60
				}
				Else If (strSub = "{C_Clr}")
					Clipboard :=				; クリップボードを空にする
				Else If (SubStr(strSub, 1, 7) = "{C_Wait")
				{
					; 例: {C_Wait 0.5} は 0.5秒クリップボードの更新を待つ
					wait := SubStr(strSub, 9, strSubLength - 9)
					ClipWait, (wait ? wait : 0.2), 1
				}
				Else If (strSub = "{C_Bkup}")
					clipSaved := ClipboardAll	; クリップボードの全内容を保存
				Else If (strSub = "{C_Rstr}")
				{
					Clipboard := clipSaved		; クリップボードの内容を復元
					clipSaved :=				; 保存用変数に使ったメモリを開放
				}
				Else If (Asc(strSub) > 127 || SubStr(strSub, 1, 3) = "{U+"
					|| (SubStr(strSub, 1, 5) = "{ASC " && SubStr(strSub, 6, strSubLength - 6) > 127))
				{
					out := strSub
					postDelay := 10
					; Windows 11 以降のメモ帳へはゆっくりと
					If (osBuild >= 20000 && class == "Notepad" && postDelay < 30)
						postDelay := 30
				}
				Else If (strSub != "{Null}" && strSub != "{UndoIME}")
				{
					out := strSub
					; Win11メモ帳+新MS-IME
					If (osBuild >= 20000 && class == "Notepad" && imeName == "NewMSIME"
						&& (RegExMatch(strSub, "^\{[a-z\d\-]\sdown\}$")
							|| RegExMatch(strSub, "i)^\{sc[0-9a-f]+\sdown\}$")))
					{
						; "{? down}{? up}" に変換後のアルファベット、数字、ハイフンだけの定義
						; "{sc○○ down}{sc○○ up}" に変換後の "{sc○○}" 形式の定義
						; はディレイ30
						postDelay := 30
					}
				}
			}

			; キー出力
			If (out)
			{
				; 前回の出力からの時間が短ければ、ディレイを入れる
				If (lastDelay < preDelay)
					Sleep, % preDelay - lastDelay
				; 後置ディレイの値を決定	{? up} はあとでディレイなし(-2)にされる
				If (osBuild >= 20000 && class == "Notepad" && imeName == "NewMSIME"
				 && postDelay < delay)	; Win11メモ帳+新MS-IME は postDelay が決まっていなかったら 40 を
				{
					postDelay := 40
				}
				Else If (postDelay < delay)
					postDelay := delay

				; 文字と回数を分離
				If (RegExMatch(out, "i)^([\+\^!#]*\{\S+)\s(\d+)\}$", outSub))
				{
					out := outSub1 . "}"	; outSub1 に文字が
					count := outSub2		; outSub2 に回数が入る
				}
				; ループして出力
				Loop, % count - 1
				{
					Send, % out
					; 出力直後のディレイ
					If (postDelay > -2)
						Sleep, % postDelay
				}
				; 最後の1回の出力
				Send, % out

				; 必要に応じて出力した時間を記録
				If (!noIME && i > strLength)
					lastSendTime := QPC()

				; ローマ字入力の文字を押した時
				If (strSubLength == 1 && strSub >= "!" && strSub <= "~"
				 || strSubLength == 3 && strSub >= "{!}" && strSub <= "{~}"
				 || RegExMatch(strSub, "^\{[a-z\d\-]\sdown\}$"))
				{
					romanChar := True
					If (noIME)
						romanCharForNoIME := True
				}
				; キーを上げたのではなく、ローマ字入力の文字を押したのでもない時
				Else If (SubStr(strSub, strSubLength - 3, 4) != " up}")
				{
					; IME窓の検出が当てにできるか判定
					; 初めてのスペース変換1回目にIME窓検出タイマーを起動
					If (hwnd != goodHwnd && hwnd != badHwnd
					 && (out = "{vk20}" || out = "{Space}") && romanChar && i > strLength)
						SetTimer, JudgeHwnd, % - imeGetConvertingInterval
					romanChar := False
					imeState := imeSentenceMode := ""
				}
				; キーを上げただけの時
				Else
					postDelay := -2

				; 出力直後のディレイ
				If (postDelay > -2)
					Sleep, % postDelay
				lastDelay := (postDelay < 0 ? 0 : postDelay)
			}
			Else
			{
				romanChar := False
				imeState := imeSentenceMode := ""
			}

			; 必要なら IME の状態を元に戻す
			; ※IME_SET(1) を使う方法
			If (noIME && (i > strLength || strSub = "{UndoIME}"))
			{
				noIME := False

				; シフトが残りやすいので IMEごとにディレイを調整
				If (imeName == "ATOK")
					preDelay := 80
				; SendRawだったか、または一時IMEをオフにした間にローマ字(アスキー文字)を出力していない
				Else If (!romanCharForNoIME)
				 	preDelay := (imeName == "CustomMSIME" || imeName == "OldMSIME" ? 40 : 20)
				Else If (imeName == "NewMSIME")
					preDelay := 60
				Else If (imeName == "Google")
					preDelay := 90
				Else	; 旧MS-IME
					preDelay := 70

				; 前回の出力からの時間が短ければ、ディレイを入れる
				If (lastDelay < preDelay)
					Sleep, % preDelay - lastDelay
				IME_SET(1)			; IMEオン
				lastDelay := imeNeedDelay
				lastSendTime := 0.0
				romanCharForNoIME := False
			}

			preDelay := postDelay := -2
			strSub := out := ""
			strSubLength := 0
		}
	}
}

; 仮出力バッファの先頭から i 個出力する
; i の指定がないときは、全部出力する
OutBuf(i:=2)	; (i: Int) -> Void
{
	global outStrsLength, outStrs, outCtrlNames, NR, R
		, testMode
;	local out		; String型
;		, ctrlName	; String型

	While (i > 0 && outStrsLength > 0)
	{
		out := outStrs[1]
		ctrlName := outCtrlNames[1]

		; テスト表示 出力文字列
		If (testMode == 3)
		{
			ToolTip, %out%
			SetTimer, RemoveToolTip, 2500
		}

		; リピートなし
		If (ctrlName == NR)
		{
			SendEachChar(out)
			SendKeyUp()		; 押し下げ出力中のキーを上げる
		}
		; リピート可能
		Else If (ctrlName == R)
			SendEachChar(out)
		; 特別出力(かな定義ファイルで操作)
		Else
		{
			SendSP(out, ctrlName)
			SendKeyUp()		; 押し下げ出力中のキーを上げる
		}

		outStrs[1] := outStrs[2]
		outCtrlNames[1] := outCtrlNames[2]
		outStrsLength--
		i--
	}
	DispStoredStr()	; 表示待ち文字列表示
}

; 仮出力バッファを最後から backCount 回分を削除して、str と ctrlName を保存
StoreBuf(str, backCount, ctrlName)	; (str: String, backCount: Int, ctrlName: String) -> Void
{
	global outStrsLength, outStrs, outCtrlNames

	If (backCount > 0)
	{
		outStrsLength -= backCount
		If (outStrsLength < 0)
			outStrsLength := 0
	}
	; バッファがいっぱいなので、1文字出力
	Else If (outStrsLength == 2)
		OutBuf(1)

	outStrsLength++
	outStrs[outStrsLength] := str
	outCtrlNames[outStrsLength] := ctrlName
	DispStoredStr()	; 表示待ち文字列表示
}

; 縦書き・横書き切り替え
ChangeVertical(mode)	; (mode: Bool) -> Void
{
	global iniFilePath, vertical

	static icon_H_Path := Path_AddBackslash(A_ScriptDir) . "Icons\"
					. Path_RemoveExtension(A_ScriptName) . "_H.ico"	; String型
		, icon_V_Path := Path_AddBackslash(A_ScriptDir) . "Icons\"
					. Path_RemoveExtension(A_ScriptName) . "_V.ico"	; String型

	; 設定ファイル書き込み
	If (vertical != mode)
	{
		vertical := mode
		IniWrite, %vertical%, %iniFilePath%, Naginata, Vertical
	}

	; タスクトレイ関連
	If (vertical)
	{
		Menu, TRAY, Check, 縦書きモード		; “縦書きモード”にチェックを付ける
		If (Path_FileExists(icon_V_Path))
			Menu, TRAY, Icon, %icon_V_Path%
		Else
			Menu, TRAY, Icon, *
	}
	Else
	{
		Menu, TRAY, Uncheck, 縦書きモード	; “縦書きモード”のチェックを外す
		If (Path_FileExists(icon_H_Path))
			Menu, TRAY, Icon, %icon_H_Path%
		Else
			Menu, TRAY, Icon, *
	}
}

; 出力する文字列を選択
SelectStr(index)	; (index: Int) -> String
{
	global vertical, defsTateStr, defsYokoStr

	Return (vertical ? defsTateStr[index] : defsYokoStr[index])
}

; テスト表示 timeA からの時間[ミリ秒単位]
DispTime(timeA, str:="")	; (timeA: Double, str: String) -> Void
{
	global testMode
;	local timeAtoB	; Double型

	If (testMode == 1)
	{
		timeAtoB := Round(QPC() - timeA, 1)
		ToolTip, %timeAtoB% ms%str%
		SetTimer, RemoveToolTip, 1000
	}
}

; テスト表示 表示待ち文字列
DispStoredStr()	; () -> Void
{
	global testMode, outStrsLength, outStrs
;	local str	; String型

	If (testMode == 2)
	{
		If (!outStrsLength)
			ToolTip
		Else
		{
			If (outStrsLength == 1)
				str := outStrs[1]
			Else
				str := outStrs[1] . "`n" . outStrs[2]
			ToolTip, %str%
		}
	}
}

; リピート回数を更新する
RepeatCount(nowKey)	; (nowKey: String) -> Void
{
	global repeatCount
	static lastKey := ""	; String型	最後に押したキー
;	local key	; [String]型

	; nowKey をスペースで分割して配列 key に入れる
	key := StrSplit(nowKey, A_Space)

	; 最後に押したキーが
	If (key[1] == lastKey)
	{
		; 離れた時
		If (key[2] == "up")
		{
			repeatCount := 0
			lastKey := ""
		}
		; リピート
		Else
			repeatCount++
	}
	; 別のキーが押された時
	Else If (key[2] != "up")
	{
		repeatCount := 0
		lastKey := nowKey
	}
	; なお最後に押したキーと別のキーが離れた時は何もしない
}

; 変換、出力
Convert()	; () -> Void
{
	global inBufsKey, inBufReadPos, inBufsTime, inBufRest
		, KC_SPC, JP_YEN, KC_INT1, NR, R
		, defsKey, defsGroup, defsKanaMode, defsCombinableBit, defsCtrlName, defBegin, defEnd
		, outStrsLength, lastSendTime, kanaMode
		, sideShift, shiftDelay, combDelay, spaceKeyRepeat
		, combLimitN, combStyleN, combKeyUpN, combLimitS, combStyleS, combKeyUpS, combLimitE, combKeyUpSPC
		, keyUpToOutputAll, eisuSandS, eisuRepeat
		, repeatStyle, imeGetInterval
		, spc, ent, repeatCount
		, imeState, imeSentenceMode
	static convRest	:= 0		; Int型		入力バッファに積んだ数/多重起動防止フラグ
		, nextKey	:= ""		; String型	次回送りのキー入力
		, realBit	:= 0		; Int64型	今押している全部のキービットの集合
		, lastBit	:= 0		; Int64型	前回のキービット
		, last2Bit	:= 0		; Int64型	前々回のキービット
		, reuseBit	:= 0		; Int64型	復活したキービット
		, lastPushedTime := 0.0	; Double型	有効なキーを押した時間
		, timeLimit := 0.0		; Double型	タイマーを止めたい時間
		, lastToBuf	:= ""		; String型	前回、出力バッファに送った文字列(リピート、後置シフト用)
		, lastKeyCount := 0		; Int型		前回、何キー同時押しだったか？
		, lastGroup	:= ""		; String型	前回、何グループだったか？ 0または空はグループなし
		, repeatFlg	:= False	; Bool型	リピート中か
		, ctrlName	:= NR		; String型	NR: リピートなし, R: リピートあり, 他: かな配列ごとの特殊コード
		, combinableBit := -1	; Int64型	押すと同時押しになるキー (-1 は次の入力で即確定しないことを意味する)
		, lastIMEConvMode		; Int型
		, lastIMESentenceMode	; Int型
		; シフト用キーの状態
		, sft		:= 0	; Bool型	左シフト
		, rsft		:= 0	; Bool型	右シフト
		; グローバル変数へ移動
;		, spc		:= 0	; Int型	スペースキー 0: 押していない, 1: 単独押し, 2: シフト継続中, 3, 5: リピート中(3: かなを押すと変換取消→シフト側文字)
;		, ent		:= 0	; Int型	エンター	 0: 押していない, 1: 単独押し, 2: シフト継続中, 5: リピート中
;	local class				; String型
;		, keyTime			; Double型	キーを押した時間
;		, nowKey			; String型
;		, nowKeyLength		; Int型
;		, term				; String型	入力の末端2文字
;		, toBuf				; String型	出力バッファに送る文字列
;		, keyCount			; Int型		今回は何キー同時押しか
;		, nowBit			; Int64型	今回のキービット
;		, bitMask			; Int64型
;		, realBitAndKC_SPC	; Int64型	スペースを押していれば 0以外
;		, backCount			; Int型
;		, searchBit			; Int64型	いま検索しようとしているキーの集合
;		, shiftStyle		; Int型
;		, i, imax			; Int型		カウンタ用
;		, defKeyCopy		; Int64型
;		, interval			; Double型
;		, imeConvMode		; Int?型	IME 入力モード	IME_GetConvMode()用

	; 判定期限タイマー停止
	SetTimer, KeyTimer, Off
	; 多重起動防止
	If (convRest || nextKey != "")
		Return

	; 入力バッファが空になるまで
	While (convRest := 31 - inBufRest || nextKey != "")
	{
		If (nextKey == "")
		{
			; 入力バッファから読み出し
			; 参考: 鶴見惠一；6809マイコン・システム 設計手法，CQ出版社 p.114-121
			nowKey := inBufsKey[inBufReadPos], keyTime := inBufsTime[inBufReadPos]
				, inBufReadPos := ++inBufReadPos & 31, inBufRest++

			; 同時押し、後置シフトの判定タイマー反応
			If (nowKey == "KeyTimer")
			{
				; タイマー割り込み後にキー変化がないこと
				If (inBufRest != 31)
					Continue
				; 判定期限到来
				If (keyTime > timeLimit)
				{
					OutBuf()
					DispTime(lastPushedTime, "`n判定期限")	; キー変化からの経過時間を表示
				}
				Else
					; 10ミリ秒後に再判定
					SetTimer, KeyTimer, -10
				Continue
			}

			; リピート回数を数える
			RepeatCount(nowKey)
		}
		Else
		{
			; 前回の残りを読み出し
			nowKey := nextKey
			nextKey := ""
		}

		WinGetClass, class, A
		; IME の状態を検出しない時間を過ぎていたら、入力モードを検出
		; ※ 通常、IME_GET() の値が 0 でも IME_GetConvMode() の値は 0 にならない
		;		例外1: IME のアイコンが "×" になっているとき。ただし Google Chrome と Edge の入力欄でないところは別
		;		例外2: Excel と PowerPoint のコメント。でも IME のアイコンは "×" になっていない
		;		例外3: IME_SetConvMode(0) を実行したとき
		;		例外4: Firefox と Thunderbird を新MS-IMEで使い、左右シフトで一時英数入力にしているとき
		If (lastSendTime + imeGetInterval <= QPC())
		{
			imeState := IME_GET()
			imeConvMode := IME_GetConvMode()
			imeSentenceMode := IME_GetSentenceMode()
			; IME_GetConvMode() の値が 0 になった直後を英数モードに	※ 10行前を参照
			If (imeConvMode == 0 && lastIMEConvMode)
				kanaMode := 0
			; 検出したものを保存
			lastIMEConvMode := imeConvMode
			lastIMESentenceMode := imeSentenceMode
		}
		Else
		{
			; 検出できなかったことを示す
			imeState := ""
			; 保存していたものをコピー
			imeConvMode := lastIMEConvMode
			imeSentenceMode := lastIMESentenceMode
		}

		; コンテキストメニューが出ている時
		; または IMEオフ状態を検出	※ 18行前を参照
		If (WinExist("ahk_class #32768")
		 || imeState == 0 && imeConvMode)
		{
			kanaMode := 0	; 英数モード
		}
		; Win+X キーで出てくるメニュー
;		Else If (imeState && WinExist("ahk_class Xaml_WindowedPopupClass"))
;			IME_SET(kanaMode := 0)	; IMEオフ
		Else If ((sft || rsft) && sideShift <= 1	; 左右シフト英数で左右シフトを押している
			&& !InStr(nowKey, "sc39") && !InStr(nowKey, "Shift") && !InStr(nowKey, "Enter"))
		{
			If (DetectIME() == "Google" && imeState && (imeConvMode & 1) == 1)
			{
				Send, {vkF3}	; 半角/全角 ※ 半角英数に入力切替
				imeState := ""
			}
			kanaMode := 0	; 英数モード
			imeConvMode := lastIMEConvMode := ""	; IME 入力モードは不明になる
		}
		; 検出したものを反映する
		Else If (imeState == 1)
			kanaMode := imeConvMode & 1

		; 先頭の "+" を消去
		If (Asc(nowKey) == 43)
			nowKey := SubStr(nowKey, 2)
		; 左右シフト処理
		If (nowKey == "~LShift")
		{
			sft := 1
			If (spc)
				spc := 2	; 単独スペースではない
			If (ent)
				ent := 2	; 単独エンターではない
			OutBuf()
			nowKey := "sc39"	; センターシフト押す
		}
		Else If (nowKey == "*RShift")
		{
			rsft := 1
			If (spc)
				spc := 2	; 単独スペースではない
			If (ent)
				ent := 2	; 単独エンターではない
			OutBuf()
			Send, {ShiftDown}
			nowKey := "sc39"	; センターシフト押す
		}
		Else If (nowKey == "~LShift up")
		{
			sft := 0
			; 右シフトは離されていない
			If (rsft)
			{
				Send, {ShiftDown}
				DispTime(keyTime)	; キー変化からの経過時間を表示
				Continue
			}
			; 他のシフトを押している
			Else If (spc || ent)
			{
				DispTime(keyTime)	; キー変化からの経過時間を表示
				Continue
			}
			Else
				nowKey := "sc39 up"	; センターシフト上げ
		}
		Else If (nowKey == "*RShift up")
		{
			rsft := 0
			; 左シフトも離されている
			If (!sft)
				Send, {ShiftUp}
			; 他のシフトを押している時
			If (sft || spc || ent)
			{
				DispTime(keyTime)	; キー変化からの経過時間を表示
				Continue
			}
			Else
				nowKey := "sc39 up"	; センターシフト上げ
		}
		; スペースキー処理
		Else If (nowKey == "sc39")
		{
			If (ent)
				ent := 2	; 単独エンターではない

			; 他のシフトを押している時
			If (sft || rsft || ent)
			{
				spc := (SpaceKeyRepeat == 2 ? 3 : 2)	; 他のシフトを離した後もリピートするか
				StoreBuf("+{Space}", 0, R)
				OutBuf()
				DispTime(keyTime, "`nシフト+スペース")	; キー変化からの経過時間を表示
				Continue
			}
			; Firefox と Thunderbird のスペースキーでのスクロール
			; またはSandSなしの設定をした英数入力中
			Else If (imeConvMode == 0 && class == "MozillaWindowClass"
				&& !(DetectIME() == "NewMSIME" && imeSentenceMode != 0)
				|| !eisuSandS && !kanaMode)
			{
				StoreBuf("{Space}", 0, R)
				OutBuf()
				DispTime(keyTime)	; キー変化からの経過時間を表示
				Continue
			}
			; 英数単打のリピート、(スペースキーの長押し	空白リピート以外)リピートの好み 全て
			Else If ((!kanaMode && eisuRepeat || !repeatStyle && SpaceKeyRepeat != 2)
				&& repeatCount && !(lastBit & KC_SPC))
			{
				spc := 5	; 空白をリピート中
				StoreBuf("{Space}", 0, R)
				OutBuf()
				DispTime(keyTime, "`nスペース長押し")	; キー変化からの経過時間を表示
				Continue
			}
			; スペースキーの長押し
			Else If (spaceKeyRepeat && (spc & 1))
			{
				; 空白キャンセル
				If (spaceKeyRepeat == 1)
					spc := 2	; シフト継続中
				Else
				{
					spc := 3	; 空白をリピート中
					StoreBuf("{Space}", 0, R)
					OutBuf()
				}
				DispTime(keyTime, "`nスペース長押し")	; キー変化からの経過時間を表示
				Continue
			}
			Else If (spc)
				Continue

			spc := 1	; 単独押し
		}
		Else If (nowKey == "sc39 up")
		{
			SendKeyUp()		; 押し下げ出力中のキーを上げる
			; 他のシフトを押している時
			If (sft || rsft || ent)
			{
				spc := 0
				DispTime(keyTime)	; キー変化からの経過時間を表示
				Continue
			}
			Else If (spc == 1)
				nextKey := "vk20"	; センターシフト上げ→スペース単独押し
			spc := 0
		}
		; エンターキー処理
		Else If (nowKey == "Enter")
;		Else If (nowKey == "Enter" && (eisuSandS || kanaMode))	; 英数入力のSandSなし設定でエンターシフトも止めたい時
		{
			If (spc)
				spc := 2	; 単独スペースではない

			; 他のシフトを押している時
			If (sft || rsft || spc)
			{
				ent := 2	; 他のシフトを離した後にリピートしない
				StoreBuf("+{Enter}", 0, R)
				OutBuf()
				DispTime(keyTime, "`nシフト+エンター")	; キー変化からの経過時間を表示
				Continue
			}
			; 英数単打のリピート
			Else If ((!kanaMode && eisuRepeat || !repeatStyle)
				&& repeatCount && !(lastBit & KC_SPC))
			{
				ent := 5	; エンターをリピート中
				StoreBuf("{vk0D}", 0, R)	; エンター単独押し ※"Enter"としないこと
				OutBuf()
				DispTime(keyTime, "`nエンター長押し")	; キー変化からの経過時間を表示
				Continue
			}
			Else If (ent)
				Continue

			ent := 1
			nowKey := "sc39"	; センターシフト押す
		}
		Else If (nowKey == "Enter up")
		{
			nowKey := "sc39 up"	; センターシフト上げ
			SendKeyUp()			; 押し下げ出力中のキーを上げる
			; 他のシフトを押している時
			If (sft || rsft || spc)
			{
				ent := 0
				DispTime(keyTime)	; キー変化からの経過時間を表示
				Continue
			}
			Else If (ent == 1)
				nextKey := "vk0D"	; センターシフト上げ→エンター単独押し ※"Enter"としないこと
			ent := 0
		}
		; スペースのリピートを止める
		Else If (spc == 3)
		{
			; かなを押すと変換取消→シフト側文字
			If (kanaMode)
			{
				nextKey := nowKey
				nowKey := "vk1B"	; Shiftが付け加えられるので Shift+Esc(変換取消)→シフト側文字
			}
			spc := 2	; シフト継続中
		}

		keyCount := 0	; 何キー同時押しか、を入れる変数
		nowKeyLength := StrLen(nowKey)
		term := SubStr(nowKey, nowKeyLength - 1)	; term に入力末尾の2文字を入れる
		; キーが離れた時
		If (term == "up")
		{
			; nowBit に sc○○ から 0x○○ に変換されたものを入れる
			; 行が変われば十六進数の数値として扱える
			If (SubStr(nowKey, 1, 2) == "sc")
				nowBit := "0x" . SubStr(nowKey, nowKeyLength - 4, 2)
			Else
				nowBit := 0
		}
		Else
		{
			; スペースキーが押されていたら、toBuf にシフトを加える(SandSの実装)
			toBuf := (realBit & KC_SPC ? "+" : "")

			; sc** で入力
			If (SubStr(nowKey, 1, 2) == "sc")
			{
			; nowBit に sc○○ から 0x○○ に変換されたものを入れる
			; 行が変われば十六進数の数値として扱える
				nowBit := "0x" . term
				; スペースキーが押されていたら
				If (realBit & KC_SPC)
					; toBuf に "{sc○○}" の形式で入れる
					toBuf .= "{sc" . term . "}"
				; スペースキーが押されていない
				Else
					; toBuf に "{sc○○ down}{sc○○ up}" の形式で入れる
					toBuf .= "{sc" . term . " down}{sc" . term . " up}"
			}
			; sc** 以外で入力
			Else
			{
				nowBit := searchBit := 0
				toBuf .= "{" . nowKey . "}"
				keyCount := -1	; かな定義の検索は不要
			}
		}

		; ビットに変換
		If (nowBit == 0x7D)			; (JIS)\
			nowBit := JP_YEN
		Else If (nowBit == 0x73)	; (JIS)_
			nowBit := KC_INT1
		Else If (nowBit)
			nowBit := 1 << nowBit

		; キーリリース時
		If (term == "up")
		{
			bitMask := nowBit ^ (-1)	; realBit &= ~nowBit では32ビット計算になることがあるので
			realBit &= bitMask

			; 文字キーによるシフトの適用範囲
			If (combKeyUpSPC && nowBit == KC_SPC)
				shiftStyle := combKeyUpS	; スペースキーを離した時は、スペース押下時の設定
			Else
				shiftStyle := ((realBit & KC_SPC) ? combKeyUpS : combKeyUpN)

			; 「キーを離せば常に全部出力する」がオン、または直近の検索結果のキーを離した
			If (keyUpToOutputAll || (lastBit & nowBit))
			{
				OutBuf()
				SendKeyUp()		; 押し下げ出力中のキーを上げる
				If (lastBit & nowBit)
					lastToBuf := ""
				lastKeyCount := 0
				; 全部出力済みならシフト解除
				If (shiftStyle == 2)
					last2Bit := lastBit := 0
				; 同グループ優先は白紙に
				lastGroup := ""
			}
			; 一つ前に押したキーを離した
			Else If (outStrsLength == 2 && lastKeyCount == 1 && nowBit == last2Bit)
				OutBuf(1)	; 1個出力
			; カーソルキー等
			Else If (!nowBit)
				SendKeyUp()		; 押し下げ出力中のキーを上げる

			last2Bit &= bitMask
			lastBit &= bitMask
			reuseBit := (shiftStyle ? 0 : realBit)	; 文字キーシフト全復活
			combinableBit |= nowBit ; 次の入力で即確定しないキーに追加

			DispTime(keyTime)	; キー変化からの経過時間を表示
		}
		; (キーリリース直後か、通常シフトまたは後置シフトの判定期限後に)スペースキーが押された時
		Else If (nowBit == KC_SPC && !(realBit & nowBit)
			&& (!outStrsLength || lastPushedTime + shiftDelay < keyTime))
		{
			OutBuf()
			SendKeyUp()			; 押し下げ出力中のキーを上げる
			realBit |= KC_SPC
			repeatFlg := False	; リピート解除
			DispTime(keyTime)	; キー変化からの経過時間を表示
		}
		; リピート中のキー
		Else If (repeatFlg && repeatCount && lastToBuf != "")
		{
			; 入力バッファが空の時
			If (inBufRest == 31 || !repeatStyle)
			{
				; 前回の文字列を出力
				If (!outStrsLength)
					StoreBuf(lastToBuf, 0, ctrlName)
				OutBuf()
				DispTime(keyTime, "`nリピート " . repeatCount . "回目")	; キー変化からの経過時間を表示
			}
		}
		; 押されていなかったキー、sc**以外のキー
		Else If !(realBit & nowBit)
		{
			realBit |= nowBit
			realBitAndKC_SPC := realBit & KC_SPC	; スペースを押していれば 0以外

			; 文字キーによるシフトの適用範囲
			; 英数入力時に判定期限ありなら、文字キーシフトは「同グループのみ継続」か「1回のみ」
			shiftStyle := (realBitAndKC_SPC ? combStyleS : combStyleN)
			If (combLimitE && !kanaMode && shiftStyle < 2)
				shiftStyle := 2
;			lastGroup := (!shiftStyle ? "" : lastGroup)	; かわせみ2用と同じ動作にするなら有効に

			; 前に押したキーと同時押しにならない
			; または同時押しの判定期限到来
			If (outStrsLength
			 && (!(combinableBit & nowBit) || (nowBit != KC_SPC && combDelay > 0 && lastPushedTime + combDelay < keyTime
			 && ((combLimitN && !realBitAndKC_SPC) || (combLimitS && realBitAndKC_SPC) || (combLimitE && !kanaMode)) )))
				OutBuf()
			; 前に押したキーが出力確定していなければ同グループ優先で検索しない
			If (outStrsLength)
				lastGroup := ""
			; 出力確定しているので、シフト設定によっては1キー入力だけを検索する
			Else If (shiftStyle == 3 || (shiftStyle == 2 && !lastGroup) || (shiftStyle == 1 && lastKeyCount == 1))
				last2Bit := lastBit := 0

			; 検索ループ
			backCount := 0
			While (!keyCount)
			{
				; 3キー入力を検索
				If (last2Bit | reuseBit)
				{
					; 検索場所の設定
					i := defBegin[3]
					imax := defEnd[3]
					; シフトの適用範囲に応じた検索キーを設定
					If (shiftStyle)
						searchBit := realBitAndKC_SPC | nowBit | ((lastBit | last2Bit) ? (lastBit | last2Bit) : reuseBit)
					Else
						searchBit := realBit

					While (i < imax)
					{
						defKeyCopy := defsKey[i]
						If ((defKeyCopy & nowBit) ; 今回のキーを含み
							&& (defKeyCopy & searchBit) == defKeyCopy ; 検索キーがいま調べている定義を含み
							&& (defKeyCopy & KC_SPC) == realBitAndKC_SPC ; シフトの相違はなく
							&& defsKanaMode[i] == kanaMode	; 英数用、かな用の種別が一致していること
							&& (!lastGroup || lastGroup == defsGroup[i]))
						{
							; 見つかった!
							; 前回が2キー、3キー同時押しだったら仮出力バッファの1文字消す
							; 前回が1キー入力だったら仮出力バッファの2文字消す
							backCount := (!(defKeyCopy & (lastBit | last2Bit)) ? 0 : lastKeyCount >= 2 ? 1 : 2)
							keyCount := 3
							Break
						}
						i++
					}
				}
				; 2キー入力を検索
				If (!keyCount && (lastBit | reuseBit))
				{
					; 検索場所の設定
					i := defBegin[2]
					imax := defEnd[2]
					; シフトの適用範囲に応じた検索キーを設定
					If (shiftStyle)
						searchBit := realBitAndKC_SPC | nowBit | (lastBit ? lastBit : reuseBit)
					Else
						searchBit := realBit

					While (i < imax)
					{
						defKeyCopy := defsKey[i]
						If ((defKeyCopy & nowBit) ; 今回のキーを含み
							&& (defKeyCopy & searchBit) == defKeyCopy ; 検索キーがいま調べている定義を含み
							&& (defKeyCopy & KC_SPC) == realBitAndKC_SPC ; シフトの相違はなく
							&& defsKanaMode[i] == kanaMode	; 英数用、かな用の種別が一致していること
							&& (!lastGroup || lastGroup == defsGroup[i]))
						{
							; 見つかった!
							If (outStrsLength >= 2)
								; 2つ前に押したキーを出力
								OutBuf(1)
							backCount := (lastKeyCount >= 2 && nowBit != KC_SPC || !(defKeyCopy & lastBit) ? 0 : 1)
							keyCount := 2
							Break
						}
						i++
					}
				}
				; 1キー入力を検索
				If (!keyCount)
				{
					; 検索場所の設定
					i := defBegin[1]
					imax := defEnd[1]
					; 検索キーを設定
					searchBit := realBitAndKC_SPC | (nowBit == KC_SPC ? lastBit : nowBit)

					While (i < imax)
					{
						If (searchBit == defsKey[i] && kanaMode == defsKanaMode[i]
							&& (!lastGroup || lastGroup == defsGroup[i]))
						{
							; 見つかった!
							If (nowBit == KC_SPC)
								backCount := 1
							keyCount := 1
							Break
						}
						i++
					}
				}
				; 検索終了判定
				If (!lastGroup || keyCount)
					Break
				; 同グループが見つからなければグループなしで再度検索
				lastGroup := ""
				reuseBit := last2Bit := lastBit := 0
			}

			; スペースを押したが、定義がなかった時
			If (nowBit == KC_SPC && !keyCount)
			{
				; 仮出力バッファが空の時
				If (!outStrsLength)
				{
					SendKeyUp()			; 押し下げ出力中のキーを上げる
					repeatFlg := False	; リピート解除
					DispTime(keyTime)	; キー変化からの経過時間を表示
					Continue
				}
				; 直前の文字にシフトを加える(後置シフト)
				Else
				{
					toBuf := "+" . lastToBuf
					backCount := 1
				}
			}
			If (spc)
				spc := 2	; 単独スペースではない
			If (ent)
				ent := 2	; 単独エンターではない

			; 仮出力する文字列を変数に入れる
			; 定義が見つかった時
			If (keyCount > 0)
			{
				toBuf := SelectStr(i)
				ctrlName := defsCtrlName[i]
			}
			; 定義がなければリピートあり
			Else
				ctrlName := R

			; 仮出力バッファに入れる
			StoreBuf(toBuf, backCount, ctrlName)

			; キーリピート用
			If (ctrlName == R || !repeatStyle)
				repeatFlg := True	; キーリピートする
			Else
				repeatFlg := False

			; 次回の検索用に変数を更新(グループの保存は後で)
			lastToBuf := toBuf			; 今回の文字列を保存
			lastPushedTime := keyTime	; 有効なキーを押した時間を保存
			lastKeyCount := keyCount	; 何キー同時押しだったかを保存
			reuseBit := 0				; 復活したキービットを消去
			; キービットを保存
			If (keyCount >= 2)
				; 2、3キー入力のときは今回のを保存
				last2Bit := lastBit := defsKey[i]
			Else If (backCount)
				; 1キー入力で今はスペースキーを押した
				lastBit := searchBit
			Else
			{
				; 繰り上げ
				last2Bit := lastBit
				lastBit := searchBit
			}

			; 一緒に押すと同時押しになるキーを探す
			If (keyCount > 0 && !lastGroup)
				combinableBit := defsCombinableBit[i]
			Else If (keyCount >= 0)
				combinableBit := FindCombinableBit(lastBit, kanaMode, keyCount, lastGroup)
			Else	; If (keyCount < 0)
				combinableBit := 0
			; 何グループだったか保存
			lastGroup := (keyCount > 0 ? defsGroup[i] : "")

			; 出力確定文字か？
			; 「キーを離せば常に全部出力する」がオンなら、現在押されているキーを除外
			; オフなら、いま検索したキーを除外
			combinableBit &= (keyUpToOutputAll ? realBit : lastBit) ^ (-1)

			; 出力処理
			If (combinableBit == 0 || (shiftDelay <= 0 && combinableBit == KC_SPC))
				; 出力確定
				OutBuf()
			Else
			{
				SendKeyUp()	; 押し下げ出力中のキーを上げる
				If (inBufRest == 31 && nextKey == "")
				{
					; 入力バッファが空なので、同時押し、後置シフトの判定タイマー起動処理
					timeLimit := 0.0
					; 同時押しの判定
					If (combDelay > 0
					 && ((combLimitN && !realBitAndKC_SPC) || (combLimitS && realBitAndKC_SPC) || (combLimitE && !kanaMode)))
					{
						timeLimit := keyTime + combDelay	; 期限の時間
						; 後置シフトも判定し、期限の長いほうを採用
						If ((combinableBit & KC_SPC) && shiftDelay > combDelay)
							timeLimit := keyTime + shiftDelay
					}
					; 後置シフトの判定
					Else If (combinableBit == KC_SPC)
						timeLimit := keyTime + shiftDelay
					; タイマー起動
					If (timeLimit != 0.0 && (interval := QPC() - timeLimit) < 0.0)
						SetTimer, KeyTimer, %interval%	; 1回のみのタイマー
				}
			}
			DispTime(keyTime)	; キー変化からの経過時間を表示
		}
	}
}


; ----------------------------------------------------------------------
; ホットキー
; ----------------------------------------------------------------------
#MaxThreadsPerHotkey 3	; 1つのホットキー・ホットストリングに多重起動可能な
						; 最大のスレッド数を設定

; キー入力部
~LShift::
*RShift::
	Suspend, Permit	; ここまではSuspendの対象でないことを示す
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
+sc39::	; Space
; Microsoft OneNote 対策のため、スペースキーかエンターキーを押しているときだけ
; UpキーとDownキーを取得する
#If (spc || ent)
Up::	; ※小文字にしてはいけない
Down::
Left::
Right::
Home::
End::
PgUp::
PgDn::
; エンター同時押しをシフトとして扱う場合
#If (EnterShift)
Enter::
+Enter::
; USキーボードの場合
#If (USKB)
sc29::	; (JIS)半角/全角	(US)`
+sc29::	; (JIS)半角/全角	(US)`
#If		; End #If ()
; 入力バッファへ保存
	; 参考: 鶴見惠一；6809マイコン・システム 設計手法，CQ出版社 p.114-121
	inBufsKey[inBufWritePos] := A_ThisHotkey, inBufsTime[inBufWritePos] := QPC()
		, inBufWritePos := (inBufRest > 16 ? ++inBufWritePos & 31 : inBufWritePos)	; キーを押す方はいっぱいまで使わない
		, (inBufRest > 16 ? inBufRest-- : )
	Convert()	; 変換ルーチン
/*
	If (testMode != "ERROR" && inBufRest <= 16 && A_TickCount >= trayTipTimeLimit)
	{
		TrayTip, , 入力バッファが一杯, , 16
		trayTipTimeLimit := A_TickCount + 10000
	}
*/
	Return

; キー押上げ
~LShift up::
*RShift up::
	Suspend, Permit	; ここまではSuspendの対象でないことを示す
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
+sc39 up::	; Space
; Microsoft OneNote 対策のため、スペースキーかエンターキーを押しているときだけ
; UpキーとDownキーを取得する
#If (spc || ent)
Up up::	; ※小文字にしてはいけない
Down up::
Left up::
Right up::
Home up::
End up::
PgUp up::
PgDn up::
; エンター同時押しをシフトとして扱う場合
#If (EnterShift)
Enter up::
+Enter up::
; USキーボードの場合
#If (USKB)
sc29 up::	; (JIS)半角/全角	(US)`
+sc29 up::	; (JIS)半角/全角	(US)`
#If		; End #If ()
; 入力バッファへ保存
	; 参考: 鶴見惠一；6809マイコン・システム 設計手法，CQ出版社 p.114-121
	inBufsKey[inBufWritePos] := A_ThisHotkey, inBufsTime[inBufWritePos] := QPC()
		, inBufWritePos := (inBufRest ? ++inBufWritePos & 31 : inBufWritePos)
		, (inBufRest ? inBufRest-- : )
	Convert()	; 変換ルーチン
	Return

#MaxThreadsPerHotkey 1	; 元に戻す
