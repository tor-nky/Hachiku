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
	; 固有名詞ショートカットの書き込み・登録
	KoyuWriteAndRegist(koyuNumber)
	; 出力確定する定義に印をつける
	RecordCombinable()
KoyuCancel:
	Gui, Destroy
	Return

; 「固有名詞」編集画面
KoyuMenu:
	Gui, Destroy
	Gui, Add, Text, , 固有名詞ショートカット設定
;	Gui, Add, Text, x+15, 〈セット%koyuNumber%〉
	Gui, Add, Tab2, xm+560 y+0 Section Buttons Center, 第一面|第二面

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


	Gui, Tab, 第二面
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
KoyuIniRead(number, keyName)	; (number: Int, keyName: String) -> String
{
	global iniFilePath
;	local i		; Int型
;		, c, strChopped, strIn, strOut	; String型

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
KoyuIniWrite(number, keyName, strIn:="")	; (number: Int, keyName: Srting, strIn: String) -> Void
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
KoyuReadAndRegist(number)	; (number: Int) -> Void
{
	#IncludeAgain %A_ScriptDir%/Sub/Naginata-Koyu_h.ahk

	E01 := KoyuIniRead(number, "E01")
	E02 := KoyuIniRead(number, "E02")
	E03 := KoyuIniRead(number, "E03")
	E04 := KoyuIniRead(number, "E04")
	E05 := KoyuIniRead(number, "E05")
	E06 := KoyuIniRead(number, "E06")
	E07 := KoyuIniRead(number, "E07")
	E08 := KoyuIniRead(number, "E08")
	E09 := KoyuIniRead(number, "E09")
	E10 := KoyuIniRead(number, "E10")
	E11 := KoyuIniRead(number, "E11")
	E12 := KoyuIniRead(number, "E12")
	E13 := KoyuIniRead(number, "E13")

	D01 := KoyuIniRead(number, "D01")
	D02 := KoyuIniRead(number, "D02")
	D03 := KoyuIniRead(number, "D03")
	D04 := KoyuIniRead(number, "D04")
	D05 := KoyuIniRead(number, "D05")
	D06 := KoyuIniRead(number, "D06")
	D07 := KoyuIniRead(number, "D07")
	D08 := KoyuIniRead(number, "D08")
	D09 := KoyuIniRead(number, "D09")
	D10 := KoyuIniRead(number, "D10")
	D11 := KoyuIniRead(number, "D11")
	D12 := KoyuIniRead(number, "D12")

	C01 := KoyuIniRead(number, "C01")
	C02 := KoyuIniRead(number, "C02")
	C03 := KoyuIniRead(number, "C03")
	C04 := KoyuIniRead(number, "C04")
	C05 := KoyuIniRead(number, "C05")
	C06 := KoyuIniRead(number, "C06")
	C07 := KoyuIniRead(number, "C07")
	C08 := KoyuIniRead(number, "C08")
	C09 := KoyuIniRead(number, "C09")
	C10 := KoyuIniRead(number, "C10")
	C11 := KoyuIniRead(number, "C11")
	C12 := KoyuIniRead(number, "C12")

	B01 := KoyuIniRead(number, "B01")
	B02 := KoyuIniRead(number, "B02")
	B03 := KoyuIniRead(number, "B03")
	B04 := KoyuIniRead(number, "B04")
	B05 := KoyuIniRead(number, "B05")
	B06 := KoyuIniRead(number, "B06")
	B07 := KoyuIniRead(number, "B07")
	B08 := KoyuIniRead(number, "B08")
	B09 := KoyuIniRead(number, "B09")
	B10 := KoyuIniRead(number, "B10")
	B11 := KoyuIniRead(number, "B11")

	E01S := KoyuIniRead(number, "E01S")
	E02S := KoyuIniRead(number, "E02S")
	E03S := KoyuIniRead(number, "E03S")
	E04S := KoyuIniRead(number, "E04S")
	E05S := KoyuIniRead(number, "E05S")
	E06S := KoyuIniRead(number, "E06S")
	E07S := KoyuIniRead(number, "E07S")
	E08S := KoyuIniRead(number, "E08S")
	E09S := KoyuIniRead(number, "E09S")
	E10S := KoyuIniRead(number, "E10S")
	E11S := KoyuIniRead(number, "E11S")
	E12S := KoyuIniRead(number, "E12S")
	E13S := KoyuIniRead(number, "E13S")

	D01S := KoyuIniRead(number, "D01S")
	D02S := KoyuIniRead(number, "D02S")
	D03S := KoyuIniRead(number, "D03S")
	D04S := KoyuIniRead(number, "D04S")
	D05S := KoyuIniRead(number, "D05S")
	D06S := KoyuIniRead(number, "D06S")
	D07S := KoyuIniRead(number, "D07S")
	D08S := KoyuIniRead(number, "D08S")
	D09S := KoyuIniRead(number, "D09S")
	D10S := KoyuIniRead(number, "D10S")
	D11S := KoyuIniRead(number, "D11S")
	D12S := KoyuIniRead(number, "D12S")

	C01S := KoyuIniRead(number, "C01S")
	C02S := KoyuIniRead(number, "C02S")
	C03S := KoyuIniRead(number, "C03S")
	C04S := KoyuIniRead(number, "C04S")
	C05S := KoyuIniRead(number, "C05S")
	C06S := KoyuIniRead(number, "C06S")
	C07S := KoyuIniRead(number, "C07S")
	C08S := KoyuIniRead(number, "C08S")
	C09S := KoyuIniRead(number, "C09S")
	C10S := KoyuIniRead(number, "C10S")
	C11S := KoyuIniRead(number, "C11S")
	C12S := KoyuIniRead(number, "C12S")

	B01S := KoyuIniRead(number, "B01S")
	B02S := KoyuIniRead(number, "B02S")
	B03S := KoyuIniRead(number, "B03S")
	B04S := KoyuIniRead(number, "B04S")
	B05S := KoyuIniRead(number, "B05S")
	B06S := KoyuIniRead(number, "B06S")
	B07S := KoyuIniRead(number, "B07S")
	B08S := KoyuIniRead(number, "B08S")
	B09S := KoyuIniRead(number, "B09S")
	B10S := KoyuIniRead(number, "B10S")
	B11S := KoyuIniRead(number, "B11S")

	KoyuRegist()	; 固有名詞ショートカットの登録
	Return
}

; 固有名詞ショートカットの書き込み・登録
KoyuWriteAndRegist(number)	; (number: Int) -> Void
{
	#IncludeAgain %A_ScriptDir%/Sub/Naginata-Koyu_h.ahk

	; 固有名詞ショートカットの書き出し
	KoyuIniWrite(number, "E01", E01)
	KoyuIniWrite(number, "E02", E02)
	KoyuIniWrite(number, "E03", E03)
	KoyuIniWrite(number, "E04", E04)
	KoyuIniWrite(number, "E05", E05)
	KoyuIniWrite(number, "E06", E06)
	KoyuIniWrite(number, "E07", E07)
	KoyuIniWrite(number, "E08", E08)
	KoyuIniWrite(number, "E09", E09)
	KoyuIniWrite(number, "E10", E10)
	KoyuIniWrite(number, "E11", E11)
	KoyuIniWrite(number, "E12", E12)
	KoyuIniWrite(number, "E13", E13)

	KoyuIniWrite(number, "D01", D01)
	KoyuIniWrite(number, "D02", D02)
	KoyuIniWrite(number, "D03", D03)
	KoyuIniWrite(number, "D04", D04)
	KoyuIniWrite(number, "D05", D05)
	KoyuIniWrite(number, "D06", D06)
	KoyuIniWrite(number, "D07", D07)
	KoyuIniWrite(number, "D08", D08)
	KoyuIniWrite(number, "D09", D09)
	KoyuIniWrite(number, "D10", D10)
	KoyuIniWrite(number, "D11", D11)
	KoyuIniWrite(number, "D12", D12)

	KoyuIniWrite(number, "C01", C01)
	KoyuIniWrite(number, "C02", C02)
	KoyuIniWrite(number, "C03", C03)
	KoyuIniWrite(number, "C04", C04)
	KoyuIniWrite(number, "C05", C05)
	KoyuIniWrite(number, "C06", C06)
	KoyuIniWrite(number, "C07", C07)
	KoyuIniWrite(number, "C08", C08)
	KoyuIniWrite(number, "C09", C09)
	KoyuIniWrite(number, "C10", C10)
	KoyuIniWrite(number, "C11", C11)
	KoyuIniWrite(number, "C12", C12)

	KoyuIniWrite(number, "B01", B01)
	KoyuIniWrite(number, "B02", B02)
	KoyuIniWrite(number, "B03", B03)
	KoyuIniWrite(number, "B04", B04)
	KoyuIniWrite(number, "B05", B05)
	KoyuIniWrite(number, "B06", B06)
	KoyuIniWrite(number, "B07", B07)
	KoyuIniWrite(number, "B08", B08)
	KoyuIniWrite(number, "B09", B09)
	KoyuIniWrite(number, "B10", B10)
	KoyuIniWrite(number, "B11", B11)

	KoyuIniWrite(number, "E01S", E01S)
	KoyuIniWrite(number, "E02S", E02S)
	KoyuIniWrite(number, "E03S", E03S)
	KoyuIniWrite(number, "E04S", E04S)
	KoyuIniWrite(number, "E05S", E05S)
	KoyuIniWrite(number, "E06S", E06S)
	KoyuIniWrite(number, "E07S", E07S)
	KoyuIniWrite(number, "E08S", E08S)
	KoyuIniWrite(number, "E09S", E09S)
	KoyuIniWrite(number, "E10S", E10S)
	KoyuIniWrite(number, "E11S", E11S)
	KoyuIniWrite(number, "E12S", E12S)
	KoyuIniWrite(number, "E13S", E13S)

	KoyuIniWrite(number, "D01S", D01S)
	KoyuIniWrite(number, "D02S", D02S)
	KoyuIniWrite(number, "D03S", D03S)
	KoyuIniWrite(number, "D04S", D04S)
	KoyuIniWrite(number, "D05S", D05S)
	KoyuIniWrite(number, "D06S", D06S)
	KoyuIniWrite(number, "D07S", D07S)
	KoyuIniWrite(number, "D08S", D08S)
	KoyuIniWrite(number, "D09S", D09S)
	KoyuIniWrite(number, "D10S", D10S)
	KoyuIniWrite(number, "D11S", D11S)
	KoyuIniWrite(number, "D12S", D12S)

	KoyuIniWrite(number, "C01S", C01S)
	KoyuIniWrite(number, "C02S", C02S)
	KoyuIniWrite(number, "C03S", C03S)
	KoyuIniWrite(number, "C04S", C04S)
	KoyuIniWrite(number, "C05S", C05S)
	KoyuIniWrite(number, "C06S", C06S)
	KoyuIniWrite(number, "C07S", C07S)
	KoyuIniWrite(number, "C08S", C08S)
	KoyuIniWrite(number, "C09S", C09S)
	KoyuIniWrite(number, "C10S", C10S)
	KoyuIniWrite(number, "C11S", C11S)
	KoyuIniWrite(number, "C12S", C12S)

	KoyuIniWrite(number, "B01S", B01S)
	KoyuIniWrite(number, "B02S", B02S)
	KoyuIniWrite(number, "B03S", B03S)
	KoyuIniWrite(number, "B04S", B04S)
	KoyuIniWrite(number, "B05S", B05S)
	KoyuIniWrite(number, "B06S", B06S)
	KoyuIniWrite(number, "B07S", B07S)
	KoyuIniWrite(number, "B08S", B08S)
	KoyuIniWrite(number, "B09S", B09S)
	KoyuIniWrite(number, "B10S", B10S)
	KoyuIniWrite(number, "B11S", B11S)

	KoyuRegist()	; 固有名詞ショートカットの登録
	Return
}
