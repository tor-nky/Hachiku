; **********************************************************************
; 薙刀式配列
;		ローマ字入力モード
;	※MS-IME は初期設定のままでも使えます
;	※ATOK を使う場合のキー設定
;		Ctrl+Enter	→ Enter と同じにする
;		変換		→ [文字未入力]再変換
;		ひらがな	→ 入力文字種全角ひらがな(あ)
;		カタカナ	→ 入力文字種全角カタカナ(ア)
;		半角／全角	→ [文字未入力]日本語入力ON/OFF [他]入力文字種半角無変換(A)
; **********************************************************************
; --------〈起動処理１〉------------------------------------------------
SetWorkingDir %A_ScriptDir%		; スクリプトの作業ディレクトリを変更	;
#SingleInstance force			; 既存のプロセスを終了して実行開始		;
#Include Sub/IME.ahk	; Author: eamat. http://www6.atwiki.jp/eamat/	;
#Include Sub/Path.ahk	; Author: eamat. http://www6.atwiki.jp/eamat/	;
#Include Sub/init.ahk					; 初期設定						;
#Include KanaTable/StandardTable.ahk	; キーボード初期配列の読み込み	;
#Include KanaTable/NaginataTable.ahk	; かな定義の読み込み			;
; ----------------------------------------------------------------------

; ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
; ☆☆☆ 固有名詞ショートカット						☆☆☆
; ☆☆☆	上段人差指＋中指						☆☆☆
; ☆☆☆		書き方: "{固有} に続けて入力します	☆☆☆
; ☆☆☆ 	例： SetKana(KOYU_E, "{固有}天狗")		☆☆☆
; ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆

Group := 1	; 左手側
	SetKana(KOYU_1		,"{固有}")
	SetKana(KOYU_2		,"{固有}")
	SetKana(KOYU_3		,"{固有}")
	SetKana(KOYU_4		,"{固有}")
	SetKana(KOYU_5		,"{固有}")

	SetKana(KOYU_Q		,"{固有}臨兵闘者皆陣烈在前")
	SetKana(KOYU_W		,"{固有}ネムカケ")
	SetKana(KOYU_E		,"{固有}天狗")
	SetKana(KOYU_R		,"{固有}シンイチ")
	SetKana(KOYU_T		,"{固有}")

	SetKana(KOYU_A		,"{固有}")
	SetKana(KOYU_S		,"{固有}")
	SetKana(KOYU_D		,"{固有}")
	SetKana(KOYU_F		,"{固有}心の闇")
	SetKana(KOYU_G		,"{固有}")

	SetKana(KOYU_Z		,"{固有}火よ、在れ")
	SetKana(KOYU_X		,"{固有}火の剣")
	SetKana(KOYU_C		,"{固有}小鴉")
	SetKana(KOYU_V		,"{固有}光太郎")
	SetKana(KOYU_B		,"{固有}峯")

Group := 2	; 右手側
	SetKana(KOYU_6		,"{固有}")
	SetKana(KOYU_7		,"{固有}")
	SetKana(KOYU_8		,"{固有}")
	SetKana(KOYU_9		,"{固有}")
	SetKana(KOYU_0		,"{固有}")
	SetKana(KOYU_MINS	,"{固有}")
	SetKana(KOYU_EQL	,"{固有}")
	SetKana(KOYU_YEN	,"{固有}")

	SetKana(KOYU_Y		,"{固有}才一")
	SetKana(KOYU_U		,"{固有}さくら")
	SetKana(KOYU_I		,"{固有}妖怪")
	SetKana(KOYU_O		,"{固有}")
	SetKana(KOYU_P		,"{固有}")
	SetKana(KOYU_LBRC	,"{固有}")
	SetKana(KOYU_RBRC	,"{固有}")

	SetKana(KOYU_H		,"{固有}鞍馬")
	SetKana(KOYU_J		,"{固有}青鬼")
	SetKana(KOYU_K		,"{固有}")
	SetKana(KOYU_L		,"{固有}")
	SetKana(KOYU_SCLN	,"{固有}")
	SetKana(KOYU_QUOT	,"{固有}")
	SetKana(KOYU_NUHS	,"{固有}")
	SetKana(KOYU_BSLS	,"{固有}")

	SetKana(KOYU_N		,"{固有}鬼塚")
	SetKana(KOYU_M		,"{固有}")
	SetKana(KOYU_COMM	,"{固有}")
	SetKana(KOYU_DOT	,"{固有}不動金縛りの術")
	SetKana(KOYU_SLSH	,"{固有}")
	SetKana(KOYU_INT1	,"{固有}")


; --------〈起動処理２〉------------------------------------------------
	if USLike > 0														;
		Gosub, toUSLike													;
	KanaSetting()	; 出力確定するかな定義に印をつける					;
	EisuSetting()	; 出力確定する英数定義に印をつける					;
; --------〈変換〉------------------------------------------------------
#Include Sub/Conv.ahk													;
#Include KanaTable/USKBLike.ahk			; USキーボード風配列			;
; ----------------------------------------------------------------------
