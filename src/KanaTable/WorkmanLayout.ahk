; **********************************************************************
; Workman Keyboard Layout
; **********************************************************************

; ----------------------------------------------------------------------
; 英数／かな配列の定義ファイル
;
;【縦書き用だけ書き、横書き用は自動変換する方法】
;
; 例：	SetKana( KC_Q | KC_L | KC_SPC		,"xwa"	, R)	; (ゎ)
;		~~~~~~~  ~~~~~~~~~~~~~~~~~~~~		  ~~~	  ~ 	  ~~~~
;		かな定義	スペース+Q+L	   縦書き用の出力 ↑	コメント
;													  ｜
;									リピートあり(NRがリピートなし)
;
; 例：	 SetEisu( KC_H | KC_J			,"{vkF2 2}" )		; IME ON
;		 ~~~~~~~
;		 英数定義
;
; 【縦書き用と横書き用を分けて書く方法】
;
; 例：	SetKana2(KC_J | KC_K | KC_Z		,"││{確定}", "──{確定}")
; 例：	SetEisu2(KC_J | KC_K | KC_Z		,"││{確定}", "──{確定}")
;		~~~~~~~  ~~~~~~~~~~~~~~~~~~		  ~~~~~~~~~~	~~~~~~~~~~
;		かな定義	   J+K+Z		   縦書き用の出力   横書き用の出力
;		英数定義
;
;	※ "(){確定}" はIMEに合わせ、"{一時半角}()" は半角になり、全角で定義した "（）" は全角になります
;
;	※再読み込みか、再起動で有効になります
;	※全角空白の違いが見えるエディタを使うことをおすすめします
;	※UTF-8(BOM付)で保存してください
;	※順序はグループ内で自由です。同じキーの組み合わせは、後の方が有効になります。
; ----------------------------------------------------------------------

; かな配列読み込み
ReadWorkmanLayout()	; () -> Void
{
	#IncludeAgain %A_ScriptDir%/Sub/KeyBit_h.ahk	; 配列定義で使う定数
	global layoutNameE, koyuNumber

	layoutNameE := "Workman Keyboard Layout"

kanaGroup := ""	; グループなし
	SetEisu( KC_1		,"1"	)
	SetEisu( KC_2		,"2"	)
	SetEisu( KC_3		,"3"	)
	SetEisu( KC_4		,"4"	)
	SetEisu( KC_5		,"5"	)
	SetEisu( KC_6		,"6"	)
	SetEisu( KC_7		,"7"	)
	SetEisu( KC_8		,"8"	)
	SetEisu( KC_9		,"9"	)
	SetEisu( KC_0		,"{0}"	)
	SetEisu( KC_MINS	,"-"	)
	SetEisu( KC_EQL		,"="	)
	SetEisu( JP_YEN		,"\"	)

	SetEisu( KC_Q		,"q"	)
	SetEisu( KC_W		,"d"	)
	SetEisu( KC_E		,"r"	)
	SetEisu( KC_R		,"w"	)
	SetEisu( KC_T		,"b"	)
	SetEisu( KC_Y		,"j"	)
	SetEisu( KC_U		,"f"	)
	SetEisu( KC_I		,"u"	)
	SetEisu( KC_O		,"p"	)
	SetEisu( KC_P		,";"	)
	SetEisu( KC_LBRC	,"["	)
	SetEisu( KC_RBRC	,"]"	)

	SetEisu( KC_A		,"a"	)
	SetEisu( KC_S		,"s"	)
	SetEisu( KC_D		,"h"	)
	SetEisu( KC_F		,"t"	)
	SetEisu( KC_G		,"g"	)
	SetEisu( KC_H		,"y"	)
	SetEisu( KC_J		,"n"	)
	SetEisu( KC_K		,"e"	)
	SetEisu( KC_L		,"o"	)
	SetEisu( KC_SCLN	,"i"	)
	SetEisu( KC_QUOT	,"'"	)
	SetEisu( KC_NUHS	,"``"	)

	SetEisu( KC_Z		,"z"	)
	SetEisu( KC_X		,"x"	)
	SetEisu( KC_C		,"m"	)
	SetEisu( KC_V		,"c"	)
	SetEisu( KC_B		,"v"	)
	SetEisu( KC_N		,"k"	)
	SetEisu( KC_M		,"l"	)
	SetEisu( KC_COMM	,","	)
	SetEisu( KC_DOT 	,"."	)
	SetEisu( KC_SLSH	,"/"	)
	SetEisu( KC_INT1	,"\"	)

	SetEisu( KC_SPC | KC_1		,"{!}"	)
	SetEisu( KC_SPC | KC_2		,"@"	)
	SetEisu( KC_SPC | KC_3		,"{#}"	)
	SetEisu( KC_SPC | KC_4		,"$"	)
	SetEisu( KC_SPC | KC_5		,"%"	)
	SetEisu( KC_SPC | KC_6		,"{^}"	)
	SetEisu( KC_SPC | KC_7		,"&"	)
	SetEisu( KC_SPC | KC_8		,"*"	)
	SetEisu( KC_SPC | KC_9		,"("	)
	SetEisu( KC_SPC | KC_0		,")"	)
	SetEisu( KC_SPC | KC_MINS	,"_"	)
	SetEisu( KC_SPC | KC_EQL	,"{+}"	)
	SetEisu( KC_SPC | JP_YEN	,"|"	)

	SetEisu( KC_SPC | KC_Q		,"Q"	)
	SetEisu( KC_SPC | KC_W		,"D"	)
	SetEisu( KC_SPC | KC_E		,"R"	)
	SetEisu( KC_SPC | KC_R		,"W"	)
	SetEisu( KC_SPC | KC_T		,"B"	)
	SetEisu( KC_SPC | KC_Y		,"J"	)
	SetEisu( KC_SPC | KC_U		,"F"	)
	SetEisu( KC_SPC | KC_I		,"U"	)
	SetEisu( KC_SPC | KC_O		,"P"	)
	SetEisu( KC_SPC | KC_P		,":"	)
	SetEisu( KC_SPC | KC_LBRC	,"{{}"	)
	SetEisu( KC_SPC | KC_RBRC	,"{}}"	)

	SetEisu( KC_SPC | KC_A		,"A"	)
	SetEisu( KC_SPC | KC_S		,"S"	)
	SetEisu( KC_SPC | KC_D		,"H"	)
	SetEisu( KC_SPC | KC_F		,"T"	)
	SetEisu( KC_SPC | KC_G		,"G"	)
	SetEisu( KC_SPC | KC_H		,"Y"	)
	SetEisu( KC_SPC | KC_J		,"N"	)
	SetEisu( KC_SPC | KC_K		,"E"	)
	SetEisu( KC_SPC | KC_L		,"O"	)
	SetEisu( KC_SPC | KC_SCLN	,"I"	)
	SetEisu( KC_SPC | KC_QUOT	,""""	)
	SetEisu( KC_SPC | KC_NUHS	,"~"	)

	SetEisu( KC_SPC | KC_Z		,"Z"	)
	SetEisu( KC_SPC | KC_X		,"X"	)
	SetEisu( KC_SPC | KC_C		,"M"	)
	SetEisu( KC_SPC | KC_V		,"C"	)
	SetEisu( KC_SPC | KC_B		,"V"	)
	SetEisu( KC_SPC | KC_N		,"K"	)
	SetEisu( KC_SPC | KC_M		,"L"	)
	SetEisu( KC_SPC | KC_COMM	,"<"	)
	SetEisu( KC_SPC | KC_DOT	,">"	)
	SetEisu( KC_SPC | KC_SLSH	,"?"	)
	SetEisu( KC_SPC | KC_INT1	,"_"	)


	SetKana( KC_1		,"1"	)
	SetKana( KC_2		,"2"	)
	SetKana( KC_3		,"3"	)
	SetKana( KC_4		,"4"	)
	SetKana( KC_5		,"5"	)
	SetKana( KC_6		,"6"	)
	SetKana( KC_7		,"7"	)
	SetKana( KC_8		,"8"	)
	SetKana( KC_9		,"9"	)
	SetKana( KC_0		,"{0}"	)
	SetKana( KC_MINS	,"-"	)
	SetKana( KC_EQL		,"="	)
	SetKana( JP_YEN		,"\"	)

	SetKana( KC_Q		,"q"	)
	SetKana( KC_W		,"d"	)
	SetKana( KC_E		,"r"	)
	SetKana( KC_R		,"w"	)
	SetKana( KC_T		,"b"	)
	SetKana( KC_Y		,"j"	)
	SetKana( KC_U		,"f"	)
	SetKana( KC_I		,"u"	)
	SetKana( KC_O		,"p"	)
	SetKana( KC_P		,";"	)
	SetKana( KC_LBRC	,"["	)
	SetKana( KC_RBRC	,"]"	)

	SetKana( KC_A		,"a"	)
	SetKana( KC_S		,"s"	)
	SetKana( KC_D		,"h"	)
	SetKana( KC_F		,"t"	)
	SetKana( KC_G		,"g"	)
	SetKana( KC_H		,"y"	)
	SetKana( KC_J		,"n"	)
	SetKana( KC_K		,"e"	)
	SetKana( KC_L		,"o"	)
	SetKana( KC_SCLN	,"i"	)
	SetKana( KC_QUOT	,"'"	)
	SetKana( KC_NUHS	,"``"	)

	SetKana( KC_Z		,"z"	)
	SetKana( KC_X		,"x"	)
	SetKana( KC_C		,"m"	)
	SetKana( KC_V		,"c"	)
	SetKana( KC_B		,"v"	)
	SetKana( KC_N		,"k"	)
	SetKana( KC_M		,"l"	)
	SetKana( KC_COMM	,","	)
	SetKana( KC_DOT 	,"."	)
	SetKana( KC_SLSH	,"/"	)
	SetKana( KC_INT1	,"\"	)

	SetKana( KC_SPC | KC_1		,"{!}"	)
	SetKana( KC_SPC | KC_2		,"@"	)
	SetKana( KC_SPC | KC_3		,"{#}"	)
	SetKana( KC_SPC | KC_4		,"$"	)
	SetKana( KC_SPC | KC_5		,"%"	)
	SetKana( KC_SPC | KC_6		,"{^}"	)
	SetKana( KC_SPC | KC_7		,"&"	)
	SetKana( KC_SPC | KC_8		,"*"	)
	SetKana( KC_SPC | KC_9		,"("	)
	SetKana( KC_SPC | KC_0		,")"	)
	SetKana( KC_SPC | KC_MINS	,"_"	)
	SetKana( KC_SPC | KC_EQL	,"{+}"	)
	SetKana( KC_SPC | JP_YEN	,"|"	)

	SetKana( KC_SPC | KC_Q		,"Q"	)
	SetKana( KC_SPC | KC_W		,"D"	)
	SetKana( KC_SPC | KC_E		,"R"	)
	SetKana( KC_SPC | KC_R		,"W"	)
	SetKana( KC_SPC | KC_T		,"B"	)
	SetKana( KC_SPC | KC_Y		,"J"	)
	SetKana( KC_SPC | KC_U		,"F"	)
	SetKana( KC_SPC | KC_I		,"U"	)
	SetKana( KC_SPC | KC_O		,"P"	)
	SetKana( KC_SPC | KC_P		,":"	)
	SetKana( KC_SPC | KC_LBRC	,"{{}"	)
	SetKana( KC_SPC | KC_RBRC	,"{}}"	)

	SetKana( KC_SPC | KC_A		,"A"	)
	SetKana( KC_SPC | KC_S		,"S"	)
	SetKana( KC_SPC | KC_D		,"H"	)
	SetKana( KC_SPC | KC_F		,"T"	)
	SetKana( KC_SPC | KC_G		,"G"	)
	SetKana( KC_SPC | KC_H		,"Y"	)
	SetKana( KC_SPC | KC_J		,"N"	)
	SetKana( KC_SPC | KC_K		,"E"	)
	SetKana( KC_SPC | KC_L		,"O"	)
	SetKana( KC_SPC | KC_SCLN	,"I"	)
	SetKana( KC_SPC | KC_QUOT	,""""	)
	SetKana( KC_SPC | KC_NUHS	,"~"	)

	SetKana( KC_SPC | KC_Z		,"Z"	)
	SetKana( KC_SPC | KC_X		,"X"	)
	SetKana( KC_SPC | KC_C		,"M"	)
	SetKana( KC_SPC | KC_V		,"C"	)
	SetKana( KC_SPC | KC_B		,"V"	)
	SetKana( KC_SPC | KC_N		,"K"	)
	SetKana( KC_SPC | KC_M		,"L"	)
	SetKana( KC_SPC | KC_COMM	,"<"	)
	SetKana( KC_SPC | KC_DOT	,">"	)
	SetKana( KC_SPC | KC_SLSH	,"?"	)
	SetKana( KC_SPC | KC_INT1	,"_"	)


	; 設定がUSキーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
	If (keyDriver = "kbd101.dll")
	{
		SetEisu( KC_GRV				,"{sc29}"	)
		SetEisu( KC_GRV | KC_SPC	,"+{sc29}"	)
		SetKana( KC_GRV				,"{sc29}"	)
		SetKana( KC_GRV | KC_SPC	,"+{sc29}"	)
	}
}
