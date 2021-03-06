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
	WinGet, hwnd, ID, A
	If (IME_GET())
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
QPCInit() {
	DllCall("QueryPerformanceFrequency", "Int64P", freq)
	Return freq
}
QPC() {	; ミリ秒単位
	static coefficient := 1000.0 / QPCInit()
	DllCall("QueryPerformanceCounter", "Int64P", count)
	Return count * coefficient
}

; str をツールチップに表示し、time ミリ秒後に消す(デバッグ用)
ToolTip2(str, time:=0)
{
	ToolTip, %str%
	If (time != 0)
		SetTimer, RemoveToolTip, %time%
}

; 配列定義をすべて消去する
DeleteDefs()
{
	global defsKey, defsGroup, defsKanaMode, defsTateStr, defsYokoStr, defsCtrlNo
		, defBegin, defEnd

	; かな配列の入れ物
	defsKey := []		; キービットの集合
	defsGroup := []		; 定義のグループ番号 ※0はグループなし
	defsKanaMode := []	; 0: 英数入力用, 1: かな入力用
	defsTateStr := []	; 縦書き用定義
	defsYokoStr := []	; 横書き用定義
	defsCtrlNo := []	; 0: なし, 1: リピートできる, 2以上: 特別出力(かな定義ファイルで操作)
	defsCombinableBit := []	; 0: 出力確定しない,
							; 1: 通常シフトのみ出力確定, 2: どちらのシフトも出力確定
	defBegin := [1, 1, 1]	; 定義の始め 1キー, 2キー同時, 3キー同時
	defEnd	:= [1, 1, 1]	; 定義の終わり+1 1キー, 2キー同時, 3キー同時
}

; 何キー同時か数える
CountBit(keyComb)
{
	global KC_SPC
;	local count, i

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
ConvTateYoko(str)
{
	StringReplace, str, str, {Up,		{Temp,	A
	StringReplace, str, str, {Right,	{Up,	A
	StringReplace, str, str, {Down,		{Right,	A
	StringReplace, str, str, {Left,		{Down,	A
	StringReplace, str, str, {Temp,		{Left,	A

	Return str
}

; 機能置き換え処理 - DvorakJ との互換用
ControlReplace(str)
{
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
	StringReplace, str, str, {カタカナ,		{vkF1,		A
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

	StringReplace, str, str, {漢字,			{vk19,		A
	StringReplace, str, str, {英数,			{vkF0,		A

	Return str
}

; {確定} の後の定義を見て、{確定} だけにするか、{NoIME} を付加するかを返す
; Google日本語入力では「半角/全角」を押すと入力中のかなが確定するのを利用する
AnalysisForKakutei(str)
{
;	local strLength, strSub, c
;		, i, bracket

	If (str == "")
		Return (DetectIME() != "Google" ? "{確定}" : "{NoIME}")

	strSub := ""
	bracket := 0
	i := 1
	strLength := StrLen(str)
	While (i <= strLength)
	{
		c := SubStr(str, i, 1)
		If (c == "}" && bracket != 1)
			bracket := 0
		Else If (c == "{" || bracket)
			bracket++
		strSub .= c
		If (!(bracket || c == "+" || c == "^" || c == "!" || c == "#")
			|| i == strLength)
		{
		   	; ASCIIコード以外の文字が来た、またはIMEの状態を変更するまで「かな」の出力がない
			If ((Asc(strSub) > 127
			 || RegExMatch(strSub, "^\{U\+")
			 || (RegExMatch(strSub, "^\{ASC ") && SubStr(strSub, 6, strSubLength - 6) > 127))
			 || strSub = "{NoIME}"	|| strSub = "{UndoIME}"
			 || strSub = "{IMEOFF}" || strSub = "{IMEON}"
			 || strSub == "{全英}"	|| strSub == "{半ｶﾅ}")
			{
				; {NoIME} も付加する
				Return (DetectIME() != "Google" ? "{確定}{NoIME}" : "{NoIME}")
			}
			; 削除系、移動系、改行、カット、ペースト以外の定義が来たら「かな」入力とみなし
			Else If !(InStr(strSub, "{BS}")		|| InStr(strSub, "{Del}")
				  || InStr(strSub, "{Esc}")
				  || InStr(strSub, "{Up}")		|| InStr(strSub, "{Left}")
				  || InStr(strSub, "{Right}")	|| InStr(strSub, "{Down}")
				  || InStr(strSub, "{Home}")	|| InStr(strSub, "{End}")
				  || InStr(strSub, "{PgUp}")	|| InStr(strSub, "{PgDn}")
				  || RegExMatch(strSub, "^\{Enter")
				  || strSub == "^x" || strSub == "^v")
			{
				; {確定} のみとする
				Return "{確定}"
			}
			strSub := ""
		}
		i++
	}
	Return (DetectIME() != "Google" ? "{確定}" : "{NoIME}")
 }

; ASCIIコードでない文字が入っていたら、"{確定}""{NoIME}"を書き足す
; "{直接}"は"{Raw}"に書き換え
Analysis(str)
{
;	local strLength, strSub, strSubLength, ret, c
;		, i, bracket, kakutei, noIME

	If (str = "{Raw}" || str = "{直接}")
		; 有効な文字列がないので空白を返す
		Return ""

	kakutei := noIME := False
	ret := ""	; 変換後文字列
	strSub := ""
	strSubLength := 0
	bracket := 0
	i := 1
	strLength := StrLen(str)
	While (i <= strLength)
	{
		c := SubStr(str, i, 1)
		If (c == "}" && bracket != 1)
			bracket := 0
		Else If (c == "{" || bracket)
			bracket++
		strSub .= c
		strSubLength++
		If (!(bracket || c == "+" || c == "^" || c == "!" || c == "#")
			|| i == strLength)
		{
			If (RegExMatch(strSub, "\{Raw\}$"))
				; 残り全部を出力
				Return ret . SubStr(str, i - strSubLength + 1)
			Else If (RegExMatch(strSub, "\{直接\}$"))
			{
				If (!kakutei && DetectIME() != "Google")
					ret .= "{確定}"
				If (!noIME)
					ret .= "{NoIME}"
				; 残り全部を出力
				Return ret . "{Raw}" . SubStr(str, i + 1)
			}

			strSub := ControlReplace(strSub)

			If ((Asc(strSub) > 127 || RegExMatch(strSub, "^\{U\+")
				|| (RegExMatch(strSub, "^\{ASC ") && SubStr(strSub, 6, strSubLength - 6) > 127)))
			{
				; ASCIIコード以外の文字は IMEをオフにして出力
				If (!kakutei && DetectIME() != "Google")
					ret .= "{確定}"
				If (!noIME)
					ret .= "{NoIME}"
				ret .= strSub
				kakutei := noIME := True
			}
			Else If (strSub = "{NoIME}")
			{
				If (!kakutei && DetectIME() != "Google")
					ret .= "{確定}"
				If (!noIME)
					ret .= "{NoIME}"
				kakutei := noIME := True
			}
			Else If (strSub = "{確定}")
			{
				If (!noIME && !kakutei)
					ret .= AnalysisForKakutei(ControlReplace(SubStr(str, i + 1)))
				kakutei := True
				If (RegExMatch(ret, "\{NoIME\}$"))
					noIME := True
			}
			Else If (RegExMatch(strSub, "^\{Enter"))
			{
				; "{Enter" で確定状態
				ret .= strSub
				kakutei := True
			}
			Else If (strSub == "^x")
			{
				; 確定状態のときに "^x" を使うとみなし、IME 入力時のことは無視する
				ret .= strSub
				kakutei := True
			}
			Else If (str != "^v" && strSub == "^v")
			{
				; "^v" 単独は除外
				If (!noIME && !kakutei)
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
				|| strSub == "{全英}" || strSub == "{半ｶﾅ}")
			{
				ret .= strSub
				noIME := False
			}
			Else If (InStr(strSub, "{BS}")		|| InStr(strSub, "{Del}")
				  || InStr(strSub, "{Esc}")
				  || InStr(strSub, "{Up}")		|| InStr(strSub, "{Left}")
				  || InStr(strSub, "{Right}")	|| InStr(strSub, "{Down}")
				  || InStr(strSub, "{Home}")	|| InStr(strSub, "{End}")
				  || InStr(strSub, "{PgUp}")	|| InStr(strSub, "{PgDn}"))
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
		i++
	}

	Return ret
}

; 定義登録
; kanaMode	0: 英数, 1: かな
; keyComb	キーをビットに置き換えたものの集合
; convYoko	False: tate - 縦書き定義, yoko - 横書き定義
;			True:  tate - 縦書き定義, yoko - tate から変換必要
; ctrlNo	0: リピートなし, R: リピートあり, それ以外: かな配列ごとの特殊コード
SetDefinition(kanaMode, keyComb, convYoko, tate, yoko, ctrlNo)
{
	global defsKey, defsGroup, defsKanaMode, defsTateStr, defsYokoStr, defsCtrlNo
		, defBegin, defEnd
		, kanaGroup, R
;	local nkeys		; 何キー同時押しか
;		, i, imax	; カウンタ用

	If (!ctrlNo || ctrlNo == R)
	{
		; 機能を置き換え、ASCIIコードでない文字が入っていたら、"{確定}""{NoIME}"を書き足す
		; "{直接}"は"{Raw}"に書き換え
		tate := Analysis(tate)
		If (convYoko)
			yoko := ConvTateYoko(tate)	; 縦横変換
		Else
			yoko := Analysis(yoko)
	}
	Else If (convYoko)
		yoko := ConvTateYoko(tate)	; 縦横変換

	; 登録
	nkeys := CountBit(keyComb)	; 何キー同時押しか
	i := defBegin[nkeys]		; 始まり
	imax := defEnd[nkeys]		; 終わり
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
			defsCtrlNo.RemoveAt(i)

			defEnd[1]--
			If (nkeys > 1)
				defBegin[1]--, defEnd[2]--
			If (nkeys > 2)
				defBegin[2]--, defEnd[3]--
			Break
		}
		i++
	}
	If ((ctrlNo && ctrlNo != R) || tate != "" || yoko != "")
	{
		; 定義あり
		i := defEnd[nkeys]
		defsKey.InsertAt(i, keyComb)
		defsGroup.InsertAt(i, kanaGroup)
		defsKanaMode.InsertAt(i, kanaMode)
		defsTateStr.InsertAt(i, tate)
		defsYokoStr.InsertAt(i, yoko)
		defsCtrlNo.InsertAt(i, ctrlNo)

		defEnd[1]++
		If (nkeys > 1)
			defBegin[1]++, defEnd[2]++
		If (nkeys > 2)
			defBegin[2]++, defEnd[3]++
	}
	Return
}

; かな定義登録
SetKana(keyComb, str, ctrlNo:=0)
{
	; 横書き用は自動変換
	SetDefinition(1, keyComb, True, str, "", ctrlNo)
	Return
}
SetKana2(keyComb, tate, yoko, ctrlNo:=0)
{
	SetDefinition(1, keyComb, False, tate, yoko, ctrlNo)
	Return
}
; 英数定義登録
SetEisu(keyComb, str, ctrlNo:=0)
{
	; 横書き用は自動変換
	global eisuSandS, KC_SPC
	; 英数入力時のSandSが無効なら定義を削除する
	If (!eisuSandS && (keyComb & KC_SPC))
		str := ""
	SetDefinition(0, keyComb, True, str, "", ctrlNo)
	Return
}
SetEisu2(keyComb, tate, yoko, ctrlNo:=0)
{
	global eisuSandS, KC_SPC
	; 英数入力時のSandSが無効なら定義を削除する
	If (!eisuSandS && (keyComb & KC_SPC))
		tate := yoko := ""
	SetDefinition(0, keyComb, False, tate, yoko, ctrlNo)
	Return
}

; 一緒に押すと同時押しになるキーを探す
FindCombinableBit(searchBit, kanaMode, nkeys, group:=0)
{
	global defsKey, defsKanaMode, defsGroup, defBegin, defEnd
		, KC_SPC
;	local j, jmax	; カウンタ用
;		, bit
;		, defKeyCopy

	bit := (nkeys > 1 ? 0 : KC_SPC)
	j := defBegin[3]
	jmax := (nkeys >= 1 && nkeys <= 3 ? defEnd[nkeys] : defEnd[1])
	While (j < jmax)
	{
		defKeyCopy := defsKey[j]
		; グループAll か同じグループ、「かな」モードも同じで、判定中のキーを含むのを登録
		If ((!group || group := defsGroup[j])
		 && kanaMode == defsKanaMode[j] && (defKeyCopy & searchBit) == searchBit)
			bit |= defKeyCopy
		j++
	}
;	bit &= searchBit ^ (-1)	; 検索中のキーを削除

	Return bit
}

; 一緒に押すと同時押しになるキーを defsCombinableBit[] に記録
SettingLayout()
{
	global defsKey, defsKanaMode, defsCombinableBit, defBegin, defEnd
;	local i, imax	; カウンタ用
;		, searchBit

	; 出力確定するか検索
	i := defBegin[3]
	imax := defEnd[1]
	While (i < imax)
	{
		searchBit := defsKey[i]
		defsCombinableBit[i] := FindCombinableBit(searchBit, defsKanaMode[i], CountBit(searchBit))
		i++
	}
	Return
}

ExistNewMSIME()
{
;	local build

	; 参考: https://www.autohotkey.com/docs/Variables.htm#OSVersion
	If A_OSVersion in WIN_8.1,WIN_8,WIN_7,WIN_VISTA,WIN_2003,WIN_XP,WIN_2000	; Note: No spaces around commas.
		Return False

	; 参考: https://docs.microsoft.com/ja-jp/windows/release-health/supported-versions-windows-client
	; [requires v1.1.20+]
	build := SubStr(A_OSVersion, 6)	; 例えば 10.0.19043 は Windows 10 build 19043 (21H2)
	If (build <= 18363)	; Windows 10 1909 以前
		Return False
	Else
		Return True
}

; 使用している IME を調べる。MS-IME は 10秒経過していれば再調査。
; 戻り値	"MSIME": 新MS-IME登場以前のもの,
;			"NewMSIME":	新MS-IME, "OldMSIME": 以前のバージョンのMS-IMEを選んでいる
;			"ATOK": ATOK
DetectIME()
{
	global imeSelect, goodHwnd, badHwnd
	static existNewMSIME := existNewMSIME()
		, imeName := "", lastSearchTime := 0
;	local value, nowIME

	nowIME := imeName

	If (imeSelect == 1)
		nowIME := "ATOK"
	Else If (imeSelect)
		nowIME := "Google"
	Else If (!existNewMSIME)
		nowIME := "MSIME"
	Else If (A_TickCount < lastSearchTime || lastSearchTime + 10000 < A_TickCount)
	{
		lastSearchTime := A_TickCount
		; 「以前のバージョンの Microsoft IME を使う」がオンになっているか調べる
		; 参考: https://registry.tomoroh.net/archives/11547
		RegRead, value, HKEY_CURRENT_USER
			, SOFTWARE\Microsoft\Input\TSF\Tsf3Override\{03b5835f-f03c-411b-9ce2-aa23e1171e36}
			, NoTsf3Override2
		nowIME := (ErrorLevel == 1 || !value ? "NewMSIME" : "OldMSIME")
	}

	If (nowIME != imeName)
		goodHwnd := badHwnd := ""
	Return (imeName := nowIME)
}

; 文字列 str を適宜スリープを入れながら出力する
;	delay:	-1未満	Sleep をなるべく入れない
;			ほか	Sleep, % delay が基本的に1文字ごとに入る
SendEachChar(str, delay:=-2)
{
	global goodHwnd, badHwnd, lastSendTime, IME_Get_Interval
	static flag := False	; 変換1回目のIME窓検出用	False: 検出済みか文字以外, True: その他
;	local hwnd, title, class, process
;		, strLength				; str の長さ
;		, strSub, strSubLength	; 細切れにした文字列と、その長さを入れる変数
;		, out
;		, i, c, bracket
;		, noIME, imeConvMode	; IME入力モードの保存、復元に関するフラグと変数
;		, preDelay, postDelay	; 出力前後のディレイの値
;		, lastDelay				; 前回出力時のディレイの値
;		, clipSaved
;		, imeName

	SetTimer, JudgeHwnd, Off	; IME窓検出タイマー停止
	SetKeyDelay, -1, -1
	imeName := DetectIME()
	WinGet, hwnd, ID, A
	WinGetTitle, title, ahk_id %hwnd%
	WinGetClass, class, ahk_id %hwnd%
	WinGet, process, ProcessName, ahk_id %hwnd%

	; ディレイの初期値
	If (delay < -1)
		delay := -2
	Else If (delay > 500)
		TrayTip, , SendEachCharのディレイが長すぎです
	preDelay := postDelay := -2
	If (class == "CabinetWClass" && delay < 10)
		delay := 10	; エクスプローラーにはゆっくり出力する
	Else If (SubStr(title, 1, 18) = "P-touch Editor - [")	; brother P-touch Editor
		postDelay := 30	; 1文字目を必ずゆっくり出力する
	lastDelay := Floor(QPC() - lastSendTime)

	; 文字列を細切れにして出力
	noIME := False
	strSub := out := ""
	strSubLength := 0
	bracket := 0
	i := 1
	strLength := StrLen(str)
	While (i <= strLength)
	{
		c := SubStr(str, i, 1)
		If (c == "}" && bracket != 1)
			bracket := 0
		Else If (c == "{" || bracket)
			bracket++
		strSub .= c
		strSubLength++
		If (!(bracket || c == "+" || c == "^" || c == "!" || c == "#")
			|| i == strLength )
		{
			; "{Raw}"からの残りは全部出力する
			If (SubStr(strSub, strSubLength - 4, 5) = "{Raw}")
			{
				lastDelay := (imeName == "ATOK" && class == "Hidemaru32Class" && delay < 30 ? 30
					: (delay < 10 ? 10 : delay))
				While (++i <= strLength)
				{
					SendRaw, % SubStr(str, i, 1)
					If (i >= strLength)
						lastSendTime := QPC()	; 最後に出力した時間を記録
					; 出力直後のディレイ
					Sleep, % lastDelay
				}
				strSub := ""	; 後で誤作動しないように消去
			}

			; 出力するキーを変換
			Else If (SubStr(strSub, 1, 5) = "{vkF2" || strSub = "{vkF3}")
			{	; ひらがなキー、半角/全角キー
				out := strSub
				postDelay := (noIME || i < strLength ? 30 : 40)
			}
			Else If (strSub == "{確定}")
			{
				If (lastDelay < IME_Get_Interval)
				{
					Sleep, % IME_Get_Interval - lastDelay	; 前回の出力から一定時間経ってから IME_GET()
					lastDelay := IME_Get_Interval
				}
				If (IME_GET() && IME_GetSentenceMode())	; 変換モード(無変換)ではない
				{
					If (lastDelay >= (imeName == "Google" ? 30 : (imeName == "ATOK" ? 90 : 70)) && IME_GetConverting())
						; 文字出力から一定時間経っていて、IME窓あり
						out := "{Enter}"
					Else If (hwnd != goodHwnd || lastDelay < (imeName == "Google" ? 30 : (imeName == "ATOK" ? 90 : 70)))
						; IME窓の検出を当てにできない
						; あるいは文字出力から時間が経っていない(Google は Sleep, 30 が、ATOKは Sleep, 90 が、他は Sleep, 70 がいる)
					{
						Send, _
						Send, {Enter}
						Sleep, 40	; その他
						out := "{BS}"
					}
				}
			}
			Else If (strSub = "{NoIME}")	; IMEをオフにするが後で元に戻せるようにする
			{
				If (lastDelay < IME_Get_Interval)
				{
					Sleep, % IME_Get_Interval - lastDelay	; 前回の出力から一定時間経ってから IME_GET()
					lastDelay := IME_Get_Interval
				}
				If (IME_GET())
				{
					noIME := True
					imeConvMode := IME_GetConvMode()	; IME入力モードを保存する
					out := "{vkF3}"	; 半角/全角
					postDelay := 30
				}
			}
			Else If (strSub = "{IMEOFF}")
			{
				noIME := False
				preDelay := 50
				If (lastDelay < preDelay)
					Sleep, % preDelay - lastDelay
				IME_SET(0)			; IMEオフ
				lastDelay := IME_Get_Interval
			}
			Else If (strSub = "{IMEON}")
			{
				noIME := False
				IME_SET(1)			; IMEオン
				lastDelay := IME_Get_Interval
			}
			Else If (strSub == "{全英}")
			{
				If (imeName == "Google")
				{
					Send, {vkF2}		; ひらがなキー
					Sleep, 30
					out := "+{vk1D}"	; シフト+無変換
				}
				Else
				{
					noIME := False
					IME_SET(1)			; IMEオン
					IME_SetConvMode(24)	; IME 入力モード	全英数
					lastDelay := IME_Get_Interval
				}
			}
			Else If (strSub == "{半ｶﾅ}")
			{
				If (imeName == "Google")
					TrayTip, , Google 日本語入力では`n配列定義に {半ｶﾅ} は使えません
				Else
				{
					noIME := False
					IME_SET(1)			; IMEオン
					IME_SetConvMode(19)	; IME 入力モード	半ｶﾅ
					lastDelay := IME_Get_Interval
				}
			}
			Else If (SubStr(strSub, 1, 6) = "{Enter" && class == "Hidemaru32Class")	; 秀丸エディタ
			{
				out := strSub
				If (imeName == "ATOK")
				{
					preDelay := 80
					postDelay := 100
				}
				Else If (imeName == "Google")
				{
					preDelay := 30
					postDelay := 10
				}
				Else If (imeName != "NewMSIME")
				{
					preDelay := 60
					postDelay := 10
				}
			}
			Else If (strSub = "^v")
			{
				out := strSub
				preDelay := 10
				postDelay := 40
			}
			Else If (strSub = "{C_Clr}")
				clipboard =					;クリップボードを空にする
			Else If (SubStr(strSub, 1, 7) = "{C_Wait")
			{	; 例: {C_Wait 0.5} は 0.5秒クリップボードの更新を待つ
				Wait := SubStr(strSub, 9, strSubLength - 9)
				ClipWait, (Wait ? Wait : 0.2), 1
			}
			Else If (strSub = "{C_Bkup}")
				clipSaved := ClipboardAll	;クリップボードの全内容を保存
			Else If (strSub = "{C_Rstr}")
			{
				Clipboard := clipSaved		;クリップボードの内容を復元
				clipSaved =					;保存用変数に使ったメモリを開放
			}
			Else If (strSub != "{Null}" && strSub != "{UndoIME}")
			{
				out := strSub
				If (imeName != "OldMSIME" && imeName != "MSIME" && postDelay < 10
				 && (Asc(strSub) > 127 || SubStr(strSub, 1, 3) = "{U+"
				 || (SubStr(strSub, 1, 5) = "{ASC " && SubStr(strSub, 6, strSubLength - 6) > 127)))
					postDelay := 10	; ASCIIコードでないとき
			}

			; キー出力
			If (out)
			{
				; 前回の出力からの時間が短ければ、ディレイを入れる
				If (lastDelay < preDelay)
					Sleep, % preDelay - lastDelay
				Send, % out
				lastSendTime := QPC()	; 最後に出力した時間を記録
				; IME窓の検出が当てにできるか。変換1回目にはIME窓検出タイマーを起動
				If (hwnd != goodHwnd && hwnd != badHwnd)
				{
					If (flag && (out = "{vk20}" || out = "{Space down}"))
					{
						If (i >= strLength)
							SetTimer, JudgeHwnd, % (imeName == "Google" ? -30 : (imeName == "OldMSIME" ? -100 : -70))
						flag := False
					}
					Else If ((strSubLength == 1 && Asc(strSub) >= 33)
					|| (strSubLength == 3 && Asc(strSub) == 123))
						flag := True	; 文字が入力されたとき(ほぼローマ字の文字)
					Else
						flag := False
				}
				Else
					flag := False
				; 出力直後のディレイ
				lastDelay := (postDelay < delay ? delay : postDelay)
				If (lastDelay > -2)
					Sleep, % lastDelay
				If (lastDelay <= 0)
					lastDelay := 0
			}

			; 必要なら IME の状態を元に戻す
			If (noIME && (i >= strLength || strSub = "{UndoIME}"))
			{
				noIME := False
				preDelay := 30
				postDelay := (imeName == "ATOK" ? 60 : 30)
				; 前回の出力からの時間が短ければ、ディレイを入れる
				If (lastDelay < preDelay)
					Sleep, % preDelay - lastDelay
				Send, {vkF3}	; 半角/全角
				lastSendTime := QPC()	; 最後に出力した時間を記録
				Sleep, % (lastDelay := postDelay)
				; IME入力モードを回復する
				If (imeName == "ATOK")
					IME_SetConvMode(imeConvMode)
			}

			preDelay := postDelay := -2
			strSub := out := ""
			strSubLength := 0
		}
		i++
	}
	Return
}

SendBlind(str)
{
	global lastSendTime

	Send, % "{Blind}" . str
	lastSendTime := QPC()	; 最後に出力した時間を記録
}

; 押し下げを出力中のキーを上げ、別のに入れ替え
SendKeyUp(str:="")
{
	global restStr

	If (restStr != "")
	{
		If (SubStr(restStr, StrLen(restStr) - 9, 9) = "{ShiftUp}")
		{	; 押し下げを出力中のキーは {ShiftUp} あり
			SendBlind(SubStr(restStr, 1, StrLen(restStr) - 9))	; "{ShiftUp}" より左を出力
			; 入れ替えるキーに {ShiftUp} なし
			If (SubStr(str, StrLen(str) - 9, 9) != "{ShiftUp}")
				SendBlind("{ShiftUp}")
		}
		Else
			SendBlind(restStr)
	}
	restStr := str
	Return
}

; キーの上げ下げを分離
;	返り値: 下げるキー
;	restStr: 後で上げるキー
SplitKeyUpDown(str)
{
	global restStr	; まだ上げていないキー
	static keyDowns := Object("{Space}", "{Space down}"
;			, "{Home}", "{Home down}", "{End}", "{End down}", "{PgUp}", "{PgUp down}", "{PgDn}", "{PgDn down}"
			, "{Up}", "{Up down}", "{Left}", "{Left down}", "{Right}", "{Right down}", "{Down}", "{Down down}")
		, keyUps := Object("{Space}", "{Space up}"
;			, "{Home}", "{Home up}", "{End}", "{End up}", "{PgUp}", "{PgUp up}", "{PgDn}", "{PgDn up}"
			, "{Up}", "{Up up}", "{Left}", "{Left up}", "{Right}", "{Right up}", "{Down}", "{Down up}")
;	local ret, keyDown, keyUp

	If (Asc(str) == 43)	; "+" から始まる
	{
		ret := SubStr(str, 2)	; 先頭の "+" を消去
		keyDown := keyDowns[ret]
		If (keyDown == "")		; キーの上げ下げを分離しない時
		{
			SendKeyUp()			; 押し下げを出力中のキーを上げる
			Return str
		}
		keyUp := keyUps[ret] . "{ShiftUp}"
		If (restStr != keyUp)
		{
			SendKeyUp(keyUp)	; 押し下げを出力中のキーを入れ替え
			SendBlind("{ShiftDown}")
		}
	}
	Else
	{
		keyDown := keyDowns[str]
		If (keyDown == "")	; キーの上げ下げを分離しない時
		{
			SendKeyUp()			; 押し下げを出力中のキーを上げる
			Return str
		}
		keyUp := keyUps[str]
		If (restStr != keyUp)
			SendKeyUp(keyUp)	; 押し下げを出力中のキーを入れ替え
	}
	SendBlind(keyDown)
	Return ""
}

; 仮出力バッファの先頭から i 個出力する
; i の指定がないときは、全部出力する
OutBuf(i:=2)
{
	global _usc, outStrs, outCtrlNos, R, lastSendTime
;	local out, ctrlNo

	While (i > 0 && _usc > 0)
	{
		out := outStrs[1]
		ctrlNo := outCtrlNos[1]
		If (!ctrlNo || ctrlNo == R)
		{
			If (ctrlNo == R)	; リピート可能
				out := SplitKeyUpDown(out)	; キーの上げ下げを分離
			Else
				SendKeyUp()		; 押し下げを出力中のキーを上げる

			SendEachChar(out)
		}
		Else
		{
			SendKeyUp()				; 押し下げを出力中のキーを上げる
			SendSP(out, ctrlNo)		; 特別出力(かな定義ファイルで操作)
			lastSendTime := QPC()	; 最後に出力した時間を記録
		}

		outStrs[1] := outStrs[2]
		outCtrlNos[1] := outCtrlNos[2]
		_usc--
		i--
	}
	DispStr()	; 表示待ち文字列表示
	Return
}

; 仮出力バッファを最後から nBack 回分を削除して、Str1 と outCtrlNos を保存
StoreBuf(nBack, str, ctrlNo:=0)
{
	global _usc, outStrs, outCtrlNos

	If (nBack > 0)
	{
		_usc -= nBack
		If (_usc < 0)
			_usc := 0	; バッファが空になる以上は削除しない
	}
	Else If (_usc == 2)	; バッファがいっぱいなので、1文字出力
		OutBuf(1)
	_usc++
	outStrs[_usc] := str
	outCtrlNos[_usc] := ctrlNo
	DispStr()	; 表示待ち文字列表示
	Return
}

; 縦書き・横書き切り替え
ChangeVertical(number)
{
	global iniFilePath, vertical

	static icon_H_Path := Path_AddBackslash(A_ScriptDir) . "Icons\"
					. Path_RemoveExtension(A_ScriptName) . "_H.ico"
		, icon_V_Path := Path_AddBackslash(A_ScriptDir) . "Icons\"
					. Path_RemoveExtension(A_ScriptName) . "_V.ico"

	; 設定ファイル書き込み
	If (vertical != number)
	{
		vertical := number
		IniWrite, %vertical%, %iniFilePath%, Naginata, vertical
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
SelectStr(i)
{
	global vertical, defsTateStr, defsYokoStr

	Return (vertical ? defsTateStr[i] : defsYokoStr[i])
}

; timeA からの時間を表示[ミリ秒単位]
DispTime(timeA, str:="")
{
	global testMode
;	local timeAtoB

	If (testMode == 1)
	{
		timeAtoB := Round(QPC() - timeA, 1)
		ToolTip, %timeAtoB% ms%str%
		SetTimer, RemoveToolTip, 1000
	}
}

; 表示待ち文字列表示
DispStr()
{
	global testMode, _usc, outStrs
;	local std

	If (testMode == 2)
	{
		If (!_usc)
			ToolTip
		Else
		{
			If (_usc == 1)
				str := outStrs[1]
			Else
				str := outStrs[1] . "`n" . outStrs[2]
			ToolTip, %str%
		}
	}
}

; 変換、出力
Convert()
{
	global inBufsKey, inBufReadPos, inBufsTime, inBufRest
		, KC_SPC, JP_YEN, KC_INT1, R
		, defsKey, defsGroup, defsKanaMode, defsCombinableBit, defsCtrlNo, defBegin, defEnd
		, _usc, lastSendTime, IME_Get_Interval
		, sideShift, shiftDelay, combDelay, spaceKeyRepeat
		, combLimitN, combStyleN, combKeyUpN, combLimitS, combStyleS, combKeyUpS, combLimitE, combKeyUpSPC
		, keyUpToOutputAll, eisuSandS
	static convRest	:= 0	; 入力バッファに積んだ数/多重起動防止フラグ
		, nextKey	:= ""	; 次回送りのキー入力
		, realBit	:= 0	; 今押している全部のキービットの集合
		, lastBit	:= 0	; 前回のキービット
		, last2Bit	:= 0	; 前々回のキービット
		, reuseBit	:= 0	; 復活したキービット
		, lastKeyTime := 0	; 有効なキーを押した時間
		, timeLimit := 0.0	; タイマーを止めたい時間
		, kanaMode	:= 0	; 0: 英数入力, 1: かな入力
		, toBuf		:= ""	; 出力バッファに送る文字列
		, lastToBuf	:= ""	; 前回、出力バッファに送った文字列(リピート、後置シフト用)
		, _lks		:= 0	; 前回、何キー同時押しだったか？
		, lastGroup	:= 0	; 前回、何グループだったか？ 0はグループなし
		, repeatBit	:= 0	; リピート中のキーのビット
		, ctrlNo	:= 0	; 0: リピートなし, R: リピートあり, それ以外: かな配列ごとの特殊コード
		; シフト用キーの状態 0: 押していない, 1: 単独押し, 2: シフト継続中, 3: リピート中
		, spc		:= 0	; スペースキー
		, sft		:= 0	; 左シフト
		, rsft		:= 0	; 右シフト
		, ent		:= 0	; エンター
		, combinableBit := -1 ; 押すと同時押しになるキー (-1 は次の入力で即確定しないことを意味する)
;	local keyTime	; キーを押した時間
;		, forceEisuMode
;		, imeState, imeConvMode
;		, nowKey, len
;		, term		; 入力の末端2文字
;		, nkeys		; 今回は何キー同時押しか
;		, nowBit	; 今回のキービット
;		, bitMask
;		, nBack
;		, searchBit	; いま検索しようとしているキーの集合
;		, shiftStyle
;		, i, imax	; カウンタ用
;		, defKeyCopy
;		, outOfCombDelay	; 同時押しの判定期限が来たか
;		, enableComb
;		, interval

	SetTimer, KeyTimer, Off		; 判定期限タイマー停止
	If (convRest || nextKey != "")
		Return	; 多重起動防止で戻る

	; 入力バッファが空になるまで
	While (convRest := 31 - inBufRest || nextKey != "")
	{
		If (nextKey == "")
		{
			; 入力バッファから読み出し
			; 参考: 鶴見惠一；6809マイコン・システム 設計手法，CQ出版社 p.114-121
			nowKey := inBufsKey[inBufReadPos], keyTime := inBufsTime[inBufReadPos]
				, inBufReadPos := ++inBufReadPos & 31, inBufRest++

			If (nowKey == "KeyTimer")
			{
				If (inBufRest != 31)		; タイマー割り込み後にキー変化がないこと
					Continue
				If (keyTime > timeLimit)	; 判定期限到来
				{
					OutBuf()
					DispTime(lastKeyTime, "`n判定期限")	; キー変化からの経過時間を表示
				}
				Else
					SetTimer, KeyTimer, -10	; 10ミリ秒後に再判定
				Continue
			}
		}
		Else
		{	; 前回の残りを読み出し
			nowKey := nextKey
			nextKey := ""
		}

		; IME の状態を更新
		forceEisuMode := True	; 強制英数モードを意味する仮の値
		imeConvMode := IME_GetConvMode()
		IfWinExist, ahk_class #32768	; コンテキストメニューが出ている時
			kanaMode := 0
		Else If ((Asc(nowKey) == 43 || sft || rsft) && sideShift <= 1)	; 左右シフト英数２
			kanaMode := 0
		Else If (lastSendTime + IME_Get_Interval <= QPC())
		{	; IME状態を確実に検出できる時
			forceEisuMode := False	; 強制英数モードではない
			imeState := IME_GET()
			If (imeState == 0)
				kanaMode := 0
			Else If (imeState == 1 && imeConvMode != "")	; かな入力中
				kanaMode := imeConvMode & 1
		}

		; 先頭の "+" を消去
		If (Asc(nowKey) == 43)
			nowKey := SubStr(nowKey, 2)
		; 左右シフト処理
		If (nowKey == "LShift")
		{
			sft := 1
			OutBuf()
			SendBlind("{ShiftDown}")
			nowKey := "sc39"	; センターシフト押す
		}
		Else If (nowKey == "RShift")
		{
			rsft := 1
			OutBuf()
			SendBlind("{ShiftDown}")
			nowKey := "sc39"	; センターシフト押す
		}
		Else If (nowKey == "LShift up")
		{
			sft := 0
			If (!rsft)	; 右シフトも離されている
				SendBlind("{ShiftUp}")
			If (rsft || spc || ent)	; 他のシフトを押している時
			{
				DispTime(keyTime)	; キー変化からの経過時間を表示
				Continue
			}
			Else
				nowKey := "sc39 up"	; センターシフト上げ
		}
		Else If (nowKey == "RShift up")
		{
			rsft := 0
			If (!sft)	; 左シフトも離されている
				SendBlind("{ShiftUp}")
			If (sft || spc || ent)	; 他のシフトを押している時
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
			If ((!imeConvMode && DetectIME() != "NewMSIME")	; Firefox と Thunderbird のスクロール対応(新MS-IMEは除外)
				|| (!eisuSandS && !kanaMode))	; SandSなしの設定で英数入力時
			{
				StoreBuf(0, "{Space}", R)
				OutBuf()
				DispTime(keyTime)	; キー変化からの経過時間を表示
				Continue
			}
			Else If (ent)	; 他のシフトを押している時
			{
				StoreBuf(0, "+{Space}", R)
				OutBuf()
				If (ent == 1)
					ent := 2	; 単独エンターではない
				DispTime(keyTime, "`nエンター+スペース")	; キー変化からの経過時間を表示
			}
			Else If (spaceKeyRepeat && (spc & 1))	; スペースキーの長押し
			{
				If (spaceKeyRepeat == 1)	; スペースキーの長押し	1: 空白キャンセル
					spc := 2	; シフト継続中
				Else
				{
					spc := 3	; 空白をリピート中
					StoreBuf(0, "{Space}", R)
					OutBuf()
				}
				If (ent == 1)
					ent := 2	; 単独エンターではない
				DispTime(keyTime, "`nスペース長押し")	; キー変化からの経過時間を表示
				Continue
			}
			Else If (!spc)
				spc := 1	; 単独押し
		}
		Else If (nowKey == "sc39 up")
		{
			SendKeyUp()			; 押し下げを出力中のキーを上げる
			If (sft || rsft || ent)	; 他のシフトを押している時
			{
				If (spc == 1)
					nowKey := "vk20"	; スペース単独押しのみ
				Else
				{
					spc := 0
					DispTime(keyTime)	; キー変化からの経過時間を表示
					Continue
				}
			}
			Else If (spc == 1)
				nextKey := "vk20"	; スペース単独押し→センターシフト上げ
			spc := 0
		}
		; エンターキー処理
		Else If (nowKey == "Enter")
;		Else If (nowKey == "Enter" && (eisuSandS || kanaMode))	; 英数入力のSandSなし設定でエンターシフトも止めたい時
		{
			If !(sft || rsft || spc)	; シフトキーを押していない時
			{
				nowKey := "sc39"	; センターシフト押す
				ent := 1
			}
		}
		Else If (nowKey == "Enter up")
		{
			nowKey := "sc39 up"	; センターシフト上げ
			SendKeyUp()			; 押し下げを出力中のキーを上げる
			If (sft || rsft || spc)		; 他のシフトを押している時
			{
				If (ent == 1)
					nowKey := "vk0D"	; エンター単独押しのみ
				Else
				{
					ent := 0
					DispTime(keyTime)	; キー変化からの経過時間を表示
					Continue
				}
			}
			Else If (ent == 1)
				nextKey := "vk0D"	; エンター単独押し→センターシフト上げ ※"Enter"としないこと
			ent := 0
		}
		; スペースのリピートを止める
		Else If (spc == 3)
		{
			If (kanaMode)
			{
				nextKey := nowKey
				nowKey := "vk1B"	; Shiftが付け加えられて Shift+Esc(変換取消)→シフト側文字
			}
			spc := 2	; シフト継続中
		}

		nkeys := 0	; 何キー同時押しか、を入れる変数
		len := StrLen(nowKey)
		term := SubStr(nowKey, len - 1)	; term に入力末尾の2文字を入れる
		; キーが離れた時
		If (term == "up")
		{
			If (SubStr(nowKey, 1, 2) == "sc")
				nowBit := "0x" . SubStr(nowKey, len - 4, 2)
			Else
				nowBit := 0
		}
		Else
		{
			; sc** で入力
			If (SubStr(nowKey, 1, 2) == "sc")
			{
				nowBit := "0x" . term
				toBuf := "{sc" . term . "}"
			}	; ここで nowBit に sc○○ から 0x○○ に変換されたものが入っているが、
				; Autohotkey は十六進数の数値としてそのまま扱える
			; sc** 以外で入力
			Else
			{
				nowBit := searchBit := 0
				toBuf := "{" . nowKey . "}"
				nkeys := -1	; かな定義の検索は不要
			}
			; スペースキーが押されていたら、シフトを加えておく(SandSの実装)
			If (realBit & KC_SPC)
				toBuf := "+" . toBuf
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

			If (keyUpToOutputAll || (lastBit & nowBit))
			{	; 「キーを離せば常に全部出力する」がオン、または直近の検索結果のキーを離した
				OutBuf()
				SendKeyUp()	; 押し下げを出力中のキーを上げる
				lastToBuf := ""
				_lks := 0
				If (shiftStyle == 2)	; 全解除
					lastGroup := last2Bit := lastBit := 0
				Else If (lastBit & nowBit)
					lastGroup := 0
			}
			Else If (_usc == 2 && _lks == 1 && nowBit == last2Bit)
			{	; 同時押しにならなくなった
				OutBuf(1)	; 1個出力
				combinableBit |= nowBit ; 次の入力で即確定しないキーに追加
			}
			Else If (!nowBit)
				SendKeyUp()	; 押し下げを出力中のキーを上げる
			repeatBit &= bitMask
			reuseBit := (shiftStyle ? 0 : realBit)	; 文字キーシフト全復活
			last2Bit &= bitMask
			lastBit &= bitMask
			DispTime(keyTime)	; キー変化からの経過時間を表示
		}
		; (キーリリース直後か、通常シフトまたは後置シフトの判定期限後に)スペースキーが押された時
		Else If (nowBit == KC_SPC && !(realBit & nowBit)
			&& (!_usc || lastKeyTime + shiftDelay < keyTime))
		{
			OutBuf()
			SendKeyUp()			; 押し下げを出力中のキーを上げる
			realBit |= KC_SPC
			repeatBit := 0		; リピート解除
			DispTime(keyTime)	; キー変化からの経過時間を表示
		}
		; リピート中のキー
		Else If (repeatBit && nowBit == repeatBit && lastToBuf != "")
		{	; 前回の文字列を出力
			If (!_usc)
				StoreBuf(0, lastToBuf, ctrlNo)
			OutBuf()
			DispTime(keyTime, "`nリピート")	; キー変化からの経過時間を表示
		}
		; 押されていなかったキー、sc**以外のキー
		Else If (!(realBit & nowBit) || repeatBit)
		{
			realBit |= nowBit
			; 文字キーによるシフトの適用範囲
			If (combLimitE && !kanaMode)
				shiftStyle := 3	; 英数入力時に判定期限ありなら、文字キーシフトは1回のみ
			Else
				shiftStyle := ((realBit & KC_SPC) ? combStyleS : combStyleN)
;			lastGroup := (shiftStyle == 0 ? 0 : lastGroup)	; かわせみ2用と同じ動作にするなら有効に

			; 同時押しの判定期限到来
			enableComb := True
			If (nowBit != KC_SPC && combDelay > 0 && lastKeyTime + combDelay < keyTime
			 && ((combLimitN && !(realBit & KC_SPC)) || (combLimitS && (realBit & KC_SPC)) || (combLimitE && !kanaMode)))
			{
				outOfCombDelay := True
				If ((shiftStyle == 2 && !lastGroup) || shiftStyle == 3)
					enableComb := False	; 同時押しを一時停止
			}
			Else
				outOfCombDelay := False
			; 前のキーとは同時押しにならないので出力確定
			If !(combinableBit & nowBit)
			{
				OutBuf()
				If (nowBit && !forceEisuMode)
				{	; IMEの状態を再検出
					delay := IME_Get_Interval - Floor(QPC() - lastSendTime)
					If (delay > 0)	; 時間を空けてIME検出へ
						Sleep, %delay%
					imeState := IME_GET()
					If (imeState == 0)
						kanaMode := 0
					Else If (imeState == 1 && imeConvMode != "")	; かな入力中
						kanaMode := imeConvMode & 1
				}
			}
			; 前のキーが出力確定してなかったら同グループ優先で検索しない
			Else If (!outOfCombDelay && _usc)
				lastGroup := 0
			nBack := 0
			While (!nkeys)
			{
				; 3キー入力を検索
				If ((last2Bit | reuseBit) && enableComb)
				{
					; 検索場所の設定
					i := defBegin[3]
					imax := defEnd[3]
					; シフトの適用範囲に応じた検索キーを設定
					searchBit := (!shiftStyle ? realBit : (realBit & KC_SPC) | nowBit | lastBit | last2Bit | reuseBit)
					While (i < imax)
					{
						defKeyCopy := defsKey[i]
						If ((defKeyCopy & nowBit) ; 今回のキーを含み
							&& (defKeyCopy & searchBit) == defKeyCopy ; 検索中のキー集合が、いま調べている定義内にあり
							&& (defKeyCopy & KC_SPC) == (searchBit & KC_SPC) ; シフトの相違はなく
							&& defsKanaMode[i] == kanaMode)	; 英数用、かな用の種別が一致していること
						{
							If (shiftStyle == 3 && _lks >= 3 && nowBit != KC_SPC)
							{
								; 文字キーシフト「1回のみ」で再びなので、1キー入力の検索へ
								enableComb := False
								Break
							}
							Else If ((!lastGroup && _lks < 3 && !outOfCombDelay) || lastGroup == defsGroup[i])
							{
								; 見つかった!
								; 前回が2キー、3キー同時押しだったら仮出力バッファの1文字消す
								; 前回が1キー入力だったら仮出力バッファの2文字消す
								nBack := (_lks >= 2 ? 1 : 2)
								nkeys := 3
								Break
							}
						}
						i++
					}
				}
				; 2キー入力を検索
				If (!nkeys && (lastBit | reuseBit) && enableComb)
				{
					; 検索場所の設定
					i := defBegin[2]
					imax := defEnd[2]
					; シフトの適用範囲に応じた検索キーを設定
					searchBit := (!shiftStyle ? realBit : (realBit & KC_SPC) | nowBit | lastBit | reuseBit)
					While (i < imax)
					{
						defKeyCopy := defsKey[i]
						If ((defKeyCopy & nowBit) ; 今回のキーを含み
							&& (defKeyCopy & searchBit) == defKeyCopy ; 検索中のキー集合が、いま調べている定義内にあり
							&& (defKeyCopy & KC_SPC) == (searchBit & KC_SPC) ; シフトの相違はなく
							&& defsKanaMode[i] == kanaMode)	; 英数用、かな用の種別が一致していること
						{
							If (shiftStyle == 3 && _lks >= 2 && nowBit != KC_SPC)
							{
								; 文字キーシフト「1回のみ」で再びなので、1キー入力の検索へ
								enableComb := False
								Break
							}
							Else If ((!lastGroup && _lks < 2 && !outOfCombDelay) || lastGroup == defsGroup[i])
							{
								; 見つかった!
								If (_usc == 2)
									; 2つ前に押したキーを出力
									OutBuf(1)
								nBack := (_lks >= 2 && nowBit != KC_SPC ? 0 : 1)
								nkeys := 2
								Break
							}
						}
						i++
					}
				}
				; 1キー入力を検索
				If (!nkeys)
				{
					; 検索場所の設定
					i := defBegin[1]
					imax := defEnd[1]
					; 検索キーを設定
					searchBit := nowBit | (nowBit == KC_SPC ? lastBit : realBit & KC_SPC)
					While (i < imax)
					{
						If (searchBit == defsKey[i] && kanaMode == defsKanaMode[i])
						{
							If (!lastGroup || lastGroup == defsGroup[i])
							{
								; 見つかった!
								If (nowBit == KC_SPC)
									nBack := 1
								nkeys := 1
								Break
							}
						}
						i++
					}
				}
				; 検索終了判定
				If (!lastGroup || nkeys)
					Break
				; グループなしで再度検索
				lastGroup := 0
				If (shiftStyle == 2)
					; (同グループのみ継続)同グループが見つからなかった
					enableComb := False
			}
			If (!enableComb)	; 同時押しを一時停止中
				reuseBit := last2Bit := lastBit := 0

			; スペースを押したが、定義がなかった時
			If (nowBit == KC_SPC && !nkeys)
			{
				If (!_usc)
				{
					; 仮出力バッファが空の時
					repeatBit := 0		; リピート解除
					DispTime(keyTime)	; キー変化からの経過時間を表示
					Continue
				}
				Else
				{
					; 後置シフト
					toBuf := "+" . lastToBuf
					nBack := 1
				}
			}
			If (spc == 1)
				spc := 2	; 単独スペースではない
			If (ent == 1)
				ent := 2	; 単独エンターではない
			; 仮出力する文字列を選ぶ
			If (nkeys > 0)
			{
				; 定義が見つかった時
				toBuf := SelectStr(i)
				ctrlNo := defsCtrlNo[i]
			}
			Else
				ctrlNo := R
			; 一緒に押すと同時押しになるキーを探す
			If (nkeys > 0 && !lastGroup)
				combinableBit := defsCombinableBit[i]
			Else If (nkeys >= 0)
				combinableBit := FindCombinableBit(searchBit, kanaMode, nkeys, lastGroup)
			Else	; nkeys < 0
				combinableBit := 0
			; 仮出力バッファに入れる
			StoreBuf(nBack, toBuf, ctrlNo)

			; 次回の検索用に変数を更新
			lastToBuf := toBuf		; 今回の文字列を保存
			lastKeyTime := keyTime	; 有効なキーを押した時間を保存
			_lks := nkeys			; 何キー同時押しだったかを保存
			reuseBit := 0			; 復活したキービットを消去
			; キービットを保存
			If (nkeys >= 2)
				; 2、3キー入力のときは今回のを保存
				last2Bit := lastBit := defsKey[i]
			Else If (nBack)
				; 1キー入力で今はスペースキーを押した
				lastBit := searchBit
			Else
			{
				; 繰り上げ
				last2Bit := lastBit
				lastBit := searchBit
			}
			; 何グループだったか保存
			lastGroup := (nkeys > 0 ? defsGroup[i] : 0)
			; キーリピート用
			If (ctrlNo == R)
				repeatBit := nowBit	; キーリピートする
			Else
				repeatBit := 0

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
				SendKeyUp()	; 押し下げを出力したままのキーを上げる
				If (inBufRest == 31 && nextKey == "")
				{
					; 入力バッファが空なので、同時押し、後置シフトの判定タイマー起動処理
					timeLimit := 0.0
					; 同時押しの判定
					If (combDelay > 0
					 && ((combLimitN && !(realBit & KC_SPC)) || (combLimitS && (realBit & KC_SPC)) || (combLimitE && !kanaMode)))
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

	Return
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
+Home::
+End::
+PgUp::
+PgDn::
; エンター同時押しをシフトとして扱う場合
#If (EnterShift)
Enter::
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
	Return

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
Home up::
End up::
PgUp up::
PgDn up::
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
+Home up::
+End up::
+PgUp up::
+PgDn up::
; エンター同時押しをシフトとして扱う場合
#If (EnterShift)
Enter up::
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

; 左右シフト
LShift::
RShift::
+LShift::
+RShift::
LShift up::
RShift up::
+LShift up::
+RShift up::
	Suspend, Permit	; Suspendの対象でないことを示す
	; 参考: 鶴見惠一；6809マイコン・システム 設計手法，CQ出版社 p.114-121
	inBufsKey[inBufWritePos] := A_ThisHotkey, inBufsTime[inBufWritePos] := QPC()
		, inBufWritePos := (inBufRest ? ++inBufWritePos & 31 : inBufWritePos)
		, (inBufRest ? inBufRest-- : )
	Convert()	; 変換ルーチン
	Return

#MaxThreadsPerHotkey 1	; 元に戻す
