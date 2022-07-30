; ※※※ 不具合（13行目に記載）があるので注意！！
;
; **********************************************************************
; 編集モード、固有名詞ショートカートのみ
; 参考：
; 【薙刀式】v14集大成版
; http://oookaworks.seesaa.net/article/484704326.html#gsc.tab=0
; (2021年12月10日)より
; 【薙刀式】編集モードv14を私家版に改造
; http://oookaworks.seesaa.net/article/485841978.html#gsc.tab=0
; (2022年3月4日より)
;
;	IME OFF、新(J+K+Q)は確定してから ← 範囲選択している部分を消去してしまう不具合がある
;
;	記号はすべて全角文字を出力する
;	編集モードD+F+H、J+K+G、J+K+V、J+K+Bは変換中かどうかを問わない
;	編集モードM+Comma+W、M+Comma+S、M+Comma+F、M+Cooma+B の動作後にはクリップボードは空になる。ダミーの空白も入らない。
;	固有名詞ショートカットのシフト面（スペース押下）を追加
;	固有名詞ショートカットを最大５組を切り替えられる。切り替えは E+R+1 で１番、E+R+2 で２番、など。
;	Q+W に横書きモード、Q+A に縦書きモード を割り当て
; **********************************************************************

#Include %A_ScriptDir%/KanaTable/StandardLayout.ahk	; キーボード初期配列

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
; 特別出力
#Include %A_ScriptDir%/KanaTable/SendSP.ahk

; かな配列読み込み
ReadLayout()	; () -> Void
{
	#IncludeAgain %A_ScriptDir%/Sub/KeyBit_h.ahk	; 配列定義で使う定数
	global layoutName, koyuNumber

	layoutName := "編集モード、固有名詞ショートカットのみ"


; IME ON/OFF
; 事前に、MS-IMEのプロパティで、
; ひらがなカタカナキー：IME ON、無変換キー：IME OFFに設定のこと
; HJ: ON / FG: OFF

kanaGroup := 0	; 0 はグループなし
	SetKana( KC_H | KC_J			,"{ひらがな 2}")		; IME ON
	SetEisu( KC_H | KC_J			,"{ひらがな 2}")
	SetKana( KC_F | KC_G			,"{確定}{IMEOFF}"	)	; IME OFF
	SetEisu( KC_F | KC_G			,"{確定}{IMEOFF}"	)	; (英語入力ON は "{ひらがな 2}{英数}")
	SetKana( KC_H | KC_J | KC_SPC	,"{ひらがな 2}{カタカナ}")	; カタカナ入力
	SetEisu( KC_H | KC_J | KC_SPC	,"{ひらがな 2}{カタカナ}")
	SetKana( KC_F | KC_G | KC_SPC	,"{全英}"	)				; 全角英数入力
	SetEisu( KC_F | KC_G | KC_SPC	,"{全英}"	)

; Enter
; VとMの同時押し
kanaGroup := "ENT"
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
kanaGroup := "1L"
	SetKana( KC_J | KC_K | KC_Q		,"{確定}^{End}"						)	; 新
	SetKana( KC_J | KC_K | KC_A		,"……{確定}"						)	; ……
	SetKana2(KC_J | KC_K | KC_Z		,"││{確定}", "──{確定}"			)	; ──
	SetKana( KC_J | KC_K | KC_W		,"『』{確定}{↑}"					)	; 『』
	SetKana( KC_J | KC_K | KC_S		,"（）{確定}{↑}"					)	; （）
	SetKana( KC_J | KC_K | KC_X		,"【】{確定}{↑}"					)	; 【】
;	SetKana( KC_J | KC_K | KC_E		,"dhi"								)	; ディ
	SetKana( KC_J | KC_K | KC_D		,"？{確定}"							)	; ？
	SetKana( KC_J | KC_K | KC_C		,"！{確定}"							)	; ！
	SetKana( KC_J | KC_K | KC_R		,"^s"								)	; 保
	SetKana( KC_J | KC_K | KC_F		,"「」{確定}{↑}"					)	; 「」
	SetKana( KC_J | KC_K | KC_V		,"{確定}{↓}"						)	; 確定↓
	SetKana( KC_J | KC_K | KC_T		,"/"								)	; ・未確定
	SetKana( KC_J | KC_K | KC_G		,"{確定}{End}{改行}「」{確定}{↑}"	)	; ⏎「」
	SetKana( KC_J | KC_K | KC_B		,"{確定}{End}{改行}　"				)	; ⏎□

	SetEisu( KC_J | KC_K | KC_Q		,"{確定}^{End}"						)	; 新
	SetEisu( KC_J | KC_K | KC_A		,"……{確定}"						)	; ……
	SetEisu2(KC_J | KC_K | KC_Z		,"││{確定}", "──{確定}"			)	; ──
	SetEisu( KC_J | KC_K | KC_W		,"『』{確定}{↑}"					)	; 『』
	SetEisu( KC_J | KC_K | KC_S		,"（）{確定}{↑}"					)	; （）
	SetEisu( KC_J | KC_K | KC_X		,"【】{確定}{↑}"					)	; 【】
;	SetEisu( KC_J | KC_K | KC_E		,"dhi"								)	; ディ
	SetEisu( KC_J | KC_K | KC_D		,"？{確定}"							)	; ？
	SetEisu( KC_J | KC_K | KC_C		,"！{確定}"							)	; ！
	SetEisu( KC_J | KC_K | KC_R		,"^s"								)	; 保
	SetEisu( KC_J | KC_K | KC_F		,"「」{確定}{↑}"					)	; 「」
	SetEisu( KC_J | KC_K | KC_V		,"{確定}{↓}"						)	; 確定↓
	SetEisu( KC_J | KC_K | KC_T		,"・"								)	; ・未確定
	SetEisu( KC_J | KC_K | KC_G		,"{確定}{End}{改行}「」{確定}{↑}"	)	; ⏎「」
	SetEisu( KC_J | KC_K | KC_B		,"{確定}{End}{改行}　"				)	; ⏎□
; 右手
kanaGroup := "1R"
	SetKana( KC_D | KC_F | KC_Y		,"{Home}"			)		; Home
	SetKana( KC_D | KC_F | KC_H		,"{確定}{End}"		)		; 確定End
	SetKana( KC_D | KC_F | KC_N		,"{End}"			)		; End
	SetKana( KC_D | KC_F | KC_U		,"+{End}{BS}"		)		; 文末消去
	SetKana( KC_D | KC_F | KC_J		,"{↑}"				, R)	; ↑
	SetKana( KC_D | KC_F | KC_M		,"{↓}"				, R)	; ↓
	SetKana( KC_D | KC_F | KC_I		,"{vk1C}"			)		; 再
	SetKana( KC_D | KC_F | KC_K		,"+{↑}"			, R)	; +↑
	SetKana( KC_D | KC_F | KC_COMM	,"+{↓}"			, R)	; +↓
	SetKana( KC_D | KC_F | KC_O		,"{Del}"			)		; Del
	SetKana( KC_D | KC_F | KC_L		,"+{↑ 7}"			, R)	; +7↑
	SetKana( KC_D | KC_F | KC_DOT	,"+{↓ 7}"			, R)	; +7↓
	SetKana( KC_D | KC_F | KC_P		,"{Esc 5}",		  "ESCx3")	; 入力キャンセル
	SetKana( KC_D | KC_F | KC_SCLN	,"^i"				)		; カタカナ変換
	SetKana( KC_D | KC_F | KC_SLSH	,"^u"				)		; ひらがな変換

	SetEisu( KC_D | KC_F | KC_Y		,"{Home}"			)		; Home
	SetEisu( KC_D | KC_F | KC_H		,"{確定}{End}"		)		; 確定End
	SetEisu( KC_D | KC_F | KC_N		,"{End}"			)		; End
	SetEisu( KC_D | KC_F | KC_U		,"+{End}{BS}"		)		; 文末消去
	SetEisu( KC_D | KC_F | KC_J		,"{↑}"				, R)	; ↑
	SetEisu( KC_D | KC_F | KC_M		,"{↓}"				, R)	; ↓
	SetEisu( KC_D | KC_F | KC_I		,"{vk1C}"			)		; 再
	SetEisu( KC_D | KC_F | KC_K		,"+{↑}"			, R)	; +↑
	SetEisu( KC_D | KC_F | KC_COMM	,"+{↓}"			, R)	; +↓
	SetEisu( KC_D | KC_F | KC_O		,"{Del}"			)		; Del
	SetEisu( KC_D | KC_F | KC_L		,"+{↑ 7}"			, R)	; +7↑
	SetEisu( KC_D | KC_F | KC_DOT	,"+{↓ 7}"			, R)	; +7↓
	SetEisu( KC_D | KC_F | KC_P		,"{Esc 5}",		  "ESCx3")	; 入力キャンセル
	SetEisu( KC_D | KC_F | KC_SCLN	,"^i"				)		; カタカナ変換
	SetEisu( KC_D | KC_F | KC_SLSH	,"^u"				)		; ひらがな変換

; 編集モード２
; 下段人差指＋中指

; 左手
kanaGroup := "2L"
	SetKana( KC_M | KC_COMM | KC_Q	,"^x{BS}{Del}^v"						)	; カッコ外し
	SetKana( KC_M | KC_COMM | KC_A	,"《》{確定}{↑}"						)	; 《》
	SetKana( KC_M | KC_COMM | KC_Z	,"^x｜{確定}^v《》{確定}{↑}{C_Clr}"	)	; ｜《》
	SetKana( KC_M | KC_COMM | KC_W	,"^x『^v』{確定}{C_Clr}"				)	; +『』
	SetKana( KC_M | KC_COMM | KC_S	,"^x（^v）{確定}{C_Clr}"				)	; +（）
	SetKana( KC_M | KC_COMM | KC_X	,"^x【^v】{確定}{C_Clr}"				)	; +【】
	SetKana( KC_M | KC_COMM | KC_E	,"{Home}{改行}　　　{End}"				)	; 行頭□□□挿入
	SetKana( KC_M | KC_COMM | KC_D	,"　　　"								)	; □□□
	SetKana( KC_M | KC_COMM | KC_C	,"{Home}{BS}{Del 3}{End}"				)	; 行頭□□□戻し
	SetKana( KC_M | KC_COMM | KC_R	,"{Home}{改行}　{End}"					)	; 行頭□挿入
	SetKana( KC_M | KC_COMM | KC_F	,"^x「^v」{確定}{C_Clr}"				)	; +「」
	SetKana( KC_M | KC_COMM | KC_V	,"{Home}{BS}{Del 1}{End}"				)	; 行頭□戻し
	SetKana( KC_M | KC_COMM | KC_T	,"〇{確定}"								)	; ○
	SetKana( KC_M | KC_COMM | KC_G	,"／{確定}"								)	; ／
	SetKana( KC_M | KC_COMM | KC_B	,"　　　×　　　×　　　×{確定}{改行}"	)	; x   x   x

	SetEisu( KC_M | KC_COMM | KC_Q	,"^x{BS}{Del}^v"						)	; カッコ外し
	SetEisu( KC_M | KC_COMM | KC_A	,"《》{確定}{↑}"						)	; 《》
	SetEisu( KC_M | KC_COMM | KC_Z	,"^x｜{確定}^v《》{確定}{↑}{C_Clr}"	)	; ｜《》
	SetEisu( KC_M | KC_COMM | KC_W	,"^x『^v』{確定}{C_Clr}"				)	; +『』
	SetEisu( KC_M | KC_COMM | KC_S	,"^x（^v）{確定}{C_Clr}"				)	; +（）
	SetEisu( KC_M | KC_COMM | KC_X	,"^x【^v】{確定}{C_Clr}"				)	; +【】
	SetEisu( KC_M | KC_COMM | KC_E	,"{Home}{改行}　　　{End}"				)	; 行頭□□□挿入
	SetEisu( KC_M | KC_COMM | KC_D	,"　　　"								)	; □□□
	SetEisu( KC_M | KC_COMM | KC_C	,"{Home}{BS}{Del 3}{End}"				)	; 行頭□□□戻し
	SetEisu( KC_M | KC_COMM | KC_R	,"{Home}{改行}　{End}"					)	; 行頭□挿入
	SetEisu( KC_M | KC_COMM | KC_F	,"^x「^v」{確定}{C_Clr}"				)	; +「」
	SetEisu( KC_M | KC_COMM | KC_V	,"{Home}{BS}{Del 1}{End}"				)	; 行頭□戻し
	SetEisu( KC_M | KC_COMM | KC_T	,"〇{確定}"								)	; ○
	SetEisu( KC_M | KC_COMM | KC_G	,"／{確定}"								)	; ／
	SetEisu( KC_M | KC_COMM | KC_B	,"　　　×　　　×　　　×{確定}{改行}"	)	; x   x   x

; 右手
kanaGroup := "2R"
	SetKana( KC_C | KC_V | KC_Y		,"+{Home}"	)		; +Home
	SetKana( KC_C | KC_V | KC_H		,"^c"		)		; Copy
	SetKana( KC_C | KC_V | KC_N		,"+{End}"	)		; +End
	SetKana( KC_C | KC_V | KC_U		,"^x"		)		; Cut
	SetKana( KC_C | KC_V | KC_J		,"{→ 5}"	, R)	; →5
	SetKana( KC_C | KC_V | KC_M		,"{← 5}"	, R)	; ←5
	SetKana( KC_C | KC_V | KC_I		,"^v"		)		; Paste
	SetKana( KC_C | KC_V | KC_K		,"+{→ 5}"	, R)	; +→5
	SetKana( KC_C | KC_V | KC_COMM	,"+{← 5}"	, R)	; +←5
	SetKana( KC_C | KC_V | KC_O		,"^y"		)		; Redo
	SetKana( KC_C | KC_V | KC_L		,"+{→ 20}"	)		; +→20
	SetKana( KC_C | KC_V | KC_DOT	,"+{← 20}"	)		; +←20
	SetKana( KC_C | KC_V | KC_P		,"^z"		)		; Undo
	SetKana( KC_C | KC_V | KC_SCLN	,"+{→}"	, R)	; 一行前選択
	SetKana( KC_C | KC_V | KC_SLSH	,"+{←}"	, R)	; 一行後選択

	SetEisu( KC_C | KC_V | KC_Y		,"+{Home}"	)		; +Home
	SetEisu( KC_C | KC_V | KC_H		,"^c"		)		; Copy
	SetEisu( KC_C | KC_V | KC_N		,"+{End}"	)		; +End
	SetEisu( KC_C | KC_V | KC_U		,"^x"		)		; Cut
	SetEisu( KC_C | KC_V | KC_J		,"{→ 5}"	, R)	; →5
	SetEisu( KC_C | KC_V | KC_M		,"{← 5}"	, R)	; ←5
	SetEisu( KC_C | KC_V | KC_I		,"^v"		)		; Paste
	SetEisu( KC_C | KC_V | KC_K		,"+{→ 5}"	, R)	; +→5
	SetEisu( KC_C | KC_V | KC_COMM	,"+{← 5}"	, R)	; +←5
	SetEisu( KC_C | KC_V | KC_O		,"^y"		)		; Redo
	SetEisu( KC_C | KC_V | KC_L		,"+{→ 20}"	)		; +→20
	SetEisu( KC_C | KC_V | KC_DOT	,"+{← 20}"	)		; +←20
	SetEisu( KC_C | KC_V | KC_P		,"^z"		)		; Undo
	SetEisu( KC_C | KC_V | KC_SCLN	,"+{→}"	, R)	; 一行前選択
	SetEisu( KC_C | KC_V | KC_SLSH	,"+{←}"	, R)	; 一行後選択

kanaGroup := 0	; 0 はグループなし
	SetKana( KC_Q | KC_W			,"Null"		,"横書き")
	SetEisu( KC_Q | KC_W			,"Null"		,"横書き")
	SetKana( KC_Q | KC_A			,"Null"		,"縦書き")
	SetEisu( KC_Q | KC_A			,"Null"		,"縦書き")


	; 設定がUSキーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	If (keyDriver = "kbd101.dll")
	{
	; おまけ
		SetEisu( JP_YEN				,"\"	)	; ￥
		SetEisu( KC_INT1			,"\"	)	; ￥
		SetEisu( JP_YEN | KC_SPC	,"|"	)	; ｜	スペース押しながら
		SetEisu( KC_INT1 | KC_SPC	,"_"	)	; ＿	スペース押しながら

		SetKana( JP_YEN				,"\"	)	; ￥
		SetKana( JP_YEN | KC_SPC	,"|"	)	; ｜	スペース押しながら
	}

	If (usLike > 0)
		USLikeLayout()	; USキーボード風の配列へ

	KoyuReadAndRegist(koyuNumber)	; 固有名詞ショートカットの読み込み・登録

	Return
}

; USキーボード風の配列へ
USLikeLayout()	; () -> Void
{
	#IncludeAgain %A_ScriptDir%/Sub/KeyBit_h.ahk	; 配列定義で使う定数

	; 設定がUSキーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	If (keyDriver = "kbd101.dll")
		Return

kanaGroup := 0	; 0 はグループなし
	SetEisu( KC_EQL				,"+{sc0C}"	)	; =
	SetEisu( KC_LBRC			,"{sc1B}"	)	; [
	SetEisu( KC_RBRC			,"{sc2B}"	)	; ]
	SetEisu( KC_QUOT			,"+{sc08}"	)	; '
	SetEisu( KC_NUHS			,"+{sc1A}"	)	; `

	SetEisu( KC_SPC | KC_2		,"{sc1A}"	)	; @
	SetEisu( KC_SPC | KC_6		,"{sc0D}"	)	; ^
	SetEisu( KC_SPC | KC_7		,"+{sc07}"	)	; &
	SetEisu( KC_SPC | KC_8		,"+{sc28}"	)	; *
	SetEisu( KC_SPC | KC_9		,"+{sc09}"	)	; (
	SetEisu( KC_SPC | KC_0		,"+{sc0A}"	)	; )
	SetEisu( KC_SPC | KC_MINS	,"+{sc73}"	)	; _
	SetEisu( KC_SPC | KC_EQL	,"+{sc27}"	)	; +
	SetEisu( KC_SPC | KC_LBRC	,"+{sc1B}"	)	; {
	SetEisu( KC_SPC | KC_RBRC	,"+{sc2B}"	)	; }
	SetEisu( KC_SPC | KC_SCLN	,"{sc28}"	)	; :
	SetEisu( KC_SPC | KC_QUOT	,"+{sc03}"	)	; "
	SetEisu( KC_SPC | KC_NUHS	,"+{sc0D}"	)	; ~


	SetKana( KC_EQL				,"+{sc0C}"	)	; =
	SetKana( KC_LBRC			,"{sc1B}"	)	; [
	SetKana( KC_RBRC			,"{sc2B}"	)	; ]
	SetKana( KC_QUOT			,"+{sc08}"	)	; '
	SetKana( KC_NUHS			,"+{sc1A}"	)	; `

	SetKana( KC_SPC | KC_2		,"{sc1A}"	)	; @
	SetKana( KC_SPC | KC_6		,"{sc0D}"	)	; ^
	SetKana( KC_SPC | KC_7		,"+{sc07}"	)	; &
	SetKana( KC_SPC | KC_8		,"+{sc28}"	)	; *
	SetKana( KC_SPC | KC_9		,"+{sc09}"	)	; (
	SetKana( KC_SPC | KC_0		,"+{sc0A}"	)	; )
	SetKana( KC_SPC | KC_MINS	,"+{sc73}"	)	; _
	SetKana( KC_SPC | KC_EQL	,"+{sc27}"	)	; +
	SetKana( KC_SPC | KC_LBRC	,"+{sc1B}"	)	; {
	SetKana( KC_SPC | KC_RBRC	,"+{sc2B}"	)	; }
;	SetKana( KC_SPC |  KC_SCLN	,"{sc28}"	)	; :	(薙刀式で使用)
	SetKana( KC_SPC | KC_QUOT	,"+{sc03}"	)	; "
	SetKana( KC_SPC | KC_NUHS	,"+{sc0D}"	)	; ~

	; 設定がPC-9800キーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	If (keyDriver = "kbdnec.dll")
	{
		SetEisu( KC_NUHS			,"+{sc0D}"	)	; `
		SetEisu( KC_NUHS | KC_SPC	,"+{sc1A}"	)	; ~

		SetKana( KC_NUHS			,"+{sc0D}"	)	; `
		SetKana( KC_NUHS | KC_SPC	,"+{sc1A}"	)	; ~
	}

	Return
}

; 固有名詞ショートカットの登録
KoyuRegist()	; () -> Void
{
	#IncludeAgain %A_ScriptDir%/Sub/KeyBit_h.ahk	; 配列定義で使う定数
	#IncludeAgain %A_ScriptDir%/Sub/Naginata-Koyu_h.ahk

	kanaGroup := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_1		,"{直接}" . E01)
		SetKana(KC_U | KC_I | KC_2		,"{直接}" . E02)
		SetKana(KC_U | KC_I | KC_3		,"{直接}" . E03)
		SetKana(KC_U | KC_I | KC_4		,"{直接}" . E04)
		SetKana(KC_U | KC_I | KC_5		,"{直接}" . E05)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_6		,"{直接}" . E06)
		SetKana(KC_E | KC_R | KC_7		,"{直接}" . E07)
		SetKana(KC_E | KC_R | KC_8		,"{直接}" . E08)
		SetKana(KC_E | KC_R | KC_9		,"{直接}" . E09)
		SetKana(KC_E | KC_R | KC_0		,"{直接}" . E10)
		SetKana(KC_E | KC_R | KC_MINS	,"{直接}" . E11)
		SetKana(KC_E | KC_R | KC_EQL	,"{直接}" . E12)
		SetKana(KC_E | KC_R | JP_YEN	,"{直接}" . E13)

	kanaGroup := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_Q		,"{直接}" . D01)
		SetKana(KC_U | KC_I | KC_W		,"{直接}" . D02)
		SetKana(KC_U | KC_I | KC_E		,"{直接}" . D03)
		SetKana(KC_U | KC_I | KC_R		,"{直接}" . D04)
		SetKana(KC_U | KC_I | KC_T		,"{直接}" . D05)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_Y		,"{直接}" . D06)
		SetKana(KC_E | KC_R | KC_U		,"{直接}" . D07)
		SetKana(KC_E | KC_R | KC_I		,"{直接}" . D08)
		SetKana(KC_E | KC_R | KC_O		,"{直接}" . D09)
		SetKana(KC_E | KC_R | KC_P		,"{直接}" . D10)
		SetKana(KC_E | KC_R | KC_LBRC	,"{直接}" . D11)
		SetKana(KC_E | KC_R | KC_RBRC	,"{直接}" . D12)

	kanaGroup := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_A		,"{直接}" . C01)
		SetKana(KC_U | KC_I | KC_S		,"{直接}" . C02)
		SetKana(KC_U | KC_I | KC_D		,"{直接}" . C03)
		SetKana(KC_U | KC_I | KC_F		,"{直接}" . C04)
		SetKana(KC_U | KC_I | KC_G		,"{直接}" . C05)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_H		,"{直接}" . C06)
		SetKana(KC_E | KC_R | KC_J		,"{直接}" . C07)
		SetKana(KC_E | KC_R | KC_K		,"{直接}" . C08)
		SetKana(KC_E | KC_R | KC_L		,"{直接}" . C09)
		SetKana(KC_E | KC_R | KC_SCLN	,"{直接}" . C10)
		SetKana(KC_E | KC_R | KC_QUOT	,"{直接}" . C11)
		SetKana(KC_E | KC_R | KC_NUHS	,"{直接}" . C12)

	kanaGroup := "KL"	; 左手側
		SetKana(KC_U | KC_I | KC_Z		,"{直接}" . B01)
		SetKana(KC_U | KC_I | KC_X		,"{直接}" . B02)
		SetKana(KC_U | KC_I | KC_C		,"{直接}" . B03)
		SetKana(KC_U | KC_I | KC_V		,"{直接}" . B04)
		SetKana(KC_U | KC_I | KC_B		,"{直接}" . B05)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_E | KC_R | KC_N		,"{直接}" . B06)
		SetKana(KC_E | KC_R | KC_M		,"{直接}" . B07)
		SetKana(KC_E | KC_R | KC_COMM	,"{直接}" . B08)
		SetKana(KC_E | KC_R | KC_DOT	,"{直接}" . B09)
		SetKana(KC_E | KC_R | KC_SLSH	,"{直接}" . B10)
		SetKana(KC_E | KC_R | KC_INT1	,"{直接}" . B11)

	kanaGroup := "KL"	; 左手側
		SetKana(KC_SPC | KC_U | KC_I | KC_1		,"{直接}" . E01S)
		SetKana(KC_SPC | KC_U | KC_I | KC_2		,"{直接}" . E02S)
		SetKana(KC_SPC | KC_U | KC_I | KC_3		,"{直接}" . E03S)
		SetKana(KC_SPC | KC_U | KC_I | KC_4		,"{直接}" . E04S)
		SetKana(KC_SPC | KC_U | KC_I | KC_5		,"{直接}" . E05S)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_SPC | KC_E | KC_R | KC_6		,"{直接}" . E06S)
		SetKana(KC_SPC | KC_E | KC_R | KC_7		,"{直接}" . E07S)
		SetKana(KC_SPC | KC_E | KC_R | KC_8		,"{直接}" . E08S)
		SetKana(KC_SPC | KC_E | KC_R | KC_9		,"{直接}" . E09S)
		SetKana(KC_SPC | KC_E | KC_R | KC_0		,"{直接}" . E10S)
		SetKana(KC_SPC | KC_E | KC_R | KC_MINS	,"{直接}" . E11S)
		SetKana(KC_SPC | KC_E | KC_R | KC_EQL	,"{直接}" . E12S)
		SetKana(KC_SPC | KC_E | KC_R | JP_YEN	,"{直接}" . E13S)

	kanaGroup := "KL"	; 左手側
		SetKana(KC_SPC | KC_U | KC_I | KC_Q		,"{直接}" . D01S)
		SetKana(KC_SPC | KC_U | KC_I | KC_W		,"{直接}" . D02S)
		SetKana(KC_SPC | KC_U | KC_I | KC_E		,"{直接}" . D03S)
		SetKana(KC_SPC | KC_U | KC_I | KC_R		,"{直接}" . D04S)
		SetKana(KC_SPC | KC_U | KC_I | KC_T		,"{直接}" . D05S)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_SPC | KC_E | KC_R | KC_Y		,"{直接}" . D06S)
		SetKana(KC_SPC | KC_E | KC_R | KC_U		,"{直接}" . D07S)
		SetKana(KC_SPC | KC_E | KC_R | KC_I		,"{直接}" . D08S)
		SetKana(KC_SPC | KC_E | KC_R | KC_O		,"{直接}" . D09S)
		SetKana(KC_SPC | KC_E | KC_R | KC_P		,"{直接}" . D10S)
		SetKana(KC_SPC | KC_E | KC_R | KC_LBRC	,"{直接}" . D11S)
		SetKana(KC_SPC | KC_E | KC_R | KC_RBRC	,"{直接}" . D12S)

	kanaGroup := "KL"	; 左手側
		SetKana(KC_SPC | KC_U | KC_I | KC_A		,"{直接}" . C01S)
		SetKana(KC_SPC | KC_U | KC_I | KC_S		,"{直接}" . C02S)
		SetKana(KC_SPC | KC_U | KC_I | KC_D		,"{直接}" . C03S)
		SetKana(KC_SPC | KC_U | KC_I | KC_F		,"{直接}" . C04S)
		SetKana(KC_SPC | KC_U | KC_I | KC_G		,"{直接}" . C05S)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_SPC | KC_E | KC_R | KC_H		,"{直接}" . C06S)
		SetKana(KC_SPC | KC_E | KC_R | KC_J		,"{直接}" . C07S)
		SetKana(KC_SPC | KC_E | KC_R | KC_K		,"{直接}" . C08S)
		SetKana(KC_SPC | KC_E | KC_R | KC_L		,"{直接}" . C09S)
		SetKana(KC_SPC | KC_E | KC_R | KC_SCLN	,"{直接}" . C10S)
		SetKana(KC_SPC | KC_E | KC_R | KC_QUOT	,"{直接}" . C11S)
		SetKana(KC_SPC | KC_E | KC_R | KC_NUHS	,"{直接}" . C12S)

	kanaGroup := "KL"	; 左手側
		SetKana(KC_SPC | KC_U | KC_I | KC_Z		,"{直接}" . B01S)
		SetKana(KC_SPC | KC_U | KC_I | KC_X		,"{直接}" . B02S)
		SetKana(KC_SPC | KC_U | KC_I | KC_C		,"{直接}" . B03S)
		SetKana(KC_SPC | KC_U | KC_I | KC_V		,"{直接}" . B04S)
		SetKana(KC_SPC | KC_U | KC_I | KC_B		,"{直接}" . B05S)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_SPC | KC_E | KC_R | KC_N		,"{直接}" . B06S)
		SetKana(KC_SPC | KC_E | KC_R | KC_M		,"{直接}" . B07S)
		SetKana(KC_SPC | KC_E | KC_R | KC_COMM	,"{直接}" . B08S)
		SetKana(KC_SPC | KC_E | KC_R | KC_DOT	,"{直接}" . B09S)
		SetKana(KC_SPC | KC_E | KC_R | KC_SLSH	,"{直接}" . B10S)
		SetKana(KC_SPC | KC_E | KC_R | KC_INT1	,"{直接}" . B11S)

	; 設定がUSキーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	If (keyDriver == "kbd101.dll")
	{
		SetKana(KC_E | KC_R | KC_BSLS			,"{直接}" . E13)
		SetKana(KC_E | KC_R | KC_GRV			,"{直接}" . C12)
		SetKana(KC_SPC | KC_E | KC_R | KC_BSLS	,"{直接}" . E13S)
		SetKana(KC_SPC | KC_E | KC_R | KC_GRV	,"{直接}" . C12S)
	}

	kanaGroup := "2L"
		; 固有名詞ショートカットを切り替える
		SetKana( KC_E | KC_R | KC_1	, 1, "KoyuChange")	; 固有名詞ショートカット１
		SetKana( KC_E | KC_R | KC_2	, 2, "KoyuChange")	; 固有名詞ショートカット２
		SetKana( KC_E | KC_R | KC_3	, 3, "KoyuChange")	; 固有名詞ショートカット３
		SetKana( KC_E | KC_R | KC_4	, 4, "KoyuChange")	; 固有名詞ショートカット４
		SetKana( KC_E | KC_R | KC_5	, 5, "KoyuChange")	; 固有名詞ショートカット５

	kanaGroup := 0	; 0 はグループなし
	Return
}

; ----------------------------------------------------------------------
; 追加のホットキー
; ----------------------------------------------------------------------

F13::PrintScreen	; (Apple Pro Keyboard)F13 → PrintScreen
F14::ScrollLock	; (Apple Pro Keyboard)F14 → ScrollLock
F15::!sc29			; (Apple Pro Keyboard)F15 → 半角/全角
sc59::Send, =		; (Apple Pro Keyboard)テンキー"="
sc7E::Send, `,		; (Apple Pro Keyboard)テンキー","
NumLock::
	KeyWait, NumLock, T0.3	;0.3秒対象キーが押されたかどうか
	If (ErrorLevel)
	{
		Send, =	; 長押しで"="入力
		KeyWait, NumLock
		Return
	}
	Send, :			; 単打で":"入力
	Return
NumpadDot::
	KeyWait, NumpadDot, T0.3	;0.3秒対象キーが押されたかどうか
	If (ErrorLevel)
	{
		Send, `,		; 長押しで","入力
		KeyWait, NumpadDot
		Return
	}
	Send, {NumpadDot}	; 単打で"."入力
	Return
#If (keyDriver = "kbd106.dll")
sc3A::	; 英数キー単独で CapsLock をオンオフする
	If (GetKeyState("CapsLock", "T"))
		SetCapsLockState, Off
	else
		SetCapsLockState, On
	Return
#If		; End #If ()

; ----------------------------------------------------------------------
; IME 操作
; ----------------------------------------------------------------------
sc7B::		; 無変換
sc71 up::	; (Apple Pro Keyboard)英数	(旧方式)
vk1A::		; (Apple Pro Keyboard)英数
	StoreBuf("{vkF2}{vkF3}")	; ひらがな(IMEオンを兼ねる) → 半角/全角
	OutBuf()
	Return
+sc7B::	; Shift + 無変換
+sc71 up:: ; (Apple Pro Keyboard)Shift + 英数	(旧方式)
+vk1A::	; (Apple Pro Keyboard)Shift + 英数
	StoreBuf("{全英}")
	OutBuf()
	Return
sc70::		; ひらがな
sc72 up::	; (Apple Pro Keyboard)かな	(旧方式)
vk16::		; (Apple Pro Keyboard)かな
	if (A_PriorHotKey = A_ThisHotKey && A_TimeSincePriorHotkey < 200)
		StoreBuf("{vk1C}")		; 2連打で 変換キー 入力
	else
		StoreBuf("{vkF2 2}")	; ひらがな(IMEオンを兼ねる)
	OutBuf()
	Return
+sc70::	; Shift + ひらがな
+sc72 up:: ; (Apple Pro Keyboard)Shift + かな	(旧方式)
+vk16::	; (Apple Pro Keyboard)Shift + かな
	StoreBuf("{vkF2 2}{vkF1}")	; ひらがな(IMEオンを兼ねる) → カタカナ
	OutBuf()
	Return
