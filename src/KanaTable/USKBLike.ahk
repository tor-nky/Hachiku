; **********************************************************************
; 【薙刀式】v13完成版、発表。
; http://oookaworks.seesaa.net/article/479173898.html#gsc.tab=0
; (2020年12月25日)より
;
; 変更部分：
; 記号はすべて全角文字を出力する
; **********************************************************************

; ----------------------------------------------------------------------
; 英数／かな配列の定義ファイル 【すべて縦書き用で書くこと】
;
; 例：	SetKana( KC_Q | KC_L | KC_SPC		,"xwa"	, R)	; (ゎ)
;		~~~~~~~  ~~~~~~~~~~~~~~~~~~~~		  ~~~	  ~ 	  ~~~~
;		かな定義	スペース+Q+L		 変換後の出力 ↑	コメント
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


; ----------------------------------------------------------------------
; USキーボード風の配列へ
; ----------------------------------------------------------------------
toUSLike:
	; 設定がUSキーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	if (KeyDriver == "kbd101.dll")
		return

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
;	SetKana( KC_LBRC | KC_SPC	,"+{sc1B}"	)	; {
;	SetKana( KC_RBRC | KC_SPC	,"+{sc2B}"	)	; }
;	SetKana( KC_SCLN | KC_SPC	,"{sc28}"	)	; :
	SetKana( KC_QUOT | KC_SPC	,"+{sc03}"	)	; "
	SetKana( KC_NUHS | KC_SPC	,"+{sc0D}"	)	; ~

	; 設定がPC-9800キーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	if (KeyDriver == "kbdnec.dll")
	{
		SetEisu( KC_NUHS			,"+{sc0D}"	)	; `
		SetEisu( KC_NUHS | KC_SPC	,"+{sc1A}"	)	; ~

		SetKana( KC_NUHS			,"+{sc0D}"	)	; `
		SetKana( KC_NUHS | KC_SPC	,"+{sc1A}"	)	; ~
	}

	; 薙刀式固有の変更箇所
	SetKana( KC_INT1			,"?"		)	; ？
	SetKana( KC_LBRC | KC_SPC	,"『"		)	; 『
	SetKana( KC_RBRC | KC_SPC	,"』"		)	; 』
	SetKana( KC_INT1 | KC_SPC	,"{!}"		)	; ！

	return


; ----------------------------------------------------------------------
; USキーボード風の解除
; ----------------------------------------------------------------------
toJIS:
	; 設定がUSキーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	if (KeyDriver == "kbd101.dll")
		return

	SetEisu( KC_EQL		,"{sc0D}"	)
	SetEisu( KC_LBRC	,"{sc1A}"	)
	SetEisu( KC_RBRC	,"{sc1B}"	)
	SetEisu( KC_QUOT	,"{sc28}"	)
	SetEisu( KC_NUHS	,"{sc2B}"	)

	SetEisu( KC_2 | KC_SPC		,"+{sc03}"	)
	SetEisu( KC_6 | KC_SPC		,"+{sc07}"	)
	SetEisu( KC_7 | KC_SPC		,"+{sc08}"	)
	SetEisu( KC_8 | KC_SPC		,"+{sc09}"	)
	SetEisu( KC_9 | KC_SPC		,"+{sc0A}"	)
	SetEisu( KC_0 | KC_SPC		,"+{sc0B}"	)
	SetEisu( KC_MINS | KC_SPC	,"+{sc0C}"	)
	SetEisu( KC_EQL | KC_SPC	,"+{sc0D}"	)
	SetEisu( KC_LBRC | KC_SPC	,"+{sc1A}"	)
	SetEisu( KC_RBRC | KC_SPC	,"+{sc1B}"	)
	SetEisu( KC_SCLN | KC_SPC	,"+{sc27}"	)
	SetEisu( KC_QUOT | KC_SPC	,"+{sc28}"	)
	SetEisu( KC_NUHS | KC_SPC	,"+{sc2B}"	)


	SetKana( KC_EQL		,"{sc0D}"	)
	SetKana( KC_LBRC	,"{sc1A}"	)
	SetKana( KC_RBRC	,"{sc1B}"	)
	SetKana( KC_QUOT	,"{sc28}"	)
	SetKana( KC_NUHS	,"{sc2B}"	)

	SetKana( KC_2 | KC_SPC		,"+{sc03}"	)
	SetKana( KC_6 | KC_SPC		,"+{sc07}"	)

	SetKana( KC_7 | KC_SPC		,"+{sc08}"	)
	SetKana( KC_8 | KC_SPC		,"+{sc09}"	)
	SetKana( KC_9 | KC_SPC		,"+{sc0A}"	)
	SetKana( KC_0 | KC_SPC		,"+{sc0B}"	)
	SetKana( KC_MINS | KC_SPC	,"+{sc0C}"	)
	SetKana( KC_EQL | KC_SPC	,"+{sc0D}"	)
	SetKana( KC_LBRC | KC_SPC	,"+{sc1A}"	)
;	SetKana( KC_RBRC | KC_SPC	,"+{sc1B}"	)
	SetKana( KC_QUOT | KC_SPC	,"+{sc28}"	)
	SetKana( KC_NUHS | KC_SPC	,"+{sc2B}"	)


	; 薙刀式固有の変更箇所
	SetKana( KC_INT1	,"\"		)		; ￥(PC-9800キーボード対策)
	SetKana( KC_RBRC | KC_SPC	,"『"		)		; 『
	SetKana( KC_NUHS | KC_SPC	,"』"		)		; 』
	SetKana( KC_INT1 | KC_SPC	,"+{sc73}"	)

	return
