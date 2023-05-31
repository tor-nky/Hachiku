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
;	3キー同時押し配列 初期設定
; **********************************************************************

#NoEnv						; 変数名を解釈するとき、環境変数を無視する
SetBatchLines, -1			; 自動Sleepなし
ListLines, Off				; スクリプトの実行履歴を取らない
SetKeyDelay, -1, -1			; キーストローク間のディレイを変更
;Process, Priority, , High	; スクリプトを実行するプロセスの優先度を上げる
#MenuMaskKey vk07			; Win または Alt の押下解除時のイベントを隠蔽するためのキーを変更する
#UseHook					; ホットキーはすべてフックを使用する
Thread, Interrupt, 15, 12	; スレッド開始から15ミリ秒ないし12行以内の割り込みを、絶対禁止
SetStoreCapslockMode, Off	; Sendコマンド実行時にCapsLockの状態を自動的に変更しない

;SetFormat, Integer, H		; 数値演算の結果を、16進数の整数による文字列で表現する
;CoordMode, ToolTip, Screen	; ToolTipの表示座標の扱いをスクリーン上での絶対座標にする

#HotkeyInterval 1000		; 指定時間(ミリ秒単位)の間に実行できる最大のホットキー数
#MaxHotkeysPerInterval 120	; 指定時間の間に実行できる最大のホットキー数


; ----------------------------------------------------------------------
; 配列定義で使う定数	Int64型定数
;	関数内では #IncludeAgain %A_ScriptDir%/Sub/KeyBit_h.ahk で利用可能
; ----------------------------------------------------------------------
; キーを64bitの各ビットに割り当てる
; 右側の数字は仮想キーコードになっている
KC_1	:= 1 << 0x02
KC_2	:= 1 << 0x03
KC_3	:= 1 << 0x04
KC_4	:= 1 << 0x05
KC_5	:= 1 << 0x06
KC_6	:= 1 << 0x07

KC_7	:= 1 << 0x08
KC_8	:= 1 << 0x09
KC_9	:= 1 << 0x0A
KC_0	:= 1 << 0x0B
KC_MINS	:= 1 << 0x0C
KC_EQL	:= 1 << 0x0D
JP_YEN	:= 1 << 0x37	; sc7D

KC_Q	:= 1 << 0x10
KC_W	:= 1 << 0x11
KC_E	:= 1 << 0x12
KC_R	:= 1 << 0x13
KC_T	:= 1 << 0x14

KC_Y	:= 1 << 0x15
KC_U	:= 1 << 0x16
KC_I	:= 1 << 0x17
KC_O	:= 1 << 0x18
KC_P	:= 1 << 0x19
KC_LBRC	:= 1 << 0x1A
KC_RBRC	:= 1 << 0x1B

KC_A	:= 1 << 0x1E
KC_S	:= 1 << 0x1F
KC_D	:= 1 << 0x20
KC_F	:= 1 << 0x21
KC_G	:= 1 << 0x22

KC_H	:= 1 << 0x23
KC_J	:= 1 << 0x24
KC_K	:= 1 << 0x25
KC_L	:= 1 << 0x26
KC_SCLN	:= 1 << 0x27
KC_QUOT	:= 1 << 0x28
KC_GRV	:= 1 << 0x29
KC_NUHS	:= 1 << 0x2B
KC_BSLS	:= 1 << 0x2B

KC_Z	:= 1 << 0x2C
KC_X	:= 1 << 0x2D
KC_C	:= 1 << 0x2E
KC_V	:= 1 << 0x2F
KC_B	:= 1 << 0x30

KC_N	:= 1 << 0x31
KC_M	:= 1 << 0x32
KC_COMM	:= 1 << 0x33
KC_DOT	:= 1 << 0x34
KC_SLSH	:= 1 << 0x35
KC_INT1	:= 1 << 0x38	; sc73

KC_SPC	:= 1 << 0x39

; リピート定義用
R := "Repeat"		; String型定数

; ----------------------------------------------------------------------
; 共用変数(メニュー用は別途)
; ----------------------------------------------------------------------
lastSendTime := 0.0	; Double型		最後に出力した時間
kanaMode := 0		; Bool型		0: 英数入力, 1: かな入力
layoutNameE := ""	; String型		英語配列の名前
layoutName := ""	; String型		かな配列の名前
kanaGroup := ""		; String型		配列定義のグループ名 ※0または空はグループなし
; かな配列の入れ物
defsKey := []		; [Int64]型		キービットの集合
defsGroup := []		; [String]型	定義のグループ名
defsKanaMode := []	; [Int]型		0: 英数入力用, 1: かな入力用
defsTateStr := []	; [String]型	縦書き用定義
defsYokoStr := []	; [String]型	横書き用定義
defsCtrlName := []	; [String]型	0または空: なし, R: リピートできる, 他: 特別出力(かな定義ファイルで操作)
defsCombinableBit := []	; [Int64]型
defBegin := [1, 1, 1]	; [Int]型	定義の始め 1キー, 2キー同時, 3キー同時
defEnd	:= [1, 1, 1]	; [Int]型	定義の終わり+1 1キー, 2キー同時, 3キー同時
; 入力バッファ
inBufsKey := []		; [String]型
inBufsTime := []	; [Double]型	入力の時間
inBufReadPos := 0	; Int型			読み出し位置
inBufWritePos := 0	; Int型			書き込み位置
inBufRest := 31		; Int型
; 仮出力バッファ
outStrs := []		; [String]型
outCtrlNames := []	; [String]型
outStrsLength := 0	; Int型			保存されている個数
restStr := ""		; [String]型

goodHwnd := badHwnd := 0	;  Int型	IME窓の検出可否

; ----------------------------------------------------------------------
; 設定ファイル読み込み
; ----------------------------------------------------------------------

; スクリプトのパス名の拡張子をiniに付け替え、スペースを含んでいたら""でくくる
iniFilePath := Path_RenameExtension(A_ScriptFullPath, "ini")	; String型

; 参考: https://so-zou.jp/software/tool/system/auto-hot-key/commands/file.htm
; [general]
; バージョン記録
	IniRead, iniVersion, %iniFilePath%, general, Version, ""

; [Basic]
; IMESelect		0または空: MS-IME専用, 1: ATOK使用, 他: Google 日本語入力
	IniRead, imeSelect, %iniFilePath%, Basic, IMESelect, 0
; UsingKeyConfig	0または空: なし, 他: あり
	IniRead, usingKeyConfig, %iniFilePath%, Basic, UsingKeyConfig, 0
; USLike		0以下または空: 英数表記通り, 他: USキーボード風配列
	IniRead, usLike, %iniFilePath%, Basic, USLike, 0
; SideShift		左右シフト	1以下または空: 英数２, 他: かな
	IniRead, sideShift, %iniFilePath%, Basic, SideShift, 1
; EnterShift	0または空: 通常のエンター, 他: エンター同時押しをシフトとして扱う
	IniRead, enterShift, %iniFilePath%, Basic, EnterShift, 0
; ShiftDelay	0または空: 通常シフト, 1-200: 後置シフトの待ち時間(ミリ秒)
	IniRead, shiftDelay, %iniFilePath%, Basic, ShiftDelay, 0
; CombDelay		0または空: 同時押しは時間無制限
; 				1-200: シフト中の同時打鍵判定時間(ミリ秒)
	IniRead, combDelay, %iniFilePath%, Basic, CombDelay, 50
; SpaceKeyRepeat	スペースキーの長押し	0または空: 何もしない, 1: 空白キャンセル, 他: 空白リピート
	IniRead, spaceKeyRepeat, %iniFilePath%, Basic, SpaceKeyRepeat, 0

; [Naginata]
; Vertical		0または空: 横書き用, 他: 縦書き用
	IniRead, vertical, %iniFilePath%, Naginata, Vertical, 1
; 固有名詞ショートカットの選択
	IniRead, koyuNumber, %iniFilePath%, Naginata, KoyuNumber, 1

; [Advanced]
;	通常時
;		同時打鍵の判定期限	0または空: なし, 他: あり
		IniRead, combLimitN, %iniFilePath%, Advanced, CombLimitN, 0
;		文字キーシフト		0または空: ずっと, 1: 途切れるまで, 2: 同グループのみ継続, 3: 1回のみ ※他は1と同じ
		IniRead, combStyleN, %iniFilePath%, Advanced, CombStyleN, 3
;		キーを離すと		0または空: 全復活, 1: そのまま, 2: 全部出力済みなら解除 ※他は1と同じ
		IniRead, combKeyUpN, %iniFilePath%, Advanced, CombKeyUpN, 0
;	スペース押下時
;		同時打鍵の判定期限	0または空: なし, 他: あり
		IniRead, combLimitS, %iniFilePath%, Advanced, CombLimitS, 1
;		文字キーシフト		0または空: ずっと, 1: 途切れるまで, 2: 同グループのみ継続, 3: 1回のみ ※他は1と同じ
		IniRead, combStyleS, %iniFilePath%, Advanced, CombStyleS, 3
;		キーを離すと		0または空: 全復活, 1: そのまま, 2: 全部出力済みなら解除 ※他は1と同じ
		IniRead, combKeyUpS, %iniFilePath%, Advanced, CombKeyUpS, 2
;	英数時の同時打鍵期限を強制する	0または空: なし, 他: あり
		IniRead, combLimitE, %iniFilePath%, Advanced, CombLimitE, 0
;	スペースキーを離した時の設定	0または空: 通常時, 他: スペース押下時
		IniRead, combKeyUpSPC, %iniFilePath%, Advanced, CombKeyUpSPC, 1
; キーを離せば常に全部出力する	0または空: いいえ, 他: はい
	IniRead, keyUpToOutputAll, %iniFilePath%, Advanced, KeyUpToOutputAll, 0
; 英数入力時のSandS		0または空: なし, 他: あり
	IniRead, eisuSandS, %iniFilePath%, Advanced, EisuSandS, 1
; テスト表示	1: 処理時間, 2: 表示待ち文字列, 3: 出力文字列, 他: なし ※iniになければ設定画面に表示しない
	IniRead, testMode, %iniFilePath%, Advanced, TestMode

; 範囲外は初期値へ
	If (shiftDelay < 0)
		shiftDelay := 0
	If (combDelay < 0)
		combDelay := 0

; ----------------------------------------------------------------------
; かな配列読み込み
; ----------------------------------------------------------------------
	; キーボードドライバを調べて keyDriver に格納する
	; 参考: https://ixsvr.dyndns.org/blog/764
	RegRead, keyDriver, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Services\i8042prt\Parameters, LayerDriver JPN
	USKB := (keyDriver = "kbd101.dll" ? True : False)	; Bool型

	ReadLayout()	; かな配列読み込み
	SettingLayout()	; 出力確定する定義に印をつける
	DetectIME()

; ----------------------------------------------------------------------
; メニューで使う変数	Bool型
; ----------------------------------------------------------------------
	; [Basic]
	imeSelect0 := (imeSelect == 0 ? 1 : 0)
	imeSelect1 := (imeSelect == 1 ? 1 : 0)
	imeSelect2 := (imeSelect == 2 ? 1 : 0)
	sideShift1 := (sideShift <= 1 ? 1 : 0)
	sideShift2 := (sideShift > 1 ? 1 : 0)
	enterShift0 := (!enterShift ? 1 : 0)
	enterShift1 := (enterShift 1 ? 1 : 0)
	spaceKeyRepeat0 := (spaceKeyRepeat == 0 ? 1 : 0)
	spaceKeyRepeat1 := (spaceKeyRepeat == 1 ? 1 : 0)
	spaceKeyRepeat2 := (spaceKeyRepeat == 2 ? 1 : 0)
	; [Advanced]
	combStyleN0 := (combStyleN == 0 ? 1 : 0)
	combStyleN1 := (combStyleN == 1 ? 1 : 0)
	combStyleN2 := (combStyleN == 2 ? 1 : 0)
	combStyleN3 := (combStyleN == 3 ? 1 : 0)
	combKeyUpN0 := (combKeyUpN == 0 ? 1 : 0)
	combKeyUpN1 := (combKeyUpN == 1 ? 1 : 0)
	combKeyUpN2 := (combKeyUpN == 2 ? 1 : 0)
	combStyleS0 := (combStyleS == 0 ? 1 : 0)
	combStyleS1 := (combStyleS == 1 ? 1 : 0)
	combStyleS2 := (combStyleS == 2 ? 1 : 0)
	combStyleS3 := (combStyleS == 3 ? 1 : 0)
	combKeyUpS0 := (combKeyUpS == 0 ? 1 : 0)
	combKeyUpS1 := (combKeyUpS == 1 ? 1 : 0)
	combKeyUpS2 := (combKeyUpS == 2 ? 1 : 0)
	combKeyUpSPC0 := (!combKeyUpSPC ? 1 : 0)
	combKeyUpSPC1 := (combKeyUpSPC ? 1 : 0)
	If (testMode != "ERROR")
	{
		testMode0 := (testMode == 0 ? 1 : 0)
		testMode1 := (testMode == 1 ? 1 : 0)
		testMode2 := (testMode == 2 ? 1 : 0)
		testMode3 := (testMode == 3 ? 1 : 0)
	}

; ----------------------------------------------------------------------
; メニュー表示
; ----------------------------------------------------------------------
	; ツールチップを変更する
	If (layoutNameE)
		Menu, TRAY, Tip, Hachiku %version%`n%layoutNameE%`n+ %layoutName%`n固有名詞セット%koyuNumber%
	Else
		Menu, TRAY, Tip, Hachiku %version%`n%layoutName%`n固有名詞セット%koyuNumber%
	; 標準メニュー項目を削除する
	Menu, TRAY, NoStandard

	; 薙刀式配列用メニュー
	If (IsFunc("KoyuRegist"))	; 関数 KoyuRegist が存在するか
	{
		; 縦書きモード切替を追加
		Menu, TRAY, Add, 縦書きモード, VerticalMode
		ChangeVertical(vertical)
		; 「固有名詞」編集画面を追加
		Menu, TRAY, Add, 固有名詞登録, KoyuMenu
	}

	Menu, TRAY, Add, 設定..., PrefMenu	; 設定画面を追加
	Menu, TRAY, Add						; セパレーター
	Menu, TRAY, Add, ログ表示, DispLog	; ログ
	Menu, TRAY, Add						; セパレーター
	Menu, TRAY, Standard	; 標準メニュー項目を追加する

	; iniファイルがなけれは設定画面を表示
	If (!Path_FileExists(iniFilePath))
		Gosub, PrefMenu

; ----------------------------------------------------------------------
; スクリプト終了時に実行させたいサブルーチンを指定
; ----------------------------------------------------------------------
OnExit, ExitSub

Exit	; 起動時はここまで実行

; ----------------------------------------------------------------------
; スクリプト終了時に実行するサブルーチン
; ----------------------------------------------------------------------
ExitSub:
	SendKeyUp()	; キーの押し残しを出力する
	ExitApp

; ----------------------------------------------------------------------
; メニュー動作
; ----------------------------------------------------------------------
; 参考: https://rcmdnk.com/blog/2017/11/07/computer-windows-autohotkey/

; 縦書きモード切替
VerticalMode:
	Menu, TRAY, ToggleCheck, 縦書きモード
	ChangeVertical(vertical == 0 ? 1 : 0)
	Return

ButtonOK:
	Gui, Submit
	; [general]
	iniVersion := version
	; [Basic]
	imeSelect := (imeSelect0 ? 0 : (imeSelect1 ? 1 : 2))
	sideShift := (sideShift1 ? 1 : 2)
	enterShift := (enterShift0 ? 0 : 1)
	spaceKeyRepeat := (spaceKeyRepeat0 ? 0 : (spaceKeyRepeat1 ? 1 : 2))
	; [Advanced]
	combStyleN := (combStyleN0 ? 0 : (combStyleN1 ? 1 : (combStyleN2 ? 2 : 3)))
	combKeyUpN := (combKeyUpN0 ? 0 : (combKeyUpN1 ? 1 : 2))
	combStyleS := (combStyleS0 ? 0 : (combStyleS1 ? 1 : (combStyleS2 ? 2 : 3)))
	combKeyUpS := (combKeyUpS0 ? 0 : (combKeyUpS1 ? 1 : 2))
	combKeyUpSPC := (combKeyUpSPC0 ? 0 : 1)
	If (testMode != "ERROR")
		testMode := (testMode0 ? 0 : (testMode1 ? 1 : (testMode2 ? 2 : 3)))
	; 設定ファイル書き込み
	; [general]
	IniWrite, %iniVersion%, %iniFilePath%, general, Version
	; [Basic]
	IniWrite, %imeSelect%, %iniFilePath%, Basic, IMESelect
	IniWrite, %usingKeyConfig%, %iniFilePath%, Basic, UsingKeyConfig
	IniWrite, %usLike%, %iniFilePath%, Basic, USLike
	IniWrite, %sideShift%, %iniFilePath%, Basic, SideShift
	IniWrite, %enterShift%, %iniFilePath%, Basic, EnterShift
	IniWrite, %shiftDelay%, %iniFilePath%, Basic, ShiftDelay
	IniWrite, %combDelay%, %iniFilePath%, Basic, CombDelay
	IniWrite, %spaceKeyRepeat%, %iniFilePath%, Basic, SpaceKeyRepeat
	; [Naginata]
	IniWrite, %vertical%, %iniFilePath%, Naginata, Vertical
	IniWrite, %koyuNumber%, %iniFilePath%, Naginata, KoyuNumber
	; [Advanced]
	IniWrite, %combLimitN%, %iniFilePath%, Advanced, CombLimitN
	IniWrite, %combStyleN%, %iniFilePath%, Advanced, CombStyleN
	IniWrite, %combKeyUpN%, %iniFilePath%, Advanced, CombKeyUpN
	IniWrite, %combLimitS%, %iniFilePath%, Advanced, CombLimitS
	IniWrite, %combStyleS%, %iniFilePath%, Advanced, CombStyleS
	IniWrite, %combKeyUpS%, %iniFilePath%, Advanced, CombKeyUpS
	IniWrite, %combLimitE%, %iniFilePath%, Advanced, CombLimitE
	IniWrite, %combKeyUpSPC%, %iniFilePath%, Advanced, CombKeyUpSPC
	IniWrite, %keyUpToOutputAll%, %iniFilePath%, Advanced, KeyUpToOutputAll
	IniWrite, %eisuSandS%, %iniFilePath%, Advanced, EisuSandS
	If (testMode != "ERROR")
		IniWrite, %testMode%, %iniFilePath%, Advanced, TestMode

	Menu, TRAY, Icon, *	; トレイアイコンをいったん起動時のものに
	DeleteDefs()		; 配列定義をすべて消去する
	ReadLayout()		; かな配列読み込み
	SettingLayout()		; 出力確定する定義に印をつける
	; 関数 KoyuRegist が存在したらトレイアイコン変更
	If (IsFunc("KoyuRegist"))
		ChangeVertical(vertical)
GuiEscape:
ButtonCancel:
ButtonClose:
GuiClose:
	; IME窓の検出可否をリセット
	goodHwnd := badHwnd := 0
	Gui, Destroy
	Return

; 設定画面
PrefMenu:
	Gui, Destroy
	Gui, -MinimizeBox
	Gui, Add, Text, , 設定

	Gui, Add, Text, x+200 W180 Right, %version%
	Gui, Add, Tab2, xm+140 y+0 Section Buttons Center, 基本|キー|同時打鍵

	; 「基本」メニュー
	Gui, Tab, 基本
		; IMEの選択
		Gui, Add, Text, xm ys+40, IMEの選択
		Gui, Add, Radio, xm+68 yp+0 Group VimeSelect0, MS-IME
		Gui, Add, Radio, x+0 VimeSelect1, ATOK
		Gui, Add, Radio, x+0 VimeSelect2, Google
		If (imeSelect0)
			GuiControl, , imeSelect0, 1
		Else If (imeSelect1)
			GuiControl, , imeSelect1, 1
		Else
			GuiControl, , imeSelect2, 1
		; キー設定利用
		Gui, Add, Checkbox, xm+18 y+5 VusingKeyConfig, キー設定利用 (Ctrl+Shift+変換⇒全確定、Ctrl+Shift+無変換⇒全消去)
		If (usingKeyConfig)
			GuiControl, , usingKeyConfig, 1
		; 後置シフトの待ち時間
		Gui, Add, Text, xm y+15, 後置シフトの待ち時間
		Gui, Add, Edit, xm+132 yp-3 W45
		Gui, Add, UpDown, VshiftDelay Range0-200, %shiftDelay%
		Gui, Add, Text, x+5 yp+3, ミリ秒
		; テストモード
		If (testMode != "ERROR")
		{
			Gui, Add, Text, xm ys+172, テスト表示
			Gui, Add, Radio, xm+75 yp+0 Group VtestMode0, なし
			Gui, Add, Radio, x+0 VtestMode1, 処理時間
			Gui, Add, Radio, x+0 VtestMode2, 表示待ち文字列
			Gui, Add, Radio, x+0 VtestMode3, 出力文字列
			If (testMode0)
				GuiControl, , testMode0, 1
			Else If (testMode1)
				GuiControl, , testMode1, 1
			Else If (testMode2)
				GuiControl, , testMode2, 1
			Else
				GuiControl, , testMode3, 1
		}
	; 「キー」メニュー
	Gui, Tab, キー
		; 記号をUSキーボード風にする
		; 関数 USLikeLayout が存在したら
		If (IsFunc("USLikeLayout"))
		{
			Gui, Add, Checkbox, xm y+10 VusLike, 記号をUSキーボード風にする
			If (usLike)
				GuiControl, , usLike, 1
			Gui, Add, Text, xm+18 y+1, ※ 日本語キーボードの時のみ有効です
		}
		; 左右シフト
		Gui, Add, Text, xm y+10, 左右シフト
		Gui, Add, Radio, xm+68 yp+0 Group VsideShift1, 英数
		Gui, Add, Radio, x+0 VsideShift2, かな
		If (sideShift1)
			GuiControl, , sideShift1, 1
		Else
			GuiControl, , sideShift2, 1
		; エンター
		Gui, Add, Text, xm y+5, エンター
		Gui, Add, Radio, xm+68 yp+0 Group VenterShift0, 通常
		Gui, Add, Radio, x+0 VenterShift1, 同時押しシフト
		If (enterShift0)
			GuiControl, , enterShift0, 1
		Else
			GuiControl, , enterShift1, 1
		; スペースキーの長押し
		Gui, Add, Text, xm y+10, スペースキーの長押し
		Gui, Add, Radio, xm+18 y+3 Group VspaceKeyRepeat0, 何もしない
		Gui, Add, Radio, x+0 VspaceKeyRepeat1, 空白キャンセル
		Gui, Add, Radio, x+0 VspaceKeyRepeat2, 空白リピート
		If (spaceKeyRepeat0)
			GuiControl, , spaceKeyRepeat0, 1
		Else If (spaceKeyRepeat1)
			GuiControl, , spaceKeyRepeat1, 1
		Else
			GuiControl, , spaceKeyRepeat2, 1
		; 英数入力時のSandS
		Gui, Add, Checkbox, xm y+15 VeisuSandS, 英数入力時のSandS
		If (eisuSandS)
			GuiControl, , eisuSandS, 1
		; キーを離せば常に全部出力する
		Gui, Add, Checkbox, xm y+15 VkeyUpToOutputAll, キーを離せば常に全部出力する
		If (keyUpToOutputAll)
			GuiControl, , keyUpToOutputAll, 1
	; 「同時打鍵」メニュー
	Gui, Tab, 同時打鍵
		; 同時打鍵判定
		Gui, Add, Text, xm y+10, 同時打鍵判定
		Gui, Add, Edit, xm+95 yp-3 W45
		Gui, Add, UpDown, VcombDelay Range0-200, %combDelay%
		Gui, Add, Text, x+5 yp+3, ミリ秒 ※ 0 は無制限
		; 通常
		Gui, Add, Text, xm+10 y+10, 通常
			; 判定期限
			Gui, Add, Checkbox, xm+95 yp+0 VcombLimitN, 判定期限
			If (combLimitN)
				GuiControl, , combLimitN, 1
			; 文字キーシフト
			Gui, Add, Text, xm+20 y+5, 文字キーシフト
			Gui, Add, Radio, xm+105 yp+0 Group VcombStyleN0, ずっと
			Gui, Add, Radio, x+0 VcombStyleN1, 途切れるまで
			Gui, Add, Radio, x+0 VcombStyleN2, 同グループのみ継続
			Gui, Add, Radio, x+0 VcombStyleN3, 1回のみ
			If (combStyleN0)
				GuiControl, , combStyleN0, 1
			Else If (combStyleN1)
				GuiControl, , combStyleN1, 1
			Else If (combStyleN2)
				GuiControl, , combStyleN2, 1
			Else
				GuiControl, , combStyleN3, 1
			; キーを離すと
			Gui, Add, Text, xm+20 y+5, キーを離すと
			Gui, Add, Radio, xm+105 yp+0 Group VcombKeyUpN0, 全復活
			Gui, Add, Radio, x+0 VcombKeyUpN1, そのまま
			Gui, Add, Radio, x+0 VcombKeyUpN2, 全部出力済みなら解除
			If (combKeyUpN0)
				GuiControl, , combKeyUpN0, 1
			Else If (combKeyUpN1)
				GuiControl, , combKeyUpN1, 1
			Else
				GuiControl, , combKeyUpN2, 1
		; スペース押下時
		Gui, Add, Text, xm+10 y+5, スペース押下時
			; 判定期限
			Gui, Add, Checkbox, xm+95 yp+0 VcombLimitS, 判定期限
			If (combLimitS)
				GuiControl, , combLimitS, 1
			; 文字キーシフト
			Gui, Add, Text, xm+20 y+5, 文字キーシフト
			Gui, Add, Radio, xm+105 yp+0 Group VcombStyleS0, ずっと
			Gui, Add, Radio, x+0 VcombStyleS1, 途切れるまで
			Gui, Add, Radio, x+0 VcombStyleS2, 同グループのみ継続
			Gui, Add, Radio, x+0 VcombStyleS3, 1回のみ
			If (combStyleS0)
				GuiControl, , combStyleS0, 1
			Else If (combStyleS1)
				GuiControl, , combStyleS1, 1
			Else If (combStyleS2)
				GuiControl, , combStyleS2, 1
			Else
				GuiControl, , combStyleS3, 1
			; キーを離すと
			Gui, Add, Text, xm+20 y+5, キーを離すと
			Gui, Add, Radio, xm+105 yp+0 Group VcombKeyUpS0, 全復活
			Gui, Add, Radio, x+0 VcombKeyUpS1, そのまま
			Gui, Add, Radio, x+0 VcombKeyUpS2, 全部出力済みなら解除
			If (combKeyUpS0)
				GuiControl, , combKeyUpS0, 1
			Else If (combKeyUpS1)
				GuiControl, , combKeyUpS1, 1
			Else
				GuiControl, , combKeyUpS2, 1
		; 英数入力時
		Gui, Add, Text, xm+10 y+5, 英数入力時
			; 判定期限ありを強制する
			Gui, Add, Checkbox, xm+95 yp+0 VcombLimitE, 判定期限ありを強制する ※文字キーシフトは1回のみとなる
			If (combLimitE)
				GuiControl, , combLimitE, 1
		; スペースキーを離した時の設定
		Gui, Add, Text, xm+10 y+5, スペースキーを離した時の設定
			Gui, Add, Radio, xm+160 yp+0 Group VcombKeyUpSPC0, 通常時
			Gui, Add, Radio, x+0 VcombKeyUpSPC1, スペース押下時
			If (combKeyUpSPC0)
				GuiControl, , combKeyUpSPC0, 1
			Else
				GuiControl, , combKeyUpSPC1, 1

	Gui, Tab
	Gui, Add, Button, W60 xm+146 ys+200 Default, OK
	Gui, Add, Button, W60 x+0, Cancel

	Gui, Show
	Return

; ログ表示
DispLog:
	DispLogFunc()
	Return
; ログ表示(本体)
DispLogFunc()	; () -> Void型
{
	global inBufsKey, inBufReadPos, inBufsTime, USKB, testMode
;	local scanCodeArray					; [String]型
;		, lastKeyTime, keyTime, diff	; Double型
;		, pos, number					; Int型
;		, str, c, preStr, term, temp	; String型

	; USキーボード
	If (USKB)
		scanCodeArray := ["Esc", "1", "2", "3", "4", "5", "6", "7", "8", "9", "Ø", "-", "=", "BackSpace", "Tab"
			, "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]", "", "", "A", "S"
			, "D", "F", "G", "H", "J", "K", "L", ";", "'", "`", "LShift", "\", "Z", "X", "C", "V"
			, "B", "N", "M", ",", ".", "/", "", "", "", "Space", "CapsLock", "F1", "F2", "F3", "F4", "F5"
			, "F6", "F7", "F8", "F9", "F10", "Pause", "ScrollLock", "", "", "", "", "", "", "", "", ""
			, "", "", "", "", "SysRq", "", "KC_NUBS", "F11", "F12", "(Mac)=", "", "", "(NEC),", "", "", ""
			, "", "", "", "", "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20", "F21", "F22", "F23", ""
			, "(JIS)ひらがな", "(Mac)英数", "(Mac)かな", "(JIS)_", "", "", "F24", "KC_LANG4"
			, "KC_LANG3", "(JIS)変換", "", "(JIS)無変換", "", "(JIS)￥", "(Mac),", ""]
	; USキーボード以外
	Else
		scanCodeArray := ["Esc", "1", "2", "3", "4", "5", "6", "7", "8", "9", "Ø", "-", "^", "BackSpace", "Tab"
			, "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "@", "[", "", "", "A", "S"
			, "D", "F", "G", "H", "J", "K", "L", ";", ":", "半角/全角", "LShift", "]", "Z", "X", "C", "V"
			, "B", "N", "M", ",", ".", "/", "", "", "", "Space", "英数", "F1", "F2", "F3", "F4", "F5"
			, "F6", "F7", "F8", "F9", "F10", "Pause", "ScrollLock", "", "", "", "", "", "", "", "", ""
			, "", "", "", "", "SysRq", "", "KC_NUBS", "F11", "F12", "(Mac)=", "", "", "(NEC),", "", "", ""
			, "", "", "", "", "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20", "F21", "F22", "F23", ""
			, "(JIS)ひらがな", "(Mac)英数", "(Mac)かな", "(JIS)_", "", "", "F24", "KC_LANG4"
			, "KC_LANG3", "(JIS)変換", "", "(JIS)無変換", "", "(JIS)￥", "(Mac),", ""]

	Gui, Destroy
	Gui, -MinimizeBox
	Gui, Add, Text, xm, ≪ログ≫
	lastKeyTime := 0.0
	pos := inBufReadPos
	While ((pos := ++pos & 31) != inBufReadPos)
	{
		str := inBufsKey[pos], keyTime := inBufsTime[pos]
		If (str)
		{
			; 時間を書き出し
			If (lastKeyTime)
			{
				If (testMode != "ERROR")
					diff := round(keyTime - lastKeyTime, 1)
				Else
					diff := round(keyTime - lastKeyTime)
				Gui, Add, Text, xm, % "(" . diff . "ms) "
			}
			Else
				Gui, Add, Text, xm

			; 修飾キー
			preStr := ""
			While (c := SubStr(str, 1, 1))
			{
				If (c == "+" || c == "^" || c == "!" || c == "#"
				 || c == "<" || c == ">")
				{
					; 先頭の文字を分離
					preStr .= c
					str := SubStr(str, 2)
				}
				Else If (c == "*" || c == "~" || c == "$")
					; 表示させたくない先頭の文字を消去
					str := SubStr(str, 2)
				Else
					Break
			}
			; キーの上げ下げを調べる
			StringRight, term, str, 3	; term に入力末尾の2文字を入れる
			If (term = " up")
			{
				; キーが離されたとき
				term := "↑"
				str := SubStr(str, 1, StrLen(str) - 3)
			}
			Else
				term := ""

			; 書き出し
			If (str = "KeyTimer")
				str := "[KeyTimer]"
			Else If (str = "vk1A")
				str := "(Mac)英数"
			Else If (str = "vk16")
				str := "(Mac)かな"
			Else If (SubStr(str, 1, 2) = "sc")
			{
				number := "0x" . SubStr(str, 3, 2)
				temp := scanCodeArray[number]
				If (temp != "")
					str := temp
			}
			Gui, Add, Text, xm+60 yp, % preStr . str . term
		}
		; 押した時間を保存
		lastKeyTime := keyTime
	}
	Gui, Add, Button, W60 xm+30 y+10 Default, Close
	Gui, Show
	Return
}
