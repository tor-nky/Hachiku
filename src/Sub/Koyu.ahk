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
;	固有名詞ショートカット関連
; **********************************************************************

; ----------------------------------------------------------------------
; サブルーチン
; ----------------------------------------------------------------------

; 固有名詞ショートカットの読み込み
KoyuReadAll:
	E01 := KoyuIniRead(KoyuNumber, "E01")
	E02 := KoyuIniRead(KoyuNumber, "E02")
	E03 := KoyuIniRead(KoyuNumber, "E03")
	E04 := KoyuIniRead(KoyuNumber, "E04")
	E05 := KoyuIniRead(KoyuNumber, "E05")
	E06 := KoyuIniRead(KoyuNumber, "E06")
	E07 := KoyuIniRead(KoyuNumber, "E07")
	E08 := KoyuIniRead(KoyuNumber, "E08")
	E09 := KoyuIniRead(KoyuNumber, "E09")
	E10 := KoyuIniRead(KoyuNumber, "E10")
	E11 := KoyuIniRead(KoyuNumber, "E11")
	E12 := KoyuIniRead(KoyuNumber, "E12")
	E13 := KoyuIniRead(KoyuNumber, "E13")

	D01 := KoyuIniRead(KoyuNumber, "D01")
	D02 := KoyuIniRead(KoyuNumber, "D02")
	D03 := KoyuIniRead(KoyuNumber, "D03")
	D04 := KoyuIniRead(KoyuNumber, "D04")
	D05 := KoyuIniRead(KoyuNumber, "D05")
	D06 := KoyuIniRead(KoyuNumber, "D06")
	D07 := KoyuIniRead(KoyuNumber, "D07")
	D08 := KoyuIniRead(KoyuNumber, "D08")
	D09 := KoyuIniRead(KoyuNumber, "D09")
	D10 := KoyuIniRead(KoyuNumber, "D10")
	D11 := KoyuIniRead(KoyuNumber, "D11")
	D12 := KoyuIniRead(KoyuNumber, "D12")

	C01 := KoyuIniRead(KoyuNumber, "C01")
	C02 := KoyuIniRead(KoyuNumber, "C02")
	C03 := KoyuIniRead(KoyuNumber, "C03")
	C04 := KoyuIniRead(KoyuNumber, "C04")
	C05 := KoyuIniRead(KoyuNumber, "C05")
	C06 := KoyuIniRead(KoyuNumber, "C06")
	C07 := KoyuIniRead(KoyuNumber, "C07")
	C08 := KoyuIniRead(KoyuNumber, "C08")
	C09 := KoyuIniRead(KoyuNumber, "C09")
	C10 := KoyuIniRead(KoyuNumber, "C10")
	C11 := KoyuIniRead(KoyuNumber, "C11")
	C12 := KoyuIniRead(KoyuNumber, "C12")

	B01 := KoyuIniRead(KoyuNumber, "B01")
	B02 := KoyuIniRead(KoyuNumber, "B02")
	B03 := KoyuIniRead(KoyuNumber, "B03")
	B04 := KoyuIniRead(KoyuNumber, "B04")
	B05 := KoyuIniRead(KoyuNumber, "B05")
	B06 := KoyuIniRead(KoyuNumber, "B06")
	B07 := KoyuIniRead(KoyuNumber, "B07")
	B08 := KoyuIniRead(KoyuNumber, "B08")
	B09 := KoyuIniRead(KoyuNumber, "B09")
	B10 := KoyuIniRead(KoyuNumber, "B10")
	B11 := KoyuIniRead(KoyuNumber, "B11")

	Gosub, KoyuRegist
	return

; 固有名詞ショートカットの登録
KoyuRegist:
	Group := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_1		,"{固有}" . E01)
		SetKana(KC_U | KC_I | KC_2		,"{固有}" . E02)
		SetKana(KC_U | KC_I | KC_3		,"{固有}" . E03)
		SetKana(KC_U | KC_I | KC_4		,"{固有}" . E04)
		SetKana(KC_U | KC_I | KC_5		,"{固有}" . E05)
	Group := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_6		,"{固有}" . E06)
		SetKana(KC_E | KC_R | KC_7		,"{固有}" . E07)
		SetKana(KC_E | KC_R | KC_8		,"{固有}" . E08)
		SetKana(KC_E | KC_R | KC_9		,"{固有}" . E09)
		SetKana(KC_E | KC_R | KC_0		,"{固有}" . E10)
		SetKana(KC_E | KC_R | KC_MINS	,"{固有}" . E11)
		SetKana(KC_E | KC_R | KC_EQL	,"{固有}" . E12)
		SetKana(KC_E | KC_R | JP_YEN	,"{固有}" . E13)

	Group := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_Q		,"{固有}" . D01)
		SetKana(KC_U | KC_I | KC_W		,"{固有}" . D02)
		SetKana(KC_U | KC_I | KC_E		,"{固有}" . D03)
		SetKana(KC_U | KC_I | KC_R		,"{固有}" . D04)
		SetKana(KC_U | KC_I | KC_T		,"{固有}" . D05)
	Group := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_Y		,"{固有}" . D06)
		SetKana(KC_E | KC_R | KC_U		,"{固有}" . D07)
		SetKana(KC_E | KC_R | KC_I		,"{固有}" . D08)
		SetKana(KC_E | KC_R | KC_O		,"{固有}" . D09)
		SetKana(KC_E | KC_R | KC_P		,"{固有}" . D10)
		SetKana(KC_E | KC_R | KC_LBRC	,"{固有}" . D11)
		SetKana(KC_E | KC_R | KC_RBRC	,"{固有}" . D12)

	Group := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_A		,"{固有}" . C01)
		SetKana(KC_U | KC_I | KC_S		,"{固有}" . C02)
		SetKana(KC_U | KC_I | KC_D		,"{固有}" . C03)
		SetKana(KC_U | KC_I | KC_F		,"{固有}" . C04)
		SetKana(KC_U | KC_I | KC_G		,"{固有}" . C05)
	Group := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_H		,"{固有}" . C06)
		SetKana(KC_E | KC_R | KC_J		,"{固有}" . C07)
		SetKana(KC_E | KC_R | KC_K		,"{固有}" . C08)
		SetKana(KC_E | KC_R | KC_L		,"{固有}" . C09)
		SetKana(KC_E | KC_R | KC_SCLN	,"{固有}" . C10)
		SetKana(KC_E | KC_R | KC_QUOT	,"{固有}" . C11)
		SetKana(KC_E | KC_R | KC_NUHS	,"{固有}" . C12)

	Group := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_Z		,"{固有}" . B01)
		SetKana(KC_U | KC_I | KC_X		,"{固有}" . B02)
		SetKana(KC_U | KC_I | KC_C		,"{固有}" . B03)
		SetKana(KC_U | KC_I | KC_V		,"{固有}" . B04)
		SetKana(KC_U | KC_I | KC_B		,"{固有}" . B05)
	Group := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_N		,"{固有}" . B06)
		SetKana(KC_E | KC_R | KC_M		,"{固有}" . B07)
		SetKana(KC_E | KC_R | KC_COMM	,"{固有}" . B08)
		SetKana(KC_E | KC_R | KC_DOT	,"{固有}" . B09)
		SetKana(KC_E | KC_R | KC_SLSH	,"{固有}" . B10)
		SetKana(KC_E | KC_R | KC_INT1	,"{固有}" . B11)

	; 設定がUSキーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	if (KeyDriver == "kbd101.dll")
	{
		SetKana(KC_E | KC_R | KC_BSLS	,"{固有}" . E13)
		SetKana(KC_E | KC_R | KC_GRV	,"{固有}" . C12)
	}

	return

; 「固有名詞」画面のOKボタン
KoyuOK:
	Gui, Submit

	; 固有名詞ショートカットの書き出し
	KoyuIniWrite(KoyuNumber, "E01", E01)
	KoyuIniWrite(KoyuNumber, "E02", E02)
	KoyuIniWrite(KoyuNumber, "E03", E03)
	KoyuIniWrite(KoyuNumber, "E04", E04)
	KoyuIniWrite(KoyuNumber, "E05", E05)
	KoyuIniWrite(KoyuNumber, "E06", E06)
	KoyuIniWrite(KoyuNumber, "E07", E07)
	KoyuIniWrite(KoyuNumber, "E08", E08)
	KoyuIniWrite(KoyuNumber, "E09", E09)
	KoyuIniWrite(KoyuNumber, "E10", E10)
	KoyuIniWrite(KoyuNumber, "E11", E11)
	KoyuIniWrite(KoyuNumber, "E12", E12)
	KoyuIniWrite(KoyuNumber, "E13", E13)

	KoyuIniWrite(KoyuNumber, "D01", D01)
	KoyuIniWrite(KoyuNumber, "D02", D02)
	KoyuIniWrite(KoyuNumber, "D03", D03)
	KoyuIniWrite(KoyuNumber, "D04", D04)
	KoyuIniWrite(KoyuNumber, "D05", D05)
	KoyuIniWrite(KoyuNumber, "D06", D06)
	KoyuIniWrite(KoyuNumber, "D07", D07)
	KoyuIniWrite(KoyuNumber, "D08", D08)
	KoyuIniWrite(KoyuNumber, "D09", D09)
	KoyuIniWrite(KoyuNumber, "D10", D10)
	KoyuIniWrite(KoyuNumber, "D11", D11)
	KoyuIniWrite(KoyuNumber, "D12", D12)

	KoyuIniWrite(KoyuNumber, "C01", C01)
	KoyuIniWrite(KoyuNumber, "C02", C02)
	KoyuIniWrite(KoyuNumber, "C03", C03)
	KoyuIniWrite(KoyuNumber, "C04", C04)
	KoyuIniWrite(KoyuNumber, "C05", C05)
	KoyuIniWrite(KoyuNumber, "C06", C06)
	KoyuIniWrite(KoyuNumber, "C07", C07)
	KoyuIniWrite(KoyuNumber, "C08", C08)
	KoyuIniWrite(KoyuNumber, "C09", C09)
	KoyuIniWrite(KoyuNumber, "C10", C10)
	KoyuIniWrite(KoyuNumber, "C11", C11)
	KoyuIniWrite(KoyuNumber, "C12", C12)

	KoyuIniWrite(KoyuNumber, "B01", B01)
	KoyuIniWrite(KoyuNumber, "B02", B02)
	KoyuIniWrite(KoyuNumber, "B03", B03)
	KoyuIniWrite(KoyuNumber, "B04", B04)
	KoyuIniWrite(KoyuNumber, "B05", B05)
	KoyuIniWrite(KoyuNumber, "B06", B06)
	KoyuIniWrite(KoyuNumber, "B07", B07)
	KoyuIniWrite(KoyuNumber, "B08", B08)
	KoyuIniWrite(KoyuNumber, "B09", B09)
	KoyuIniWrite(KoyuNumber, "B10", B10)
	KoyuIniWrite(KoyuNumber, "B11", B11)

	Gosub, KoyuRegist
	Setting()	; 出力確定する定義に印をつける
KoyuCancel:
	Gui, Destroy
	return

; 「固有名詞」編集画面
KoyuMenu:
	Gui, Destroy
	Gui, Add, Text, , 固有名詞ショートカット設定

; E列
	Gui, Add, Text, xm+0 y+12 W90 Center, 1
	Gui, Add, Text, xp+95 W92 Center, 2
	Gui, Add, Text, xp+95 W92 Center, 3
	Gui, Add, Text, xp+95 W92 Center, 4
	Gui, Add, Text, xp+95 W92 Center, 5
	Gui, Add, Text, xp+115 W92 Center, 6
	Gui, Add, Text, xp+95 W92 Center, 7
	Gui, Add, Text, xp+95 W92 Center, 8
	Gui, Add, Text, xp+95 W92 Center, 9
	Gui, Add, Text, xp+95 W92 Center, 0
	Gui, Add, Text, xp+95 W92 Center, -
	Gui, Add, Text, xp+95 W92 Center, ^  (US)=
	Gui, Add, Text, xp+95 W92 Center, \  (US)＼

	Gui, Add, Edit, xm+0 y+2 W92 R2.4 -VScroll vE01, %E01%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE02, %E02%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE03, %E03%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE04, %E04%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE05, %E05%
	Gui, Add, Edit, xp+115 W92 R2.4 -VScroll vE06, %E06%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE07, %E07%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE08, %E08%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE09, %E09%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE10, %E10%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE11, %E11%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE12, %E12%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE13, %E13%

; D列
	Gui, Add, Text, xm+0 y+15 W92 Center, Q
	Gui, Add, Text, xp+95 W92 Center, W
	Gui, Add, Text, xp+95 W92 Center, E
	Gui, Add, Text, xp+95 W92 Center, R
	Gui, Add, Text, xp+95 W92 Center, T
	Gui, Add, Text, xp+115 W92 Center, Y
	Gui, Add, Text, xp+95 W92 Center, U
	Gui, Add, Text, xp+95 W92 Center, I
	Gui, Add, Text, xp+95 W92 Center, O
	Gui, Add, Text, xp+95 W92 Center, P
	Gui, Add, Text, xp+95 W92 Center, @  (US)[
	Gui, Add, Text, xp+95 W92 Center, [  (US)]

	Gui, Add, Edit, xm+0 y+2 W92 R2.4 -VScroll vD01, %D01%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD02, %D02%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD03, %D03%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD04, %D04%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD05, %D05%
	Gui, Add, Edit, xp+115 W92 R2.4 -VScroll vD06, %D06%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD07, %D07%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD08, %D08%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD09, %D09%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD10, %D10%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD11, %D11%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD12, %D12%

; C列
	Gui, Add, Text, xm+0 y+15 W92 Center, A
	Gui, Add, Text, xp+95 W92 Center, S
	Gui, Add, Text, xp+95 W92 Center, D
	Gui, Add, Text, xp+95 W92 Center, F
	Gui, Add, Text, xp+95 W92 Center, G
	Gui, Add, Text, xp+115 W92 Center, H
	Gui, Add, Text, xp+95 W92 Center, J
	Gui, Add, Text, xp+95 W92 Center, K
	Gui, Add, Text, xp+95 W92 Center, L
	Gui, Add, Text, xp+95 W92 Center, `;
	Gui, Add, Text, xp+95 W92 Center, :  (US)'
	Gui, Add, Text, xp+95 W92 Center, ]  (US)``

	Gui, Add, Edit, xm+0 y+2 W92 R2.4 -VScroll vC01, %C01%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC02, %C02%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC03, %C03%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC04, %C04%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC05, %C05%
	Gui, Add, Edit, xp+115 W92 R2.4 -VScroll vC06, %C06%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC07, %C07%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC08, %C08%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC09, %C09%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC10, %C10%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC11, %C11%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC12, %C12%

; B列
	Gui, Add, Text, xm+0 y+15 W92 Center, Z
	Gui, Add, Text, xp+95 W92 Center, X
	Gui, Add, Text, xp+95 W92 Center, C
	Gui, Add, Text, xp+95 W92 Center, V
	Gui, Add, Text, xp+95 W92 Center, B
	Gui, Add, Text, xp+115 W92 Center, N
	Gui, Add, Text, xp+95 W92 Center, M
	Gui, Add, Text, xp+95 W92 Center, `,
	Gui, Add, Text, xp+95 W92 Center, `.
	Gui, Add, Text, xp+95 W92 Center, /
	Gui, Add, Text, xp+95 W92 Center, _  (US)なし

	Gui, Add, Edit, xm+0 y+2 W92 R2.4 -VScroll vB01, %B01%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB02, %B02%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB03, %B03%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB04, %B04%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB05, %B05%
	Gui, Add, Edit, xp+115 W92 R2.4 -VScroll vB06, %B06%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB07, %B07%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB08, %B08%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB09, %B09%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB10, %B10%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB11, %B11%


	Gui, Add, Button, W60 xm+566 y+15 GKoyuOK, OK
	Gui, Add, Button, W60 x+0 GKoyuCancel, Cancel
	Gui, Show
	return


; ----------------------------------------------------------------------
; 関数
; ----------------------------------------------------------------------

; INIファイルからの読み出し(1個のみ)
KoyuIniRead(Number, KeyName)
{
	global IniFilePath
;	local i, len, c, StrChopped, InStr, OutStr

	; 設定ファイル読み込み
	IniRead, InStr, %IniFilePath%, Koyu%Number%, %KeyName%, ""

	OutStr := ""
	StrChopped := ""
	i := StrLen(InStr)
	while (i >= 1)
	{
		c := SubStr(InStr, i, 1)
		if (c == "#")
		{
			OutStr := Chr(StrChopped) . OutStr
			StrChopped := ""
		}
		else
			StrChopped := c . StrChopped
		i--
	}

	return OutStr
}

; INIファイルへの書き出し(1個のみ)
KoyuIniWrite(Number, KeyName, Str1:="")
{
	global IniFilePath
;	local i, len, c, OutStr

	OutStr := ""
	i := 1, len := StrLen(Str1)
	while (i <= len)
	{
		c := Asc(SubStr(Str1, i, 2))
		if (c > 65535)	; ユニコード拡張領域
			i += 2
		else
		{
			c := Asc(SubStr(Str1, i, 1))
			i++
		}
		OutStr .= "#" . c
	}

	; 設定ファイル書き込み
	IniWrite, %OutStr%, %IniFilePath%, Koyu%Number%, %KeyName%

	return
}
