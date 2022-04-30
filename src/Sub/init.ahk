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
Thread, interrupt, 15, 10	; スレッド開始から15ミリ秒ないし10行以内の割り込みを、絶対禁止
SetStoreCapslockMode, off	; Sendコマンド実行時にCapsLockの状態を自動的に変更しない

;SetFormat, Integer, H		; 数値演算の結果を、16進数の整数による文字列で表現する
;CoordMode, ToolTip, Screen	; ToolTipの表示座標の扱いをスクリーン上での絶対座標にする

#HotkeyInterval 1000		; 指定時間(ミリ秒単位)の間に実行できる最大のホットキー数
#MaxHotkeysPerInterval 120	; 指定時間の間に実行できる最大のホットキー数


; ----------------------------------------------------------------------
; 定数
; ----------------------------------------------------------------------
IME_Get_Interval := 40	; Send から IME_GET までの必要時間(ミリ秒)

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
LastSendTime := 0	; 最後に出力した時間
KanaGroup := 0		; かな配列定義のグループ。0 はグループなし
LayoutName := ""	; かな配列の名前
; かな配列の入れ物
DefsKey := []		; キービットの集合
DefsGroup := []		; 定義のグループ番号 ※0はグループなし
DefsKanaMode := []	; 0: 英数入力用, 1: かな入力用
DefsTateStr := []	; 縦書き用定義
DefsYokoStr := []	; 横書き用定義
DefsCtrlNo := []	; 0: なし, 1: リピートできる, 2以上: 特別出力(かな定義ファイルで操作)
DefsCombinableBit := []	; 0: 出力確定しない,
					; 1: 通常シフトのみ出力確定, 2: どちらのシフトも出力確定
DefBegin := [1, 1, 1]	; 定義の始め 1キー, 2キー同時, 3キー同時
DefEnd	:= [1, 1, 1]	; 定義の終わり+1 1キー, 2キー同時, 3キー同時
; 入力バッファ
InBufsKey := []
InBufsTime := []	; 入力の時間
InBufReadPos := 0	; 読み出し位置
InBufWritePos := 0	; 書き込み位置
InBufRest := 31
; 仮出力バッファ
OutStrs := []
OutCtrlNos := []
_usc := 0			; 保存されている文字数
RestStr := ""

; ----------------------------------------------------------------------
; 設定ファイル読み込み
; ----------------------------------------------------------------------

; スクリプトのパス名の拡張子をiniに付け替え、スペースを含んでいたら""でくくる
IniFilePath := Path_RenameExtension(A_ScriptFullPath, "ini")

; 参考: https://so-zou.jp/software/tool/system/auto-hot-key/commands/file.htm
; [general]
; バージョン記録
	IniRead, INIVersion, %IniFilePath%, general, Version, ""
; AdvancedMenu	0: なし, 1: あり
	IniRead, AdvancedMenu, %IniFilePath%, general, AdvancedMenu, 0

; [Basic]
; IMESelect		0または空: MS-IME専用, 1: ATOK使用, 他: Google 日本語入力
	IniRead, IMESelect, %IniFilePath%, Basic, IMESelect, 0
; USLike		0または空: 英数表記通り, 他: USキーボード風配列
	IniRead, USLike, %IniFilePath%, Basic, USLike, 0
; SideShift		左右シフト	0: 英数, 1: 英数２, 2: かな
	IniRead, SideShift, %IniFilePath%, Basic, SideShift, 2
; EnterShift	0または空: 通常のエンター, 他: エンター同時押しをシフトとして扱う
	IniRead, EnterShift, %IniFilePath%, Basic, EnterShift, 0
; ShiftDelay	0または空: 通常シフト, 1-200: 後置シフトの待ち時間(ミリ秒)
	IniRead, ShiftDelay, %IniFilePath%, Basic, ShiftDelay, 0
; CombDelay		0または空: 同時押しは時間無制限
; 				1-200: シフト中の同時打鍵判定時間(ミリ秒)
	IniRead, CombDelay, %IniFilePath%, Basic, CombDelay, 50
; SpaceKeyRepeat	スペースキーの長押し	0: 何もしない, 1: 空白キャンセル, 他: 空白リピート
	IniRead, SpaceKeyRepeat, %IniFilePath%, Basic, SpaceKeyRepeat, 0

;[Naginata]
; Vertical		0または空: 横書き用, 他: 縦書き用
	IniRead, Vertical, %IniFilePath%, Naginata, Vertical, 1
; 固有名詞ショートカットの選択
	IniRead, KoyuNumber, %IniFilePath%, Naginata, KoyuNumber, 1

; [Advanced]
;	通常時
;		同時打鍵の判定期限	0または空: なし, 他: あり
		IniRead, CombLimitN, %IniFilePath%, Advanced, CombLimitN, 0
;		文字キーシフト		0: ずっと, 1: 途切れるまで, 2: 同グループのみ継続, 3: 1回のみ ※他は1と同じ
		IniRead, CombStyleN, %IniFilePath%, Advanced, CombStyleN, 3
;		キーを離すと		0: 全復活, 1: そのまま, 2: 全解除 ※他は1と同じ
		IniRead, CombKeyUpN, %IniFilePath%, Advanced, CombKeyUpN, 0
;	スペース押下時
;		同時打鍵の判定期限	0または空: なし, 他: あり
		IniRead, CombLimitS, %IniFilePath%, Advanced, CombLimitS, 1
;		文字キーシフト		0: ずっと, 1: 途切れるまで, 2: 同グループのみ継続, 3: 1回のみ ※他は1と同じ
		IniRead, CombStyleS, %IniFilePath%, Advanced, CombStyleS, 3
;		キーを離すと		0: 全復活, 1: そのまま, 2: 全解除 ※他は1と同じ
		IniRead, CombKeyUpS, %IniFilePath%, Advanced, CombKeyUpS, 2
;	英数時の同時打鍵期限を強制する	0または空: なし, 他: あり
		IniRead, CombLimitE, %IniFilePath%, Advanced, CombLimitE, 0
;	スペースキーを離した時の設定	0または空: 通常時, 他: スペース押下時
		IniRead, CombKeyUpSPC, %IniFilePath%, Advanced, CombKeyUpSPC, 1
; キーを離せば常に全部出力する	0または空: いいえ, 他: はい
	IniRead, KeyUpToOutputAll, %IniFilePath%, Advanced, KeyUpToOutputAll, 1
; 英数入力時のSandS		0または空: なし, 他: あり
	IniRead, EisuSandS, %IniFilePath%, Advanced, EisuSandS, 1
; テストモード	1: 処理時間表示, 2: 表示待ち文字列表示, 他: なし ※iniになければ設定画面に表示しない
	IniRead, TestMode, %IniFilePath%, Advanced, TestMode

; 範囲外は初期値へ
	if (SideShift < 0 || SideShift > 2)
		SideShift := 2
	if (ShiftDelay < 0)
		ShiftDelay := 0
	if (CombDelay < 0)
		CombDelay := 0

; ----------------------------------------------------------------------
; かな配列読み込み
; ----------------------------------------------------------------------
	; キーボードドライバを調べて KeyDriver に格納する
	; 参考: https://ixsvr.dyndns.org/blog/764
	RegRead, KeyDriver, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Services\i8042prt\Parameters, LayerDriver JPN
	USKB := (KeyDriver = "kbd101.dll" ? True : False)
	USKBSideShift := (USKB == True && SideShift > 0 ? True : False)

	ReadLayout()	; かな配列読み込み
	SettingLayout()	; 出力確定する定義に印をつける
	DetectIME()

; ----------------------------------------------------------------------
; メニューで使う変数
; ----------------------------------------------------------------------
IMESelect0 := (IMESelect == 0 ? 1 : 0)
IMESelect1 := (IMESelect == 1 ? 1 : 0)
IMESelect2 := (IMESelect == 2 ? 1 : 0)
SideShift0 := (SideShift == 0 ? 1 : 0)
SideShift1 := (SideShift == 1 ? 1 : 0)
SideShift2 := (SideShift == 2 ? 1 : 0)
EnterShift0 := (!EnterShift ? 1 : 0)
EnterShift1 := (EnterShift 1 ? 1 : 0)
SpaceKeyRepeat0 := (SpaceKeyRepeat == 0 ? 1 : 0)
SpaceKeyRepeat1 := (SpaceKeyRepeat == 1 ? 1 : 0)
SpaceKeyRepeat2 := (SpaceKeyRepeat == 2 ? 1 : 0)
if (AdvancedMenu)
{
	CombStyleN0 := (CombStyleN == 0 ? 1 : 0)
	CombStyleN1 := (CombStyleN == 1 ? 1 : 0)
	CombStyleN2 := (CombStyleN == 2 ? 1 : 0)
	CombStyleN3 := (CombStyleN == 3 ? 1 : 0)
	CombKeyUpN0 := (CombKeyUpN == 0 ? 1 : 0)
	CombKeyUpN1 := (CombKeyUpN == 1 ? 1 : 0)
	CombKeyUpN2 := (CombKeyUpN == 2 ? 1 : 0)
	CombStyleS0 := (CombStyleS == 0 ? 1 : 0)
	CombStyleS1 := (CombStyleS == 1 ? 1 : 0)
	CombStyleS2 := (CombStyleS == 2 ? 1 : 0)
	CombStyleS3 := (CombStyleS == 3 ? 1 : 0)
	CombKeyUpS0 := (CombKeyUpS == 0 ? 1 : 0)
	CombKeyUpS1 := (CombKeyUpS == 1 ? 1 : 0)
	CombKeyUpS2 := (CombKeyUpS == 2 ? 1 : 0)
	CombKeyUpSPC0 := (!CombKeyUpSPC ? 1 : 0)
	CombKeyUpSPC1 := (CombKeyUpSPC ? 1 : 0)
}
if (TestMode != "ERROR")
{
	TestMode0 := (TestMode == 0 ? 1 : 0)
	TestMode1 := (TestMode == 1 ? 1 : 0)
	TestMode2 := (TestMode == 2 ? 1 : 0)
}

; ----------------------------------------------------------------------
; メニュー表示
; ----------------------------------------------------------------------
	; ツールチップを変更する
	menu, tray, tip, Hachiku %Version%`n%LayoutName%`n固有名詞セット%KoyuNumber%
	; 標準メニュー項目を削除する
	menu, tray, NoStandard

	; 薙刀式配列用メニュー
	if (IsFunc("KoyuRegist"))	; 関数 KoyuRegist が存在したら
	{
		; 縦書きモード切替を追加
		menu, tray, add, 縦書きモード, VerticalMode
		ChangeVertical(Vertical)
		; 「固有名詞」編集画面を追加
		menu, tray, add, 固有名詞登録, KoyuMenu
	}

	menu, tray, add, 設定..., PrefMenu	; 設定画面を追加
	menu, tray, add						; セパレーター
	menu, tray, add, ログ表示, DispLog	; ログ
	menu, tray, add						; セパレーター
	menu, tray, Standard	; 標準メニュー項目を追加する

	; iniファイルがなけれは設定画面を表示
	if (!Path_FileExists(IniFilePath))
		Gosub, PrefMenu

; ----------------------------------------------------------------------
; スクリプト終了時に実行させたいサブルーチンを指定
; ----------------------------------------------------------------------
OnExit, ExitSub

exit	; 起動時はここまで実行

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
	menu, tray, ToggleCheck, 縦書きモード
	ChangeVertical(Vertical == 0 ? 1 : 0)
	return

ButtonOK:
	Gui, Submit
	INIVersion := Version
	IMESelect := (IMESelect0 ? 0 : (IMESelect1 ? 1 : 2))
	SideShift := (SideShift0 ? 0 : (SideShift1 ? 1 : 2))
	EnterShift := (EnterShift0 ? 0 : 1)
	SpaceKeyRepeat := (SpaceKeyRepeat0 ? 0 : (SpaceKeyRepeat1 ? 1 : 2))
	if (AdvancedMenu)
	{
		CombStyleN := (CombStyleN0 ? 0 : (CombStyleN1 ? 1 : (CombStyleN2 ? 2 : 3)))
		CombKeyUpN := (CombKeyUpN0 ? 0 : (CombKeyUpN1 ? 1 : 2))
		CombStyleS := (CombStyleS0 ? 0 : (CombStyleS1 ? 1 : (CombStyleS2 ? 2 : 3)))
		CombKeyUpS := (CombKeyUpS0 ? 0 : (CombKeyUpS1 ? 1 : 2))
		CombKeyUpSPC := (CombKeyUpSPC0 ? 0 : 1)
	}
	if (TestMode != "ERROR")
		TestMode := (TestMode0 ? 0 : (TestMode1 ? 1 : 2))
	; 設定ファイル書き込み
	IniWrite, %INIVersion%, %IniFilePath%, general, Version
	IniWrite, %AdvancedMenu%, %IniFilePath%, general, AdvancedMenu
	IniWrite, %IMESelect%, %IniFilePath%, Basic, IMESelect
	IniWrite, %USLike%, %IniFilePath%, Basic, USLike
	IniWrite, %SideShift%, %IniFilePath%, Basic, SideShift
	IniWrite, %EnterShift%, %IniFilePath%, Basic, EnterShift
	IniWrite, %ShiftDelay%, %IniFilePath%, Basic, ShiftDelay
	IniWrite, %CombDelay%, %IniFilePath%, Basic, CombDelay
	IniWrite, %SpaceKeyRepeat%, %IniFilePath%, Basic, SpaceKeyRepeat
	IniWrite, %Vertical%, %IniFilePath%, Naginata, Vertical
	IniWrite, %KoyuNumber%, %IniFilePath%, Naginata, KoyuNumber
	if (AdvancedMenu)
	{
		IniWrite, %CombLimitN%, %IniFilePath%, Advanced, CombLimitN
		IniWrite, %CombStyleN%, %IniFilePath%, Advanced, CombStyleN
		IniWrite, %CombKeyUpN%, %IniFilePath%, Advanced, CombKeyUpN
		IniWrite, %CombLimitS%, %IniFilePath%, Advanced, CombLimitS
		IniWrite, %CombStyleS%, %IniFilePath%, Advanced, CombStyleS
		IniWrite, %CombKeyUpS%, %IniFilePath%, Advanced, CombKeyUpS
		IniWrite, %CombLimitE%, %IniFilePath%, Advanced, CombLimitE
		IniWrite, %CombKeyUpSPC%, %IniFilePath%, Advanced, CombKeyUpSPC
		IniWrite, %KeyUpToOutputAll%, %IniFilePath%, Advanced, KeyUpToOutputAll
		IniWrite, %EisuSandS%, %IniFilePath%, Advanced, EisuSandS
	}
	if (TestMode != "ERROR")
		IniWrite, %TestMode%, %IniFilePath%, Advanced, TestMode

	USKBSideShift := (USKB == True && SideShift > 0 ? True : False)	; 更新
	DeleteDefs()	; 配列定義をすべて消去する
	ReadLayout()	; かな配列読み込み
	SettingLayout()	; 出力確定する定義に印をつける
GuiEscape:
ButtonCancel:
ButtonClose:
GuiClose:
	GoodHwnd := BadHwnd := ""	; IME窓の検出可否をリセット
	Gui, Destroy
	return

; 設定画面
PrefMenu:
	Gui, Destroy
	Gui, -MinimizeBox
	Gui, Add, Text, , 設定

	if (AdvancedMenu)	; 詳細メニュー
	{
		Gui, Add, Text, x+200 W180 Right, %Version%
		Gui, Add, Tab2, xm+168 y+0 Section W120 Buttons Center, 基本|詳細
		Gui, Tab, 基本
	}
	else	; 詳細メニュー不要の時
		Gui, Add, Text, x+0 W230 Right Section, %Version%

	Gui, Add, Text, xm ys+25, IMEの選択
	Gui, Add, Radio, xm+68 yp+0 Group vIMESelect0, MS-IME
	Gui, Add, Radio, x+0 vIMESelect1, ATOK
	Gui, Add, Radio, x+0 vIMESelect2, Google
	if (IMESelect0)
		GuiControl, , IMESelect0, 1
	else if (IMESelect1)
		GuiControl, , IMESelect1, 1
	else
		GuiControl, , IMESelect2, 1

	if (IsFunc("USLikeLayout"))	; 関数 USLikeLayout が存在したら
	{
		Gui, Add, Checkbox, xm y+10 vUSLike, 記号をUSキーボード風にする
		if (USLike)
			GuiControl, , USLike, 1
		Gui, Add, Text, xm+18 y+1, ※ 日本語キーボードの時のみ有効です
		Gui, Add, Text, xm+18 y+1, ※ 左右シフトかなに設定してください
	}

	Gui, Add, Text, xm y+10, 左右シフト
	Gui, Add, Radio, xm+68 yp+0 Group vSideShift0, 英数
	if (AdvancedMenu || SideShift1)	; AdvancedMenuオン、または英数２になっているとき
		Gui, Add, Radio, x+0 vSideShift1, 英数2
	Gui, Add, Radio, x+0 vSideShift2, かな
	if (SideShift0)
		GuiControl, , SideShift0, 1
	else if (SideShift1)
		GuiControl, , SideShift1, 1
	else
		GuiControl, , SideShift2, 1

	Gui, Add, Text, xm y+5, エンター
	Gui, Add, Radio, xm+68 yp+0 Group vEnterShift0, 通常
	Gui, Add, Radio, x+0 vEnterShift1, 同時押しシフト
	if (EnterShift0)
		GuiControl, , EnterShift0, 1
	else
		GuiControl, , EnterShift1, 1

	Gui, Add, Text, xm y+15, 後置シフトの待ち時間
	Gui, Add, Edit, xm+132 yp-3 W45
	Gui, Add, UpDown, vShiftDelay Range0-200, %ShiftDelay%
	Gui, Add, Text, x+5 yp+3, ミリ秒

	Gui, Add, Text, xm y+15, 同時打鍵判定
	Gui, Add, Edit, xm+132 yp-3 W45
	Gui, Add, UpDown, vCombDelay Range0-200, %CombDelay%
	Gui, Add, Text, x+5 yp+3, ミリ秒
	Gui, Add, Text, xm+18 y+1, ※ 0 は無制限

	Gui, Add, Text, xm y+10, スペースキーの長押し
	Gui, Add, Radio, xm+18 y+3 Group vSpaceKeyRepeat0, 何もしない
	Gui, Add, Radio, x+0 vSpaceKeyRepeat1, 空白キャンセル
	Gui, Add, Radio, x+0 vSpaceKeyRepeat2, 空白リピート
	if (SpaceKeyRepeat0)
		GuiControl, , SpaceKeyRepeat0, 1
	else if (SpaceKeyRepeat1)
		GuiControl, , SpaceKeyRepeat1, 1
	else
		GuiControl, , SpaceKeyRepeat2, 1

	if (AdvancedMenu)	; 詳細メニュー
	{
		Gui, Tab, 詳細

		Gui, Add, Text, xm ys+20, 同時打鍵
			Gui, Add, Text, xm+10 y+5, 通常
				Gui, Add, Checkbox, xm+95 yp+0 vCombLimitN, 判定期限
				if (CombLimitN)
					GuiControl, , CombLimitN, 1

				Gui, Add, Text, xm+20 y+5, 文字キーシフト
				Gui, Add, Radio, xm+105 yp+0 Group vCombStyleN0, ずっと
				Gui, Add, Radio, x+0 vCombStyleN1, 途切れるまで
				Gui, Add, Radio, x+0 vCombStyleN2, 同グループのみ継続
				Gui, Add, Radio, x+0 vCombStyleN3, 1回のみ
				if (CombStyleN0)
					GuiControl, , CombStyleN0, 1
				else if (CombStyleN1)
					GuiControl, , CombStyleN1, 1
				else if (CombStyleN2)
					GuiControl, , CombStyleN2, 1
				else
					GuiControl, , CombStyleN3, 1

				Gui, Add, Text, xm+20 y+5, キーを離すと
				Gui, Add, Radio, xm+105 yp+0 Group vCombKeyUpN0, 全復活
				Gui, Add, Radio, x+0 vCombKeyUpN1, そのまま
				Gui, Add, Radio, x+0 vCombKeyUpN2, 全解除
				if (CombKeyUpN0)
					GuiControl, , CombKeyUpN0, 1
				else if (CombKeyUpN1)
					GuiControl, , CombKeyUpN1, 1
				else
					GuiControl, , CombKeyUpN2, 1
			Gui, Add, Text, xm+10 y+5, スペース押下時
				Gui, Add, Checkbox, xm+95 yp+0 vCombLimitS, 判定期限
				if (CombLimitS)
					GuiControl, , CombLimitS, 1

				Gui, Add, Text, xm+20 y+5, 文字キーシフト
				Gui, Add, Radio, xm+105 yp+0 Group vCombStyleS0, ずっと
				Gui, Add, Radio, x+0 vCombStyleS1, 途切れるまで
				Gui, Add, Radio, x+0 vCombStyleS2, 同グループのみ継続
				Gui, Add, Radio, x+0 vCombStyleS3, 1回のみ
				if (CombStyleS0)
					GuiControl, , CombStyleS0, 1
				else if (CombStyleS1)
					GuiControl, , CombStyleS1, 1
				else if (CombStyleS2)
					GuiControl, , CombStyleS2, 1
				else
					GuiControl, , CombStyleS3, 1

				Gui, Add, Text, xm+20 y+5, キーを離すと
				Gui, Add, Radio, xm+105 yp+0 Group vCombKeyUpS0, 全復活
				Gui, Add, Radio, x+0 vCombKeyUpS1, そのまま
				Gui, Add, Radio, x+0 vCombKeyUpS2, 全解除
				if (CombKeyUpS0)
					GuiControl, , CombKeyUpS0, 1
				else if (CombKeyUpS1)
					GuiControl, , CombKeyUpS1, 1
				else
					GuiControl, , CombKeyUpS2, 1
			Gui, Add, Text, xm+10 y+5, 英数入力時
				Gui, Add, Checkbox, xm+95 yp+0 vCombLimitE, 判定期限ありを強制する ※文字キーシフトは1回のみとなる
				if (CombLimitE)
					GuiControl, , CombLimitE, 1
			Gui, Add, Text, xm+10 y+5, スペースキーを離した時の設定
				Gui, Add, Radio, xm+160 yp+0 Group vCombKeyUpSPC0, 通常時
				Gui, Add, Radio, x+0 vCombKeyUpSPC1, スペース押下時
				if (CombKeyUpSPC0)
					GuiControl, , CombKeyUpSPC0, 1
				else
					GuiControl, , CombKeyUpSPC1, 1
		Gui, Add, Checkbox, xm y+10 vKeyUpToOutputAll, キーを離せば常に全部出力する
		if (KeyUpToOutputAll)
			GuiControl, , KeyUpToOutputAll, 1
		Gui, Add, Checkbox, xm y+10 vEisuSandS, 英数入力時のSandS
		if (EisuSandS)
			GuiControl, , EisuSandS, 1
		if (TestMode != "ERROR")
		{
			Gui, Add, Text, xm y+10, テストモード
			Gui, Add, Radio, xm+75 yp+0 Group vTestMode0, なし
			Gui, Add, Radio, x+0 vTestMode1, 処理時間表示
			Gui, Add, Radio, x+0 vTestMode2, 表示待ち文字列表示
			if (TestMode0)
				GuiControl, , TestMode0, 1
			else if (TestMode1)
				GuiControl, , TestMode1, 1
			else
				GuiControl, , TestMode2, 1
		}

		Gui, Tab
		Gui, Add, Button, W60 xm+146 ys+240 Default, OK
		Gui, Add, Button, W60 x+0, Cancel
	}
	else	; 詳細メニュー不要の時
	{
		Gui, Add, Button, W60 xm+71 y+10 Default, OK
		Gui, Add, Button, W60 x+0, Cancel
	}
	Gui, Show
	return

; ログ表示
DispLog:
	DispLogFunc()
	return
; ログ表示(本体)
DispLogFunc()
{
	global InBufsKey, InBufReadPos, InBufsTime, USKB, TestMode
;	local SCArray, LastKeyTime, KeyTime, diff, pos, Str, c, PreStr, Term, number, temp

	if (USKB)	; USキーボード
		SCArray := ["Esc", "1", "2", "3", "4", "5", "6", "7", "8", "9", "Ø", "-", "=", "BackSpace", "Tab"
			, "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]", "", "", "A", "S"
			, "D", "F", "G", "H", "J", "K", "L", ";", "'", "`", "LShift", "\", "Z", "X", "C", "V"
			, "B", "N", "M", ",", ".", "/", "", "", "", "Space", "CapsLock", "F1", "F2", "F3", "F4", "F5"
			, "F6", "F7", "F8", "F9", "F10", "Pause", "ScrollLock", "", "", "", "", "", "", "", "", ""
			, "", "", "", "", "SysRq", "", "KC_NUBS", "F11", "F12", "(Mac)=", "", "", "(NEC),", "", "", ""
			, "", "", "", "", "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20", "F21", "F22", "F23", ""
			, "(JIS)ひらがな", "(Mac)英数", "(Mac)かな", "(JIS)_", "", "", "F24", "KC_LANG4"
			, "KC_LANG3", "(JIS)変換", "", "(JIS)無変換", "", "(JIS)￥", "(Mac),", ""]
	else		; USキーボード以外
		SCArray := ["Esc", "1", "2", "3", "4", "5", "6", "7", "8", "9", "Ø", "-", "^", "BackSpace", "Tab"
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
	LastKeyTime := 0.0
	pos := InBufReadPos
	while ((pos := ++pos & 31) != InBufReadPos)
	{
		Str := InBufsKey[pos], KeyTime := InBufsTime[pos]
		if (Str)
		{
			; 時間を書き出し
			if (LastKeyTime)
			{
				if (TestMode != "ERROR")
					diff := round(KeyTime - LastKeyTime, 1)
				else
					diff := round(KeyTime - LastKeyTime)
				Gui, Add, Text, xm, % "(" . diff . "ms) "
			}
			else
				Gui, Add, Text, xm

			; 修飾キー
			PreStr := ""
			while (c := SubStr(Str, 1, 1))
			{
				if (c == "+" || c == "^" || c == "!" || c == "#"
				 || c == "*" || c == "~" || c == "$")
				{
					PreStr .= c
					Str := SubStr(Str, 2)	; 先頭の文字を消去
				}
				else
					break
			}
			; キーの上げ下げを調べる
			StringRight, Term, Str, 3	; Term に入力末尾の2文字を入れる
			if (Term = " up")	; キーが離されたとき
			{
				Term := "↑"
				Str := SubStr(Str, 1, StrLen(Str) - 3)
			}
			else
				Term := ""

			; 書き出し
			if (Str = "KeyTimer")
				Str := "[KeyTimer]"
			else if (Str = "vk1A")
				Str := "(Mac)英数"
			else if (Str = "vk16")
				Str := "(Mac)かな"
			else if (SubStr(Str, 1, 2) = "sc")
			{
				number := "0x" . SubStr(Str, 3, 2)
				temp := SCArray[number]
				if (temp != "")
					Str := temp
			}
			Gui, Add, Text, xm+60 yp, % PreStr . Str . Term
		}
		LastKeyTime := KeyTime	; 押した時間を保存
	}
	Gui, Add, Button, W60 xm+30 y+10 Default, Close
	Gui, Show
	return
}
