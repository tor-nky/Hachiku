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
;	3キー同時押し配列 初期設定
; **********************************************************************

ListLines False				; スクリプトの実行履歴を取らない
SetKeyDelay -1, -1			; キーストローク間のディレイを変更
;ProcessSetPriority "High"	; スクリプトを実行するプロセスの優先度を上げる
#UseHook					; ホットキーはすべてフックを使用する
Thread "Interrupt", 33, 13	; スレッド開始から約33ミリ秒ないし13行以内の割り込みを禁止
SetStoreCapsLockMode False	; Sendコマンド実行時にCapsLockの状態を自動的に変更しない

;CoordMode "ToolTip", "Screen"	; ToolTipの表示座標の扱いをスクリーン上での絶対座標にする

A_MenuMaskKey := "vk07"			; Win または Alt の押下解除時のイベントを隠蔽するためのキーを変更する
A_HotkeyInterval := 1000		; 指定時間(ミリ秒単位)の間に実行できる最大のホットキー数
A_MaxHotkeysPerInterval := 120	; 指定時間の間に実行できる最大のホットキー数


; ----------------------------------------------------------------------
; 配列定義で使う定数	Int64型定数
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
NR := "NonRepeat"	; String型定数
R := "Repeat"		; String型定数

;imeState			; Bool?型	IMEの状態		IME_GET()用
;imeSentenceMode	; Int?型	IME 変換モード	IME_GetSentenceMode()用

; Send から IME_GET() までに Sleep で必要な時間(ミリ秒)
;imeNeedDelay		; Int型定数
; Send から IME_GetConverting() までに Sleep で必要な時間(ミリ秒)
;imeGetConvertingInterval	; Int型定数

; ----------------------------------------------------------------------
; 共用変数
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
inBufsKey.Length := 32
inBufsKey.Default := ""
inBufsTime := []	; [Double]型	入力の時間
inBufsTime.Length := 32
inBufsTime.Default := 0
inBufReadPos := 0	; Int型			読み出し位置
inBufWritePos := 0	; Int型			書き込み位置
inBufRest := 31		; Int型
; 仮出力バッファ
outStrs := []		; [String]型
outCtrlNames := []	; [String]型
restStr := ""		; [String]型	下げたままのキー 例: +{Up}
; シフト用キーの状態
spc		:= 0		; Int型	スペースキー 0: 押していない, 1: 単独押し, 2: シフト継続中, 3, 5: リピート中(3: かなを押すと変換取消→シフト側文字)
ent		:= 0		; Int型	エンター	 0: 押していない, 1: 単独押し, 2: シフト継続中, 5: リピート中
repeat_count := 0	; Int型	リピート回数

goodHwnd := badHwnd := ""	;  Int?型	IME窓の検出できるか

; ----------------------------------------------------------------------
; 設定ファイル読み込み
; ----------------------------------------------------------------------
pref := Preference()	; Object型	設定用

; ----------------------------------------------------------------------
; かな配列読み込み
; ----------------------------------------------------------------------

	koyu := KoyuMeishi()	; Object型	固有名詞用

	ReadLayout()	; かな配列読み込み
	SettingLayout()	; 出力確定する定義に印をつける

; ----------------------------------------------------------------------
; メニュー表示
; ----------------------------------------------------------------------
	; ツールチップを変更する
	If (layoutNameE)
		A_IconTip := "Hachiku " . version . "`n" . layoutNameE . "`n+ " . layoutName . "`n固有名詞セット" . pref.koyuNumber
	Else
		A_IconTip := "Hachiku " . version . "`n" . layoutName . "`n固有名詞セット" . pref.koyuNumber
	; 標準メニュー項目を削除する
	A_TrayMenu.Delete()

	; 薙刀式配列用メニュー
	; 縦書きモード切替を追加
	A_TrayMenu.Add("縦書きモード", VerticalMode)
	ChangeVertical(pref.vertical)
	; 「固有名詞」編集画面を追加
	A_TrayMenu.Add("固有名詞登録", KoyuMenu)

	A_TrayMenu.Add("設定...", PreferenceMenu)	; 設定画面を追加
	A_TrayMenu.Add()	; セパレーター
	A_TrayMenu.Add("ログ表示", DispLog)			; ログ
	A_TrayMenu.Add()	; セパレーター
	A_TrayMenu.AddStandard()	; 標準メニュー項目を追加する

	; iniファイルがなけれは設定画面を表示
	If (!Path_FileExists(pref.iniFilePath))
		PreferenceMenu()

; ----------------------------------------------------------------------
; スクリプト終了時に実行させたい関数を指定
; ----------------------------------------------------------------------
OnExit ExitSub

Exit	; 起動時はここまで実行

; ----------------------------------------------------------------------
; スクリプト終了時に実行する関数
; ----------------------------------------------------------------------
ExitSub(*)
{
	; 押し下げ出力中のキーを上げる
	SendKeyUp()
	; 右シフトが押されていればキーを下げる
	If (GetKeyState("RShift", "P"))
		Send "{RShift down}"
	ExitApp
}

; ----------------------------------------------------------------------
; メニュー動作
; ----------------------------------------------------------------------
; 参考: https://rcmdnk.com/blog/2017/11/07/computer-windows-autohotkey/

; 縦書きモード切替
VerticalMode(*)
{
	ChangeVertical(pref.vertical == 0 ? 1 : 0)
}

; 固有名詞ショートカット登録画面
KoyuMenu(*)
{
	koyuGUI := koyu.Edit()
}

; 設定メニュー
PreferenceMenu(*)
{
	prefMenu := pref.Edit()
}

; ログ表示
DispLog(*)
{
	log := DisplayLog()
}

; ----------------------------------------------------------------------
; クラス
; ----------------------------------------------------------------------

; OS情報
class OSInfo
{
	; OS情報
	static build := 0
	static keyDriver := ""	; String型
	static uskb := ""		; Bool型

	static __New()
	{
		; local var[]	; [Int]型

		If (RegExMatch(A_OSVersion, "\d+\.\d+\.(\d+)", &var))	; 右から数字を検索
			this.build := var[1]	; 例えば 10.0.19043 は Windows 10 build 19043 (21H2)
		; キーボードドライバを調べて keyDriver に格納する
		; 参考: https://ixsvr.dyndns.org/blog/764
		this.keyDriver := RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters", "LayerDriver JPN")
		this.uskb := (this.keyDriver = "kbd101.dll" ? True : False)	; Bool型
	}
}

; 設定関連
class Preference
{
	; 設定ファイル読み込み ※規定外の値が書かれていたら、初期値になる
	__New()
	{
		; local str		; String型

		; スクリプトのパス名の拡張子をiniに付け替え、スペースを含んでいたら""でくくる
		this.iniFilePath := Path_RenameExtension(A_ScriptFullPath, "ini")	; String型

		; [general]
		; バージョン記録
			; this.iniVersion := IniRead(this.iniFilePath, "general", "Version", "")

		; [Basic]
		; IMESelect		0: MS-IME専用, 1: ATOK使用, 2: Google 日本語入力
			str := IniRead(this.iniFilePath, "Basic", "IMESelect", "")
			this.imeSelect := Normalize(str, 0, 2, 0)
		; UsingKeyConfig	0: なし, 1: あり
			str := IniRead(this.iniFilePath, "Basic", "UsingKeyConfig", "")
			this.usingKeyConfig := Normalize(str, 0, 1, 0)
		; USLike		0: 英数表記通り, 1: USキーボード風配列
			str := IniRead(this.iniFilePath, "Basic", "USLike", "")
			this.usLike := Normalize(str, 0, 1, 0)
		; SideShift		左右シフト	0または1: 英数２, 2: かな
			str := IniRead(this.iniFilePath, "Basic", "SideShift", "")
			this.sideShift := Normalize(str, 1, 2, 1)
		; EnterShift	0: 通常のエンター, 1: エンター同時押しをシフトとして扱う
			str := IniRead(this.iniFilePath, "Basic", "EnterShift", "")
			this.enterShift := Normalize(str, 0, 1, 0)
		; ShiftDelay	0: 通常シフト, 1-200: 後置シフトの待ち時間(ミリ秒)
			str := IniRead(this.iniFilePath, "Basic", "ShiftDelay", "")
			this.shiftDelay := Normalize(str, 0, 200, 0)
		; CombDelay		0: 同時押しは時間無制限
		; 				1-200: シフト中の同時打鍵判定時間(ミリ秒)
			str := IniRead(this.iniFilePath, "Basic", "CombDelay", "")
			this.combDelay := Normalize(str, 0, 200, 50)
		; SpaceKeyRepeat	スペースキーの長押し	0: 何もしない, 1: 空白キャンセル, 2: 空白リピート
			str := IniRead(this.iniFilePath, "Basic", "SpaceKeyRepeat", "")
			this.spaceKeyRepeat := Normalize(str, 0, 2, 0)
		; 英数単打のリピート	0: なし, 1: あり
			str := IniRead(this.iniFilePath, "Basic", "EisuRepeat", "")
			this.eisuRepeat := Normalize(str, 0, 1, 1)

		; [Naginata]
		; Vertical		0: 横書き用, 1: 縦書き用
			str := IniRead(this.iniFilePath, "Naginata", "Vertical", "")
			this.vertical := Normalize(str, 0, 1, 1)
		; 固有名詞ショートカットの選択
			this.koyuNumber := IniRead(this.iniFilePath, "Naginata", "KoyuNumber", 1)

		; [Advanced]
		;	通常時
		;		同時打鍵の判定期限	0: なし, 1: あり
				str := IniRead(this.iniFilePath, "Advanced", "CombLimitN", "")
				this.combLimitN := Normalize(str, 0, 1, 0)
		;		文字キーシフト		0: ずっと, 1: 途切れるまで, 2: 同グループのみ継続, 3: 1回のみ
				str := IniRead(this.iniFilePath, "Advanced", "CombStyleN", "")
				this.combStyleN := Normalize(str, 0, 3, 3)
		;		キーを離すと		0: 全復活, 1: そのまま, 2: 全部出力済みなら解除
				str := IniRead(this.iniFilePath, "Advanced", "CombKeyUpN", "")
				this.combKeyUpN := Normalize(str, 0, 2, 0)
		;	スペース押下時
		;		同時打鍵の判定期限	0: なし, 1: あり
				str := IniRead(this.iniFilePath, "Advanced", "CombLimitS", "")
				this.combLimitS := Normalize(str, 0, 1, 1)
		;		文字キーシフト		0: ずっと, 1: 途切れるまで, 2: 同グループのみ継続, 3: 1回のみ
				str := IniRead(this.iniFilePath, "Advanced", "CombStyleS", "")
				this.combStyleS := Normalize(str, 0, 3, 3)
		;		キーを離すと		0: 全復活, 1: そのまま, 2: 全部出力済みなら解除
				str := IniRead(this.iniFilePath, "Advanced", "CombKeyUpS", "")
				this.combKeyUpS := Normalize(str, 0, 2, 2)
		;	英数時の同時打鍵期限を強制する	0: なし, 1: あり
				str := IniRead(this.iniFilePath, "Advanced", "CombLimitE", "")
				this.combLimitE := Normalize(str, 0, 1, 0)
		;	スペースキーを離した時の設定	0: 通常時, 1: スペース押下時
				str := IniRead(this.iniFilePath, "Advanced", "CombKeyUpSPC", "")
				this.combKeyUpSPC := Normalize(str, 0, 1, 1)
		; 英数入力時のSandS		0: なし, 1: あり
			str := IniRead(this.iniFilePath, "Advanced", "EisuSandS", "")
			this.eisuSandS := Normalize(str, 0, 1, 1)
		; キーを離せば常に全部出力する	0: しない, 1: する
			str := IniRead(this.iniFilePath, "Advanced", "KeyUpToOutputAll", "")
			this.keyUpToOutputAll := Normalize(str, 0, 1, 0)
		; テスト表示	0: なし, 1: 処理時間, 2: 表示待ち文字列, 3: 出力文字列 ※iniになければ設定画面に表示しない
			str := IniRead(this.iniFilePath, "Advanced", "TestMode", "")
			this.testMode := Normalize(str, 0, 3, "NONE")
		; リピートの好み	0: 常に無制限, 1: 基本する, 2: 基本しない, 3: 全くしない
				str := IniRead(this.iniFilePath, "Advanced", "RepeatStyle", "")
				this.repeatStyle := Normalize(str, 0, 3, 2)
		; IME_Get_Interval	文字出力後に IME の状態を検出しない時間(ミリ秒)
			str := IniRead(this.iniFilePath, "Advanced", "IME_Get_Interval", "")
			this.imeGetInterval := Normalize(str, 0, 2000, 125)

		; 文字列から数値を取り出す
		; min から max の範囲に入っていなければ、default を返す
		; (str: String, min: Int, max: Int, default) -> Any ※ defalut は数値でなくてもよい
		Normalize(str, min, max, default)
		{
			If (IsInteger(str))
			{
				value := Integer(str)
				If (min <= value && value <= max)
					Return value
			}
			Return default
		}
	}

	; 設定メニュー
	Edit()
	{
		; GUI操作
		this.menu := Gui()
		this.menu.Opt("-MinimizeBox")	; タイトルバーの最小化ボタンを無効化
		this.menu.Add("Text", , "設定")

		this.menu.Add("Text", "x+200 W180 Right", version)

		tab := this.menu.Add("Tab2", "xm+140 y+0 Section Buttons Center", ["基本", "キー", "同時打鍵"])
		; 「基本」メニュー
			; IMEの選択
			this.menu.Add("Text", "xm ys+40", "IMEの選択")
			this.menu.Add("Radio", "xm+68 yp+0 Group VimeSelect" . (pref.imeSelect == 0 ? " Checked" : ""), "MS-IME")
			this.menu.Add("Radio", "x+0"						 . (pref.imeSelect == 1 ? " Checked" : ""), "ATOK")
			this.menu.Add("Radio", "x+0"						 . (pref.imeSelect == 2 ? " Checked" : ""), "Google")
			; キー設定利用
			this.menu.Add("Checkbox", "xm+18 y+5 VusingKeyConfig" . (pref.usingKeyConfig ? " Checked" : ""), "キー設定利用 (Ctrl+Shift+変換⇒全確定、Ctrl+Shift+無変換⇒全消去)")
			; 後置シフトの待ち時間
			this.menu.Add("Text", "xm y+15", "後置シフトの待ち時間")
			this.menu.Add("Edit", "xm+122 yp-3 W45 Number Right")
			this.menu.Add("UpDown", "VshiftDelay Range0-200", pref.shiftDelay)
			this.menu.Add("Text", "x+5 yp+3", "ミリ秒")
			; 英数単打のリピート
			this.menu.Add("Checkbox", "x+55 VeisuRepeat" . (pref.eisuRepeat ? " Checked" : ""), "英数単打のリピート")
			; テストモードが無効の時
			If (pref.testMode = "NONE")
			{
				; 文字出力後に IME の状態を検出しない時間
				this.menu.Add("Text", "xm y+30", "文字出力後に IME の状態を検出しない時間")
				this.menu.Add("Edit", "xm+235 yp-3 W51 Number Right")
				this.menu.Add("UpDown", "VimeGetInterval Range0-500 128", pref.imeGetInterval)
				this.menu.Add("Text", "x+5 yp+3", "ミリ秒")
			}
			; テストモード
			Else
			{
				; テスト表示
				this.menu.Add("Text", "xm ys+132", "テスト表示")
				this.menu.Add("Radio", "xm+75 yp+0 Group VtestMode" . (pref.testMode == 0 ? " Checked" : ""), "なし")
				this.menu.Add("Radio", "x+0"						. (pref.testMode == 1 ? " Checked" : ""), "処理時間")
				this.menu.Add("Radio", "x+0"						. (pref.testMode == 2 ? " Checked" : ""), "表示待ち文字列")
				this.menu.Add("Radio", "x+0"						. (pref.testMode == 3 ? " Checked" : ""), "出力文字列")
				; リピートの好み
				this.menu.Add("Text", "xm y+8", "リピートの好み")
				this.menu.Add("Radio", "xm+75 yp+0 Group VrepeatStyle" . (pref.repeatStyle == 0 ? " Checked" : ""), "常に無制限")
				this.menu.Add("Radio", "x+0"						   . (pref.repeatStyle == 1 ? " Checked" : ""), "基本する")
				this.menu.Add("Radio", "x+0"						   . (pref.repeatStyle == 2 ? " Checked" : ""), "基本しない")
				this.menu.Add("Radio", "x+0"						   . (pref.repeatStyle == 3 ? " Checked" : ""), "全くしない")
				; 文字出力後に IME の状態を検出しない時間
				this.menu.Add("Text", "xm y+10", "文字出力後に IME の状態を検出しない時間")
				this.menu.Add("Edit", "xm+235 yp-3 W51 Number Right")
				this.menu.Add("UpDown", "VimeGetInterval Range0-2000 128", pref.imeGetInterval)
				this.menu.Add("Text", "x+5 yp+3", "ミリ秒")
			}
		; 「キー」メニュー
		tab.UseTab(2)
			; 記号をUSキーボード風にする
			this.menu.Add("Checkbox", "xm y+10 VusLike" . (pref.usLike ? " Checked" : ""), "記号をUSキーボード風にする")
			this.menu.Add("Text", "xm+18 y+1", "※ 日本語キーボードの時のみ有効です")
			; 左右シフト
			this.menu.Add("Text", "xm y+10", "左右シフト")
			this.menu.Add("Radio", "xm+68 yp+0 Group VsideShift" . (pref.sideShift <= 1 ? " Checked" : ""), "英数")
			this.menu.Add("Radio", "x+0"						 . (pref.sideShift == 2 ? " Checked" : ""), "かな")
			; エンター
			this.menu.Add("Text", "xm y+5", "エンター")
			this.menu.Add("Radio", "xm+68 yp+0 Group VenterShift" . (pref.enterShift == 0 ? " Checked" : ""), "通常")
			this.menu.Add("Radio", "x+0"						  . (pref.enterShift == 1 ? " Checked" : ""), "同時押しシフト")
			; スペースキーの長押し
			this.menu.Add("Text", "xm y+10", "スペースキーの長押し")
			this.menu.Add("Radio", "xm+18 y+3 Group VspaceKeyRepeat" . (pref.spaceKeyRepeat == 0 ? " Checked" : ""), "何もしない")
			this.menu.Add("Radio", "x+0"							 . (pref.spaceKeyRepeat == 1 ? " Checked" : ""), "空白キャンセル")
			this.menu.Add("Radio", "x+0"							 . (pref.spaceKeyRepeat == 2 ? " Checked" : ""), "空白リピート")
			; 英数入力時のSandS
			this.menu.Add("Checkbox", "xm y+15 VeisuSandS" . (pref.eisuSandS ? " Checked" : ""), "英数入力時のSandS")
			; キーを離せば常に全部出力する
			this.menu.Add("Checkbox", "xm y+15 VkeyUpToOutputAll" . (pref.keyUpToOutputAll ? " Checked" : ""), "キーを離せば常に全部出力する")
		; 「同時打鍵」メニュー
		tab.UseTab(3)
			; 同時打鍵判定
			this.menu.Add("Text", "xm y+10", "同時打鍵判定")
			this.menu.Add("Edit", "xm+95 yp-3 W45 Number Right")
			this.menu.Add("UpDown", "VcombDelay Range0-200", pref.combDelay)
			this.menu.Add("Text", "x+5 yp+3", "ミリ秒 ※ 0 は無制限")
			; 通常
			this.menu.Add("Text", "xm+10 y+10", "通常")
				; 判定期限
				this.menu.Add("Checkbox", "xm+95 yp+0 VcombLimitN" . (pref.combLimitN ? " Checked" : ""), "判定期限")
				; 文字キーシフト
				this.menu.Add("Text", "xm+20 y+5", "文字キーシフト")
				this.menu.Add("Radio", "xm+105 yp+0 Group VcombStyleN" . (pref.combStyleN == 0 ? " Checked" : ""), "ずっと")
				this.menu.Add("Radio", "x+0"						   . (pref.combStyleN == 1 ? " Checked" : ""), "途切れるまで")
				this.menu.Add("Radio", "x+0"						   . (pref.combStyleN == 2 ? " Checked" : ""), "同グループのみ継続")
				this.menu.Add("Radio", "x+0"						   . (pref.combStyleN == 3 ? " Checked" : ""), "1回のみ")
				; キーを離すと
				this.menu.Add("Text", "xm+20 y+5", "キーを離すと")
				this.menu.Add("Radio", "xm+105 yp+0 Group VcombKeyUpN" . (pref.combKeyUpN == 0 ? " Checked" : ""), "全復活")
				this.menu.Add("Radio", "x+0"						   . (pref.combKeyUpN == 1 ? " Checked" : ""), "そのまま")
				this.menu.Add("Radio", "x+0"						   . (pref.combKeyUpN == 2 ? " Checked" : ""), "全部出力済みなら解除")
			; スペース押下時
			this.menu.Add("Text", "xm+10 y+5", "スペース押下時")
				; 判定期限
				this.menu.Add("Checkbox", "xm+95 yp+0 VcombLimitS" . (pref.combLimitS ? " Checked" : ""), "判定期限")
				; 文字キーシフト
				this.menu.Add("Text", "xm+20 y+5", "文字キーシフト")
				this.menu.Add("Radio", "xm+105 yp+0 Group VcombStyleS" . (pref.combStyleS == 0 ? " Checked" : ""), "ずっと")
				this.menu.Add("Radio", "x+0"						   . (pref.combStyleS == 1 ? " Checked" : ""), "途切れるまで")
				this.menu.Add("Radio", "x+0"						   . (pref.combStyleS == 2 ? " Checked" : ""), "同グループのみ継続")
				this.menu.Add("Radio", "x+0"						   . (pref.combStyleS == 3 ? " Checked" : ""), "1回のみ")
				; キーを離すと
				this.menu.Add("Text", "xm+20 y+5", "キーを離すと")
				this.menu.Add("Radio", "xm+105 yp+0 Group VcombKeyUpS" . (pref.combKeyUpS == 0 ? " Checked" : ""), "全復活")
				this.menu.Add("Radio", "x+0"						   . (pref.combKeyUpS == 1 ? " Checked" : ""), "そのまま")
				this.menu.Add("Radio", "x+0"						   . (pref.combKeyUpS == 2 ? " Checked" : ""), "全部出力済みなら解除")
			; 英数入力時
			this.menu.Add("Text", "xm+10 y+5", "英数入力時")
				; 判定期限ありを強制する
				this.menu.Add("Checkbox", "xm+95 yp+0 VcombLimitE" . (pref.combLimitE ? " Checked" : ""), "判定期限強制 ※文字キーシフトは｢同グループのみ｣か｢1回のみ｣")
			; スペースキーを離した時の設定
			this.menu.Add("Text", "xm+10 y+5", "スペースキーを離した時の設定")
				this.menu.Add("Radio", "xm+160 yp+0 Group VcombKeyUpSPC" . (pref.combKeyUpSPC == 0 ? " Checked" : ""), "通常時")
				this.menu.Add("Radio", "x+0"							 . (pref.combKeyUpSPC == 1 ? " Checked" : ""), "スペース押下時")

		tab.UseTab()	; あとのコントロールはタブに属さない
		this.menu.Add("Button", "W60 xm+146 ys+200 Default", "OK").OnEvent("Click", Okay)
		this.menu.Add("Button", "W60 x+0", "Cancel").OnEvent("Click", Cancel)
		this.menu.OnEvent("Escape", Cancel)
		this.menu.Show()

		Cancel(*)
		{
			this.menu.Destroy()
		}

		Okay(*)
		{
			global goodHwnd, badHwnd

			Saved := this.menu.Submit()	; 名前付きコントロールの内容を、オブジェクトに保存
			this.menu.Destroy()

			; 設定値をコピー
			; [Basic]
			this.imeSelect := Saved.imeSelect - 1
			this.usingKeyConfig := Saved.usingKeyConfig
			this.usLike := Saved.usLike
			this.sideShift := Saved.sideShift
			this.enterShift := Saved.enterShift - 1
			this.shiftDelay := Saved.shiftDelay
			this.combDelay := Saved.combDelay
			this.spaceKeyRepeat := Saved.spaceKeyRepeat - 1
			this.eisuRepeat := Saved.eisuRepeat
			; [Advanced]
			this.combLimitN := Saved.combLimitN
			this.combStyleN := Saved.combStyleN - 1
			this.combKeyUpN := Saved.combKeyUpN - 1
			this.combLimitS := Saved.combLimitS
			this.combStyleS := Saved.combStyleS - 1
			this.combKeyUpS := Saved.combKeyUpS - 1
			this.combLimitE := Saved.combLimitE
			this.combKeyUpSPC := Saved.combKeyUpSPC - 1
			this.eisuSandS := Saved.eisuSandS
			this.keyUpToOutputAll := Saved.keyUpToOutputAll
			If (this.testMode != "NONE") {
				this.testMode := Saved.testMode - 1
				this.repeatStyle := Saved.repeatStyle - 1
			}
			this.imeGetInterval := Saved.imeGetInterval

			Try
			{
				; 設定ファイル書き込み
				; [general]
				IniWrite version, this.iniFilePath, "general", "Version"
				; [Basic]
				IniWrite this.imeSelect, this.iniFilePath, "Basic", "IMESelect"
				IniWrite this.usingKeyConfig, this.iniFilePath, "Basic", "UsingKeyConfig"
				IniWrite this.usLike, this.iniFilePath, "Basic", "USLike"
				IniWrite this.sideShift, this.iniFilePath, "Basic", "SideShift"
				IniWrite this.enterShift, this.iniFilePath, "Basic", "EnterShift"
				IniWrite this.shiftDelay, this.iniFilePath, "Basic", "ShiftDelay"
				IniWrite this.combDelay, this.iniFilePath, "Basic", "CombDelay"
				IniWrite this.spaceKeyRepeat, this.iniFilePath, "Basic", "SpaceKeyRepeat"
				IniWrite this.eisuRepeat, this.iniFilePath, "Basic", "EisuRepeat"
				; [Naginata]
				IniWrite this.vertical, this.iniFilePath, "Naginata", "Vertical"
				IniWrite this.koyuNumber, this.iniFilePath, "Naginata", "KoyuNumber"
				; [Advanced]
				IniWrite this.combLimitN, this.iniFilePath, "Advanced", "CombLimitN"
				IniWrite this.combStyleN, this.iniFilePath, "Advanced", "CombStyleN"
				IniWrite this.combKeyUpN, this.iniFilePath, "Advanced", "CombKeyUpN"
				IniWrite this.combLimitS, this.iniFilePath, "Advanced", "CombLimitS"
				IniWrite this.combStyleS, this.iniFilePath, "Advanced", "CombStyleS"
				IniWrite this.combKeyUpS, this.iniFilePath, "Advanced", "CombKeyUpS"
				IniWrite this.combLimitE, this.iniFilePath, "Advanced", "CombLimitE"
				IniWrite this.combKeyUpSPC, this.iniFilePath, "Advanced", "CombKeyUpSPC"
				IniWrite this.eisuSandS, this.iniFilePath, "Advanced", "EisuSandS"
				IniWrite this.keyUpToOutputAll, this.iniFilePath, "Advanced", "KeyUpToOutputAll"
				If (this.testMode != "NONE") {
					IniWrite this.testMode, this.iniFilePath, "Advanced", "TestMode"
					IniWrite this.repeatStyle, this.iniFilePath, "Advanced", "RepeatStyle"
				}
				IniWrite this.imeGetInterval, this.iniFilePath, "Advanced", "IME_Get_Interval"
			}
			Catch OSError
				TrayTip ".ini ファイルに書き込めません"

			TraySetIcon "*"		; トレイアイコンをいったん起動時のものに
			DeleteDefs()		; 配列定義をすべて消去する
			ReadLayout()		; かな配列読み込み
			SettingLayout()		; 出力確定する定義に印をつける
			; トレイアイコン変更
			ChangeVertical(this.vertical)

			; IME窓の検出できるか調べなおし
			goodHwnd := badHwnd := ""
		}
	}
}

; ログ表示
class DisplayLog
{
	disp := Gui()

	__New()
	{
		;	local scanCodeArray					; [String]型
		;		, lastKeyTime, keyTime, diff	; Double型
		;		, pos, number					; Int型
		;		, str, c, preStr, term, temp	; String型

		; USキーボード
		If (OSInfo.uskb)
			scanCodeArray := ["Esc", "1", "2", "3", "4", "5", "6", "7", "8", "9", "Ø", "-", "=", "BackSpace", "Tab"
				, "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]", "", "", "A", "S"
				, "D", "F", "G", "H", "J", "K", "L", ";", "'", "``", "LShift", "\", "Z", "X", "C", "V"
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

		; GUI操作
		this.disp.Opt("-MinimizeBox")	; タイトルバーの最小化ボタンを無効化
		this.disp.Add("Text", "xm", "≪ログ≫")
		lastKeyTime := 0.0
		pos := inBufReadPos
		While ((pos := ++pos & 31) != inBufReadPos)
		{
			str := inBufsKey[pos+1], keyTime := inBufsTime[pos+1]
			If (str)
			{
				; 時間を書き出し
				If (lastKeyTime)
				{
					If (pref.testMode != "NONE")
						diff := round(keyTime - lastKeyTime, 1)
					Else
						diff := round(keyTime - lastKeyTime)
					this.disp.Add("Text", "xm", "(" . diff . "ms) ")
				}
				Else
					this.disp.Add("Text", "xm", "")

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
				term := SubStr(str, -3)	; term に入力末尾の3文字を入れる
				If (term = " up")
				{
					; キーが離されたとき
					term := "↑"
					str := SubStr(str, 1, -3)
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
				this.disp.Add("Text", "xm+60 yp", preStr . str . term)
			}
			; 押した時間を保存
			lastKeyTime := keyTime
		}
		this.disp.Add("Button", "W60 xm+30 y+10 Default", "Close").OnEvent("Click", Cancel)
		this.disp.OnEvent("Escape", Cancel)
		this.disp.Show()

		Cancel(*)
		{
			this.disp.Destroy()
		}
	}
}
