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
; 設定ファイル読み込み
; ----------------------------------------------------------------------

; スクリプトのパス名の拡張子をiniに付け替え、スペースを含んでいたら""でくくる
IniFilePath := Path_QuoteSpaces(Path_RenameExtension(A_ScriptFullPath, "ini"))

; 参考: https://so-zou.jp/software/tool/system/auto-hot-key/commands/file.htm
IniRead, INIVersion, %IniFilePath%, general, Version, ""
IniRead, Vertical, %IniFilePath%, general, Vertical, 1
	; Vertical		0: 横書き用, 1: 縦書き用
IniRead, Slow, %IniFilePath%, general, Slow, 0
	; Slow			0: MS-IME専用, 1: ATOK可
IniRead, USLike, %IniFilePath%, general, USLike, 0
	; USLike 0: 英数表記通り, 1: USキーボード風配列
IniRead, SideShift, %IniFilePath%, general, SideShift, 2
	; SideShift		0-1: 左右シフト英数, 2: 左右シフトかな
IniRead, EnterShift, %IniFilePath%, general, EnterShift, 0
	; EnterShift	0: 通常のエンター, 1: エンター同時押しをシフトとして扱う
IniRead, ShiftDelay, %IniFilePath%, general, ShiftDelay, 0
	; ShiftDelay	0: 通常シフト, 1以上: 後置シフトの待ち時間(ミリ秒)
IniRead, CombDelay, %IniFilePath%, general, CombDelay, 60
	; CombDelay		0以下: 同時押しは時間無制限
	; 				1以上: シフト中の同時打鍵判定時間(ミリ秒)
IniRead, KoyuNumber, %IniFilePath%, general, KoyuNumber, 1

IniRead, TestMode, %IniFilePath%, test, TestMode, 0
IniRead, DispTime, %IniFilePath%, test, DispTime, 0
	; DispTime		0: なし, 1: 変換時間表示あり

; ----------------------------------------------------------------------
; 配列定義で使う変数
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
; 共通変数
; ----------------------------------------------------------------------
Group := 0	; 0 はグループAll
; 入れ物の定義
DefsKey := []		; キービットの集合
DefsGroup := []		; 定義のグループ番号 ※0はグループAll
DefsKanaMode := []	; 0: 英数入力用, 1: かな入力用
DefsTateStr := []	; 縦書き用定義
DefsYokoStr := []	; 横書き用定義
DefsRepeat := []	; 1: リピートできる
DefsSetted := []	; 0: 出力確定しない,
					; 1: 通常シフトのみ出力確定, 2: どちらのシフトも出力確定
DefBegin := [1, 1, 1]	; 定義の始め 1キー, 2キー同時, 3キー同時
DefEnd	:= [1, 1, 1]	; 定義の終わり+1 1キー, 2キー同時, 3キー同時

; キーボードドライバを調べて KeyDriver に格納する
; 参考: https://ixsvr.dyndns.org/blog/764
RegRead, KeyDriver, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Services\i8042prt\Parameters, LayerDriver JPN
USKB := (KeyDriver = "kbd101.dll" ? True : False)
USKBSideShift := (USKB == 1 && SideShift > 0 ? True : False)

; ----------------------------------------------------------------------
; 関数
; ----------------------------------------------------------------------

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
StrReplace(Str1)
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
;		, len, StrChopped, c, bracket

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
	global DefsKey, DefsGroup, DefsKanaMode, DefsTateStr, DefsYokoStr, DefsRepeat
		, DefBegin, DefEnd
		, Group
;	local nkeys		; 何キー同時押しか
;		, i, imax	; カウンタ用

	; 機能置き換え処理
	Str1 := StrReplace(Str1)

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
			DefsRepeat.RemoveAt(i)

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
		DefsGroup.InsertAt(i, Group)
		DefsKanaMode.InsertAt(i, KanaMode)
		DefsTateStr.InsertAt(i, Str1)
		DefsYokoStr.InsertAt(i, ConvTateYoko(Str1))	; 縦横変換
		DefsRepeat.InsertAt(i, Repeat)

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
SearchSet(SearchBit, KanaMode, nkeys)
{
	global DefsKey, DefsKanaMode, DefBegin, DefEnd
		, KC_SPC
;	local j, jmax	; カウンタ用
;		, LastSetted
;		, DefKeyCopy

	LastSetted := ((SearchBit & KC_SPC) ? 2 : 1)	; 初期値
	j := DefBegin[3]
	jmax := (nkeys >= 1 ? DefEnd[nkeys] : DefEnd[1])
	while (j < jmax)
	{
		; SearchBit は DefsKey[j] に内包されているか
		DefKeyCopy := DefsKey[j]
		if (SearchBit != DefKeyCopy && KanaMode == DefsKanaMode[j] && (DefKeyCopy & SearchBit) == SearchBit)
		{
			if ((DefKeyCopy & KC_SPC) == (SearchBit & KC_SPC))	; シフトも一致
				return 0	; 出力確定はしない
			else
				LastSetted := 1	; 後置シフトは出力確定しない
		}
		j++
	}
	return LastSetted
}

; 出力確定するかな定義を調べて DefsSetted[] に記録
; 0: 確定しない, 1: 通常シフトのみ確定, 2: 後置シフトでも確定
Setting()
{
	global DefsKey, DefsKanaMode, DefsSetted, DefBegin, DefEnd
;	local i, imax	; カウンタ用

	; 出力確定するか検索
	i := DefBegin[3]
	imax := DefEnd[1]
	while (i < imax)
	{
		SearchBit := DefsKey[i]
		DefsSetted[i] := SearchSet(SearchBit, DefsKanaMode[i], CountBit(SearchBit))
		i++
	}
	return
}
