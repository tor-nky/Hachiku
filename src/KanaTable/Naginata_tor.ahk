; **********************************************************************
; 【薙刀式】v14（仮）の配列図とDvorakJファイル
; http://oookaworks.seesaa.net/article/483714452.html#comment&gsc.tab=0
; (2021年10月4日)より
;
; 【薙刀式】v14仮のバグフィックス
; http://oookaworks.seesaa.net/article/483884499.html#gsc.tab=0
; (2021年10月14日)より
;
; 【薙刀式】１４仮のカナをひとつ交換
; http://oookaworks.seesaa.net/article/484030707.html#gsc.tab=0
; (2021年10月23日)より
;
;【薙刀式】同手シフトのR
; http://oookaworks.seesaa.net/article/484110925.html#gsc.tab=0
; (2021年10月29日)より
;
; DvorakJ版からの変更部分：
;	冗長シフトを加えた
;	記号はすべて全角文字を出力する
;	一太郎で編集モードD+F+Pの入力キャンセルを押しても、ESCメニューを残さない
;	編集モードD+F+H、J+K+G、J+K+Vで、変換中の文字があれば確定し、なければそのまま所定の動作をします。
;	編集モードM+Comma+W、M+Comma+S、M+Comma+F、M+Cooma+B の動作後にはクリップボードは空になる。ダミーの空白も入らない。
;	固有名詞ショートカットのシフト面（スペース押下）を追加
;	固有名詞ショートカットを最大５組を切り替えられる。切り替えは M+Comma+1 で１番、M+Comma+2 で２番、など。
; **********************************************************************

#Include %A_ScriptDir%/KanaTable/StandardLayout.ahk	; キーボード初期配列


; 特別出力
SendSP(Str1, CtrlNo)
{
	global KoyuNumber, Version, LayoutName, IniFilePath

	if (CtrlNo == "ESCx3")
	{
		SendEachChar(Str1)
		Sleep, % (IMESelect ? 140 : (DetectSlowIME() ? 150 : 80))
			; ATOK: 140, 旧MS-IME: 150, 新MS-IME: 80
		IfWinExist, ahk_class #32770	; 一太郎のメニューが出ている時
			Send, a
	}
	; 固有名詞ショートカットを切り替える
	else if (CtrlNo == "KoyuChange")
	{
		if (Str1 == KoyuNumber)	; 番号が変わらない
		{
			MsgBox, , , 固有名詞セット%KoyuNumber%
			return
		}
		MsgBox, 1, , 固有名詞 セット%KoyuNumber% → %Str1%
		IfMsgBox, Cancel	; キャンセル
			return

		KoyuNumber := Str1
		; 設定ファイル書き込み
		IniWrite, %KoyuNumber%, %IniFilePath%, Naginata, KoyuNumber
		; ツールチップを変更する
		menu, tray, tip, Hachiku %Version%`n%LayoutName%`n固有名詞セット%KoyuNumber%

		KoyuReadAndRegist(KoyuNumber)	; 固有名詞ショートカットの読み込み・登録
		SettingLayout()					; 出力確定する定義に印をつける
	}

	return
}

; ----------------------------------------------------------------------
; 英数／かな配列の定義ファイル 【すべて縦書き用で書くこと】
;
; 例：	SetKana( KC_Q | KC_L | KC_SPC		,"xwa"	, R)	; (ゎ)
;		~~~~~~~  ~~~~~~~~~~~~~~~~~~~~		  ~~~	  ~ 	  ~~~~
;		かな定義	スペース+Q+L	   縦書き用の出力 ↑	コメント
;													  ｜
			;						リピートあり(省略はリピートなし)
;
; 例：	 SetEisu( KC_H | KC_J			,"{vkF2 2}" )		; IME ON
;		 ~~~~~~~
;		 英数定義
;
;	※再読み込みか、再起動で有効になります
;	※全角空白の違いが見えるエディタを使うことをおすすめします
;	※UTF-8(BOM付)で保存してください
;	※順序はグループ内で自由です。同じキーの組み合わせは、後の方が有効になります。
; ----------------------------------------------------------------------

; 薙刀式配列固有名詞ショートカットを実装するためのルーチン
#Include %A_ScriptDir%/Sub/Naginata-Koyu.ahk

; かな配列読み込み
ReadLayout()
{
	#IncludeAgain %A_ScriptDir%/Sub/KeyBit_h.ahk	; 配列定義で使う定数
	global LayoutName, KoyuNumber

	LayoutName := "薙刀式配列v14仮（集大成版）20211029"

	ReadStandardLayout()	; キーボード初期配列を読み込み
	; ↑ 無くても動くが、あるほうがわずかに速い

	; -----------------------------------------
	; 別名登録
	; -----------------------------------------
	AL_小							:= KC_Q
	AL_き	:= AL_む				:= KC_W
	AL_て	:= AL_り				:= KC_E
	AL_し	:= AL_ぬ				:= KC_R
	AL_左							:= KC_T
	AL_右							:= KC_Y
	AL_BS	:= AL_さ				:= KC_U
	AL_る	:= AL_よ				:= KC_I
	AL_す	:= AL_え				:= KC_O
	AL_へ	:= AL_ゆ				:= KC_P

	AL_ろ	:= AL_せ				:= KC_A
	AL_け	:= AL_め				:= KC_S
	AL_と	:= AL_に				:= KC_D
	AL_か	:= AL_ま	:= AL_左濁	:= KC_F
	AL_っ	:= AL_ち				:= KC_G
	AL_く	:= AL_や				:= KC_H
	AL_あ	:= AL_の	:= AL_右濁	:= KC_J
	AL_い	:= AL_も				:= KC_K
	AL_う	:= AL_わ				:= KC_L
	AL_ー	:= AL_つ				:= KC_SCLN

	AL_ほ							:= KC_Z
	AL_ひ							:= KC_X
	AL_は	:= AL_を				:= KC_C
	AL_こ	:= AL_、	:= AL_左半	:= KC_V
	AL_そ	:= AL_み				:= KC_B
	AL_た	:= AL_お				:= KC_N
	AL_な	:= AL_。	:= AL_右半	:= KC_M
	AL_ん	:= AL_ね				:= KC_COMM
	AL_ら	:= AL_ふ				:= KC_DOT
	AL_れ							:= KC_SLSH
	; -----------------------------------------


KanaGroup := 0	; 0 はグループAll

;**********************************************
;**********************************************
; メイン部分; 単打とシフト
;**********************************************
;**********************************************

; 単打
	SetKana( AL_小	,"{Null}"	)		; ダミー
	SetKana( AL_き	,"ki"		)		; き
	SetKana( AL_て	,"te"		)		; て
	SetKana( AL_し	,"si"		)		; し
	SetKana( AL_左	,"{←}"		, R)	; 左
	SetKana( AL_右	,"{→}"		, R)	; 右
	SetKana( AL_BS	,"{BS}" 	, R)	; 前文字削除
	SetKana( AL_る	,"ru"		)		; る
	SetKana( AL_す	,"su"		)		; す
	SetKana( AL_へ	,"he"		)		; へ
	SetKana( AL_ろ	,"ro"		)		; ろ
	SetKana( AL_け	,"ke"		)		; け
	SetKana( AL_と	,"to"		)		; と
	SetKana( AL_か	,"ka"		)		; か
	SetKana( AL_っ	,"xtu"		)		; (っ)
	SetKana( AL_く	,"ku"		)		; く
	SetKana( AL_あ	,"a"		)		; あ
	SetKana( AL_い	,"i"		)		; い
	SetKana( AL_う	,"u"		)		; う
	SetKana( AL_ー	,"-"		)		; ー
	SetKana( AL_ほ	,"ho"		)		; ほ
	SetKana( AL_ひ	,"hi"		)		; ひ
	SetKana( AL_は	,"ha"		)		; は
	SetKana( AL_こ	,"ko"		)		; こ
	SetKana( AL_そ	,"so"		)		; そ
	SetKana( AL_た	,"ta"		)		; た
	SetKana( AL_な	,"na"		)		; な
	SetKana( AL_ん	,"nn"		)		; ん
	SetKana( AL_ら	,"ra"		)		; ら
	SetKana( AL_れ	,"re"		)		; れ

; センターシフト
	SetKana( AL_小 | KC_SPC		,"{Null}"	)		; ダミー
	SetKana( AL_ぬ | KC_SPC		,"nu"		)		; ぬ
	SetKana( AL_り | KC_SPC		,"ri"		)		; り
	SetKana( AL_む | KC_SPC		,"mu"		)		; む
	SetKana( AL_さ | KC_SPC		,"sa"		)		; さ
	SetKana( AL_よ | KC_SPC		,"yo"		)		; よ
	SetKana( AL_え | KC_SPC		,"e"		)		; え
	SetKana( AL_ゆ | KC_SPC		,"yu"		)		; ゆ
	SetKana( AL_せ | KC_SPC		,"se"		)		; せ
	SetKana( AL_め | KC_SPC		,"me"		)		; め
	SetKana( AL_に | KC_SPC		,"ni"		)		; に
	SetKana( AL_ま | KC_SPC		,"ma"		)		; ま
	SetKana( AL_ち | KC_SPC		,"ti"		)		; ち
	SetKana( AL_や | KC_SPC		,"ya"		)		; や
	SetKana( AL_の | KC_SPC		,"no"		)		; の
	SetKana( AL_も | KC_SPC		,"mo"		)		; も
	SetKana( AL_わ | KC_SPC		,"wa"		)		; わ
	SetKana( AL_つ | KC_SPC		,"tu"		)		; つ
	SetKana( AL_を | KC_SPC		,"wo"		)		; を
	SetKana( AL_、 | KC_SPC		,","		)		; 、
	SetKana( AL_み | KC_SPC		,"mi"		)		; み
	SetKana( AL_お | KC_SPC		,"o"		)		; お
	SetKana( AL_ね | KC_SPC		,"ne"		)		; ね
	SetKana( AL_ふ | KC_SPC		,"hu"		)		; ふ
	SetKana( AL_ほ | KC_SPC		,"ho"		)		; ほ
	SetKana( AL_ひ | KC_SPC		,"hi"		)		; ひ
	SetKana( AL_れ | KC_SPC		,"re"		)		; れ
	SetKana( AL_。 | KC_SPC		,".{Enter}"	)		; 。
	SetKana( AL_左 | KC_SPC		,"+{←}"	, R)	; シフト + 左
	SetKana( AL_右 | KC_SPC		,"+{→}"	, R)	; シフト + 右

;**********************************************
;**********************************************
; 同時押し; 濁音、半濁音、小書き、拗音、外来音
;**********************************************
;**********************************************
; 同時押しの定義は逆順もしておく

;****************************
; 濁音： 逆手の人差指中段
; 連続シフト中も有効

; 右手の濁音
	SetKana( AL_左濁 | AL_さ			,"za"	)	; ざ
	SetKana( AL_左濁 | AL_さ | KC_SPC	,"za"	)
	SetKana( AL_左濁 | AL_す			,"zu"	)	; ず
	SetKana( AL_左濁 | AL_す | KC_SPC	,"zu"	)
	SetKana( AL_左濁 | AL_へ			,"be"	)	; べ
	SetKana( AL_左濁 | AL_へ | KC_SPC	,"be"	)
	SetKana( AL_左濁 | AL_く			,"gu"	)	; ぐ
	SetKana( AL_左濁 | AL_く | KC_SPC	,"gu"	)
	SetKana( AL_左濁 | AL_う			,"vu"	)	; ヴ
	SetKana( AL_左濁 | AL_う | KC_SPC	,"vu"	)
	SetKana( AL_左濁 | AL_つ			,"du"	)	; づ
	SetKana( AL_左濁 | AL_つ | KC_SPC	,"du"	)
	SetKana( AL_左濁 | AL_た			,"da"	)	; だ
	SetKana( AL_左濁 | AL_た | KC_SPC	,"da"	)
	SetKana( AL_左濁 | AL_ふ			,"bu"	)	; ぶ
	SetKana( AL_左濁 | AL_ふ | KC_SPC	,"bu"	)

; 左手の濁音
	SetKana( AL_右濁 | AL_き			,"gi"	)	; ぎ
	SetKana( AL_右濁 | AL_き | KC_SPC	,"gi"	)
	SetKana( AL_右濁 | AL_て			,"de"	)	; で
	SetKana( AL_右濁 | AL_て | KC_SPC	,"de"	)
	SetKana( AL_右濁 | AL_し			,"zi"	)	; じ
	SetKana( AL_右濁 | AL_し | KC_SPC	,"zi"	)
	SetKana( AL_右濁 | AL_せ			,"ze"	)	; ぜ
	SetKana( AL_右濁 | AL_せ | KC_SPC	,"ze"	)
	SetKana( AL_右濁 | AL_け			,"ge"	)	; げ
	SetKana( AL_右濁 | AL_け | KC_SPC	,"ge"	)
	SetKana( AL_右濁 | AL_と			,"do"	)	; ど
	SetKana( AL_右濁 | AL_と | KC_SPC	,"do"	)
	SetKana( AL_右濁 | AL_か			,"ga"	)	; が
	SetKana( AL_右濁 | AL_か | KC_SPC	,"ga"	)
	SetKana( AL_右濁 | AL_ち			,"di"	)	; ぢ
	SetKana( AL_右濁 | AL_ち | KC_SPC	,"di"	)
	SetKana( AL_右濁 | AL_ほ			,"bo"	)	; ぼ
	SetKana( AL_右濁 | AL_ほ | KC_SPC	,"bo"	)
	SetKana( AL_右濁 | AL_ひ			,"bi"	)	; び
	SetKana( AL_右濁 | AL_ひ | KC_SPC	,"bi"	)
	SetKana( AL_右濁 | AL_は			,"ba"	)	; ば
	SetKana( AL_右濁 | AL_は | KC_SPC	,"ba"	)
	SetKana( AL_右濁 | AL_こ			,"go"	)	; ご
	SetKana( AL_右濁 | AL_こ | KC_SPC	,"go"	)
	SetKana( AL_右濁 | AL_そ			,"zo"	)	; ぞ
	SetKana( AL_右濁 | AL_そ | KC_SPC	,"zo"	)

;****************************
; 半濁音： 逆手の下段人差し指
; 連続シフト中も有効

; 右の半濁音
	SetKana( AL_左半 | AL_へ			,"pe"	)	; ぺ
	SetKana( AL_左半 | AL_へ | KC_SPC	,"pe"	)
	SetKana( AL_左半 | AL_ふ			,"pu"	)	; ぷ
	SetKana( AL_左半 | AL_ふ | KC_SPC	,"pu"	)

; 左の半濁音
	SetKana( AL_右半 | AL_ほ			,"po"	)	; ぽ
	SetKana( AL_右半 | AL_ほ | KC_SPC	,"po"	)
	SetKana( AL_右半 | AL_ひ			,"pi"	)	; ぴ
	SetKana( AL_右半 | AL_ひ | KC_SPC	,"pi"	)
	SetKana( AL_右半 | AL_は			,"pa"	)	; ぱ
	SetKana( AL_右半 | AL_は | KC_SPC	,"pa"	)

;****************************
; 小書き： Qと同時押し
	SetKana( AL_小 | AL_よ				,"xyo"	)	; (ょ)
	SetKana( AL_小 | AL_よ | KC_SPC		,"xyo"	)
	SetKana( AL_小 | AL_え				,"xe"	)	; (ぇ)
	SetKana( AL_小 | AL_え | KC_SPC		,"xe"	)
	SetKana( AL_小 | AL_ゆ				,"xyu"	)	; (ゅ)
	SetKana( AL_小 | AL_ゆ | KC_SPC		,"xyu"	)
	SetKana( AL_小 | AL_や				,"xya"	)	; (ゃ)
	SetKana( AL_小 | AL_や | KC_SPC		,"xya"	)
	SetKana( AL_小 | AL_あ				,"xa"	)	; (ぁ)
	SetKana( AL_小 | AL_あ | KC_SPC		,"xa"	)
	SetKana( AL_小 | AL_い				,"xi"	)	; (ぃ)
	SetKana( AL_小 | AL_い | KC_SPC		,"xi"	)
	SetKana( AL_小 | AL_う				,"xu"	)	; (ぅ)
	SetKana( AL_小 | AL_お				,"xo"	)	; (ぉ)
	SetKana( AL_小 | AL_お | KC_SPC		,"xo"	)

	SetKana( AL_小 | AL_わ | KC_SPC		,"xwa"	)	; (ゎ)

;**********************************************
; 拗音、外来音(３キー同時を含む)
;**********************************************
;****************************
; 清音拗音; やゆよと同時押しで、ゃゅょが付く
	SetKana( AL_き | AL_や				,"kya"	)	; きゃ
	SetKana( AL_き | AL_や | KC_SPC		,"kya"	)
	SetKana( AL_り | AL_や				,"rya"	)	; りゃ
	SetKana( AL_り | AL_や | KC_SPC		,"rya"	)
	SetKana( AL_し | AL_や				,"sya"	)	; しゃ
	SetKana( AL_し | AL_や | KC_SPC		,"sya"	)
	SetKana( AL_に | AL_や				,"nya"	)	; にゃ
	SetKana( AL_に | AL_や | KC_SPC		,"nya"	)
	SetKana( AL_ち | AL_や				,"tya"	)	; ちゃ
	SetKana( AL_ち | AL_や | KC_SPC		,"tya"	)
	SetKana( AL_ひ | AL_や				,"hya"	)	; ひゃ
	SetKana( AL_ひ | AL_や | KC_SPC		,"hya"	)
	SetKana( AL_み | AL_や				,"mya"	)	; みゃ
	SetKana( AL_み | AL_や | KC_SPC		,"mya"	)

	SetKana( AL_き | AL_ゆ				,"kyu"	)	; きゅ
	SetKana( AL_き | AL_ゆ | KC_SPC		,"kyu"	)
	SetKana( AL_り | AL_ゆ				,"ryu"	)	; りゅ
	SetKana( AL_り | AL_ゆ | KC_SPC		,"ryu"	)
	SetKana( AL_し | AL_ゆ				,"syu"	)	; しゅ
	SetKana( AL_し | AL_ゆ | KC_SPC		,"syu"	)
	SetKana( AL_に | AL_ゆ				,"nyu"	)	; にゅ
	SetKana( AL_に | AL_ゆ | KC_SPC		,"nyu"	)
	SetKana( AL_ち | AL_ゆ				,"tyu"	)	; ちゅ
	SetKana( AL_ち | AL_ゆ | KC_SPC		,"tyu"	)
	SetKana( AL_ひ | AL_ゆ				,"hyu"	)	; ひゅ
	SetKana( AL_ひ | AL_ゆ | KC_SPC		,"hyu"	)
	SetKana( AL_み | AL_ゆ				,"myu"	)	; みゅ
	SetKana( AL_み | AL_ゆ | KC_SPC		,"myu"	)

	SetKana( AL_き | AL_よ				,"kyo"	)	; きょ
	SetKana( AL_き | AL_よ | KC_SPC		,"kyo"	)
	SetKana( AL_り | AL_よ				,"ryo"	)	; りょ
	SetKana( AL_り | AL_よ | KC_SPC		,"ryo"	)
	SetKana( AL_し | AL_よ				,"syo"	)	; しょ
	SetKana( AL_し | AL_よ | KC_SPC		,"syo"	)
	SetKana( AL_に | AL_よ				,"nyo"	)	; にょ
	SetKana( AL_に | AL_よ | KC_SPC		,"nyo"	)
	SetKana( AL_ち | AL_よ				,"tyo"	)	; ちょ
	SetKana( AL_ち | AL_よ | KC_SPC		,"tyo"	)
	SetKana( AL_ひ | AL_よ				,"hyo"	)	; ひょ
	SetKana( AL_ひ | AL_よ | KC_SPC		,"hyo"	)
	SetKana( AL_み | AL_よ				,"myo"	)	; みょ
	SetKana( AL_み | AL_よ | KC_SPC		,"myo"	)

;****************************
; 濁音拗音
	SetKana( AL_右濁 | AL_き | AL_や			,"gya"		)	; ぎゃ
	SetKana( AL_右濁 | AL_き | AL_や | KC_SPC	,"gya"		)
	SetKana( AL_右濁 | AL_し | AL_や			,"ja"		)	; じゃ
	SetKana( AL_右濁 | AL_し | AL_や | KC_SPC	,"ja"		)
	SetKana( AL_右濁 | AL_ち | AL_や			,"dya"		)	; ぢゃ
	SetKana( AL_右濁 | AL_ち | AL_や | KC_SPC	,"dya"		)
	SetKana( AL_右濁 | AL_ひ | AL_や			,"bya"		)	; びゃ
	SetKana( AL_右濁 | AL_ひ | AL_や | KC_SPC	,"bya"		)

	SetKana( AL_右濁 | AL_き | AL_ゆ			,"gyu"		)	; ぎゅ
	SetKana( AL_右濁 | AL_き | AL_ゆ | KC_SPC	,"gyu"		)
	SetKana( AL_右濁 | AL_し | AL_ゆ			,"ju"		)	; じゅ
	SetKana( AL_右濁 | AL_し | AL_ゆ | KC_SPC	,"ju"		)
	SetKana( AL_右濁 | AL_ち | AL_ゆ			,"dyu"		)	; ぢゅ
	SetKana( AL_右濁 | AL_ち | AL_ゆ | KC_SPC	,"dyu"		)
	SetKana( AL_右濁 | AL_ひ | AL_ゆ			,"byu"		)	; びゅ
	SetKana( AL_右濁 | AL_ひ | AL_ゆ | KC_SPC	,"byu"		)

	SetKana( AL_右濁 | AL_き | AL_よ			,"gyo"		)	; ぎょ
	SetKana( AL_右濁 | AL_き | AL_よ | KC_SPC	,"gyo"		)
	SetKana( AL_右濁 | AL_し | AL_よ			,"jo"		)	; じょ
	SetKana( AL_右濁 | AL_し | AL_よ | KC_SPC	,"jo"		)
	SetKana( AL_右濁 | AL_ち | AL_よ			,"dyo"		)	; ぢょ
	SetKana( AL_右濁 | AL_ち | AL_よ | KC_SPC	,"dyo"		)
	SetKana( AL_右濁 | AL_ひ | AL_よ			,"byo"		)	; びょ
	SetKana( AL_右濁 | AL_ひ | AL_よ | KC_SPC	,"byo"		)

;****************************
; 半濁音拗音
	SetKana( AL_右半 | AL_ひ | AL_よ			,"pyo"		)	; ぴょ
	SetKana( AL_右半 | AL_ひ | AL_よ | KC_SPC	,"pyo"		)
	SetKana( AL_右半 | AL_ひ | AL_ゆ			,"pyu"		)	; ぴゅ
	SetKana( AL_右半 | AL_ひ | AL_ゆ | KC_SPC	,"pyu"		)
	SetKana( AL_右半 | AL_ひ | AL_や			,"pya"		)	; ぴゃ
	SetKana( AL_右半 | AL_ひ | AL_や | KC_SPC	,"pya"		)

;*************************************
; 外来音は3キー同時押しに統一しました
;*************************************
; 清音外来音は半濁音キーと使用二音の三音同時
; 濁音外来音は濁音キーと使用二音の三音同時
;****************************

; テ; ティテュディデュ
	SetKana( AL_右半 | AL_て | AL_ゆ			,"thu"		)	; てゅ
	SetKana( AL_右半 | AL_て | AL_ゆ | KC_SPC	,"thu"		)
	SetKana( AL_右半 | AL_て | AL_い			,"thi"		)	; てぃ
	SetKana( AL_右半 | AL_て | AL_い | KC_SPC	,"thi"		)

	SetKana( AL_右濁 | AL_て | AL_ゆ			,"dhu"		)	; でゅ
	SetKana( AL_右濁 | AL_て | AL_ゆ | KC_SPC	,"dhu"		)
	SetKana( AL_右濁 | AL_て | AL_い			,"dhi"		)	; でぃ
	SetKana( AL_右濁 | AL_て | AL_い | KC_SPC	,"dhi"		)

; ト; トゥドゥ
	SetKana( AL_右半 | AL_と | AL_う			,"twu"		)	; とぅ
	SetKana( AL_右半 | AL_と | AL_う | KC_SPC	,"twu"		)
	SetKana( AL_右濁 | AL_と | AL_う			,"dwu"		)	; どぅ
	SetKana( AL_右濁 | AL_と | AL_う | KC_SPC	,"dwu"		)

; シチ ェ; シェジェチェヂェ
	SetKana( AL_右半 | AL_し | AL_え			,"sye"		)	; しぇ
	SetKana( AL_右半 | AL_し | AL_え | KC_SPC	,"sye"		)
	SetKana( AL_右半 | AL_ち | AL_え			,"tye"		)	; ちぇ
	SetKana( AL_右半 | AL_ち | AL_え | KC_SPC	,"tye"		)
	SetKana( AL_右濁 | AL_し | AL_え			,"je"		)	; じぇ
	SetKana( AL_右濁 | AL_し | AL_え | KC_SPC	,"je"		)
	SetKana( AL_右濁 | AL_ち | AL_え			,"dye"		)	; ぢぇ
	SetKana( AL_右濁 | AL_ち | AL_え | KC_SPC	,"dye"		)

;****************************
; フ; ファフィフェフォフュ
	SetKana( AL_左半 | AL_ふ | AL_え			,"fe"		)	; ふぇ
	SetKana( AL_左半 | AL_ふ | AL_え | KC_SPC	,"fe"		)
	SetKana( AL_左半 | AL_ふ | AL_ゆ			,"fyu"		)	; ふゅ
	SetKana( AL_左半 | AL_ふ | AL_ゆ | KC_SPC	,"fyu"		)
	SetKana( AL_左半 | AL_ふ | AL_あ			,"fa"		)	; ふぁ
	SetKana( AL_左半 | AL_ふ | AL_あ | KC_SPC	,"fa"		)
	SetKana( AL_左半 | AL_ふ | AL_い			,"fi"		)	; ふぃ
	SetKana( AL_左半 | AL_ふ | AL_い | KC_SPC	,"fi"		)
	SetKana( AL_左半 | AL_ふ | AL_お			,"fo"		)	; ふぉ
	SetKana( AL_左半 | AL_ふ | AL_お | KC_SPC	,"fo"		)

; ヴ; ヴァヴィヴェヴォヴュ
	SetKana( AL_左濁 | AL_う | AL_え			,"ve"		)	; ヴぇ
	SetKana( AL_左濁 | AL_う | AL_え | KC_SPC	,"ve"		)
	SetKana( AL_左濁 | AL_う | AL_ゆ			,"vuxyu"	)	; ヴゅ
	SetKana( AL_左濁 | AL_う | AL_ゆ | KC_SPC	,"vuxyu"	)
	SetKana( AL_左濁 | AL_う | AL_あ			,"va"		)	; ヴぁ
	SetKana( AL_左濁 | AL_う | AL_あ | KC_SPC	,"va"		)
	SetKana( AL_左濁 | AL_う | AL_い			,"vi"		)	; ヴぃ
	SetKana( AL_左濁 | AL_う | AL_い | KC_SPC	,"vi"		)
	SetKana( AL_左濁 | AL_う | AL_お			,"vo"		)	; ヴぉ
	SetKana( AL_左濁 | AL_う | AL_お | KC_SPC	,"vo"		)

; う; ウィウェウォ　い；イェ
	SetKana( AL_左半 | AL_う | AL_え			,"we"		)	; うぇ
	SetKana( AL_左半 | AL_う | AL_え | KC_SPC	,"we"		)
	SetKana( AL_左半 | AL_う | AL_い			,"wi"		)	; うぃ
	SetKana( AL_左半 | AL_う | AL_い | KC_SPC	,"wi"		)
	SetKana( AL_左半 | AL_う | AL_お			,"uxo"		)	; うぉ
	SetKana( AL_左半 | AL_う | AL_お | KC_SPC	,"uxo"		)

	SetKana( AL_左半 | AL_い | AL_え			,"ye"		)	; いぇ
	SetKana( AL_左半 | AL_い | AL_え | KC_SPC	,"ye"		)

; ク; クァクィクェクォ
	SetKana( AL_左半 | AL_く | AL_え			,"kuxe"		)	; くぇ
	SetKana( AL_左半 | AL_く | AL_え | KC_SPC	,"kuxe"		)
	SetKana( AL_左半 | AL_く | AL_あ			,"kuxa"		)	; くぁ
	SetKana( AL_左半 | AL_く | AL_あ | KC_SPC	,"kuxa"		)
	SetKana( AL_左半 | AL_く | AL_い			,"kuxi"		)	; くぃ
	SetKana( AL_左半 | AL_く | AL_い | KC_SPC	,"kuxi"		)
	SetKana( AL_左半 | AL_く | AL_う			,"kuxwa"	)	; くゎ
	SetKana( AL_左半 | AL_く | AL_う | KC_SPC	,"kuxwa"	)
	SetKana( AL_左半 | AL_く | AL_お			,"kuxo"		)	; くぉ
	SetKana( AL_左半 | AL_く | AL_お | KC_SPC	,"kuxo"		)

; グ; グァグィグェグォ
	SetKana( AL_左濁 | AL_く | AL_え			,"guxe"		)	; ぐぇ
	SetKana( AL_左濁 | AL_く | AL_え | KC_SPC	,"guxe"		)
	SetKana( AL_左濁 | AL_く | AL_あ			,"gwa"		)	; ぐぁ
	SetKana( AL_左濁 | AL_く | AL_あ | KC_SPC	,"gwa"		)
	SetKana( AL_左濁 | AL_く | AL_い			,"guxi"		)	; ぐぃ
	SetKana( AL_左濁 | AL_く | AL_い | KC_SPC	,"guxi"		)
	SetKana( AL_左濁 | AL_く | AL_う			,"guxwa"	)	; ぐゎ
	SetKana( AL_左濁 | AL_く | AL_う | KC_SPC	,"guxwa"	)
	SetKana( AL_左濁 | AL_く | AL_お			,"guxo"		)	; ぐぉ
	SetKana( AL_左濁 | AL_く | AL_お | KC_SPC	,"guxo"		)

; ツ; ツァツィツェツォ
	SetKana( AL_左半 | AL_つ | AL_え			,"tse"		)	; つぇ
	SetKana( AL_左半 | AL_つ | AL_え | KC_SPC	,"tse"		)
	SetKana( AL_左半 | AL_つ | AL_あ			,"tsa"		)	; つぁ
	SetKana( AL_左半 | AL_つ | AL_あ | KC_SPC	,"tsa"		)
	SetKana( AL_左半 | AL_つ | AL_い			,"tsi"		)	; つぃ
	SetKana( AL_左半 | AL_つ | AL_い | KC_SPC	,"tsi"		)
	SetKana( AL_左半 | AL_つ | AL_お			,"tso"		)	; つぉ
	SetKana( AL_左半 | AL_つ | AL_お | KC_SPC	,"tso"		)

; IME ON/OFF
; 事前に、MS-IMEのプロパティで、
; ひらがなカタカナキー：IME ON、無変換キー：IME OFFに設定のこと
; HJ: ON / FG: OFF

	SetKana( KC_H | KC_J			,"{vkF2 2}"		)	; IME ON
	SetEisu( KC_H | KC_J			,"{vkF2 2}"		)
	SetKana( KC_F | KC_G			,"{vkF2}{vkF3}"	)	; IME OFF
	SetEisu( KC_F | KC_G			,"{vkF2}{vkF3}"	)

; Enter
; VとMの同時押し
	SetKana( KC_V | KC_M			,"{Enter}"		)	; 行送り
	SetKana( KC_V | KC_M | KC_SPC	,"{Enter}"		)
	SetEisu( KC_V | KC_M			,"{Enter}"		)	; 行送り
	SetEisu( KC_V | KC_M | KC_SPC	,"{Enter}"		)

;***********************************
;***********************************
; 編集モード、固有名詞ショートカット
;***********************************
;***********************************

; 編集モード１
; 中段人差し指＋中指を押しながら
; 「て」の部分は定義できない。「ディ」があるため

; 左手
KanaGroup := "1L"
	SetKana( KC_J | KC_K | KC_Q		,"{確定}^{End}"		)		; ◀新
	SetKana( KC_J | KC_K | KC_W		,"『』{確定}{↑}"	)		; 『』
;	SetKana( KC_J | KC_K | KC_E		,"dhi"				)		; ディ
	SetKana( KC_J | KC_K | KC_R		,"^s"				)		; 保
	SetKana( KC_J | KC_K | KC_T		,"/"				)		; ・未確定
	SetKana( KC_J | KC_K | KC_A		,"……{確定}"		)		; ……
	SetKana( KC_J | KC_K | KC_S		,"（）{確定}{↑}"	)		; （）
	SetKana( KC_J | KC_K | KC_D		,"？{確定}"			)		; ？
	SetKana( KC_J | KC_K | KC_F		,"「」{確定}{↑}"	)		; 「」
	SetKana( KC_J | KC_K | KC_G		,"{確定}{End}{改行}「」{確定}{↑}") ; ⏎「」
	SetKana( KC_J | KC_K | KC_Z		,"││{確定}"		)		; ──
	SetKana( KC_J | KC_K | KC_X		,"【】{確定}{↑}"	)		; 【】
	SetKana( KC_J | KC_K | KC_C		,"！{確定}"			)		; ！
	SetKana( KC_J | KC_K | KC_V		,"{確定}{↓}"		)		; ⏎↓
	SetKana( KC_J | KC_K | KC_B		,"《》{確定}{↑}"	)		; 《》

	SetEisu( KC_J | KC_K | KC_Q		,"{確定}^{End}"		)		; ◀新
	SetEisu( KC_J | KC_K | KC_W		,"『』{確定}{↑}"	)		; 『』
;	SetEisu( KC_J | KC_K | KC_E		,"dhi"				)		; ディ
	SetEisu( KC_J | KC_K | KC_R		,"^s"				)		; 保
	SetEisu( KC_J | KC_K | KC_T		,"/"				)		; ・未確定
	SetEisu( KC_J | KC_K | KC_A		,"……{確定}"		)		; ……
	SetEisu( KC_J | KC_K | KC_S		,"（）{確定}{↑}"	)		; （）
	SetEisu( KC_J | KC_K | KC_D		,"？{確定}"			)		; ？
	SetEisu( KC_J | KC_K | KC_F		,"「」{確定}{↑}"	)		; 「」
	SetEisu( KC_J | KC_K | KC_G		,"{確定}{End}{改行}「」{確定}{↑}") ; ⏎「」
	SetEisu( KC_J | KC_K | KC_Z		,"││{確定}"		)		; ──
	SetEisu( KC_J | KC_K | KC_X		,"【】{確定}{↑}"	)		; 【】
	SetEisu( KC_J | KC_K | KC_C		,"！{確定}"			)		; ！
	SetEisu( KC_J | KC_K | KC_V		,"{確定}{↓}"		)		; ⏎↓
	SetEisu( KC_J | KC_K | KC_B		,"《》{確定}{↑}"	)		; 《》

; 右手
KanaGroup := "1R"
	SetKana( KC_D | KC_F | KC_Y		,"{Home}"			)		; ▲Home
	SetKana( KC_D | KC_F | KC_U		,"+{End}{BS}"		)		; 末消▼
	SetKana( KC_D | KC_F | KC_I		,"{vk1C}"			)		; 再
	SetKana( KC_D | KC_F | KC_O		,"{Del}"			)		; Del
	SetKana( KC_D | KC_F | KC_P		,"+{Esc}{Esc 2}"	, "ESCx3") ; キャン
	SetKana( KC_D | KC_F | KC_H		,"{確定}{End}"		)		; ⏎End▼
	SetKana( KC_D | KC_F | KC_J		,"{↑}"				, R)	; ↑
	SetKana( KC_D | KC_F | KC_K		,"+{↑}"			, R)	; +↑
	SetKana( KC_D | KC_F | KC_L		,"{↑ 5}"			, R)	; 5↑
	SetKana( KC_D | KC_F | KC_SCLN	,"+{↑ 5}"			, R)	; +5↑
	SetKana( KC_D | KC_F | KC_N		,"{End}"			)		; End▼
	SetKana( KC_D | KC_F | KC_M		,"{↓}"				, R)	; ↓
	SetKana( KC_D | KC_F | KC_COMM	,"+{↓}"			, R)	; +↓
	SetKana( KC_D | KC_F | KC_DOT	,"{↓ 5}"			, R)	; 5↓
	SetKana( KC_D | KC_F | KC_SLSH	,"+{↓ 5}"			, R)	; +5↓

	SetEisu( KC_D | KC_F | KC_Y		,"{Home}"			)		; ▲Home
	SetEisu( KC_D | KC_F | KC_U		,"+{End}{BS}"		)		; 末消▼
	SetEisu( KC_D | KC_F | KC_I		,"{vk1C}"			)		; 再
	SetEisu( KC_D | KC_F | KC_O		,"{Del}"			)		; Del
	SetEisu( KC_D | KC_F | KC_P		,"+{Esc}{Esc 2}"	, "ESCx3") ; キャン
	SetEisu( KC_D | KC_F | KC_H		,"{確定}{End}"		)		; ⏎End▼
	SetEisu( KC_D | KC_F | KC_J		,"{↑}"				, R)	; ↑
	SetEisu( KC_D | KC_F | KC_K		,"+{↑}"			, R)	; +↑
	SetEisu( KC_D | KC_F | KC_L		,"{↑ 5}"			, R)	; 5↑
	SetEisu( KC_D | KC_F | KC_SCLN	,"+{↑ 5}"			, R)	; +5↑
	SetEisu( KC_D | KC_F | KC_N		,"{End}"			)		; End▼
	SetEisu( KC_D | KC_F | KC_M		,"{↓}"				, R)	; ↓
	SetEisu( KC_D | KC_F | KC_COMM	,"+{↓}"			, R)	; +↓
	SetEisu( KC_D | KC_F | KC_DOT	,"{↓ 5}"			, R)	; 5↓
	SetEisu( KC_D | KC_F | KC_SLSH	,"+{↓ 5}"			, R)	; +5↓

; 編集モード２
; 下段人差指＋中指

; 左手
KanaGroup := "2L"
	SetKana( KC_M | KC_COMM | KC_Q	,"　　　×　　　×　　　×{確定}{改行}") ; x   x   x
	SetKana( KC_M | KC_COMM | KC_W	,"^x『^v』{確定}{C_Clr}"			)		; +『』
	SetKana( KC_M | KC_COMM | KC_E	,"{Home}{改行}　　　{End}"			)		; 行頭□□□挿入
	SetKana( KC_M | KC_COMM | KC_R	,"{Home}{改行}　{End}"				)		; 行頭□挿入
	SetKana( KC_M | KC_COMM | KC_T	,"〇{確定}"							)		; ○
	SetKana( KC_M | KC_COMM | KC_A	,"+{PgUp}"							, R)	; ▶+Page
	SetKana( KC_M | KC_COMM | KC_S	,"^x（^v）{確定}{C_Clr}"			)		; +（）
	SetKana( KC_M | KC_COMM | KC_D	,"　　　"							)		; □□□
	SetKana( KC_M | KC_COMM | KC_F	,"^x「^v」{確定}{C_Clr}"			)		; +「」
	SetKana( KC_M | KC_COMM | KC_G	,"／{確定}"							)		; ／
	SetKana( KC_M | KC_COMM | KC_Z	,"+{PgDn}"							, R)	; ◀+Page
	SetKana( KC_M | KC_COMM | KC_X	,"^x{BS}{Del}^v"					)		; カッコ外し
	SetKana( KC_M | KC_COMM | KC_C	,"{Home}{BS}{Del 3}{End}"			)		; 行頭□□□戻し
	SetKana( KC_M | KC_COMM | KC_V	,"{Home}{BS}{Del 1}{End}"			)		; 行頭□戻し
	SetKana( KC_M | KC_COMM | KC_B	,"^x｜{確定}^v《》{確定}{↑}{C_Clr}")		; ｜《》

	SetEisu( KC_M | KC_COMM | KC_Q	,"　　　×　　　×　　　×{確定}{改行}") ; x   x   x
	SetEisu( KC_M | KC_COMM | KC_W	,"^x『^v』{確定}{C_Clr}"			)		; +『』
	SetEisu( KC_M | KC_COMM | KC_E	,"{Home}{改行}　　　{End}"			)		; 行頭□□□挿入
	SetEisu( KC_M | KC_COMM | KC_R	,"{Home}{改行}　{End}"				)		; 行頭□挿入
	SetEisu( KC_M | KC_COMM | KC_T	,"〇{確定}"							)		; ○
	SetEisu( KC_M | KC_COMM | KC_A	,"+{PgUp}"							, R)	; ▶+Page
	SetEisu( KC_M | KC_COMM | KC_S	,"^x（^v）{確定}{C_Clr}"			)		; +（）
	SetEisu( KC_M | KC_COMM | KC_D	,"　　　"							)		; □□□
	SetEisu( KC_M | KC_COMM | KC_F	,"^x「^v」{確定}{C_Clr}"			)		; +「」
	SetEisu( KC_M | KC_COMM | KC_G	,"／{確定}"							)		; ／
	SetEisu( KC_M | KC_COMM | KC_Z	,"+{PgDn}"							, R)	; ◀+Page
	SetEisu( KC_M | KC_COMM | KC_X	,"^x{BS}{Del}^v"					)		; カッコ外し
	SetEisu( KC_M | KC_COMM | KC_C	,"{Home}{BS}{Del 3}{End}"			)		; 行頭□□□戻し
	SetEisu( KC_M | KC_COMM | KC_V	,"{Home}{BS}{Del 1}{End}"			)		; 行頭□戻し
	SetEisu( KC_M | KC_COMM | KC_B	,"^x｜{確定}^v《》{確定}{↑}{C_Clr}")		; ｜《》

; 右手
KanaGroup := "2R"
	SetKana( KC_C | KC_V | KC_Y		,"+{Home}"							)		; ▲+Home
	SetKana( KC_C | KC_V | KC_U		,"^x"								)		; Cut
	SetKana( KC_C | KC_V | KC_I		,"^v"								)		; Paste
	SetKana( KC_C | KC_V | KC_O		,"^u"								)		; ひらがな
	SetKana( KC_C | KC_V | KC_P		,"^i"								)		; カタカナ
	SetKana( KC_C | KC_V | KC_H		,"^c"								)		; Copy
	SetKana( KC_C | KC_V | KC_J		,"{→}"								, R)	; →
	SetKana( KC_C | KC_V | KC_K		,"+{→}"							, R)	; +→
	SetKana( KC_C | KC_V | KC_L		,"{→ 5}"							, R)	; →5
	SetKana( KC_C | KC_V | KC_SCLN	,"+{→ 5}"							, R)	; +→5
	SetKana( KC_C | KC_V | KC_N		,"+{End}"							)		; +End▼
	SetKana( KC_C | KC_V | KC_M		,"{←}"								, R)	; ←
	SetKana( KC_C | KC_V | KC_COMM	,"+{←}"							, R)	; +←
	SetKana( KC_C | KC_V | KC_DOT	,"{← 5}"							, R)	; ←5
	SetKana( KC_C | KC_V | KC_SLSH	,"+{← 5}"							, R)	; +←5

	SetEisu( KC_C | KC_V | KC_Y		,"+{Home}"							)		; ▲+Home
	SetEisu( KC_C | KC_V | KC_U		,"^x"								)		; Cut
	SetEisu( KC_C | KC_V | KC_I		,"^v"								)		; Paste
	SetEisu( KC_C | KC_V | KC_O		,"^u"								)		; ひらがな
	SetEisu( KC_C | KC_V | KC_P		,"^i"								)		; カタカナ
	SetEisu( KC_C | KC_V | KC_H		,"^c"								)		; Copy
	SetEisu( KC_C | KC_V | KC_J		,"{→}"								, R)	; →
	SetEisu( KC_C | KC_V | KC_K		,"+{→}"							, R)	; +→
	SetEisu( KC_C | KC_V | KC_L		,"{→ 5}"							, R)	; →5
	SetEisu( KC_C | KC_V | KC_SCLN	,"+{→ 5}"							, R)	; +→5
	SetEisu( KC_C | KC_V | KC_N		,"+{End}"							)		; +End▼
	SetEisu( KC_C | KC_V | KC_M		,"{←}"								, R)	; ←
	SetEisu( KC_C | KC_V | KC_COMM	,"+{←}"							, R)	; +←
	SetEisu( KC_C | KC_V | KC_DOT	,"{← 5}"							, R)	; ←5
	SetEisu( KC_C | KC_V | KC_SLSH	,"+{← 5}"							, R)	; +←5

KanaGroup := 0	; 0 はグループAll

	; 固有名詞ショートカット(U+I)を押し続けて
	; 前文字削除(U)のリピートが起きる場合があるので対策
	SetKana( KC_U | KC_I					,"{Null}"	)	; ダミー


	; 設定がUSキーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	if (KeyDriver = "kbd101.dll")
	{
	; おまけ
		SetEisu( JP_YEN				,"\"	)	; ￥
		SetEisu( KC_INT1			,"\"	)	; ￥
		SetEisu( JP_YEN | KC_SPC	,"|"	)	; ｜	スペース押しながら
		SetEisu( KC_INT1 | KC_SPC	,"_"	)	; ＿	スペース押しながら

		SetKana( JP_YEN				,"\"	)	; ￥
		SetKana( JP_YEN | KC_SPC	,"|"	)	; ｜	スペース押しながら
	}

	if (USLike > 0)
		USLikeLayout()	; USキーボード風の配列へ

	KoyuReadAndRegist(KoyuNumber)	; 固有名詞ショートカットの読み込み・登録

	return
}

; USキーボード風の配列へ
USLikeLayout()
{
	#IncludeAgain %A_ScriptDir%/Sub/KeyBit_h.ahk	; 配列定義で使う定数

	; 設定がUSキーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	if (KeyDriver = "kbd101.dll")
		return

KanaGroup := 0	; 0 はグループAll
	SetEisu( KC_EQL				,"+{sc0C}"	)	; =
	SetEisu( KC_LBRC			,"{sc1B}"	)	; [
	SetEisu( KC_RBRC			,"{sc2B}"	)	; ]
	SetEisu( KC_QUOT			,"+{sc08}"	)	; '
	SetEisu( KC_NUHS			,"+{sc1A}"	)	; `

	SetEisu( KC_2 | KC_SPC		,"{sc1A}"	)	; @
	SetEisu( KC_6 | KC_SPC		,"{sc0D}"	)	; ^
	SetEisu( KC_7 | KC_SPC		,"+{sc07}"	)	; &
	SetEisu( KC_8 | KC_SPC		,"+{sc28}"	)	; *
	SetEisu( KC_9 | KC_SPC		,"+{sc09}"	)	; (
	SetEisu( KC_0 | KC_SPC		,"+{sc0A}"	)	; )
	SetEisu( KC_MINS | KC_SPC	,"+{sc73}"	)	; _
	SetEisu( KC_EQL | KC_SPC	,"+{sc27}"	)	; +
	SetEisu( KC_LBRC | KC_SPC	,"+{sc1B}"	)	; {
	SetEisu( KC_RBRC | KC_SPC	,"+{sc2B}"	)	; }
	SetEisu( KC_SCLN | KC_SPC	,"{sc28}"	)	; :
	SetEisu( KC_QUOT | KC_SPC	,"+{sc03}"	)	; "
	SetEisu( KC_NUHS | KC_SPC	,"+{sc0D}"	)	; ~


	SetKana( KC_EQL				,"+{sc0C}"	)	; =
	SetKana( KC_LBRC			,"{sc1B}"	)	; [
	SetKana( KC_RBRC			,"{sc2B}"	)	; ]
	SetKana( KC_QUOT			,"+{sc08}"	)	; '
	SetKana( KC_NUHS			,"+{sc1A}"	)	; `

	SetKana( KC_2 | KC_SPC		,"{sc1A}"	)	; @
	SetKana( KC_6 | KC_SPC		,"{sc0D}"	)	; ^
	SetKana( KC_7 | KC_SPC		,"+{sc07}"	)	; &
	SetKana( KC_8 | KC_SPC		,"+{sc28}"	)	; *
	SetKana( KC_9 | KC_SPC		,"+{sc09}"	)	; (
	SetKana( KC_0 | KC_SPC		,"+{sc0A}"	)	; )
	SetKana( KC_MINS | KC_SPC	,"+{sc73}"	)	; _
	SetKana( KC_EQL | KC_SPC	,"+{sc27}"	)	; +
	SetKana( KC_LBRC | KC_SPC	,"+{sc1B}"	)	; {
	SetKana( KC_RBRC | KC_SPC	,"+{sc2B}"	)	; }
;	SetKana( KC_SCLN | KC_SPC	,"{sc28}"	)	; :	(薙刀式で使用)
	SetKana( KC_QUOT | KC_SPC	,"+{sc03}"	)	; "
	SetKana( KC_NUHS | KC_SPC	,"+{sc0D}"	)	; ~

	; 設定がPC-9800キーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	if (KeyDriver = "kbdnec.dll")
	{
		SetEisu( KC_NUHS			,"+{sc0D}"	)	; `
		SetEisu( KC_NUHS | KC_SPC	,"+{sc1A}"	)	; ~

		SetKana( KC_NUHS			,"+{sc0D}"	)	; `
		SetKana( KC_NUHS | KC_SPC	,"+{sc1A}"	)	; ~
	}

	return
}

; 固有名詞ショートカットの登録
KoyuRegist()
{
	#IncludeAgain %A_ScriptDir%/Sub/KeyBit_h.ahk	; 配列定義で使う定数
	#IncludeAgain %A_ScriptDir%/Sub/Naginata-Koyu_h.ahk

	KanaGroup := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_1		,"{直接}" . E01)
		SetKana(KC_U | KC_I | KC_2		,"{直接}" . E02)
		SetKana(KC_U | KC_I | KC_3		,"{直接}" . E03)
		SetKana(KC_U | KC_I | KC_4		,"{直接}" . E04)
		SetKana(KC_U | KC_I | KC_5		,"{直接}" . E05)
	KanaGroup := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_6		,"{直接}" . E06)
		SetKana(KC_E | KC_R | KC_7		,"{直接}" . E07)
		SetKana(KC_E | KC_R | KC_8		,"{直接}" . E08)
		SetKana(KC_E | KC_R | KC_9		,"{直接}" . E09)
		SetKana(KC_E | KC_R | KC_0		,"{直接}" . E10)
		SetKana(KC_E | KC_R | KC_MINS	,"{直接}" . E11)
		SetKana(KC_E | KC_R | KC_EQL	,"{直接}" . E12)
		SetKana(KC_E | KC_R | JP_YEN	,"{直接}" . E13)

	KanaGroup := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_Q		,"{直接}" . D01)
		SetKana(KC_U | KC_I | KC_W		,"{直接}" . D02)
		SetKana(KC_U | KC_I | KC_E		,"{直接}" . D03)
		SetKana(KC_U | KC_I | KC_R		,"{直接}" . D04)
		SetKana(KC_U | KC_I | KC_T		,"{直接}" . D05)
	KanaGroup := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_Y		,"{直接}" . D06)
		SetKana(KC_E | KC_R | KC_U		,"{直接}" . D07)
		SetKana(KC_E | KC_R | KC_I		,"{直接}" . D08)
		SetKana(KC_E | KC_R | KC_O		,"{直接}" . D09)
		SetKana(KC_E | KC_R | KC_P		,"{直接}" . D10)
		SetKana(KC_E | KC_R | KC_LBRC	,"{直接}" . D11)
		SetKana(KC_E | KC_R | KC_RBRC	,"{直接}" . D12)

	KanaGroup := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_A		,"{直接}" . C01)
		SetKana(KC_U | KC_I | KC_S		,"{直接}" . C02)
		SetKana(KC_U | KC_I | KC_D		,"{直接}" . C03)
		SetKana(KC_U | KC_I | KC_F		,"{直接}" . C04)
		SetKana(KC_U | KC_I | KC_G		,"{直接}" . C05)
	KanaGroup := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_H		,"{直接}" . C06)
		SetKana(KC_E | KC_R | KC_J		,"{直接}" . C07)
		SetKana(KC_E | KC_R | KC_K		,"{直接}" . C08)
		SetKana(KC_E | KC_R | KC_L		,"{直接}" . C09)
		SetKana(KC_E | KC_R | KC_SCLN	,"{直接}" . C10)
		SetKana(KC_E | KC_R | KC_QUOT	,"{直接}" . C11)
		SetKana(KC_E | KC_R | KC_NUHS	,"{直接}" . C12)

	KanaGroup := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_Z		,"{直接}" . B01)
		SetKana(KC_U | KC_I | KC_X		,"{直接}" . B02)
		SetKana(KC_U | KC_I | KC_C		,"{直接}" . B03)
		SetKana(KC_U | KC_I | KC_V		,"{直接}" . B04)
		SetKana(KC_U | KC_I | KC_B		,"{直接}" . B05)
	KanaGroup := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_N		,"{直接}" . B06)
		SetKana(KC_E | KC_R | KC_M		,"{直接}" . B07)
		SetKana(KC_E | KC_R | KC_COMM	,"{直接}" . B08)
		SetKana(KC_E | KC_R | KC_DOT	,"{直接}" . B09)
		SetKana(KC_E | KC_R | KC_SLSH	,"{直接}" . B10)
		SetKana(KC_E | KC_R | KC_INT1	,"{直接}" . B11)

	KanaGroup := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_1 | KC_SPC		,"{直接}" . E01S)
		SetKana(KC_U | KC_I | KC_2 | KC_SPC		,"{直接}" . E02S)
		SetKana(KC_U | KC_I | KC_3 | KC_SPC		,"{直接}" . E03S)
		SetKana(KC_U | KC_I | KC_4 | KC_SPC		,"{直接}" . E04S)
		SetKana(KC_U | KC_I | KC_5 | KC_SPC		,"{直接}" . E05S)
	KanaGroup := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_6 | KC_SPC		,"{直接}" . E06S)
		SetKana(KC_E | KC_R | KC_7 | KC_SPC		,"{直接}" . E07S)
		SetKana(KC_E | KC_R | KC_8 | KC_SPC		,"{直接}" . E08S)
		SetKana(KC_E | KC_R | KC_9 | KC_SPC		,"{直接}" . E09S)
		SetKana(KC_E | KC_R | KC_0 | KC_SPC		,"{直接}" . E10S)
		SetKana(KC_E | KC_R | KC_MINS | KC_SPC	,"{直接}" . E11S)
		SetKana(KC_E | KC_R | KC_EQL | KC_SPC	,"{直接}" . E12S)
		SetKana(KC_E | KC_R | JP_YEN | KC_SPC	,"{直接}" . E13S)

	KanaGroup := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_Q | KC_SPC		,"{直接}" . D01S)
		SetKana(KC_U | KC_I | KC_W | KC_SPC		,"{直接}" . D02S)
		SetKana(KC_U | KC_I | KC_E | KC_SPC		,"{直接}" . D03S)
		SetKana(KC_U | KC_I | KC_R | KC_SPC		,"{直接}" . D04S)
		SetKana(KC_U | KC_I | KC_T | KC_SPC		,"{直接}" . D05S)
	KanaGroup := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_Y | KC_SPC		,"{直接}" . D06S)
		SetKana(KC_E | KC_R | KC_U | KC_SPC		,"{直接}" . D07S)
		SetKana(KC_E | KC_R | KC_I | KC_SPC		,"{直接}" . D08S)
		SetKana(KC_E | KC_R | KC_O | KC_SPC		,"{直接}" . D09S)
		SetKana(KC_E | KC_R | KC_P | KC_SPC		,"{直接}" . D10S)
		SetKana(KC_E | KC_R | KC_LBRC | KC_SPC	,"{直接}" . D11S)
		SetKana(KC_E | KC_R | KC_RBRC | KC_SPC	,"{直接}" . D12S)

	KanaGroup := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_A | KC_SPC		,"{直接}" . C01S)
		SetKana(KC_U | KC_I | KC_S | KC_SPC		,"{直接}" . C02S)
		SetKana(KC_U | KC_I | KC_D | KC_SPC		,"{直接}" . C03S)
		SetKana(KC_U | KC_I | KC_F | KC_SPC		,"{直接}" . C04S)
		SetKana(KC_U | KC_I | KC_G | KC_SPC		,"{直接}" . C05S)
	KanaGroup := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_H | KC_SPC		,"{直接}" . C06S)
		SetKana(KC_E | KC_R | KC_J | KC_SPC		,"{直接}" . C07S)
		SetKana(KC_E | KC_R | KC_K | KC_SPC		,"{直接}" . C08S)
		SetKana(KC_E | KC_R | KC_L | KC_SPC		,"{直接}" . C09S)
		SetKana(KC_E | KC_R | KC_SCLN | KC_SPC	,"{直接}" . C10S)
		SetKana(KC_E | KC_R | KC_QUOT | KC_SPC	,"{直接}" . C11S)
		SetKana(KC_E | KC_R | KC_NUHS | KC_SPC	,"{直接}" . C12S)

	KanaGroup := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_Z | KC_SPC		,"{直接}" . B01S)
		SetKana(KC_U | KC_I | KC_X | KC_SPC		,"{直接}" . B02S)
		SetKana(KC_U | KC_I | KC_C | KC_SPC		,"{直接}" . B03S)
		SetKana(KC_U | KC_I | KC_V | KC_SPC		,"{直接}" . B04S)
		SetKana(KC_U | KC_I | KC_B | KC_SPC		,"{直接}" . B05S)
	KanaGroup := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_N | KC_SPC		,"{直接}" . B06S)
		SetKana(KC_E | KC_R | KC_M | KC_SPC		,"{直接}" . B07S)
		SetKana(KC_E | KC_R | KC_COMM | KC_SPC	,"{直接}" . B08S)
		SetKana(KC_E | KC_R | KC_DOT | KC_SPC	,"{直接}" . B09S)
		SetKana(KC_E | KC_R | KC_SLSH | KC_SPC	,"{直接}" . B10S)
		SetKana(KC_E | KC_R | KC_INT1 | KC_SPC	,"{直接}" . B11S)

	; 設定がUSキーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	if (KeyDriver == "kbd101.dll")
	{
		SetKana(KC_E | KC_R | KC_BSLS			,"{直接}" . E13)
		SetKana(KC_E | KC_R | KC_GRV			,"{直接}" . C12)
		SetKana(KC_E | KC_R | KC_BSLS | KC_SPC	,"{直接}" . E13S)
		SetKana(KC_E | KC_R | KC_GRV | KC_SPC	,"{直接}" . C12S)
	}

	KanaGroup := "2L"
		; 固有名詞ショートカットを切り替える
		SetKana( KC_M | KC_COMM | KC_1	, 1, "KoyuChange")	; 固有名詞ショートカット１
		SetEisu( KC_M | KC_COMM | KC_1	, 1, "KoyuChange")
		SetKana( KC_M | KC_COMM | KC_2	, 2, "KoyuChange")	; 固有名詞ショートカット２
		SetEisu( KC_M | KC_COMM | KC_2	, 2, "KoyuChange")
		SetKana( KC_M | KC_COMM | KC_3	, 3, "KoyuChange")	; 固有名詞ショートカット３
		SetEisu( KC_M | KC_COMM | KC_3	, 3, "KoyuChange")
		SetKana( KC_M | KC_COMM | KC_4	, 4, "KoyuChange")	; 固有名詞ショートカット４
		SetEisu( KC_M | KC_COMM | KC_4	, 4, "KoyuChange")
		SetKana( KC_M | KC_COMM | KC_5	, 5, "KoyuChange")	; 固有名詞ショートカット５
		SetEisu( KC_M | KC_COMM | KC_5	, 5, "KoyuChange")

	return
}

; ----------------------------------------------------------------------
; 追加のホットキー
; ----------------------------------------------------------------------
+^sc0B::Suspend On	; 薙刀式中断 Shift+Ctrl+0
+^sc02::Suspend Off	; 薙刀式再開 Shift+Ctrl+1
