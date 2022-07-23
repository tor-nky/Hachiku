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
	KoyuWriteAndRegist(koyuNumber)	; 固有名詞ショートカットの書き込み・登録
	SettingLayout()					; 出力確定する定義に印をつける
KoyuCancel:
	Gui, Destroy
	Return

; 「固有名詞」編集画面
KoyuMenu:
	Gui, Destroy
	Gui, Add, Text, , 固有名詞ショートカット設定
;	Gui, Add, Text, x+15, 〈セット%koyuNumber%〉
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
	Return


; ----------------------------------------------------------------------
; 関数
; ----------------------------------------------------------------------

; INIファイルからの読み出し(1個のみ)
KoyuIniRead(number, keyName)
{
	global iniFilePath
;	local i, c, strChopped, strIn, strOut

	; 設定ファイル読み込み
	IniRead, strIn, %iniFilePath%, Koyu%number%, %keyName%, ""

	strOut := ""
	strChopped := ""
	i := StrLen(strIn)
	While (i > 0)
	{
		c := SubStr(strIn, i, 1)
		If (c == "#")
		{
			strOut := Chr(strChopped) . strOut
			strChopped := ""
		}
		Else
			strChopped := c . strChopped
		i--
	}

	Return strOut
}

; INIファイルへの書き出し(1個のみ)
KoyuIniWrite(number, keyName, strIn:="")
{
	global iniFilePath
;	local i, len, c, strOut

	If (strIn == "")	; 空白の時は、キーを削除する
		IniDelete, %iniFilePath%, Koyu%number% , %keyName%
	Else
	{
		strOut := ""
		i := 1
		len := StrLen(strIn)
		While (i <= len)
		{
			c := Asc(SubStr(strIn, i, 1))
			i++
			strOut .= "#" . c
		}
		; 設定ファイル書き込み
		IniWrite, %strOut%, %iniFilePath%, Koyu%number%, %keyName%
	}
	Return
}

; 固有名詞ショートカットの読み込み・登録
KoyuReadAndRegist(koyuNumber)
{
	#IncludeAgain %A_ScriptDir%/Sub/Naginata-Koyu_h.ahk

	E01 := KoyuIniRead(koyuNumber, "E01")
	E02 := KoyuIniRead(koyuNumber, "E02")
	E03 := KoyuIniRead(koyuNumber, "E03")
	E04 := KoyuIniRead(koyuNumber, "E04")
	E05 := KoyuIniRead(koyuNumber, "E05")
	E06 := KoyuIniRead(koyuNumber, "E06")
	E07 := KoyuIniRead(koyuNumber, "E07")
	E08 := KoyuIniRead(koyuNumber, "E08")
	E09 := KoyuIniRead(koyuNumber, "E09")
	E10 := KoyuIniRead(koyuNumber, "E10")
	E11 := KoyuIniRead(koyuNumber, "E11")
	E12 := KoyuIniRead(koyuNumber, "E12")
	E13 := KoyuIniRead(koyuNumber, "E13")

	D01 := KoyuIniRead(koyuNumber, "D01")
	D02 := KoyuIniRead(koyuNumber, "D02")
	D03 := KoyuIniRead(koyuNumber, "D03")
	D04 := KoyuIniRead(koyuNumber, "D04")
	D05 := KoyuIniRead(koyuNumber, "D05")
	D06 := KoyuIniRead(koyuNumber, "D06")
	D07 := KoyuIniRead(koyuNumber, "D07")
	D08 := KoyuIniRead(koyuNumber, "D08")
	D09 := KoyuIniRead(koyuNumber, "D09")
	D10 := KoyuIniRead(koyuNumber, "D10")
	D11 := KoyuIniRead(koyuNumber, "D11")
	D12 := KoyuIniRead(koyuNumber, "D12")

	C01 := KoyuIniRead(koyuNumber, "C01")
	C02 := KoyuIniRead(koyuNumber, "C02")
	C03 := KoyuIniRead(koyuNumber, "C03")
	C04 := KoyuIniRead(koyuNumber, "C04")
	C05 := KoyuIniRead(koyuNumber, "C05")
	C06 := KoyuIniRead(koyuNumber, "C06")
	C07 := KoyuIniRead(koyuNumber, "C07")
	C08 := KoyuIniRead(koyuNumber, "C08")
	C09 := KoyuIniRead(koyuNumber, "C09")
	C10 := KoyuIniRead(koyuNumber, "C10")
	C11 := KoyuIniRead(koyuNumber, "C11")
	C12 := KoyuIniRead(koyuNumber, "C12")

	B01 := KoyuIniRead(koyuNumber, "B01")
	B02 := KoyuIniRead(koyuNumber, "B02")
	B03 := KoyuIniRead(koyuNumber, "B03")
	B04 := KoyuIniRead(koyuNumber, "B04")
	B05 := KoyuIniRead(koyuNumber, "B05")
	B06 := KoyuIniRead(koyuNumber, "B06")
	B07 := KoyuIniRead(koyuNumber, "B07")
	B08 := KoyuIniRead(koyuNumber, "B08")
	B09 := KoyuIniRead(koyuNumber, "B09")
	B10 := KoyuIniRead(koyuNumber, "B10")
	B11 := KoyuIniRead(koyuNumber, "B11")

	E01S := KoyuIniRead(koyuNumber, "E01S")
	E02S := KoyuIniRead(koyuNumber, "E02S")
	E03S := KoyuIniRead(koyuNumber, "E03S")
	E04S := KoyuIniRead(koyuNumber, "E04S")
	E05S := KoyuIniRead(koyuNumber, "E05S")
	E06S := KoyuIniRead(koyuNumber, "E06S")
	E07S := KoyuIniRead(koyuNumber, "E07S")
	E08S := KoyuIniRead(koyuNumber, "E08S")
	E09S := KoyuIniRead(koyuNumber, "E09S")
	E10S := KoyuIniRead(koyuNumber, "E10S")
	E11S := KoyuIniRead(koyuNumber, "E11S")
	E12S := KoyuIniRead(koyuNumber, "E12S")
	E13S := KoyuIniRead(koyuNumber, "E13S")

	D01S := KoyuIniRead(koyuNumber, "D01S")
	D02S := KoyuIniRead(koyuNumber, "D02S")
	D03S := KoyuIniRead(koyuNumber, "D03S")
	D04S := KoyuIniRead(koyuNumber, "D04S")
	D05S := KoyuIniRead(koyuNumber, "D05S")
	D06S := KoyuIniRead(koyuNumber, "D06S")
	D07S := KoyuIniRead(koyuNumber, "D07S")
	D08S := KoyuIniRead(koyuNumber, "D08S")
	D09S := KoyuIniRead(koyuNumber, "D09S")
	D10S := KoyuIniRead(koyuNumber, "D10S")
	D11S := KoyuIniRead(koyuNumber, "D11S")
	D12S := KoyuIniRead(koyuNumber, "D12S")

	C01S := KoyuIniRead(koyuNumber, "C01S")
	C02S := KoyuIniRead(koyuNumber, "C02S")
	C03S := KoyuIniRead(koyuNumber, "C03S")
	C04S := KoyuIniRead(koyuNumber, "C04S")
	C05S := KoyuIniRead(koyuNumber, "C05S")
	C06S := KoyuIniRead(koyuNumber, "C06S")
	C07S := KoyuIniRead(koyuNumber, "C07S")
	C08S := KoyuIniRead(koyuNumber, "C08S")
	C09S := KoyuIniRead(koyuNumber, "C09S")
	C10S := KoyuIniRead(koyuNumber, "C10S")
	C11S := KoyuIniRead(koyuNumber, "C11S")
	C12S := KoyuIniRead(koyuNumber, "C12S")

	B01S := KoyuIniRead(koyuNumber, "B01S")
	B02S := KoyuIniRead(koyuNumber, "B02S")
	B03S := KoyuIniRead(koyuNumber, "B03S")
	B04S := KoyuIniRead(koyuNumber, "B04S")
	B05S := KoyuIniRead(koyuNumber, "B05S")
	B06S := KoyuIniRead(koyuNumber, "B06S")
	B07S := KoyuIniRead(koyuNumber, "B07S")
	B08S := KoyuIniRead(koyuNumber, "B08S")
	B09S := KoyuIniRead(koyuNumber, "B09S")
	B10S := KoyuIniRead(koyuNumber, "B10S")
	B11S := KoyuIniRead(koyuNumber, "B11S")

	KoyuRegist()	; 固有名詞ショートカットの登録
	Return
}

; 固有名詞ショートカットの書き込み・登録
KoyuWriteAndRegist(koyuNumber)
{
	#IncludeAgain %A_ScriptDir%/Sub/Naginata-Koyu_h.ahk

	; 固有名詞ショートカットの書き出し
	KoyuIniWrite(koyuNumber, "E01", E01)
	KoyuIniWrite(koyuNumber, "E02", E02)
	KoyuIniWrite(koyuNumber, "E03", E03)
	KoyuIniWrite(koyuNumber, "E04", E04)
	KoyuIniWrite(koyuNumber, "E05", E05)
	KoyuIniWrite(koyuNumber, "E06", E06)
	KoyuIniWrite(koyuNumber, "E07", E07)
	KoyuIniWrite(koyuNumber, "E08", E08)
	KoyuIniWrite(koyuNumber, "E09", E09)
	KoyuIniWrite(koyuNumber, "E10", E10)
	KoyuIniWrite(koyuNumber, "E11", E11)
	KoyuIniWrite(koyuNumber, "E12", E12)
	KoyuIniWrite(koyuNumber, "E13", E13)

	KoyuIniWrite(koyuNumber, "D01", D01)
	KoyuIniWrite(koyuNumber, "D02", D02)
	KoyuIniWrite(koyuNumber, "D03", D03)
	KoyuIniWrite(koyuNumber, "D04", D04)
	KoyuIniWrite(koyuNumber, "D05", D05)
	KoyuIniWrite(koyuNumber, "D06", D06)
	KoyuIniWrite(koyuNumber, "D07", D07)
	KoyuIniWrite(koyuNumber, "D08", D08)
	KoyuIniWrite(koyuNumber, "D09", D09)
	KoyuIniWrite(koyuNumber, "D10", D10)
	KoyuIniWrite(koyuNumber, "D11", D11)
	KoyuIniWrite(koyuNumber, "D12", D12)

	KoyuIniWrite(koyuNumber, "C01", C01)
	KoyuIniWrite(koyuNumber, "C02", C02)
	KoyuIniWrite(koyuNumber, "C03", C03)
	KoyuIniWrite(koyuNumber, "C04", C04)
	KoyuIniWrite(koyuNumber, "C05", C05)
	KoyuIniWrite(koyuNumber, "C06", C06)
	KoyuIniWrite(koyuNumber, "C07", C07)
	KoyuIniWrite(koyuNumber, "C08", C08)
	KoyuIniWrite(koyuNumber, "C09", C09)
	KoyuIniWrite(koyuNumber, "C10", C10)
	KoyuIniWrite(koyuNumber, "C11", C11)
	KoyuIniWrite(koyuNumber, "C12", C12)

	KoyuIniWrite(koyuNumber, "B01", B01)
	KoyuIniWrite(koyuNumber, "B02", B02)
	KoyuIniWrite(koyuNumber, "B03", B03)
	KoyuIniWrite(koyuNumber, "B04", B04)
	KoyuIniWrite(koyuNumber, "B05", B05)
	KoyuIniWrite(koyuNumber, "B06", B06)
	KoyuIniWrite(koyuNumber, "B07", B07)
	KoyuIniWrite(koyuNumber, "B08", B08)
	KoyuIniWrite(koyuNumber, "B09", B09)
	KoyuIniWrite(koyuNumber, "B10", B10)
	KoyuIniWrite(koyuNumber, "B11", B11)

	KoyuIniWrite(koyuNumber, "E01S", E01S)
	KoyuIniWrite(koyuNumber, "E02S", E02S)
	KoyuIniWrite(koyuNumber, "E03S", E03S)
	KoyuIniWrite(koyuNumber, "E04S", E04S)
	KoyuIniWrite(koyuNumber, "E05S", E05S)
	KoyuIniWrite(koyuNumber, "E06S", E06S)
	KoyuIniWrite(koyuNumber, "E07S", E07S)
	KoyuIniWrite(koyuNumber, "E08S", E08S)
	KoyuIniWrite(koyuNumber, "E09S", E09S)
	KoyuIniWrite(koyuNumber, "E10S", E10S)
	KoyuIniWrite(koyuNumber, "E11S", E11S)
	KoyuIniWrite(koyuNumber, "E12S", E12S)
	KoyuIniWrite(koyuNumber, "E13S", E13S)

	KoyuIniWrite(koyuNumber, "D01S", D01S)
	KoyuIniWrite(koyuNumber, "D02S", D02S)
	KoyuIniWrite(koyuNumber, "D03S", D03S)
	KoyuIniWrite(koyuNumber, "D04S", D04S)
	KoyuIniWrite(koyuNumber, "D05S", D05S)
	KoyuIniWrite(koyuNumber, "D06S", D06S)
	KoyuIniWrite(koyuNumber, "D07S", D07S)
	KoyuIniWrite(koyuNumber, "D08S", D08S)
	KoyuIniWrite(koyuNumber, "D09S", D09S)
	KoyuIniWrite(koyuNumber, "D10S", D10S)
	KoyuIniWrite(koyuNumber, "D11S", D11S)
	KoyuIniWrite(koyuNumber, "D12S", D12S)

	KoyuIniWrite(koyuNumber, "C01S", C01S)
	KoyuIniWrite(koyuNumber, "C02S", C02S)
	KoyuIniWrite(koyuNumber, "C03S", C03S)
	KoyuIniWrite(koyuNumber, "C04S", C04S)
	KoyuIniWrite(koyuNumber, "C05S", C05S)
	KoyuIniWrite(koyuNumber, "C06S", C06S)
	KoyuIniWrite(koyuNumber, "C07S", C07S)
	KoyuIniWrite(koyuNumber, "C08S", C08S)
	KoyuIniWrite(koyuNumber, "C09S", C09S)
	KoyuIniWrite(koyuNumber, "C10S", C10S)
	KoyuIniWrite(koyuNumber, "C11S", C11S)
	KoyuIniWrite(koyuNumber, "C12S", C12S)

	KoyuIniWrite(koyuNumber, "B01S", B01S)
	KoyuIniWrite(koyuNumber, "B02S", B02S)
	KoyuIniWrite(koyuNumber, "B03S", B03S)
	KoyuIniWrite(koyuNumber, "B04S", B04S)
	KoyuIniWrite(koyuNumber, "B05S", B05S)
	KoyuIniWrite(koyuNumber, "B06S", B06S)
	KoyuIniWrite(koyuNumber, "B07S", B07S)
	KoyuIniWrite(koyuNumber, "B08S", B08S)
	KoyuIniWrite(koyuNumber, "B09S", B09S)
	KoyuIniWrite(koyuNumber, "B10S", B10S)
	KoyuIniWrite(koyuNumber, "B11S", B11S)

	KoyuRegist()	; 固有名詞ショートカットの登録
	Return
}
