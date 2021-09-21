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

; 「固有名詞」画面のOKボタン
KoyuOK:
	Gui, Submit
	KoyuWriteAndRegist(KoyuNumber)	; 固有名詞ショートカットの書き込み・登録
	SettingLayout()					; 出力確定する定義に印をつける
KoyuCancel:
	Gui, Destroy
	return

; 「固有名詞」編集画面
KoyuMenu:
	Gui, Destroy
	Gui, Add, Text, , 固有名詞ショートカット設定
;	Gui, Add, Text, x+15, 〈セット%KoyuNumber%〉
	Gui, Add, Tab2, xm+560 y+0 Section Buttons Center, 通常面|シフト面

; E列
	Gui, Add, Text, xm+0 ys+25 W90 Center, 1
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


	Gui, Tab, シフト面
; E列
	Gui, Add, Text, xm+0 ys+25 W90 Center, 1
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

	Gui, Add, Edit, xm+0 y+2 W92 R2.4 -VScroll vE01S, %E01S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE02S, %E02S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE03S, %E03S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE04S, %E04S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE05S, %E05S%
	Gui, Add, Edit, xp+115 W92 R2.4 -VScroll vE06S, %E06S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE07S, %E07S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE08S, %E08S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE09S, %E09S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE10S, %E10S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE11S, %E11S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE12S, %E12S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vE13S, %E13S%

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

	Gui, Add, Edit, xm+0 y+2 W92 R2.4 -VScroll vD01S, %D01S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD02S, %D02S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD03S, %D03S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD04S, %D04S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD05S, %D05S%
	Gui, Add, Edit, xp+115 W92 R2.4 -VScroll vD06S, %D06S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD07S, %D07S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD08S, %D08S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD09S, %D09S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD10S, %D10S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD11S, %D11S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vD12S, %D12S%

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

	Gui, Add, Edit, xm+0 y+2 W92 R2.4 -VScroll vC01S, %C01S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC02S, %C02S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC03S, %C03S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC04S, %C04S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC05S, %C05S%
	Gui, Add, Edit, xp+115 W92 R2.4 -VScroll vC06S, %C06S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC07S, %C07S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC08S, %C08S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC09S, %C09S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC10S, %C10S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC11S, %C11S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vC12S, %C12S%

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

	Gui, Add, Edit, xm+0 y+2 W92 R2.4 -VScroll vB01S, %B01S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB02S, %B02S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB03S, %B03S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB04S, %B04S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB05S, %B05S%
	Gui, Add, Edit, xp+115 W92 R2.4 -VScroll vB06S, %B06S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB07S, %B07S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB08S, %B08S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB09S, %B09S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB10S, %B10S%
	Gui, Add, Edit, xp+95 W92 R2.4 -VScroll vB11S, %B11S%


	Gui, Tab
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
;	local i, c, StrChopped, InStr, OutStr

	; 設定ファイル読み込み
	IniRead, InStr, %IniFilePath%, Koyu%Number%, %KeyName%, ""

	OutStr := ""
	StrChopped := ""
	i := StrLen(InStr)
	while (i > 0)
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

	if (Str1 == "")	; 空白の時は、キーを削除する
		IniDelete, %IniFilePath%, Koyu%Number% , %KeyName%
	else
	{
		OutStr := ""
		i := 1
		len := StrLen(Str1)
		while (i <= len)
		{
			c := Asc(SubStr(Str1, i, 2))
			if (c > 65535)	; ユニコード拡張領域
				i += 2
			else
				i++
			OutStr .= "#" . c
		}
		; 設定ファイル書き込み
		IniWrite, %OutStr%, %IniFilePath%, Koyu%Number%, %KeyName%
	}
	return
}

; 固有名詞ショートカットの読み込み・登録
KoyuReadAndRegist(KoyuNumber)
{
	#IncludeAgain %A_ScriptDir%/Sub/Naginata-Koyu_h.ahk

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

	E01S := KoyuIniRead(KoyuNumber, "E01S")
	E02S := KoyuIniRead(KoyuNumber, "E02S")
	E03S := KoyuIniRead(KoyuNumber, "E03S")
	E04S := KoyuIniRead(KoyuNumber, "E04S")
	E05S := KoyuIniRead(KoyuNumber, "E05S")
	E06S := KoyuIniRead(KoyuNumber, "E06S")
	E07S := KoyuIniRead(KoyuNumber, "E07S")
	E08S := KoyuIniRead(KoyuNumber, "E08S")
	E09S := KoyuIniRead(KoyuNumber, "E09S")
	E10S := KoyuIniRead(KoyuNumber, "E10S")
	E11S := KoyuIniRead(KoyuNumber, "E11S")
	E12S := KoyuIniRead(KoyuNumber, "E12S")
	E13S := KoyuIniRead(KoyuNumber, "E13S")

	D01S := KoyuIniRead(KoyuNumber, "D01S")
	D02S := KoyuIniRead(KoyuNumber, "D02S")
	D03S := KoyuIniRead(KoyuNumber, "D03S")
	D04S := KoyuIniRead(KoyuNumber, "D04S")
	D05S := KoyuIniRead(KoyuNumber, "D05S")
	D06S := KoyuIniRead(KoyuNumber, "D06S")
	D07S := KoyuIniRead(KoyuNumber, "D07S")
	D08S := KoyuIniRead(KoyuNumber, "D08S")
	D09S := KoyuIniRead(KoyuNumber, "D09S")
	D10S := KoyuIniRead(KoyuNumber, "D10S")
	D11S := KoyuIniRead(KoyuNumber, "D11S")
	D12S := KoyuIniRead(KoyuNumber, "D12S")

	C01S := KoyuIniRead(KoyuNumber, "C01S")
	C02S := KoyuIniRead(KoyuNumber, "C02S")
	C03S := KoyuIniRead(KoyuNumber, "C03S")
	C04S := KoyuIniRead(KoyuNumber, "C04S")
	C05S := KoyuIniRead(KoyuNumber, "C05S")
	C06S := KoyuIniRead(KoyuNumber, "C06S")
	C07S := KoyuIniRead(KoyuNumber, "C07S")
	C08S := KoyuIniRead(KoyuNumber, "C08S")
	C09S := KoyuIniRead(KoyuNumber, "C09S")
	C10S := KoyuIniRead(KoyuNumber, "C10S")
	C11S := KoyuIniRead(KoyuNumber, "C11S")
	C12S := KoyuIniRead(KoyuNumber, "C12S")

	B01S := KoyuIniRead(KoyuNumber, "B01S")
	B02S := KoyuIniRead(KoyuNumber, "B02S")
	B03S := KoyuIniRead(KoyuNumber, "B03S")
	B04S := KoyuIniRead(KoyuNumber, "B04S")
	B05S := KoyuIniRead(KoyuNumber, "B05S")
	B06S := KoyuIniRead(KoyuNumber, "B06S")
	B07S := KoyuIniRead(KoyuNumber, "B07S")
	B08S := KoyuIniRead(KoyuNumber, "B08S")
	B09S := KoyuIniRead(KoyuNumber, "B09S")
	B10S := KoyuIniRead(KoyuNumber, "B10S")
	B11S := KoyuIniRead(KoyuNumber, "B11S")

	KoyuRegist()	; 固有名詞ショートカットの登録
	return
}

; 固有名詞ショートカットの書き込み・登録
KoyuWriteAndRegist(KoyuNumber)
{
	#IncludeAgain %A_ScriptDir%/Sub/Naginata-Koyu_h.ahk

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

	KoyuIniWrite(KoyuNumber, "E01S", E01S)
	KoyuIniWrite(KoyuNumber, "E02S", E02S)
	KoyuIniWrite(KoyuNumber, "E03S", E03S)
	KoyuIniWrite(KoyuNumber, "E04S", E04S)
	KoyuIniWrite(KoyuNumber, "E05S", E05S)
	KoyuIniWrite(KoyuNumber, "E06S", E06S)
	KoyuIniWrite(KoyuNumber, "E07S", E07S)
	KoyuIniWrite(KoyuNumber, "E08S", E08S)
	KoyuIniWrite(KoyuNumber, "E09S", E09S)
	KoyuIniWrite(KoyuNumber, "E10S", E10S)
	KoyuIniWrite(KoyuNumber, "E11S", E11S)
	KoyuIniWrite(KoyuNumber, "E12S", E12S)
	KoyuIniWrite(KoyuNumber, "E13S", E13S)

	KoyuIniWrite(KoyuNumber, "D01S", D01S)
	KoyuIniWrite(KoyuNumber, "D02S", D02S)
	KoyuIniWrite(KoyuNumber, "D03S", D03S)
	KoyuIniWrite(KoyuNumber, "D04S", D04S)
	KoyuIniWrite(KoyuNumber, "D05S", D05S)
	KoyuIniWrite(KoyuNumber, "D06S", D06S)
	KoyuIniWrite(KoyuNumber, "D07S", D07S)
	KoyuIniWrite(KoyuNumber, "D08S", D08S)
	KoyuIniWrite(KoyuNumber, "D09S", D09S)
	KoyuIniWrite(KoyuNumber, "D10S", D10S)
	KoyuIniWrite(KoyuNumber, "D11S", D11S)
	KoyuIniWrite(KoyuNumber, "D12S", D12S)

	KoyuIniWrite(KoyuNumber, "C01S", C01S)
	KoyuIniWrite(KoyuNumber, "C02S", C02S)
	KoyuIniWrite(KoyuNumber, "C03S", C03S)
	KoyuIniWrite(KoyuNumber, "C04S", C04S)
	KoyuIniWrite(KoyuNumber, "C05S", C05S)
	KoyuIniWrite(KoyuNumber, "C06S", C06S)
	KoyuIniWrite(KoyuNumber, "C07S", C07S)
	KoyuIniWrite(KoyuNumber, "C08S", C08S)
	KoyuIniWrite(KoyuNumber, "C09S", C09S)
	KoyuIniWrite(KoyuNumber, "C10S", C10S)
	KoyuIniWrite(KoyuNumber, "C11S", C11S)
	KoyuIniWrite(KoyuNumber, "C12S", C12S)

	KoyuIniWrite(KoyuNumber, "B01S", B01S)
	KoyuIniWrite(KoyuNumber, "B02S", B02S)
	KoyuIniWrite(KoyuNumber, "B03S", B03S)
	KoyuIniWrite(KoyuNumber, "B04S", B04S)
	KoyuIniWrite(KoyuNumber, "B05S", B05S)
	KoyuIniWrite(KoyuNumber, "B06S", B06S)
	KoyuIniWrite(KoyuNumber, "B07S", B07S)
	KoyuIniWrite(KoyuNumber, "B08S", B08S)
	KoyuIniWrite(KoyuNumber, "B09S", B09S)
	KoyuIniWrite(KoyuNumber, "B10S", B10S)
	KoyuIniWrite(KoyuNumber, "B11S", B11S)

	KoyuRegist()	; 固有名詞ショートカットの登録
	return
}
