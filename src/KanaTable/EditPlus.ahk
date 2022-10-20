; **********************************************************************
; 編集モード、固有名詞ショートカートのみ
; 参考：
; 【薙刀式】v15候補
; http://oookaworks.seesaa.net/article/489739560.html#gsc.tab=0
; (2022年07月14日)より
;
;
;	記号はすべて全角文字を出力する
;	編集モードD+F+H、J+K+G、J+K+V、J+K+Bは変換中かどうかを問わない
;	切り取りと貼り付けを使う編集モードの前後で、クリップボードの内容を保つ
;	固有名詞ショートカットのシフト面（スペース押下）を追加
;	固有名詞ショートカットを最大５組を切り替えられる。切り替えは E+R+1 で１番、E+R+2 で２番、など。
;	Q+W に横書きモード、Q+A に縦書きモード を割り当て
; **********************************************************************
;   ※旧MS-IME の設定
;		Microsoft IME の設定 → IME 入力モード切替の通知 → オフ: 画面中央に表示する
;
;		(キー設定をユーザー定義にしている場合)
;		Microsoft IME の設定 → 詳細設定(A) → キー設定(Y)
;			|* キー           |入力/変換済み文字なし|入力文字のみ|変換済み|候補一覧表示中|文節長変更中|変換済み文節内入力文字|
;			|-----------------|:-------------------:|:----------:|:------:|:------------:|:----------:|:--------------------:|
;			|半角/全角        |IME-オン/オフ        |半英固定    |半英固定|半英固定      |半英固定    |半英固定              |
;			|Ctrl+Shift+無変換|      -              |全消去      |全消去  |全消去        |全消去      |全消去                |
;			|Ctrl+Shift+変換  |      -              |全確定      |全確定  |全確定        |全確定      |全確定                |
;	Ctrl+Shift+変換 は Ctrl+Enter を選択してキー追加すると簡単
; **********************************************************************
;	※ATOK のキーカスタマイズ
;		|キー             |機能                                                                                  |
;		|-----------------|--------------------------------------------------------------------------------------|
;		|Shift+Esc        |[変換中][次候補表示中]変換取消                                                        |
;		|変換             |[文字未入力]再変換                                                                    |
;		|Shift+Ctrl+変換  |Enter と同じ                                                                          |
;		|Shift+Ctrl+無変換|[入力中][変換中][次候補表示中][文節区切り直し中]全文字削除[全候補表示中]全候補選択取消|
;		|半角／全角       |[文字未入力][記号入力]日本語入力ON/OFF [他]入力文字種半角無変換(A)                    |
;	☆ATOK プロパティ → 入力･変換 → 設定項目(Y) → 入力補助 → 特殊 → 設定一覧(L)
;		なし - 日本語入力オンで変更したモードを元に戻す
; **********************************************************************
;	※Google 日本語入力 のキー設定
;		|モード      |  入力キー         |    コマンド      |
;		|------------|:-----------------:|:----------------:|
;		|変換前入力中|Ctrl Shift Henkan  |       確定       |
;		|変換中      |      〃           |        〃        |
;		|変換前入力中|Ctrl Shift Muhenkan|  入力キャンセル  |
;		|変換中      |      〃           |        〃        |
;		|変換前入力中|Shift Muhenkan     |全角英数に入力切替|
;		|変換中      |      〃           |        〃        |
;		|入力文字なし|      〃           |        〃        |
; **********************************************************************

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

kanaGroup := ""	; グループなし
	SetKana( KC_H | KC_J			,"{ひらがな}")				; IME ON
	SetEisu( KC_H | KC_J			,"{ひらがな 2}")
	SetKana( KC_F | KC_G			,"{確定}{全角}"	)			; IME OFF
	SetEisu( KC_F | KC_G			,"{確定}{ひらがな}{全角}")	; (ATOK)英語入力ON は "{ひらがな 2}{英数}")
	SetKana( KC_H | KC_J | KC_SPC	,"{ひらがな}{カタカナ}")	; カタカナ入力
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
	SetKana( KC_D | KC_F | KC_I		,"#/"				)		; 再
	SetKana( KC_D | KC_F | KC_K		,"+{↑}"			, R)	; +↑
	SetKana( KC_D | KC_F | KC_COMM	,"+{↓}"			, R)	; +↓
	SetKana( KC_D | KC_F | KC_O		,"{Del}"			, R)	; Del
	SetKana( KC_D | KC_F | KC_L		,"+{↑ 7}"			, R)	; +7↑
	SetKana( KC_D | KC_F | KC_DOT	,"+{↓ 7}"			, R)	; +7↓
	SetKana( KC_D | KC_F | KC_P		,"{Esc 3}",		  "ESCx3")	; 入力キャンセル
	SetKana( KC_D | KC_F | KC_SCLN	,"^i"				)		; カタカナ変換
	SetKana( KC_D | KC_F | KC_SLSH	,"^u"				)		; ひらがな変換

	SetEisu( KC_D | KC_F | KC_Y		,"{Home}"			)		; Home
	SetEisu( KC_D | KC_F | KC_H		,"{確定}{End}"		)		; 確定End
	SetEisu( KC_D | KC_F | KC_N		,"{End}"			)		; End
	SetEisu( KC_D | KC_F | KC_U		,"+{End}{BS}"		)		; 文末消去
	SetEisu( KC_D | KC_F | KC_J		,"{↑}"				, R)	; ↑
	SetEisu( KC_D | KC_F | KC_M		,"{↓}"				, R)	; ↓
	SetEisu( KC_D | KC_F | KC_I		,"#/"				)		; 再
	SetEisu( KC_D | KC_F | KC_K		,"+{↑}"			, R)	; +↑
	SetEisu( KC_D | KC_F | KC_COMM	,"+{↓}"			, R)	; +↓
	SetEisu( KC_D | KC_F | KC_O		,"{Del}"			, R)	; Del
	SetEisu( KC_D | KC_F | KC_L		,"+{↑ 7}"			, R)	; +7↑
	SetEisu( KC_D | KC_F | KC_DOT	,"+{↓ 7}"			, R)	; +7↓
	SetEisu( KC_D | KC_F | KC_P		,"{Esc 3}",		  "ESCx3")	; 入力キャンセル
	SetEisu( KC_D | KC_F | KC_SCLN	,"^i"				)		; カタカナ変換
	SetEisu( KC_D | KC_F | KC_SLSH	,"^u"				)		; ひらがな変換

; 編集モード２
; 下段人差指＋中指

; 左手
kanaGroup := "2L"
	SetKana( KC_M | KC_COMM | KC_Q	,"{C_Bkup}^x{BS}{Del}^v{C_Rstr}"			)	; カッコ外し
	SetKana( KC_M | KC_COMM | KC_A	,"／{確定}"									)	; ／
	SetKana( KC_M | KC_COMM | KC_Z	,"　　　×　　　×　　　×{確定}{改行}"		)	; x   x   x
	SetKana( KC_M | KC_COMM | KC_W	,"{C_Bkup}^x『^v』{確定}{C_Rstr}"			)	; +『』
	SetKana( KC_M | KC_COMM | KC_S	,"{C_Bkup}^x（^v）{確定}{C_Rstr}"			)	; +（）
	SetKana( KC_M | KC_COMM | KC_X	,"{C_Bkup}^x【^v】{確定}{C_Rstr}"			)	; +【】
	SetKana( KC_M | KC_COMM | KC_E	,"{Home}{改行}　　　{End}"					)	; 行頭□□□挿入
	SetKana( KC_M | KC_COMM | KC_D	,"　　　"									)	; □□□
	SetKana( KC_M | KC_COMM | KC_C	,"{End}{Del 4}"								)	; 行頭□□□戻し
	SetKana( KC_M | KC_COMM | KC_R	,"{Home}{改行}　{End}"						)	; 行頭□挿入
	SetKana( KC_M | KC_COMM | KC_F	,"{C_Bkup}^x「^v」{確定}{C_Rstr}"			)	; +「」
	SetKana( KC_M | KC_COMM | KC_V	,"{End}{Del 2}"								)	; 行頭□戻し
	SetKana( KC_M | KC_COMM | KC_T	,"〇{確定}"									)	; ○
	SetKana( KC_M | KC_COMM | KC_G	,"《》{確定}{↑}"							)	; 《》
	SetKana( KC_M | KC_COMM | KC_B	,"{C_Bkup}^x｜{確定}^v《》{確定}{↑}{C_Rstr}")	; ｜《》

	SetEisu( KC_M | KC_COMM | KC_Q	,"{C_Bkup}^x{BS}{Del}^v{C_Rstr}"			)	; カッコ外し
	SetEisu( KC_M | KC_COMM | KC_A	,"／{確定}"									)	; ／
	SetEisu( KC_M | KC_COMM | KC_Z	,"　　　×　　　×　　　×{確定}{改行}"		)	; x   x   x
	SetEisu( KC_M | KC_COMM | KC_W	,"{C_Bkup}^x『^v』{確定}{C_Rstr}"			)	; +『』
	SetEisu( KC_M | KC_COMM | KC_S	,"{C_Bkup}^x（^v）{確定}{C_Rstr}"			)	; +（）
	SetEisu( KC_M | KC_COMM | KC_X	,"{C_Bkup}^x【^v】{確定}{C_Rstr}"			)	; +【】
	SetEisu( KC_M | KC_COMM | KC_E	,"{Home}{改行}　　　{End}"					)	; 行頭□□□挿入
	SetEisu( KC_M | KC_COMM | KC_D	,"　　　"									)	; □□□
	SetEisu( KC_M | KC_COMM | KC_C	,"{End}{Del 4}"								)	; 行頭□□□戻し
	SetEisu( KC_M | KC_COMM | KC_R	,"{Home}{改行}　{End}"						)	; 行頭□挿入
	SetEisu( KC_M | KC_COMM | KC_F	,"{C_Bkup}^x「^v」{確定}{C_Rstr}"			)	; +「」
	SetEisu( KC_M | KC_COMM | KC_V	,"{End}{Del 2}"								)	; 行頭□戻し
	SetEisu( KC_M | KC_COMM | KC_T	,"〇{確定}"									)	; ○
	SetEisu( KC_M | KC_COMM | KC_G	,"《》{確定}{↑}"							)	; 《》
	SetEisu( KC_M | KC_COMM | KC_B	,"{C_Bkup}^x｜{確定}^v《》{確定}{↑}{C_Rstr}")	; ｜《》

; 右手
kanaGroup := "2R"
	SetKana( KC_C | KC_V | KC_Y		,"+{Home}"	)		; +Home
	SetKana( KC_C | KC_V | KC_H		,"^c"		)		; Copy
	SetKana( KC_C | KC_V | KC_N		,"+{End}"	)		; +End
	SetKana( KC_C | KC_V | KC_U		,"^x"		)		; Cut
	SetKana( KC_C | KC_V | KC_J		,"{→ 5}"	, R)	; →5
	SetKana( KC_C | KC_V | KC_M		,"{← 5}"	, R)	; ←5
	SetKana( KC_C | KC_V | KC_I		,"{←}"		, R)	; ←
	SetKana( KC_C | KC_V | KC_K		,"+{→}"	, R)	; +→
	SetKana( KC_C | KC_V | KC_COMM	,"+{←}"	, R)	; +←
	SetKana( KC_C | KC_V | KC_O		,"{→}"		, R)	; →
	SetKana( KC_C | KC_V | KC_L		,"+{→ 5}"	, R)	; +→5
	SetKana( KC_C | KC_V | KC_DOT	,"+{← 5}"	, R)	; +←5
	SetKana( KC_C | KC_V | KC_P		,"^v"		)		; Paste
	SetKana( KC_C | KC_V | KC_SCLN	,"+{→ 20}"	)		; +→20
	SetKana( KC_C | KC_V | KC_SLSH	,"+{← 20}"	)		; +←20

	SetEisu( KC_C | KC_V | KC_Y		,"+{Home}"	)		; +Home
	SetEisu( KC_C | KC_V | KC_H		,"^c"		)		; Copy
	SetEisu( KC_C | KC_V | KC_N		,"+{End}"	)		; +End
	SetEisu( KC_C | KC_V | KC_U		,"^x"		)		; Cut
	SetEisu( KC_C | KC_V | KC_J		,"{→ 5}"	, R)	; →5
	SetEisu( KC_C | KC_V | KC_M		,"{← 5}"	, R)	; ←5
	SetEisu( KC_C | KC_V | KC_I		,"{←}"		, R)	; ←
	SetEisu( KC_C | KC_V | KC_K		,"+{→}"	, R)	; +→
	SetEisu( KC_C | KC_V | KC_COMM	,"+{←}"	, R)	; +←
	SetEisu( KC_C | KC_V | KC_O		,"{→}"		, R)	; →
	SetEisu( KC_C | KC_V | KC_L		,"+{→ 5}"	, R)	; +→5
	SetEisu( KC_C | KC_V | KC_DOT	,"+{← 5}"	, R)	; +←5
	SetEisu( KC_C | KC_V | KC_P		,"^v"		)		; Paste
	SetEisu( KC_C | KC_V | KC_SCLN	,"+{→ 20}"	)		; +→20
	SetEisu( KC_C | KC_V | KC_SLSH	,"+{← 20}"	)		; +←20

kanaGroup := ""	; グループなし
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

kanaGroup := ""	; グループなし
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

;**************************************
; 固有名詞ショートカット
; 上段人差指＋中指

; 第一面
	kanaGroup := "KL"	; 左手側
		SetKana(KC_Y | KC_1		,"{直接}" . E01)
		SetKana(KC_Y | KC_2		,"{直接}" . E02)
		SetKana(KC_Y | KC_3		,"{直接}" . E03)
		SetKana(KC_Y | KC_4		,"{直接}" . E04)
		SetKana(KC_Y | KC_5		,"{直接}" . E05)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_T | KC_6		,"{直接}" . E06)
		SetKana(KC_T | KC_7		,"{直接}" . E07)
		SetKana(KC_T | KC_8		,"{直接}" . E08)
		SetKana(KC_T | KC_9		,"{直接}" . E09)
		SetKana(KC_T | KC_0		,"{直接}" . E10)
		SetKana(KC_T | KC_MINS	,"{直接}" . E11)
		SetKana(KC_T | KC_EQL	,"{直接}" . E12)
		SetKana(KC_T | JP_YEN	,"{直接}" . E13)

	kanaGroup := "KL"	; 左手側
		SetKana(KC_Y | KC_Q		,"{直接}" . D01)
		SetKana(KC_Y | KC_W		,"{直接}" . D02)
		SetKana(KC_Y | KC_E		,"{直接}" . D03)
		SetKana(KC_Y | KC_R		,"{直接}" . D04)
		SetKana(KC_Y | KC_T		,"{直接}" . D05)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_T | KC_Y		,"{直接}" . D06)
		SetKana(KC_T | KC_U		,"{直接}" . D07)
		SetKana(KC_T | KC_I		,"{直接}" . D08)
		SetKana(KC_T | KC_O		,"{直接}" . D09)
		SetKana(KC_T | KC_P		,"{直接}" . D10)
		SetKana(KC_T | KC_LBRC	,"{直接}" . D11)
		SetKana(KC_T | KC_RBRC	,"{直接}" . D12)

	kanaGroup := "KL"	; 左手側
		SetKana(KC_Y | KC_A		,"{直接}" . C01)
		SetKana(KC_Y | KC_S		,"{直接}" . C02)
		SetKana(KC_Y | KC_D		,"{直接}" . C03)
		SetKana(KC_Y | KC_F		,"{直接}" . C04)
		SetKana(KC_Y | KC_G		,"{直接}" . C05)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_T | KC_H		,"{直接}" . C06)
		SetKana(KC_T | KC_J		,"{直接}" . C07)
		SetKana(KC_T | KC_K		,"{直接}" . C08)
		SetKana(KC_T | KC_L		,"{直接}" . C09)
		SetKana(KC_T | KC_SCLN	,"{直接}" . C10)
		SetKana(KC_T | KC_QUOT	,"{直接}" . C11)
		SetKana(KC_T | KC_NUHS	,"{直接}" . C12)

	kanaGroup := "KL"	; 左手側
		SetKana(KC_Y | KC_Z		,"{直接}" . B01)
		SetKana(KC_Y | KC_X		,"{直接}" . B02)
		SetKana(KC_Y | KC_C		,"{直接}" . B03)
		SetKana(KC_Y | KC_V		,"{直接}" . B04)
		SetKana(KC_Y | KC_B		,"{直接}" . B05)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_T | KC_N		,"{直接}" . B06)
		SetKana(KC_T | KC_M		,"{直接}" . B07)
		SetKana(KC_T | KC_COMM	,"{直接}" . B08)
		SetKana(KC_T | KC_DOT	,"{直接}" . B09)
		SetKana(KC_T | KC_SLSH	,"{直接}" . B10)
		SetKana(KC_T | KC_INT1	,"{直接}" . B11)

; 第二面
	kanaGroup := "KL"	; 左手側
		SetKana(KC_Y | KC_U | KC_1		,"{直接}" . E01S)
		SetKana(KC_Y | KC_U | KC_2		,"{直接}" . E02S)
		SetKana(KC_Y | KC_U | KC_3		,"{直接}" . E03S)
		SetKana(KC_Y | KC_U | KC_4		,"{直接}" . E04S)
		SetKana(KC_Y | KC_U | KC_5		,"{直接}" . E05S)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_R | KC_T | KC_6		,"{直接}" . E06S)
		SetKana(KC_R | KC_T | KC_7		,"{直接}" . E07S)
		SetKana(KC_R | KC_T | KC_8		,"{直接}" . E08S)
		SetKana(KC_R | KC_T | KC_9		,"{直接}" . E09S)
		SetKana(KC_R | KC_T | KC_0		,"{直接}" . E10S)
		SetKana(KC_R | KC_T | KC_MINS	,"{直接}" . E11S)
		SetKana(KC_R | KC_T | KC_EQL	,"{直接}" . E12S)
		SetKana(KC_R | KC_T | JP_YEN	,"{直接}" . E13S)

	kanaGroup := "KL"	; 左手側
		SetKana(KC_Y | KC_U | KC_Q		,"{直接}" . D01S)
		SetKana(KC_Y | KC_U | KC_W		,"{直接}" . D02S)
		SetKana(KC_Y | KC_U | KC_E		,"{直接}" . D03S)
		SetKana(KC_Y | KC_U | KC_R		,"{直接}" . D04S)
		SetKana(KC_Y | KC_U | KC_T		,"{直接}" . D05S)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_R | KC_T | KC_Y		,"{直接}" . D06S)
		SetKana(KC_R | KC_T | KC_U		,"{直接}" . D07S)
		SetKana(KC_R | KC_T | KC_I		,"{直接}" . D08S)
		SetKana(KC_R | KC_T | KC_O		,"{直接}" . D09S)
		SetKana(KC_R | KC_T | KC_P		,"{直接}" . D10S)
		SetKana(KC_R | KC_T | KC_LBRC	,"{直接}" . D11S)
		SetKana(KC_R | KC_T | KC_RBRC	,"{直接}" . D12S)

	kanaGroup := "KL"	; 左手側
		SetKana(KC_Y | KC_U | KC_A		,"{直接}" . C01S)
		SetKana(KC_Y | KC_U | KC_S		,"{直接}" . C02S)
		SetKana(KC_Y | KC_U | KC_D		,"{直接}" . C03S)
		SetKana(KC_Y | KC_U | KC_F		,"{直接}" . C04S)
		SetKana(KC_Y | KC_U | KC_G		,"{直接}" . C05S)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_R | KC_T | KC_H		,"{直接}" . C06S)
		SetKana(KC_R | KC_T | KC_J		,"{直接}" . C07S)
		SetKana(KC_R | KC_T | KC_K		,"{直接}" . C08S)
		SetKana(KC_R | KC_T | KC_L		,"{直接}" . C09S)
		SetKana(KC_R | KC_T | KC_SCLN	,"{直接}" . C10S)
		SetKana(KC_R | KC_T | KC_QUOT	,"{直接}" . C11S)
		SetKana(KC_R | KC_T | KC_NUHS	,"{直接}" . C12S)

	kanaGroup := "KL"	; 左手側
		SetKana(KC_Y | KC_U | KC_Z		,"{直接}" . B01S)
		SetKana(KC_Y | KC_U | KC_X		,"{直接}" . B02S)
		SetKana(KC_Y | KC_U | KC_C		,"{直接}" . B03S)
		SetKana(KC_Y | KC_U | KC_V		,"{直接}" . B04S)
		SetKana(KC_Y | KC_U | KC_B		,"{直接}" . B05S)
	kanaGroup := "KR"	; 右手側
		SetKana(KC_R | KC_T | KC_N		,"{直接}" . B06S)
		SetKana(KC_R | KC_T | KC_M		,"{直接}" . B07S)
		SetKana(KC_R | KC_T | KC_COMM	,"{直接}" . B08S)
		SetKana(KC_R | KC_T | KC_DOT	,"{直接}" . B09S)
		SetKana(KC_R | KC_T | KC_SLSH	,"{直接}" . B10S)
		SetKana(KC_R | KC_T | KC_INT1	,"{直接}" . B11S)

	; 設定がUSキーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	If (keyDriver == "kbd101.dll")
	{
		SetKana(KC_T | KC_BSLS			,"{直接}" . E13)
		SetKana(KC_T | KC_GRV			,"{直接}" . C12)
		SetKana(KC_R | KC_T | KC_BSLS	,"{直接}" . E13S)
		SetKana(KC_R | KC_T | KC_GRV	,"{直接}" . C12S)
	}

	kanaGroup := "2L"
		; 固有名詞ショートカットを切り替える
		SetKana( KC_T | KC_1	, 1, "KoyuChange")	; 固有名詞ショートカット１
		SetKana( KC_T | KC_2	, 2, "KoyuChange")	; 固有名詞ショートカット２
		SetKana( KC_T | KC_3	, 3, "KoyuChange")	; 固有名詞ショートカット３
		SetKana( KC_T | KC_4	, 4, "KoyuChange")	; 固有名詞ショートカット４
		SetKana( KC_T | KC_5	, 5, "KoyuChange")	; 固有名詞ショートカット５

	kanaGroup := ""	; グループなし
	Return
}

; ----------------------------------------------------------------------
; 追加のホットキー
; ----------------------------------------------------------------------

F13::PrintScreen	; (Apple Pro Keyboard)F13 → PrintScreen
F14::ScrollLock		; (Apple Pro Keyboard)F14 → ScrollLock
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
	Else
		SetCapsLockState, On
	Return
#If		; End #If ()

; ----------------------------------------------------------------------
; IME 操作
; ----------------------------------------------------------------------
sc7B::		; 無変換
sc71 up::	; Mac英数(新MS-IME登場前)
vk1A::		; Mac英数
	StoreBuf("{vkF2}{vkF3}")	; ひらがな(IMEオンを兼ねる) → 半角/全角
	OutBuf()
	Return
+sc7B::		; Shift + 無変換
+sc71 up::	; Shift + Mac英数(新MS-IME登場前)
+vk1A::		; Shift + Mac英数
	StoreBuf("{全英}")
	OutBuf()
	Return
sc70::		; ひらがな
sc72 up::	; Macかな(新MS-IME登場前)
vk16::		; Macかな
	If (A_PriorHotKey = A_ThisHotKey && A_TimeSincePriorHotkey < 200)
		StoreBuf("#/")			; 2連打で再変換
	Else
		StoreBuf("{vkF2 2}")	; ひらがな(IMEオンを兼ねる)
	OutBuf()
	Return
+sc70::		; Shift + ひらがな
+sc72 up::	; Shift + Macかな(新MS-IME登場前)
+vk16::		; Shift + Macかな
	StoreBuf("{vkF2 2}{vkF1}")	; ひらがな(IMEオンを兼ねる) → カタカナ
	OutBuf()
	Return
