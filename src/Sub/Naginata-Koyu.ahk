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

; **********************************************************************
;	固有名詞ショートカット関連
; **********************************************************************

class KoyuMeishi
{
	; 「固有名詞」編集画面
	Edit()
	{
		this.menu := Gui()
		this.menu.Add("Text", , "固有名詞ショートカット設定")
		this.menu.Add("Text", "x+15", "〈セット" . pref.koyuNumber . "〉")
		tab := this.menu.Add("Tab2", "xm+560 y+0 Section Buttons Center", ["第一面", "第二面"])

	; 第一面
	; E列
		this.menu.Add("Text", "xm+0 ys+25 W90 Center", "1")
		this.menu.Add("Text", "xp+95 W92 Center", "2")
		this.menu.Add("Text", "xp+95 W92 Center", "3")
		this.menu.Add("Text", "xp+95 W92 Center", "4")
		this.menu.Add("Text", "xp+95 W92 Center", "5")
		this.menu.Add("Text", "xp+115 W92 Center", "6")
		this.menu.Add("Text", "xp+95 W92 Center", "7")
		this.menu.Add("Text", "xp+95 W92 Center", "8")
		this.menu.Add("Text", "xp+95 W92 Center", "9")
		this.menu.Add("Text", "xp+95 W92 Center", "0")
		this.menu.Add("Text", "xp+95 W92 Center", "-")
		this.menu.Add("Text", "xp+95 W92 Center", "^  (US)=")
		this.menu.Add("Text", "xp+95 W92 Center", "\  (US)＼")

		this.menu.Add("Edit", "xm+0 y+2 W92 R2.4 -VScroll vE01", this.E01)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE02", this.E02)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE03", this.E03)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE04", this.E04)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE05", this.E05)
		this.menu.Add("Edit", "xp+115 W92 R2.4 -VScroll vE06", this.E06)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE07", this.E07)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE08", this.E08)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE09", this.E09)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE10", this.E10)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE11", this.E11)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE12", this.E12)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE13", this.E13)

	; D列
		this.menu.Add("Text", "xm+0 y+15 W92 Center", "Q")
		this.menu.Add("Text", "xp+95 W92 Center", "W")
		this.menu.Add("Text", "xp+95 W92 Center", "E")
		this.menu.Add("Text", "xp+95 W92 Center", "R")
		this.menu.Add("Text", "xp+95 W92 Center", "T")
		this.menu.Add("Text", "xp+115 W92 Center", "Y")
		this.menu.Add("Text", "xp+95 W92 Center", "U")
		this.menu.Add("Text", "xp+95 W92 Center", "I")
		this.menu.Add("Text", "xp+95 W92 Center", "O")
		this.menu.Add("Text", "xp+95 W92 Center", "P")
		this.menu.Add("Text", "xp+95 W92 Center", "@  (US)[")
		this.menu.Add("Text", "xp+95 W92 Center", "[  (US)]")

		this.menu.Add("Edit", "xm+0 y+2 W92 R2.4 -VScroll vD01", this.D01)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD02", this.D02)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD03", this.D03)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD04", this.D04)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD05", this.D05)
		this.menu.Add("Edit", "xp+115 W92 R2.4 -VScroll vD06", this.D06)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD07", this.D07)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD08", this.D08)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD09", this.D09)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD10", this.D10)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD11", this.D11)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD12", this.D12)

	; C列
		this.menu.Add("Text", "xm+0 y+15 W92 Center", "A")
		this.menu.Add("Text", "xp+95 W92 Center", "S")
		this.menu.Add("Text", "xp+95 W92 Center", "D")
		this.menu.Add("Text", "xp+95 W92 Center", "F")
		this.menu.Add("Text", "xp+95 W92 Center", "G")
		this.menu.Add("Text", "xp+115 W92 Center", "H")
		this.menu.Add("Text", "xp+95 W92 Center", "J")
		this.menu.Add("Text", "xp+95 W92 Center", "K")
		this.menu.Add("Text", "xp+95 W92 Center", "L")
		this.menu.Add("Text", "xp+95 W92 Center", "`;")
		this.menu.Add("Text", "xp+95 W92 Center", ":  (US)'")
		this.menu.Add("Text", "xp+95 W92 Center", "]  (US)``")

		this.menu.Add("Edit", "xm+0 y+2 W92 R2.4 -VScroll vC01", this.C01)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC02", this.C02)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC03", this.C03)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC04", this.C04)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC05", this.C05)
		this.menu.Add("Edit", "xp+115 W92 R2.4 -VScroll vC06", this.C06)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC07", this.C07)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC08", this.C08)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC09", this.C09)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC10", this.C10)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC11", this.C11)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC12", this.C12)

	; B列
		this.menu.Add("Text", "xm+0 y+15 W92 Center", "Z")
		this.menu.Add("Text", "xp+95 W92 Center", "X")
		this.menu.Add("Text", "xp+95 W92 Center", "C")
		this.menu.Add("Text", "xp+95 W92 Center", "V")
		this.menu.Add("Text", "xp+95 W92 Center", "B")
		this.menu.Add("Text", "xp+115 W92 Center", "N")
		this.menu.Add("Text", "xp+95 W92 Center", "M")
		this.menu.Add("Text", "xp+95 W92 Center", "`,")
		this.menu.Add("Text", "xp+95 W92 Center", "`.")
		this.menu.Add("Text", "xp+95 W92 Center", "/")
		this.menu.Add("Text", "xp+95 W92 Center", "_  (US)なし")

		this.menu.Add("Edit", "xm+0 y+2 W92 R2.4 -VScroll vB01", this.B01)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB02", this.B02)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB03", this.B03)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB04", this.B04)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB05", this.B05)
		this.menu.Add("Edit", "xp+115 W92 R2.4 -VScroll vB06", this.B06)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB07", this.B07)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB08", this.B08)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB09", this.B09)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB10", this.B10)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB11", this.B11)


	; 第二面
		tab.UseTab(2)
	; E列
		this.menu.Add("Text", "xm+0 ys+25 W90 Center", "1")
		this.menu.Add("Text", "xp+95 W92 Center", "2")
		this.menu.Add("Text", "xp+95 W92 Center", "3")
		this.menu.Add("Text", "xp+95 W92 Center", "4")
		this.menu.Add("Text", "xp+95 W92 Center", "5")
		this.menu.Add("Text", "xp+115 W92 Center", "6")
		this.menu.Add("Text", "xp+95 W92 Center", "7")
		this.menu.Add("Text", "xp+95 W92 Center", "8")
		this.menu.Add("Text", "xp+95 W92 Center", "9")
		this.menu.Add("Text", "xp+95 W92 Center", "0")
		this.menu.Add("Text", "xp+95 W92 Center", "-")
		this.menu.Add("Text", "xp+95 W92 Center", "^  (US)=")
		this.menu.Add("Text", "xp+95 W92 Center", "\  (US)＼")

		this.menu.Add("Edit", "xm+0 y+2 W92 R2.4 -VScroll vE01S", this.E01S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE02S", this.E02S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE03S", this.E03S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE04S", this.E04S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE05S", this.E05S)
		this.menu.Add("Edit", "xp+115 W92 R2.4 -VScroll vE06S", this.E06S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE07S", this.E07S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE08S", this.E08S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE09S", this.E09S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE10S", this.E10S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE11S", this.E11S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE12S", this.E12S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vE13S", this.E13S)

	; D列
		this.menu.Add("Text", "xm+0 y+15 W92 Center", "Q")
		this.menu.Add("Text", "xp+95 W92 Center", "W")
		this.menu.Add("Text", "xp+95 W92 Center", "E")
		this.menu.Add("Text", "xp+95 W92 Center", "R")
		this.menu.Add("Text", "xp+95 W92 Center", "T")
		this.menu.Add("Text", "xp+115 W92 Center", "Y")
		this.menu.Add("Text", "xp+95 W92 Center", "U")
		this.menu.Add("Text", "xp+95 W92 Center", "I")
		this.menu.Add("Text", "xp+95 W92 Center", "O")
		this.menu.Add("Text", "xp+95 W92 Center", "P")
		this.menu.Add("Text", "xp+95 W92 Center", "@  (US)[")
		this.menu.Add("Text", "xp+95 W92 Center", "[  (US)]")

		this.menu.Add("Edit", "xm+0 y+2 W92 R2.4 -VScroll vD01S", this.D01S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD02S", this.D02S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD03S", this.D03S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD04S", this.D04S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD05S", this.D05S)
		this.menu.Add("Edit", "xp+115 W92 R2.4 -VScroll vD06S", this.D06S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD07S", this.D07S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD08S", this.D08S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD09S", this.D09S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD10S", this.D10S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD11S", this.D11S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vD12S", this.D12S)

	; C列
		this.menu.Add("Text", "xm+0 y+15 W92 Center", "A")
		this.menu.Add("Text", "xp+95 W92 Center", "S")
		this.menu.Add("Text", "xp+95 W92 Center", "D")
		this.menu.Add("Text", "xp+95 W92 Center", "F")
		this.menu.Add("Text", "xp+95 W92 Center", "G")
		this.menu.Add("Text", "xp+115 W92 Center", "H")
		this.menu.Add("Text", "xp+95 W92 Center", "J")
		this.menu.Add("Text", "xp+95 W92 Center", "K")
		this.menu.Add("Text", "xp+95 W92 Center", "L")
		this.menu.Add("Text", "xp+95 W92 Center", "`;")
		this.menu.Add("Text", "xp+95 W92 Center", ":  (US)'")
		this.menu.Add("Text", "xp+95 W92 Center", "]  (US)``")

		this.menu.Add("Edit", "xm+0 y+2 W92 R2.4 -VScroll vC01S", this.C01S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC02S", this.C02S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC03S", this.C03S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC04S", this.C04S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC05S", this.C05S)
		this.menu.Add("Edit", "xp+115 W92 R2.4 -VScroll vC06S", this.C06S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC07S", this.C07S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC08S", this.C08S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC09S", this.C09S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC10S", this.C10S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC11S", this.C11S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vC12S", this.C12S)

	; B列
		this.menu.Add("Text", "xm+0 y+15 W92 Center", "Z")
		this.menu.Add("Text", "xp+95 W92 Center", "X")
		this.menu.Add("Text", "xp+95 W92 Center", "C")
		this.menu.Add("Text", "xp+95 W92 Center", "V")
		this.menu.Add("Text", "xp+95 W92 Center", "B")
		this.menu.Add("Text", "xp+115 W92 Center", "N")
		this.menu.Add("Text", "xp+95 W92 Center", "M")
		this.menu.Add("Text", "xp+95 W92 Center", "`,")
		this.menu.Add("Text", "xp+95 W92 Center", "`.")
		this.menu.Add("Text", "xp+95 W92 Center", "/")
		this.menu.Add("Text", "xp+95 W92 Center", "_  (US)なし")

		this.menu.Add("Edit", "xm+0 y+2 W92 R2.4 -VScroll vB01S", this.B01S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB02S", this.B02S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB03S", this.B03S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB04S", this.B04S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB05S", this.B05S)
		this.menu.Add("Edit", "xp+115 W92 R2.4 -VScroll vB06S", this.B06S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB07S", this.B07S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB08S", this.B08S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB09S", this.B09S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB10S", this.B10S)
		this.menu.Add("Edit", "xp+95 W92 R2.4 -VScroll vB11S", this.B11S)

		tab.UseTab()	; あとのコントロールはタブに属さない
		this.menu.Add("Button", "W60 xm+566 y+15", "OK").OnEvent("Click", Okay)
		this.menu.Add("Button", "W60 x+0", "Cancel").OnEvent("Click", Cancel)
		this.menu.OnEvent("Escape", Cancel)
		this.menu.Show()

		Cancel(*)
		{
			this.menu.Destroy()
		}

		; 「固有名詞」画面のOKボタン
		Okay(*)
		{
			Saved := this.menu.Submit()	; 名前付きコントロールの内容を、オブジェクトに保存
			this.menu.Destroy()

			; 値をコピー
			this.E01 := Saved.E01
			this.E02 := Saved.E02
			this.E03 := Saved.E03
			this.E04 := Saved.E04
			this.E05 := Saved.E05
			this.E06 := Saved.E06
			this.E07 := Saved.E07
			this.E08 := Saved.E08
			this.E09 := Saved.E09
			this.E10 := Saved.E10
			this.E11 := Saved.E11
			this.E12 := Saved.E12
			this.E13 := Saved.E13

			this.D01 := Saved.D01
			this.D02 := Saved.D02
			this.D03 := Saved.D03
			this.D04 := Saved.D04
			this.D05 := Saved.D05
			this.D06 := Saved.D06
			this.D07 := Saved.D07
			this.D08 := Saved.D08
			this.D09 := Saved.D09
			this.D10 := Saved.D10
			this.D11 := Saved.D11
			this.D12 := Saved.D12

			this.C01 := Saved.C01
			this.C02 := Saved.C02
			this.C03 := Saved.C03
			this.C04 := Saved.C04
			this.C05 := Saved.C05
			this.C06 := Saved.C06
			this.C07 := Saved.C07
			this.C08 := Saved.C08
			this.C09 := Saved.C09
			this.C10 := Saved.C10
			this.C11 := Saved.C11
			this.C12 := Saved.C12

			this.B01 := Saved.B01
			this.B02 := Saved.B02
			this.B03 := Saved.B03
			this.B04 := Saved.B04
			this.B05 := Saved.B05
			this.B06 := Saved.B06
			this.B07 := Saved.B07
			this.B08 := Saved.B08
			this.B09 := Saved.B09
			this.B10 := Saved.B10
			this.B11 := Saved.B11

			this.E01S := Saved.E01S
			this.E02S := Saved.E02S
			this.E03S := Saved.E03S
			this.E04S := Saved.E04S
			this.E05S := Saved.E05S
			this.E06S := Saved.E06S
			this.E07S := Saved.E07S
			this.E08S := Saved.E08S
			this.E09S := Saved.E09S
			this.E10S := Saved.E10S
			this.E11S := Saved.E11S
			this.E12S := Saved.E12S
			this.E13S := Saved.E13S

			this.D01S := Saved.D01S
			this.D02S := Saved.D02S
			this.D03S := Saved.D03S
			this.D04S := Saved.D04S
			this.D05S := Saved.D05S
			this.D06S := Saved.D06S
			this.D07S := Saved.D07S
			this.D08S := Saved.D08S
			this.D09S := Saved.D09S
			this.D10S := Saved.D10S
			this.D11S := Saved.D11S
			this.D12S := Saved.D12S

			this.C01S := Saved.C01S
			this.C02S := Saved.C02S
			this.C03S := Saved.C03S
			this.C04S := Saved.C04S
			this.C05S := Saved.C05S
			this.C06S := Saved.C06S
			this.C07S := Saved.C07S
			this.C08S := Saved.C08S
			this.C09S := Saved.C09S
			this.C10S := Saved.C10S
			this.C11S := Saved.C11S
			this.C12S := Saved.C12S

			this.B01S := Saved.B01S
			this.B02S := Saved.B02S
			this.B03S := Saved.B03S
			this.B04S := Saved.B04S
			this.B05S := Saved.B05S
			this.B06S := Saved.B06S
			this.B07S := Saved.B07S
			this.B08S := Saved.B08S
			this.B09S := Saved.B09S
			this.B10S := Saved.B10S
			this.B11S := Saved.B11S

			this.Write(pref.koyuNumber)	; 固有名詞ショートカットの書き込み・登録
			SettingLayout()				; 出力確定する定義に印をつける
		}
	}

	; 固有名詞ショートカットの読み込み・登録
	Read(number)	; (number: Int) -> Void
	{
		this.E01 := Read1(number, "E01")
		this.E02 := Read1(number, "E02")
		this.E03 := Read1(number, "E03")
		this.E04 := Read1(number, "E04")
		this.E05 := Read1(number, "E05")
		this.E06 := Read1(number, "E06")
		this.E07 := Read1(number, "E07")
		this.E08 := Read1(number, "E08")
		this.E09 := Read1(number, "E09")
		this.E10 := Read1(number, "E10")
		this.E11 := Read1(number, "E11")
		this.E12 := Read1(number, "E12")
		this.E13 := Read1(number, "E13")

		this.D01 := Read1(number, "D01")
		this.D02 := Read1(number, "D02")
		this.D03 := Read1(number, "D03")
		this.D04 := Read1(number, "D04")
		this.D05 := Read1(number, "D05")
		this.D06 := Read1(number, "D06")
		this.D07 := Read1(number, "D07")
		this.D08 := Read1(number, "D08")
		this.D09 := Read1(number, "D09")
		this.D10 := Read1(number, "D10")
		this.D11 := Read1(number, "D11")
		this.D12 := Read1(number, "D12")

		this.C01 := Read1(number, "C01")
		this.C02 := Read1(number, "C02")
		this.C03 := Read1(number, "C03")
		this.C04 := Read1(number, "C04")
		this.C05 := Read1(number, "C05")
		this.C06 := Read1(number, "C06")
		this.C07 := Read1(number, "C07")
		this.C08 := Read1(number, "C08")
		this.C09 := Read1(number, "C09")
		this.C10 := Read1(number, "C10")
		this.C11 := Read1(number, "C11")
		this.C12 := Read1(number, "C12")

		this.B01 := Read1(number, "B01")
		this.B02 := Read1(number, "B02")
		this.B03 := Read1(number, "B03")
		this.B04 := Read1(number, "B04")
		this.B05 := Read1(number, "B05")
		this.B06 := Read1(number, "B06")
		this.B07 := Read1(number, "B07")
		this.B08 := Read1(number, "B08")
		this.B09 := Read1(number, "B09")
		this.B10 := Read1(number, "B10")
		this.B11 := Read1(number, "B11")

		this.E01S := Read1(number, "E01S")
		this.E02S := Read1(number, "E02S")
		this.E03S := Read1(number, "E03S")
		this.E04S := Read1(number, "E04S")
		this.E05S := Read1(number, "E05S")
		this.E06S := Read1(number, "E06S")
		this.E07S := Read1(number, "E07S")
		this.E08S := Read1(number, "E08S")
		this.E09S := Read1(number, "E09S")
		this.E10S := Read1(number, "E10S")
		this.E11S := Read1(number, "E11S")
		this.E12S := Read1(number, "E12S")
		this.E13S := Read1(number, "E13S")

		this.D01S := Read1(number, "D01S")
		this.D02S := Read1(number, "D02S")
		this.D03S := Read1(number, "D03S")
		this.D04S := Read1(number, "D04S")
		this.D05S := Read1(number, "D05S")
		this.D06S := Read1(number, "D06S")
		this.D07S := Read1(number, "D07S")
		this.D08S := Read1(number, "D08S")
		this.D09S := Read1(number, "D09S")
		this.D10S := Read1(number, "D10S")
		this.D11S := Read1(number, "D11S")
		this.D12S := Read1(number, "D12S")

		this.C01S := Read1(number, "C01S")
		this.C02S := Read1(number, "C02S")
		this.C03S := Read1(number, "C03S")
		this.C04S := Read1(number, "C04S")
		this.C05S := Read1(number, "C05S")
		this.C06S := Read1(number, "C06S")
		this.C07S := Read1(number, "C07S")
		this.C08S := Read1(number, "C08S")
		this.C09S := Read1(number, "C09S")
		this.C10S := Read1(number, "C10S")
		this.C11S := Read1(number, "C11S")
		this.C12S := Read1(number, "C12S")

		this.B01S := Read1(number, "B01S")
		this.B02S := Read1(number, "B02S")
		this.B03S := Read1(number, "B03S")
		this.B04S := Read1(number, "B04S")
		this.B05S := Read1(number, "B05S")
		this.B06S := Read1(number, "B06S")
		this.B07S := Read1(number, "B07S")
		this.B08S := Read1(number, "B08S")
		this.B09S := Read1(number, "B09S")
		this.B10S := Read1(number, "B10S")
		this.B11S := Read1(number, "B11S")

		KoyuRegist()	; 固有名詞ショートカットの登録

		; INIファイルからの読み出し(1個のみ)
		Read1(number, keyName)	; (number: Int, keyName: String) -> String
		{
		;	local i		; Int型
		;		, c, strChopped, strIn, strOut	; String型

			; 設定ファイル読み込み
			strIn := IniRead(pref.iniFilePath, "Koyu" . number, keyName, "")

			strOut := ""
			strChopped := ""
			i := StrLen(strIn)
			While (i > 0)
			{
				c := SubStr(strIn, i, 1)
				If (c == "#")
				{
					; サロゲートペア
					If (strChopped >= 0x10000 && strChopped <= 0x10FFFF)
					{
						strChopped -= 0x10000
						strOut := Chr(0xD800 + (strChopped >> 10)) . Chr(0xDC00 + (strChopped & 0x3FF)) . strOut
					}
					; その他
					Else
					{
						strOut := Chr(strChopped) . strOut
					}
					strChopped := ""
				}
				Else
					strChopped := c . strChopped
				i--
			}
			Return strOut
		}
	}

	; 固有名詞ショートカットの書き込み・登録
	Write(number)	; (number: Int) -> Void
	{
		; 固有名詞ショートカットの書き出し
		Write1(number, "E01", this.E01)
		Write1(number, "E02", this.E02)
		Write1(number, "E03", this.E03)
		Write1(number, "E04", this.E04)
		Write1(number, "E05", this.E05)
		Write1(number, "E06", this.E06)
		Write1(number, "E07", this.E07)
		Write1(number, "E08", this.E08)
		Write1(number, "E09", this.E09)
		Write1(number, "E10", this.E10)
		Write1(number, "E11", this.E11)
		Write1(number, "E12", this.E12)
		Write1(number, "E13", this.E13)

		Write1(number, "D01", this.D01)
		Write1(number, "D02", this.D02)
		Write1(number, "D03", this.D03)
		Write1(number, "D04", this.D04)
		Write1(number, "D05", this.D05)
		Write1(number, "D06", this.D06)
		Write1(number, "D07", this.D07)
		Write1(number, "D08", this.D08)
		Write1(number, "D09", this.D09)
		Write1(number, "D10", this.D10)
		Write1(number, "D11", this.D11)
		Write1(number, "D12", this.D12)

		Write1(number, "C01", this.C01)
		Write1(number, "C02", this.C02)
		Write1(number, "C03", this.C03)
		Write1(number, "C04", this.C04)
		Write1(number, "C05", this.C05)
		Write1(number, "C06", this.C06)
		Write1(number, "C07", this.C07)
		Write1(number, "C08", this.C08)
		Write1(number, "C09", this.C09)
		Write1(number, "C10", this.C10)
		Write1(number, "C11", this.C11)
		Write1(number, "C12", this.C12)

		Write1(number, "B01", this.B01)
		Write1(number, "B02", this.B02)
		Write1(number, "B03", this.B03)
		Write1(number, "B04", this.B04)
		Write1(number, "B05", this.B05)
		Write1(number, "B06", this.B06)
		Write1(number, "B07", this.B07)
		Write1(number, "B08", this.B08)
		Write1(number, "B09", this.B09)
		Write1(number, "B10", this.B10)
		Write1(number, "B11", this.B11)

		Write1(number, "E01S", this.E01S)
		Write1(number, "E02S", this.E02S)
		Write1(number, "E03S", this.E03S)
		Write1(number, "E04S", this.E04S)
		Write1(number, "E05S", this.E05S)
		Write1(number, "E06S", this.E06S)
		Write1(number, "E07S", this.E07S)
		Write1(number, "E08S", this.E08S)
		Write1(number, "E09S", this.E09S)
		Write1(number, "E10S", this.E10S)
		Write1(number, "E11S", this.E11S)
		Write1(number, "E12S", this.E12S)
		Write1(number, "E13S", this.E13S)

		Write1(number, "D01S", this.D01S)
		Write1(number, "D02S", this.D02S)
		Write1(number, "D03S", this.D03S)
		Write1(number, "D04S", this.D04S)
		Write1(number, "D05S", this.D05S)
		Write1(number, "D06S", this.D06S)
		Write1(number, "D07S", this.D07S)
		Write1(number, "D08S", this.D08S)
		Write1(number, "D09S", this.D09S)
		Write1(number, "D10S", this.D10S)
		Write1(number, "D11S", this.D11S)
		Write1(number, "D12S", this.D12S)

		Write1(number, "C01S", this.C01S)
		Write1(number, "C02S", this.C02S)
		Write1(number, "C03S", this.C03S)
		Write1(number, "C04S", this.C04S)
		Write1(number, "C05S", this.C05S)
		Write1(number, "C06S", this.C06S)
		Write1(number, "C07S", this.C07S)
		Write1(number, "C08S", this.C08S)
		Write1(number, "C09S", this.C09S)
		Write1(number, "C10S", this.C10S)
		Write1(number, "C11S", this.C11S)
		Write1(number, "C12S", this.C12S)

		Write1(number, "B01S", this.B01S)
		Write1(number, "B02S", this.B02S)
		Write1(number, "B03S", this.B03S)
		Write1(number, "B04S", this.B04S)
		Write1(number, "B05S", this.B05S)
		Write1(number, "B06S", this.B06S)
		Write1(number, "B07S", this.B07S)
		Write1(number, "B08S", this.B08S)
		Write1(number, "B09S", this.B09S)
		Write1(number, "B10S", this.B10S)
		Write1(number, "B11S", this.B11S)

		KoyuRegist()	; 固有名詞ショートカットの登録

		; INIファイルへの書き出し(1個のみ)
		Write1(number, keyName, strIn:="")	; (number: Int, keyName: Srting, strIn: String) -> Void
		{
		;	local i, len, c, strOut

			If (strIn == "")	; 空白の時は、キーを削除する
				IniDelete pref.iniFilePath, "Koyu" . number , keyName
			Else
			{
				strOut := ""
				i := 1
				len := StrLen(strIn)
				While (i <= len)
				{
					c := Ord(SubStr(strIn, i, 1))
					i++
					strOut .= "#" . c
				}
				; 設定ファイル書き込み
				Try
					IniWrite strOut, pref.iniFilePath, "Koyu" . number, keyName
				Catch OSError
					TrayTip ".ini ファイルに書き込めません"
			}
		}
	}
}
