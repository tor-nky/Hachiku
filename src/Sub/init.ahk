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
;SetKeyDelay, 10, 0			; キーストローク間のディレイを変更
#MenuMaskKey vk07			; Win または Alt の押下解除時のイベントを隠蔽するためのキーを変更する
#UseHook					; ホットキーはすべてフックを使用する
Thread, interrupt, 15, 6	; スレッド開始から15ミリ秒ないし6行以内の割り込みを、絶対禁止
SetStoreCapslockMode, off	; Sendコマンド実行時にCapsLockの状態を自動的に変更しない

;SetFormat, Integer, H		; 数値演算の結果を、16進数の整数による文字列で表現する
;CoordMode, ToolTip, Screen	; ToolTipの表示座標の扱いをスクリーン上での絶対座標にする

; ----------------------------------------------------------------------
; 配列定義で使う定数
;	関数内では #IncludeAgain %A_ScriptDir%/Sub/KeyBit_h.ahk を利用
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
R := 1

; ----------------------------------------------------------------------
; 共用変数(メニュー用は別途)
; ----------------------------------------------------------------------
KanaGroup := 0		; かな配列定義のグループ。0 はグループAll
; かな配列の入れ物
DefsKey := []		; キービットの集合
DefsGroup := []		; 定義のグループ番号 ※0はグループAll
DefsKanaMode := []	; 0: 英数入力用, 1: かな入力用
DefsTateStr := []	; 縦書き用定義
DefsYokoStr := []	; 横書き用定義
DefsCtrlNo := []	; 0: なし, 1: リピートできる, 2以上: 特別出力(かな定義ファイルで操作)
DefsSetted := []	; 0: 出力確定しない,
					; 1: 通常シフトのみ出力確定, 2: どちらのシフトも出力確定
DefBegin := [1, 1, 1]	; 定義の始め 1キー, 2キー同時, 3キー同時
DefEnd	:= [1, 1, 1]	; 定義の終わり+1 1キー, 2キー同時, 3キー同時
; 入力バッファ
InBufsKey := []
InBufsTime := []	; 入力の時間
InBufReadPos := 0	; 読み出し位置
InBufWritePos := 0	; 書き込み位置
InBufRest := 15
; 仮出力バッファ
OutStrs := []
OutCtrlNos := []
_usc := 0			; 保存されている文字数

; キーボードドライバを調べて KeyDriver に格納する
; 参考: https://ixsvr.dyndns.org/blog/764
RegRead, KeyDriver, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Services\i8042prt\Parameters, LayerDriver JPN
USKB := (KeyDriver = "kbd101.dll" ? True : False)
USKBSideShift := (USKB == True && SideShift > 0 ? True : False)

; ----------------------------------------------------------------------
; 設定ファイル読み込み
; ----------------------------------------------------------------------

; スクリプトのパス名の拡張子をiniに付け替え、スペースを含んでいたら""でくくる
IniFilePath := Path_QuoteSpaces(Path_RenameExtension(A_ScriptFullPath, "ini"))

; 参考: https://so-zou.jp/software/tool/system/auto-hot-key/commands/file.htm
; バージョン記録
	IniRead, INIVersion, %IniFilePath%, general, Version, ""
; Vertical		0: 横書き用, 1: 縦書き用
	IniRead, Vertical, %IniFilePath%, general, Vertical, 1
; IMESelect			0: MS-IME専用, 1: ATOK対応
	IniRead, IMESelect, %IniFilePath%, general, IMESelect, 0
; USLike 0: 英数表記通り, 1: USキーボード風配列
	IniRead, USLike, %IniFilePath%, general, USLike, 0
; SideShift		0-1: 左右シフト英数, 2: 左右シフトかな
	IniRead, SideShift, %IniFilePath%, general, SideShift, 2
; EnterShift	0: 通常のエンター, 1: エンター同時押しをシフトとして扱う
	IniRead, EnterShift, %IniFilePath%, general, EnterShift, 0
; ShiftDelay	0: 通常シフト, 1-200: 後置シフトの待ち時間(ミリ秒)
	IniRead, ShiftDelay, %IniFilePath%, general, ShiftDelay, 0
; CombDelay		0: 同時押しは時間無制限
; 				1-200: シフト中の同時打鍵判定時間(ミリ秒)
	IniRead, CombDelay, %IniFilePath%, general, CombDelay, 60
; 固有名詞ショートカットの選択
	IniRead, KoyuNumber, %IniFilePath%, general, KoyuNumber, 1

; TestMode		0: なし, 1: あり
	IniRead, TestMode, %IniFilePath%, test, TestMode, 0
; DispTime		0: なし, 1: 処理時間表示あり
	IniRead, INIDispTime, %IniFilePath%, test, DispTime, 0

; ----------------------------------------------------------------------
; かな配列読み込み
; ----------------------------------------------------------------------
	ReadLayout()	; かな配列読み込み
	SettingLayout()	; 出力確定する定義に印をつける

; ----------------------------------------------------------------------
; メニューで使う変数
; ----------------------------------------------------------------------
SideShift0 := (SideShift == 0 ? 1 : 0)
SideShift1 := (SideShift == 1 ? 1 : 0)
SideShift2 := (SideShift == 2 ? 1 : 0)
EnterShift0 := (EnterShift == 0 ? 1 : 0)
EnterShift1 := (EnterShift == 1 ? 1 : 0)

; ----------------------------------------------------------------------
; メニュー表示
; ----------------------------------------------------------------------
	menu, tray, tip, Hachiku`n%Version%
	; タスクトレイメニューの標準メニュー項目を解除
	menu, tray, NoStandard

	; 薙刀式配列用メニュー
	if (IsFunc("KoyuRegist"))	; 関数 KoyuRegist が存在したら
	{
		; 縦書きモード切替を追加
		menu, tray, add, 縦書きモード, VerticalMode
		if (Vertical)
			menu, tray, Check, 縦書きモード	; “縦書きモード”にチェックを付ける
		; 「固有名詞」編集画面を追加
		menu, tray, add, 固有名詞登録, KoyuMenu
	}

	; 設定画面を追加
	menu, tray, add, 設定..., PrefMenu
	; セパレーター
	menu, tray, add
	; 標準メニュー項目を追加
	menu, tray, Standard

	; バージョンアップ後、初めての起動時は設定画面を表示
	if (INIVersion != Version)
		Gosub, PrefMenu

exit	; 起動時はここまで実行

; ----------------------------------------------------------------------
; メニュー動作
; ----------------------------------------------------------------------
; 参考: https://rcmdnk.com/blog/2017/11/07/computer-windows-autohotkey/

; 縦書きモード切替
VerticalMode:
	menu, tray, ToggleCheck, 縦書きモード
	Vertical := (Vertical == 0 ? 1 : 0)
	; 設定ファイル書き込み
	IniWrite, %Vertical%, %IniFilePath%, general, Vertical
return

ButtonOK:
	Gui, Submit
	INIVersion := Version
	if (SideShift0)
		SideShift := 0
	else if (SideShift1)
		SideShift := 1
	else
		SideShift := 2
	USKBSideShift := (USKB == True && SideShift > 0 ? True : False)	; 更新
	EnterShift := (EnterShift0 == 1 ? 0 : 1)
	; 設定ファイル書き込み
	IniWrite, %INIVersion%, %IniFilePath%, general, Version
	IniWrite, %IMESelect%, %IniFilePath%, general, IMESelect
	IniWrite, %USLike%, %IniFilePath%, general, USLike
	IniWrite, %SideShift%, %IniFilePath%, general, SideShift
	IniWrite, %EnterShift%, %IniFilePath%, general, EnterShift
	IniWrite, %ShiftDelay%, %IniFilePath%, general, ShiftDelay
	IniWrite, %CombDelay%, %IniFilePath%, general, CombDelay
	if (TestMode)
		IniWrite, %INIDispTime%, %IniFilePath%, test, DispTime
	ShiftDelay += 0.0
	CombDelay += 0.0
	ReadLayout()	; かな配列読み込み
	SettingLayout()	; 出力確定する定義に印をつける
ButtonCancel:
GuiClose:
	Gui, Destroy
	return

; 設定画面
PrefMenu:
	Gui, Destroy
	Gui, -MinimizeBox
	Gui, Add, Text, , 設定
	Gui, Add, Text, x+0 W180 Right, %Version%

	Gui, Add, Checkbox, xm vIMESelect, ATOK対応
	if (IMESelect)
		GuiControl, , IMESelect, 1

	if (IsFunc("USLikeLayout"))	; 関数 USLikeLayout が存在したら
	{
		Gui, Add, Checkbox, xm vUSLike, 記号をUSキーボード風にする
		if (USLike)
			GuiControl, , USLike, 1
		Gui, Add, Text, xm+18 y+1, ※ 日本語キーボードの時のみ有効です
		Gui, Add, Text, xm+18 y+1, ※ 左右シフトかなに設定してください
	}

	Gui, Add, Text, xm y+10, 左右シフト
	Gui, Add, Radio, xm+68 yp+0 Group vSideShift0, 英数
	if (TestMode)
		Gui, Add, Radio, x+0 vSideShift1, 英数2
	Gui, Add, Radio, x+0 vSideShift2, かな
	if (SideShift0)
		GuiControl, , SideShift0, 1
	else if (SideShift1)
		GuiControl, , SideShift1, 1
	else
		GuiControl, , SideShift2, 1

	Gui, Add, Text, xm, エンター
	Gui, Add, Radio, xm+68 yp+0 Group vEnterShift0, 通常
	Gui, Add, Radio, x+0 vEnterShift1, 同時押しシフト
	if (EnterShift0)
		GuiControl, , EnterShift0, 1
	else
		GuiControl, , EnterShift1, 1

	Gui, Add, Text, xm y+15, 後置シフトの待ち時間
	Gui, Add, Edit, xm+128 yp-3 W45
	Gui, Add, UpDown, vShiftDelay Range0-200, %ShiftDelay%
	Gui, Add, Text, x+5 yp+3, ミリ秒

	Gui, Add, Text, xm y+15, シフト中の同時打鍵判定
	Gui, Add, Edit, xm+128 yp-3 W45
	Gui, Add, UpDown, vCombDelay Range0-200, %CombDelay%
	Gui, Add, Text, x+5 yp+3, ミリ秒
	Gui, Add, Text, xm+18 y+1, ※ 0 は無制限

	if (TestMode)
	{
		Gui, Add, Checkbox, xm vINIDispTime, 処理時間表示
		if (INIDispTime)
			GuiControl, , INIDispTime, 1
	}

	Gui, Add, Button, W60 xm+45 y+10 Default, OK
	Gui, Add, Button, W60 x+0, Cancel
	Gui, Show

	return
