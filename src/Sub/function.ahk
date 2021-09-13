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

PSTimer:	; 後置シフトの判定期限タイマー
	; 入力バッファが空の時、保存
	InBufsKey[InBufWritePos] := "PSTimer", InBufsTime[InBufWritePos] := QPC()
		, InBufWritePos := (InBufRest == 15 ? ++InBufWritePos & 15 : InBufWritePos)
		, (InBufRest == 15 ? InBufRest-- : )
	Convert()	; 変換ルーチン
	return

CombTimer:	; 同時押しの判定期限タイマー
	; 入力バッファが空の時、保存
	InBufsKey[InBufWritePos] := "CombTimer", InBufsTime[InBufWritePos] := QPC()
		, InBufWritePos := (InBufRest == 15 ? ++InBufWritePos & 15 : InBufWritePos)
		, (InBufRest == 15 ? InBufRest-- : )
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
	Return Count / Freq
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
	StringReplace, Str1, Str1, {改行,		{Enter,		A
	StringReplace, Str1, Str1, {後退,		{BS,		A
	StringReplace, Str1, Str1, {取消,		{Esc,		A
	StringReplace, Str1, Str1, {削除,		{Del,		A
	StringReplace, Str1, Str1, {全角,		{vkF3,		A
	StringReplace, Str1, Str1, {タブ,		{Tab,		A
	StringReplace, Str1, Str1, {空白		{Space,		A
	StringReplace, Str1, Str1, {メニュー,	{AppsKey,	A

	StringReplace, Str1, Str1, {Caps Lock,	{vkF0,		A
	StringReplace, Str1, Str1, {Back Space,	{BS,		A

	StringReplace, Str1, Str1, {固有},		{直接},		A

	return Str1
}

; ASCIIコードでない文字が入っていたら、先頭に"{記号}"を書き足す
; 先頭が"{記号}"または"{直接}"だったらそのまま
Analysis(Str1)
{
;	local StrBegin
;		, i			; カウンタ
;		, len, len2, StrChopped, c, bracket

	if (Str1 == "{記号}" || Str1 == "{直接}")
		return ""	; 有効な文字列がないので空白を返す

	StrBegin := SubStr(Str1, 1, 4)
	if (StrBegin == "{記号}" || StrBegin == "{直接}")
		return Str1	; そのまま返す

	; 1文字ずつ分析する
	len := StrLen(Str1)
	StrChopped := ""
	len2 := 0
	bracket := 0
	i := 1
	while (i <= len)
	{
		c := SubStr(Str1, i, 1)
		if (c == "}" && bracket != 1)
			bracket := 0
		else if (c == "{" || bracket > 0)
			bracket++
		StrChopped .= c
		len2++
		if (i == len || !(bracket > 0 || c == "+" || c == "^" || c == "!" || c == "#"))
		{
			; ASCIIコードでない
			if (Asc(StrChopped) > 127
			 || SubStr(StrChopped, 1, 3) = "{U+"
			 || (SubStr(StrChopped, 1, 5) = "{ASC " && SubStr(StrChopped, 6, len2 - 6) > 127))
				return "{記号}" . Str1	; 先頭に"記号"を書き足して終了
			StrChopped := ""
			len2 := 0
		}
		i++
	}

	; すべて ASCIIコードだった
	return Str1	; そのまま返す
}

; 定義登録
SetDefinition(KanaMode, KeyComb, Str1, Repeat:=0)
{
	global DefsKey, DefsGroup, DefsKanaMode, DefsTateStr, DefsYokoStr, DefsCtrlNo
		, DefBegin, DefEnd
		, KanaGroup
;	local nkeys		; 何キー同時押しか
;		, i, imax	; カウンタ用

	; 機能置き換え処理
	Str1 := ControlReplace(Str1)
	; ASCIIコードでない文字が入っていたら、先頭に"{記号}"を書き足す
	Str1 := Analysis(Str1)

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
	if (Str1 != "")		; 定義あり
	{
		i := DefEnd[nkeys]
		DefsKey.InsertAt(i, KeyComb)
		DefsGroup.InsertAt(i, KanaGroup)
		DefsKanaMode.InsertAt(i, KanaMode)
		DefsTateStr.InsertAt(i, Str1)
		DefsYokoStr.InsertAt(i, ConvTateYoko(Str1))	; 縦横変換
		DefsCtrlNo.InsertAt(i, Repeat)

		DefEnd[1]++
		if (nkeys > 1)
			DefBegin[1]++, DefEnd[2]++
		if (nkeys > 2)
			DefBegin[2]++, DefEnd[3]++
	}

	return
}

; かな定義登録
SetKana(KeyComb, Str1, Repeat:=0)
{
	SetDefinition(1, KeyComb, Str1, Repeat)
	return
}
; 英数定義登録
SetEisu(KeyComb, Str1, Repeat:=0)
{
	SetDefinition(0, KeyComb, Str1, Repeat)
	return
}

; 出力確定するか検索
FindComplete(SearchBit, KanaMode, nkeys)
{
	global DefsKey, DefsKanaMode, DefBegin, DefEnd
		, KC_SPC
;	local j, jmax	; カウンタ用
;		, Complete
;		, DefKeyCopy

	Complete := (nkeys > 1 || (SearchBit & KC_SPC) ? 2 : 1)	; 初期値
	j := DefBegin[3]
	jmax := (nkeys >= 1 ? DefEnd[nkeys] : DefEnd[1])
	while (j < jmax)
	{
		; SearchBit は DefsKey[j] に内包されているか
		DefKeyCopy := DefsKey[j]
		if (SearchBit != DefKeyCopy && KanaMode == DefsKanaMode[j] && (DefKeyCopy & SearchBit) == SearchBit)
		{
			if ((DefKeyCopy & KC_SPC) == (SearchBit & KC_SPC))	; シフトも一致
				return 0		; 出力確定はしない
			else
				Complete := 1	; 後置シフトは出力確定しない
		}
		j++
	}
	return Complete
}

; 出力確定するかな定義を調べて DefsComplete[] に記録
; 0: 確定しない, 1: 通常シフトのみ確定, 2: 後置シフトでも確定
SettingLayout()
{
	global DefsKey, DefsKanaMode, DefsComplete, DefBegin, DefEnd
;	local i, imax	; カウンタ用
;		, SearchBit

	; 出力確定するか検索
	i := DefBegin[3]
	imax := DefEnd[1]
	while (i < imax)
	{
		SearchBit := DefsKey[i]
		DefsComplete[i] := FindComplete(SearchBit, DefsKanaMode[i], CountBit(SearchBit))
		i++
	}
	return
}

; 文字列 Str1 を適宜ディレイを入れながら出力する
SendEachChar(Str1, Delay:=0)
{
	global IMESelect
	static LastTickCount := QPC()
;	local len						; Str1 の長さ
;		, StrChopped, LenChopped	; 細切れにした文字列と、その長さを入れる変数
;		, i, c, bracket
;		, IMECheck, IMEConvMode		; IME入力モードの保存、復元に関するフラグと変数
;		, PreDelay, PostDelay		; 出力前後のディレイの値
;		, LastDelay					; 前回出力時のディレイの値
;		, Slow

	Slow := IMESelect
	IfWinActive, ahk_class CabinetWClass	; エクスプローラーにはゆっくり出力する
		Delay := (Delay < 10 ? 10 : Delay)
	else IfWinActive, ahk_class Hidemaru32Class	; 秀丸エディタ
		Slow := (Slow == 1 ? 0x11 : Slow)
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
			|| i == len )
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
					if (PostDelay > 0)
						Sleep, PostDelay
				}
				break
			}
			; 出力するキーを変換
			else if (StrChopped == "{確定}")
				StrChopped := "{Enter}"
			else if (StrChopped = "{IMEOff}")
			{
				; IME入力モードを保存する
				if (IME_GET() == 1)
				{
					IMECheck := 1			; 後で IME入力モードを回復する
					IMEConvMode := IME_GetConvMode()
					StrChopped := "{vkF3}"	; 半角/全角
					PostDelay := 30
				}
				else	; かな入力モードでない時
					StrChopped := "{Null}"
			}
			; ATOK+秀丸エディタで、エンターを途中に含む文字列はゆっくり出力する
			else if (SubStr(Str1, 1, 6) != "{Enter"
				&& Slow == 0x11 && SubStr(StrChopped, 1, 6) = "{Enter")
			{
				PreDelay := 80
				PostDelay := 100	; 秀丸エディタ + ATOK 用
			}

			; 前回の出力からの時間が短ければ、ディレイを入れる
			if (LastDelay < PreDelay)
				Sleep, % PreDelay - LastDelay
			; キー出力
			if (StrChopped != "{Null}")
			{
				Send, % StrChopped
				; 出力直後のディレイ
				if (PostDelay > 0)
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
	if (IMECheck == 1)
	{
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
		; 前回の出力からの時間が短ければ、ディレイを入れる
		if (LastDelay < PreDelay)
			Sleep, % PreDelay - LastDelay
		; キー出力
		Send, {vkF3}	; 半角/全角
		; 出力直後のディレイ
		if (PostDelay > 0)
			Sleep, PostDelay
		; IME入力モードを回復する
		if (IMEConvMode > 0)
		{
			IME_SetConvMode(IMEConvMode)
			Sleep, Delay
		}
	}

	LastTickCount := QPC()	; 最後に出力した時間を記録
	return
}

; 新MS-IME がオンになっていれば 1 を返す
; 10秒経過していれば再調査する
DetectNewMSIME()
{
	static NewMSIME := 0
		, LastSearchTime := 0.0
;	local NowTime

	NowTime := QPC()
	if (LastSearchTime + 10000.0 < NowTime)
	{
		; 「以前のバージョンの Microsoft IME を使う」がオンになっているか調べる
		; 参考: https://registry.tomoroh.net/archives/11547
		RegRead, NewMSIME, HKEY_CURRENT_USER
			, SOFTWARE\Microsoft\Input\TSF\Tsf3Override\{03b5835f-f03c-411b-9ce2-aa23e1171e36}
			, NoTsf3Override2
		NewMSIME := (ErrorLevel == 1 ? 0 : NewMSIME ^ 1)
		LastSearchTime := NowTime
	}
	return NewMSIME
}

; 仮出力バッファの先頭から i 個出力する
; i の指定がないときは、全部出力する
OutBuf(i:=2)
{
	global _usc, OutStrs, OutCtrlNos, IMESelect, R
;	local Str1, StrBegin

	while (i > 0 && _usc > 0)
	{
		if (OutCtrlNos[1] > R)
			SendSP(OutStrs[1], OutCtrlNos[1])	; 特別出力(かな定義ファイルで操作)
		else
		{
			Str1 := OutStrs[1]
			StrBegin := SubStr(Str1, 1, 4)
			if (StrBegin == "{記号}" || StrBegin == "{直接}")
			{
				StringTrimLeft, Str1, Str1, 4
				if (StrBegin == "{直接}")
					Str1 := "{Raw}" . Str1
				if (IME_GET() == 1)		; IME ON の時
				{
					if (IME_GetSentenceMode() == 0)
						Str1 := "{IMEOff}" . Str1
					else
						Str1 := ":{確定}{BS}{IMEOff}" . Str1
				}
				if (IMESelect > 0 || DetectNewMSIME() || !InStr(Str1, "{Enter"))
					; ATOK か 新MS-IME を使用、または改行が含まれないとき
					SendEachChar(Str1, 10)	; 1文字ごとに 10ms のスリープ
				else
					SendEachChar(Str1, 30)	; ゆっくりと出力
			}
			else
				SendEachChar(Str1)
		}

		OutStrs[1] := OutStrs[2]
		OutCtrlNos[1] := OutCtrlNos[2]
		_usc--
		i--
	}
	return
}

; 仮出力バッファを最後から nBack 回分を削除して、Str1 と OutCtrlNos を保存
StoreBuf(nBack, Str1, CtrlNo:=0)
{
	global _usc, OutStrs, OutCtrlNos

	if (nBack > 0)
	{
		_usc -= nBack
		if (_usc <= 0)
			_usc := 0	; バッファが空になる以上は削除しない
		else
			OutBuf(1)	; nBack の分だけ戻って、残ったバッファは出力する
	}
	else if (_usc == 2)	; バッファがいっぱいなので、1文字出力
		OutBuf(1)
	_usc++
	OutStrs[_usc] := Str1
	OutCtrlNos[_usc] := CtrlNo

	return
}

; 出力する文字列を選択
SelectStr(i)
{
	global Vertical, DefsTateStr, DefsYokoStr

	return (Vertical ? DefsTateStr[i] : DefsYokoStr[i])
}

; TimeA からの時間を表示[ミリ秒単位]
DispTime(TimeA)
{
	global INIDispTime
;	local TimeAtoB

	if (INIDispTime)
	{
		TimeAtoB := Round(QPC() - TimeA, 1)
		ToolTip, %TimeAtoB% ms
		SetTimer, RemoveToolTip, 1000
	}
}

; 変換、出力
Convert()
{
	global InBufsKey, InBufReadPos, InBufsTime, InBufRest
		, KC_SPC, JP_YEN, KC_INT1, R
		, DefsKey, DefsGroup, DefsKanaMode, DefsComplete, DefsCtrlNo, DefBegin, DefEnd
		, _usc
		, SideShift, EnterShift, ShiftDelay, CombDelay
	static ConvRest	:= 0	; 入力バッファに積んだ数/多重起動防止フラグ
		, NextKey	:= ""	; 次回送りのキー入力
		, RealBit	:= 0	; 今押している全部のキービットの集合
		, LastBit	:= 0	; 前回のキービット
		, Last2Bit	:= 0	; 前々回のキービット
		, LastKeyTime := 0	; 有効なキーを押した時間
		, OutStr	:= ""	; 出力する文字列
		, LastStr	:= ""	; 前回、出力した文字列
		, _lks		:= 0	; 前回、何キー同時押しだったか？
		, LastGroup	:= 0	; 前回、何グループだったか？ 0はグループAll
		, RepeatBit	:= 0	; リピート中のキーのビット
		; シフト用キーの状態 0: 押していない, 1: 単独押し, 2以上: シフト状態
		, spc		:= 0	; スペースキー
		, sft		:= 0	; 左右シフト
		, ent		:= 0	; エンター
;	local KeyTime	; キーを押した時間
;		, KanaMode	; 0: 英数入力, 1: かな入力
;		, Detect
;		, NowKey, len
;		, Term		; 入力の末端2文字
;		, nkeys		; 今回は何キー同時押しか
;		, NowBit	; 今回のキービット
;		, SearchBit	; いま検索しようとしているキーの集合
;		, i, imax, j, jmax	; カウンタ用
;		, DefKeyCopy
;		, Complete 	; 出力確定したか(1 だと、後置シフトの判定期限到来で出力確定)
;		, CtrlNo
;		, TimeAtoB

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
					OutBuf()
					DispTime(LastKeyTime)	; キー変化からの経過時間を表示
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
					OutBuf()
					Last2Bit := LastBit := 0
					DispTime(LastKeyTime)	; キー変化からの経過時間を表示
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
		if (Asc(NowKey) == 43)		; "+" から始まる
		{
			if (sft == 0)			; 左右シフトなし→あり
			{
				OutBuf()
				NextKey := NowKey
				NowKey := "sc39"	; スペース押す→押したキー
				sft := 1
			}
			else
				NowKey := SubStr(NowKey, 2)	; 先頭の "+" を消去
		}
		else if (sft > 0)			; 左右シフトあり→なし
		{
			if (spc == 0 && ent == 0)
			{
				NextKey := NowKey
				NowKey := "sc39 up"	; スペース上げ→押したキー
			}
			sft := 0
		}
		; スペースキー処理
		else if (NowKey == "sc39" && spc == 0)
			spc := 1
		else if (NowKey == "sc39 up")
		{
			if (sft > 0 || ent > 0)		; 他のシフトを押している時
			{
				if (spc == 1)
					NowKey := "vk20"	; スペース単独押しのみ
				else
				{
					spc := 0
					DispTime(KeyTime)	; キー変化からの経過時間を表示
					continue
				}
			}
			else if (spc == 1)
				NextKey := "vk20"	; スペース単独押し→スペース上げ
			spc := 0
		}
		; エンターキー処理
		else if (NowKey == "Enter" && EnterShift)
		{
			NowKey := "sc39"	; スペース押す
			if (ent == 0)
				ent := 1
		}
		else if (NowKey == "Enter up")
		{
			NowKey := "sc39 up"			; スペース上げ
			if (sft > 0 || spc > 0)		; 他のシフトを押している時
			{
				if (ent == 1)
					NowKey := "vk0D"	; エンター単独押しのみ
				else
				{
					ent := 0
					DispTime(KeyTime)	; キー変化からの経過時間を表示
					continue
				}
			}
			else if (ent == 1)
				NextKey := "vk0D"	; エンター単独押し→スペース上げ ※"Enter"としないこと
			ent := 0
		}

		IfWinExist, ahk_class #32768	; コンテキストメニューが出ている時
			KanaMode := 0
		else if (sft > 0 && SideShift == 1)	; 左右シフト英数２
			KanaMode := 0
		else
		{
			; IME の状態を検出(失敗したら書き換えない)
			Detect := IME_GET()
			if (Detect == 0)		; IME OFF の時
				KanaMode := 0
			else if (Detect == 1)	; IME ON の時
			{
				Detect := IME_GetConvMode()
				if (Detect != "")
					KanaMode := Detect & 1
			}
		}

		nkeys := 0	; 何キー同時押しか、を入れる変数
		len := StrLen(NowKey)
		Term := SubStr(NowKey, len - 1)	; Term に入力末尾の2文字を入れる
		; キーが離れた時
		if (Term == "up")
			NowBit := "0x" . SubStr(NowKey, len - 4, 2)
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
				NowBit := 0
				OutStr := "{" . NowKey . "}"
				nkeys := -1	; 後の検索は不要
			}
			; スペースキーが押されていたら、シフトを加える(SandSの実装)
			if (RealBit & KC_SPC)
				OutStr := "+" . OutStr
		}

		; ビットに変換
		if (NowBit == 0x7D)			; (JIS)\
			NowBit := JP_YEN
		else if (NowBit == 0x73)	; (JIS)_
			NowBit := KC_INT1
		else if (NowBit != 0)
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
			DispTime(KeyTime)	; キー変化からの経過時間を表示
		}
		; (キーリリース直後か、通常シフトまたは後置シフトの判定期限後に)スペースキーが押された時
		else if (NowBit == KC_SPC && !(RealBit & NowBit)
			&& (_usc == 0 || LastKeyTime + ShiftDelay <= KeyTime))
		{
			OutBuf()
			RealBit |= KC_SPC
			LastGroup := 0
			RepeatBit := 0	; リピート解除
			DispTime(KeyTime)	; キー変化からの経過時間を表示
		}
		; 押されていなかったキー、sc**以外のキー
		else if !(RealBit & NowBit)
		{
			; 同時押しの判定期限到来(シフト時のみ)
			if (CombDelay > 0.0 && (RealBit & KC_SPC) && LastKeyTime + CombDelay <= KeyTime)
			{
				OutBuf()
				Last2Bit := LastBit := 0
			}

			RealBit |= NowBit
			nBack := 0
			while (nkeys == 0)
			{
				; 3キー入力を検索
				if (Last2Bit != 0)
				{
					i := DefBegin[3]
					imax := DefEnd[3]	; 検索場所の設定
					SearchBit := (RealBit & KC_SPC) | NowBit | LastBit | Last2Bit
					while (i < imax)
					{
						DefKeyCopy := DefsKey[i]
						if ((LastGroup == 0 || LastGroup == DefsGroup[i])
							&& (DefKeyCopy & NowBit) 		; 今回のキーを含み
							&& (DefKeyCopy & SearchBit) == DefKeyCopy ; 検索中のキー集合が、いま調べている定義内にあり
							&& (DefKeyCopy & KC_SPC) == (SearchBit & KC_SPC) ; シフトの相違はなく
							&& DefsKanaMode[i] == KanaMode)	; 英数用、かな用の種別が一致していること
						{
							if (_lks == 3 && (RealBit & KC_SPC) && NowBit != KC_SPC && CombDelay > 0.0)
							{	; 前回もシフト付き3キー入力だったら
								LastBit := 0	; 1キー入力の検索へ
								break
							}
							if (_lks == 3 && NowBit != KC_SPC)	; 3キー同時→3キー同時 は仮出力バッファを全て出力
								OutBuf()
							else if (_lks >= 2)
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
				if (LastBit != 0)
				{
					i := DefBegin[2]
					imax := DefEnd[2]	; 検索場所の設定
					SearchBit := (RealBit & KC_SPC) | NowBit | LastBit
					while (i < imax)
					{
						DefKeyCopy := DefsKey[i]
						if ((LastGroup == 0 || LastGroup == DefsGroup[i])
							&& (DefKeyCopy & NowBit) 		; 今回のキーを含み
							&& (DefKeyCopy & SearchBit) == DefKeyCopy ; 検索中のキー集合が、いま調べている定義内にあり
							&& (DefKeyCopy & KC_SPC) == (SearchBit & KC_SPC) ; シフトの相違はなく
							&& DefsKanaMode[i] == KanaMode)	; 英数用、かな用の種別が一致していること
						{
							if (_lks == 2 && (RealBit & KC_SPC) && NowBit != KC_SPC && CombDelay > 0.0)
							{	; 前回もシフト付き2キー入力だったら
								LastBit := 0	; 1キー入力の検索へ
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
				if (NowBit == KC_SPC)
					SearchBit := KC_SPC | LastBit
				else
					SearchBit := (RealBit & KC_SPC) | NowBit
				while (i < imax)
				{
					if ((LastGroup == 0 || LastGroup == DefsGroup[i])
						&& SearchBit == DefsKey[i]
						&& KanaMode == DefsKanaMode[i])
					{
						if (_lks >= 2)
							OutBuf()	; 前回が2キー、3キー同時押しだったら、仮出力バッファを全て出力
						else if (NowBit == KC_SPC)
							nBack := 1
						nkeys := 1
						break, 2
					}
					i++
				}
				if (LastGroup == 0)
					break
				LastGroup := 0	; 今の検索がグループありだったので、グループなしで再度検索
			}

			; スペースを押したが、定義がなかった時
			if (NowBit == KC_SPC && nkeys == 0)
			{
				RepeatBit := 0
				DispTime(KeyTime)	; キー変化からの経過時間を表示
				continue	; 次の入力へ
			}
			if (spc == 1)
				spc := 2	; 単独スペースではない
			if (ent == 1)
				ent := 2	; 単独エンターではない

			; 出力する文字列を選ぶ
			CtrlNo := 0
			if (nkeys > 0)	; 定義が見つかった時
			{
				OutStr := SelectStr(i)		; 出力する文字列
				Complete := DefsComplete[i]	; 出力確定するか検索
				CtrlNo := DefsCtrlNo[i]
			}
			else if (nkeys == 0)	; 定義が見つけられなかった時
				; 出力確定するか検索
				Complete := FindComplete(SearchBit, KanaMode, nkeys)
			else
				Complete := 2	; 出力確定する

			; 仮出力バッファに入れる
			StoreBuf(nBack, OutStr, CtrlNo)
			; 次回の検索用に変数を更新
			LastStr := OutStr		; 今回の文字列を保存
			LastKeyTime := KeyTime	; 有効なキーを押した時間を保存
			_lks := nkeys			; 何キー同時押しだったかを保存
			Last2Bit := (nkeys >= 2 ? DefsKey[i] : LastBit)	; 2、3キー入力のときは今回のキービットを保存
															; それ以外は前回のキービットを保存
			LastBit := (nkeys >= 1 ? DefsKey[i] : NowBit)	; 今回のキービットを保存
			LastGroup := (nkeys >= 1 ? DefsGroup[i] : 0)	; 何グループだったか保存
			if (CtrlNo == R && NowBit != KC_SPC)
				RepeatBit := NowBit		; キーリピートする
			else
				RepeatBit := 0

			; 出力確定文字か？
			if (Complete > (ShiftDelay > 0.0 ? 1 : 0))
				OutBuf()	; 出力確定
			else if (InBufRest == 15 && NextKey == "")
			{
				; 同時押しの判定期限タイマー起動(シフト時のみ)
				if (CombDelay > 0.0 && (RealBit & KC_SPC))
					SetTimer, CombTimer, % - CombDelay
				; 後置シフトの判定期限タイマー起動
				if (Complete == 1)
					SetTimer, PSTimer, % - ShiftDelay
			}
			DispTime(KeyTime)	; キー変化からの経過時間を表示
		}
		; リピートできるキー
		else if (NowBit == RepeatBit)
		{	; 前回の文字列を出力
			StoreBuf(0, LastStr)
			OutBuf()
			DispTime(KeyTime)	; キー変化からの経過時間を表示
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
; USキーボードの場合
#If (USKB)
sc29::	; (JIS)半角/全角	(US)`
; キー入力部(左右シフト)
#If (USKBSideShift)
+sc29::	; (JIS)半角/全角	(US)`
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
#If		; End #If ()
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
; USキーボードの場合
#If (USKB)
sc29 up::	; (JIS)半角/全角	(US)`
; キー押上げ(左右シフト)
#If (USKBSideShift)
+sc29 up::	; (JIS)半角/全角	(US)`
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
; エンター同時押しをシフトとして扱う場合
#If (EnterShift)
Enter up::
#If		; End #If ()
; 入力バッファへ保存
	InBufsKey[InBufWritePos] := A_ThisHotkey, InBufsTime[InBufWritePos] := QPC()
		, InBufWritePos := (InBufRest ? ++InBufWritePos & 15 : InBufWritePos)
		, (InBufRest ? InBufRest-- : )
	Convert()	; 変換ルーチン
	return

#MaxThreadsPerHotkey 1	; 元に戻す
