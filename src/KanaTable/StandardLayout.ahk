; **********************************************************************
; キーボード初期配列
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

; キーボード初期配列
ReadStandardLayout()	; () -> Void
{
	#IncludeAgain %A_ScriptDir%/Sub/KeyBit_h.ahk

kanaGroup := ""	; グループなし
	SetEisu( KC_1		,"{sc02}"	)
	SetEisu( KC_2		,"{sc03}"	)
	SetEisu( KC_3		,"{sc04}"	)
	SetEisu( KC_4		,"{sc05}"	)
	SetEisu( KC_5		,"{sc06}"	)
	SetEisu( KC_6		,"{sc07}"	)
	SetEisu( KC_7		,"{sc08}"	)
	SetEisu( KC_8		,"{sc09}"	)
	SetEisu( KC_9		,"{sc0A}"	)
	SetEisu( KC_0		,"{sc0B}"	)
	SetEisu( KC_MINS	,"{sc0C}"	)
	SetEisu( KC_EQL		,"{sc0D}"	)
	SetEisu( JP_YEN		,"{sc7D}"	)

	SetEisu( KC_Q		,"{sc10}"	)
	SetEisu( KC_W		,"{sc11}"	)
	SetEisu( KC_E		,"{sc12}"	)
	SetEisu( KC_R		,"{sc13}"	)
	SetEisu( KC_T		,"{sc14}"	)
	SetEisu( KC_Y		,"{sc15}"	)
	SetEisu( KC_U		,"{sc16}"	)
	SetEisu( KC_I		,"{sc17}"	)
	SetEisu( KC_O		,"{sc18}"	)
	SetEisu( KC_P		,"{sc19}"	)
	SetEisu( KC_LBRC	,"{sc1A}"	)
	SetEisu( KC_RBRC	,"{sc1B}"	)

	SetEisu( KC_A		,"{sc1E}"	)
	SetEisu( KC_S		,"{sc1F}"	)
	SetEisu( KC_D		,"{sc20}"	)
	SetEisu( KC_F		,"{sc21}"	)
	SetEisu( KC_G		,"{sc22}"	)
	SetEisu( KC_H		,"{sc23}"	)
	SetEisu( KC_J		,"{sc24}"	)
	SetEisu( KC_K		,"{sc25}"	)
	SetEisu( KC_L		,"{sc26}"	)
	SetEisu( KC_SCLN	,"{sc27}"	)
	SetEisu( KC_QUOT	,"{sc28}"	)
	SetEisu( KC_NUHS	,"{sc2B}"	)

	SetEisu( KC_Z		,"{sc2C}"	)
	SetEisu( KC_X		,"{sc2D}"	)
	SetEisu( KC_C		,"{sc2E}"	)
	SetEisu( KC_V		,"{sc2F}"	)
	SetEisu( KC_B		,"{sc30}"	)
	SetEisu( KC_N		,"{sc31}"	)
	SetEisu( KC_M		,"{sc32}"	)
	SetEisu( KC_COMM	,"{sc33}"	)
	SetEisu( KC_DOT 	,"{sc34}"	)
	SetEisu( KC_SLSH	,"{sc35}"	)
	SetEisu( KC_INT1	,"{sc73}"	)

	SetEisu( KC_SPC | KC_1		,"+{sc02}"	)
	SetEisu( KC_SPC | KC_2		,"+{sc03}"	)
	SetEisu( KC_SPC | KC_3		,"+{sc04}"	)
	SetEisu( KC_SPC | KC_4		,"+{sc05}"	)
	SetEisu( KC_SPC | KC_5		,"+{sc06}"	)
	SetEisu( KC_SPC | KC_6		,"+{sc07}"	)
	SetEisu( KC_SPC | KC_7		,"+{sc08}"	)
	SetEisu( KC_SPC | KC_8		,"+{sc09}"	)
	SetEisu( KC_SPC | KC_9		,"+{sc0A}"	)
	SetEisu( KC_SPC | KC_0		,"+{sc0B}"	)
	SetEisu( KC_SPC | KC_MINS	,"+{sc0C}"	)
	SetEisu( KC_SPC | KC_EQL	,"+{sc0D}"	)
	SetEisu( KC_SPC | JP_YEN	,"+{sc7D}"	)

	SetEisu( KC_SPC | KC_Q		,"+{sc10}"	)
	SetEisu( KC_SPC | KC_W		,"+{sc11}"	)
	SetEisu( KC_SPC | KC_E		,"+{sc12}"	)
	SetEisu( KC_SPC | KC_R		,"+{sc13}"	)
	SetEisu( KC_SPC | KC_T		,"+{sc14}"	)
	SetEisu( KC_SPC | KC_Y		,"+{sc15}"	)
	SetEisu( KC_SPC | KC_U		,"+{sc16}"	)
	SetEisu( KC_SPC | KC_I		,"+{sc17}"	)
	SetEisu( KC_SPC | KC_O		,"+{sc18}"	)
	SetEisu( KC_SPC | KC_P		,"+{sc19}"	)
	SetEisu( KC_SPC | KC_LBRC	,"+{sc1A}"	)
	SetEisu( KC_SPC | KC_RBRC	,"+{sc1B}"	)

	SetEisu( KC_SPC | KC_A		,"+{sc1E}"	)
	SetEisu( KC_SPC | KC_S		,"+{sc1F}"	)
	SetEisu( KC_SPC | KC_D		,"+{sc20}"	)
	SetEisu( KC_SPC | KC_F		,"+{sc21}"	)
	SetEisu( KC_SPC | KC_G		,"+{sc22}"	)
	SetEisu( KC_SPC | KC_H		,"+{sc23}"	)
	SetEisu( KC_SPC | KC_J		,"+{sc24}"	)
	SetEisu( KC_SPC | KC_K		,"+{sc25}"	)
	SetEisu( KC_SPC | KC_L		,"+{sc26}"	)
	SetEisu( KC_SPC | KC_SCLN	,"+{sc27}"	)
	SetEisu( KC_SPC | KC_QUOT	,"+{sc28}"	)
	SetEisu( KC_SPC | KC_NUHS	,"+{sc2B}"	)

	SetEisu( KC_SPC | KC_Z		,"+{sc2C}"	)
	SetEisu( KC_SPC | KC_X		,"+{sc2D}"	)
	SetEisu( KC_SPC | KC_C		,"+{sc2E}"	)
	SetEisu( KC_SPC | KC_V		,"+{sc2F}"	)
	SetEisu( KC_SPC | KC_B		,"+{sc30}"	)
	SetEisu( KC_SPC | KC_N		,"+{sc31}"	)
	SetEisu( KC_SPC | KC_M		,"+{sc32}"	)
	SetEisu( KC_SPC | KC_COMM	,"+{sc33}"	)
	SetEisu( KC_SPC | KC_DOT	,"+{sc34}"	)
	SetEisu( KC_SPC | KC_SLSH	,"+{sc35}"	)
	SetEisu( KC_SPC | KC_INT1	,"+{sc73}"	)


	SetKana( KC_1		,"{sc02}"	)
	SetKana( KC_2		,"{sc03}"	)
	SetKana( KC_3		,"{sc04}"	)
	SetKana( KC_4		,"{sc05}"	)
	SetKana( KC_5		,"{sc06}"	)
	SetKana( KC_6		,"{sc07}"	)
	SetKana( KC_7		,"{sc08}"	)
	SetKana( KC_8		,"{sc09}"	)
	SetKana( KC_9		,"{sc0A}"	)
	SetKana( KC_0		,"{sc0B}"	)
	SetKana( KC_MINS	,"{sc0C}"	)
	SetKana( KC_EQL		,"{sc0D}"	)
	SetKana( JP_YEN		,"{sc7D}"	)

	SetKana( KC_Q		,"{sc10}"	)
	SetKana( KC_W		,"{sc11}"	)
	SetKana( KC_E		,"{sc12}"	)
	SetKana( KC_R		,"{sc13}"	)
	SetKana( KC_T		,"{sc14}"	)
	SetKana( KC_Y		,"{sc15}"	)
	SetKana( KC_U		,"{sc16}"	)
	SetKana( KC_I		,"{sc17}"	)
	SetKana( KC_O		,"{sc18}"	)
	SetKana( KC_P		,"{sc19}"	)
	SetKana( KC_LBRC	,"{sc1A}"	)
	SetKana( KC_RBRC	,"{sc1B}"	)

	SetKana( KC_A		,"{sc1E}"	)
	SetKana( KC_S		,"{sc1F}"	)
	SetKana( KC_D		,"{sc20}"	)
	SetKana( KC_F		,"{sc21}"	)
	SetKana( KC_G		,"{sc22}"	)
	SetKana( KC_H		,"{sc23}"	)
	SetKana( KC_J		,"{sc24}"	)
	SetKana( KC_K		,"{sc25}"	)
	SetKana( KC_L		,"{sc26}"	)
	SetKana( KC_SCLN	,"{sc27}"	)
	SetKana( KC_QUOT	,"{sc28}"	)
	SetKana( KC_NUHS	,"{sc2B}"	)

	SetKana( KC_Z		,"{sc2C}"	)
	SetKana( KC_X		,"{sc2D}"	)
	SetKana( KC_C		,"{sc2E}"	)
	SetKana( KC_V		,"{sc2F}"	)
	SetKana( KC_B		,"{sc30}"	)
	SetKana( KC_N		,"{sc31}"	)
	SetKana( KC_M		,"{sc32}"	)
	SetKana( KC_COMM	,"{sc33}"	)
	SetKana( KC_DOT 	,"{sc34}"	)
	SetKana( KC_SLSH	,"{sc35}"	)
	SetKana( KC_INT1	,"{sc73}"	)

	SetKana( KC_SPC | KC_1		,"+{sc02}"	)
	SetKana( KC_SPC | KC_2		,"+{sc03}"	)
	SetKana( KC_SPC | KC_3		,"+{sc04}"	)
	SetKana( KC_SPC | KC_4		,"+{sc05}"	)
	SetKana( KC_SPC | KC_5		,"+{sc06}"	)
	SetKana( KC_SPC | KC_6		,"+{sc07}"	)
	SetKana( KC_SPC | KC_7		,"+{sc08}"	)
	SetKana( KC_SPC | KC_8		,"+{sc09}"	)
	SetKana( KC_SPC | KC_9		,"+{sc0A}"	)
	SetKana( KC_SPC | KC_0		,"+{sc0B}"	)
	SetKana( KC_SPC | KC_MINS	,"+{sc0C}"	)
	SetKana( KC_SPC | KC_EQL	,"+{sc0D}"	)
	SetKana( KC_SPC | JP_YEN	,"+{sc7D}"	)

	SetKana( KC_SPC | KC_Q		,"+{sc10}"	)
	SetKana( KC_SPC | KC_W		,"+{sc11}"	)
	SetKana( KC_SPC | KC_E		,"+{sc12}"	)
	SetKana( KC_SPC | KC_R		,"+{sc13}"	)
	SetKana( KC_SPC | KC_T		,"+{sc14}"	)
	SetKana( KC_SPC | KC_Y		,"+{sc15}"	)
	SetKana( KC_SPC | KC_U		,"+{sc16}"	)
	SetKana( KC_SPC | KC_I		,"+{sc17}"	)
	SetKana( KC_SPC | KC_O		,"+{sc18}"	)
	SetKana( KC_SPC | KC_P		,"+{sc19}"	)
	SetKana( KC_SPC | KC_LBRC	,"+{sc1A}"	)
	SetKana( KC_SPC | KC_RBRC	,"+{sc1B}"	)

	SetKana( KC_SPC | KC_A		,"+{sc1E}"	)
	SetKana( KC_SPC | KC_S		,"+{sc1F}"	)
	SetKana( KC_SPC | KC_D		,"+{sc20}"	)
	SetKana( KC_SPC | KC_F		,"+{sc21}"	)
	SetKana( KC_SPC | KC_G		,"+{sc22}"	)
	SetKana( KC_SPC | KC_H		,"+{sc23}"	)
	SetKana( KC_SPC | KC_J		,"+{sc24}"	)
	SetKana( KC_SPC | KC_K		,"+{sc25}"	)
	SetKana( KC_SPC | KC_L		,"+{sc26}"	)
	SetKana( KC_SPC | KC_SCLN	,"+{sc27}"	)
	SetKana( KC_SPC | KC_QUOT	,"+{sc28}"	)
	SetKana( KC_SPC | KC_NUHS	,"+{sc2B}"	)

	SetKana( KC_SPC | KC_Z		,"+{sc2C}"	)
	SetKana( KC_SPC | KC_X		,"+{sc2D}"	)
	SetKana( KC_SPC | KC_C		,"+{sc2E}"	)
	SetKana( KC_SPC | KC_V		,"+{sc2F}"	)
	SetKana( KC_SPC | KC_B		,"+{sc30}"	)
	SetKana( KC_SPC | KC_N		,"+{sc31}"	)
	SetKana( KC_SPC | KC_M		,"+{sc32}"	)
	SetKana( KC_SPC | KC_COMM	,"+{sc33}"	)
	SetKana( KC_SPC | KC_DOT	,"+{sc34}"	)
	SetKana( KC_SPC | KC_SLSH	,"+{sc35}"	)
	SetKana( KC_SPC | KC_INT1	,"+{sc73}"	)

	; 設定がUSキーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	If (keyDriver = "kbd101.dll")
	{
		SetEisu( KC_GRV				,"{sc29}"	)
		SetEisu( KC_GRV | KC_SPC	,"+{sc29}"	)
		SetKana( KC_GRV				,"{sc29}"	)
		SetKana( KC_GRV | KC_SPC	,"+{sc29}"	)

		SetEisu( JP_YEN				,"\"		)
		SetEisu( JP_YEN | KC_SPC	,"|"		)
		SetKana( JP_YEN				,"\"		)
		SetKana( JP_YEN | KC_SPC	,"|"		)
		SetEisu( KC_INT1			,"\"		)
		SetEisu( KC_INT1 | KC_SPC	,"_"		)
		SetKana( KC_INT1			,"\"		)
		SetKana( KC_INT1 | KC_SPC	,"_"		)
	}
	; 設定がPC-9800キーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	Else If (keyDriver = "kbdnec.dll")
	{
		SetEisu( KC_INT1	,"\"	)
		SetKana( KC_INT1	,"\"	)
	}
}
