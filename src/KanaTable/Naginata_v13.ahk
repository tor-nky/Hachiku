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


Group := 0	; 0 はグループAll

;***********************************************/
;***********************************************/
; メイン部分; 単打とシフト					   */
;***********************************************/
;***********************************************/

; 単打 */
	SetKana( KC_Q		,"{Null}"	)		; ダミー
	SetKana( KC_W		,"ki"		)		; き
	SetKana( KC_E		,"te"		)		; て
	SetKana( KC_R		,"si"		)		; し
	SetKana( KC_T		,"{←}"		, R)	; 左
	SetKana( KC_Y		,"{→}"		, R)	; 右
	SetKana( KC_U		,"{BS}" 	, R)	; 前文字削除
	SetKana( KC_I		,"ru"		)		; る
	SetKana( KC_O		,"su"		)		; す
	SetKana( KC_P		,"he"		)		; へ
	SetKana( KC_A		,"ro"		)		; ろ
	SetKana( KC_S		,"ke"		)		; け
	SetKana( KC_D		,"to"		)		; と
	SetKana( KC_F		,"ka"		)		; か
	SetKana( KC_G		,"xtu"		)		; (っ)
	SetKana( KC_H		,"ku"		)		; く
	SetKana( KC_J		,"a"		)		; あ
	SetKana( KC_K		,"i"		)		; い
	SetKana( KC_L		,"u"		)		; う
	SetKana( KC_SCLN	,"-"		)		; ー
	SetKana( KC_Z		,"ho"		)		; ほ
	SetKana( KC_X		,"hi"		)		; ひ
	SetKana( KC_C		,"ha"		)		; は
	SetKana( KC_V		,"ko"		)		; こ
	SetKana( KC_B		,"so"		)		; そ
	SetKana( KC_N		,"ta"		)		; た
	SetKana( KC_M		,"na"		)		; な
	SetKana( KC_COMM	,"nn"		)		; ん
	SetKana( KC_DOT 	,"ra"		)		; ら
	SetKana( KC_SLSH	,"re"		)		; れ

; センターシフト */
	SetKana( KC_Q | KC_SPC		,"{Null}"	)		; ダミー
	SetKana( KC_W | KC_SPC		,"ne"		)		; ね
	SetKana( KC_E | KC_SPC		,"ri"		)		; り
	SetKana( KC_R | KC_SPC		,"me"		)		; め
	SetKana( KC_U | KC_SPC		,"sa"		)		; さ
	SetKana( KC_I | KC_SPC		,"yo"		)		; よ
	SetKana( KC_O | KC_SPC		,"e"		)		; え
	SetKana( KC_P | KC_SPC		,"yu"		)		; ゆ
	SetKana( KC_A | KC_SPC		,"se"		)		; せ
	SetKana( KC_S | KC_SPC		,"nu"		)		; ぬ
	SetKana( KC_D | KC_SPC		,"ni"		)		; に
	SetKana( KC_F | KC_SPC		,"ma"		)		; ま
	SetKana( KC_G | KC_SPC		,"ti"		)		; ち
	SetKana( KC_H | KC_SPC		,"ya"		)		; や
	SetKana( KC_J | KC_SPC		,"no"		)		; の
	SetKana( KC_K | KC_SPC		,"mo"		)		; も
	SetKana( KC_L | KC_SPC		,"wa"		)		; わ
	SetKana( KC_SCLN | KC_SPC	,"tu"		)		; つ
	SetKana( KC_C | KC_SPC		,"wo"		)		; を
	SetKana( KC_V | KC_SPC		,","		)		; 、
	SetKana( KC_B | KC_SPC		,"mi"		)		; み
	SetKana( KC_N | KC_SPC		,"o"		)		; お
	SetKana( KC_COMM | KC_SPC	,"mu"		)		; む
	SetKana( KC_DOT | KC_SPC	,"hu"		)		; ふ
	SetKana( KC_Z | KC_SPC		,"ho"		)		; ほ
	SetKana( KC_X | KC_SPC		,"hi"		)		; ひ
	SetKana( KC_SLSH | KC_SPC	,"re"		)		; れ
	SetKana( KC_M | KC_SPC		,".{Enter}"	)		; 。
	SetKana( KC_T | KC_SPC		,"+{←}"	, R)	; シフト + 左
	SetKana( KC_Y | KC_SPC		,"+{→}"	, R)	; シフト + 右
	SetKana( KC_RBRC | KC_SPC	,"『"		)		; 『
	SetKana( KC_NUHS | KC_SPC	,"』"		)		; 』

;***********************************************/
;***********************************************/
; 同時押し; 濁音、半濁音、小書き、拗音、外来音 */
;***********************************************/
;***********************************************/
; 同時押しの定義は逆順もしておく			   */

;*****************************/
; 濁音： 逆手の人差指中段*/
; 連続シフト中も有効 */

; 右手の濁音 */
	SetKana( KC_F | KC_U				,"za"	)	; ざ
	SetKana( KC_F | KC_U | KC_SPC		,"za"	)
	SetKana( KC_F | KC_O				,"zu"	)	; ず
	SetKana( KC_F | KC_O | KC_SPC		,"zu"	)
	SetKana( KC_F | KC_P				,"be"	)	; べ
	SetKana( KC_F | KC_P | KC_SPC		,"be"	)
	SetKana( KC_F | KC_H				,"gu"	)	; ぐ
	SetKana( KC_F | KC_H | KC_SPC		,"gu"	)
	SetKana( KC_F | KC_L				,"vu"	)	; ヴ
	SetKana( KC_F | KC_L | KC_SPC		,"vu"	)
	SetKana( KC_F | KC_SCLN				,"du"	)	; づ
	SetKana( KC_F | KC_SCLN | KC_SPC	,"du"	)
	SetKana( KC_F | KC_N				,"da"	)	; だ
	SetKana( KC_F | KC_N | KC_SPC		,"da"	)
	SetKana( KC_F | KC_DOT				,"bu"	)	; ぶ
	SetKana( KC_F | KC_DOT | KC_SPC		,"bu"	)

; 左手の濁音 */
	SetKana( KC_J | KC_W				,"gi"	)	; ぎ
	SetKana( KC_J | KC_W | KC_SPC		,"gi"	)
	SetKana( KC_J | KC_E				,"de"	)	; で
	SetKana( KC_J | KC_E | KC_SPC		,"de"	)
	SetKana( KC_J | KC_R				,"zi"	)	; じ
	SetKana( KC_J | KC_R | KC_SPC		,"zi"	)
	SetKana( KC_J | KC_A				,"ze"	)	; ぜ
	SetKana( KC_J | KC_A | KC_SPC		,"ze"	)
	SetKana( KC_J | KC_S				,"ge"	)	; げ
	SetKana( KC_J | KC_S | KC_SPC		,"ge"	)
	SetKana( KC_J | KC_D				,"do"	)	; ど
	SetKana( KC_J | KC_D | KC_SPC		,"do"	)
	SetKana( KC_J | KC_F				,"ga"	)	; が
	SetKana( KC_J | KC_F | KC_SPC		,"ga"	)
	SetKana( KC_J | KC_G				,"di"	)	; ぢ
	SetKana( KC_J | KC_G | KC_SPC		,"di"	)
	SetKana( KC_J | KC_Z				,"bo"	)	; ぼ
	SetKana( KC_J | KC_Z | KC_SPC		,"bo"	)
	SetKana( KC_J | KC_X				,"bi"	)	; び
	SetKana( KC_J | KC_X | KC_SPC		,"bi"	)
	SetKana( KC_J | KC_C				,"ba"	)	; ば
	SetKana( KC_J | KC_C | KC_SPC		,"ba"	)
	SetKana( KC_J | KC_V				,"go"	)	; ご
	SetKana( KC_J | KC_V | KC_SPC		,"go"	)
	SetKana( KC_J | KC_B				,"zo"	)	; ぞ
	SetKana( KC_J | KC_B | KC_SPC		,"zo"	)

;*****************************/
; 半濁音： 逆手の下段人差し指　*/
; 連続シフト中も有効 */

; 右の半濁音 */
	SetKana( KC_V | KC_P				,"pe"	)	; ぺ
	SetKana( KC_V | KC_P | KC_SPC		,"pe"	)
	SetKana( KC_V | KC_DOT				,"pu"	)	; ぷ
	SetKana( KC_V | KC_DOT | KC_SPC		,"pu"	)

; 左の半濁音 */
	SetKana( KC_M | KC_Z				,"po"	)	; ぽ
	SetKana( KC_M | KC_Z | KC_SPC		,"po"	)
	SetKana( KC_M | KC_X				,"pi"	)	; ぴ
	SetKana( KC_M | KC_X | KC_SPC		,"pi"	)
	SetKana( KC_M | KC_C				,"pa"	)	; ぱ
	SetKana( KC_M | KC_C | KC_SPC		,"pa"	)

;*****************************/
; 小書き： Qと同時押し　*/
	SetKana( KC_Q | KC_I				,"xyo"	)	; (ょ)
	SetKana( KC_Q | KC_I | KC_SPC		,"xyo"	)
	SetKana( KC_Q | KC_O				,"xe"	)	; (ぇ)
	SetKana( KC_Q | KC_O | KC_SPC		,"xe"	)
	SetKana( KC_Q | KC_P				,"xyu"	)	; (ゅ)
	SetKana( KC_Q | KC_P | KC_SPC		,"xyu"	)
	SetKana( KC_Q | KC_H				,"xya"	)	; (ゃ)
	SetKana( KC_Q | KC_H | KC_SPC		,"xya"	)
	SetKana( KC_Q | KC_J				,"xa"	)	; (ぁ)
	SetKana( KC_Q | KC_J | KC_SPC		,"xa"	)
	SetKana( KC_Q | KC_K				,"xi"	)	; (ぃ)
	SetKana( KC_Q | KC_K | KC_SPC		,"xi"	)
	SetKana( KC_Q | KC_L				,"xu"	)	; (ぅ)
	SetKana( KC_Q | KC_N				,"xo"	)	; (ぉ)
	SetKana( KC_Q | KC_N | KC_SPC		,"xo"	)

	SetKana( KC_Q | KC_L | KC_SPC		,"xwa"	)	; (ゎ)

;***********************************************/
; 拗音、外来音(３キー同時を含む)			   */
;***********************************************/
;*****************************/
; 清音拗音; やゆよと同時押しで、ゃゅょが付く */
	SetKana( KC_W | KC_H				,"kya"	)	; きゃ
	SetKana( KC_W | KC_H | KC_SPC		,"kya"	)
	SetKana( KC_E | KC_H				,"rya"	)	; りゃ
	SetKana( KC_E | KC_H | KC_SPC		,"rya"	)
	SetKana( KC_R | KC_H				,"sya"	)	; しゃ
	SetKana( KC_R | KC_H | KC_SPC		,"sya"	)
	SetKana( KC_D | KC_H				,"nya"	)	; にゃ
	SetKana( KC_D | KC_H | KC_SPC		,"nya"	)
	SetKana( KC_G | KC_H				,"tya"	)	; ちゃ
	SetKana( KC_G | KC_H | KC_SPC		,"tya"	)
	SetKana( KC_X | KC_H				,"hya"	)	; ひゃ
	SetKana( KC_X | KC_H | KC_SPC		,"hya"	)
	SetKana( KC_B | KC_H				,"mya"	)	; みゃ
	SetKana( KC_B | KC_H | KC_SPC		,"mya"	)

	SetKana( KC_W | KC_P				,"kyu"	)	; きゅ
	SetKana( KC_W | KC_P | KC_SPC		,"kyu"	)
	SetKana( KC_E | KC_P				,"ryu"	)	; りゅ
	SetKana( KC_E | KC_P | KC_SPC		,"ryu"	)
	SetKana( KC_R | KC_P				,"syu"	)	; しゅ
	SetKana( KC_R | KC_P | KC_SPC		,"syu"	)
	SetKana( KC_D | KC_P				,"nyu"	)	; にゅ
	SetKana( KC_D | KC_P | KC_SPC		,"nyu"	)
	SetKana( KC_G | KC_P				,"tyu"	)	; ちゅ
	SetKana( KC_G | KC_P | KC_SPC		,"tyu"	)
	SetKana( KC_X | KC_P				,"hyu"	)	; ひゅ
	SetKana( KC_X | KC_P | KC_SPC		,"hyu"	)
	SetKana( KC_B | KC_P				,"myu"	)	; みゅ
	SetKana( KC_B | KC_P | KC_SPC		,"myu"	)

	SetKana( KC_W | KC_I				,"kyo"	)	; きょ
	SetKana( KC_W | KC_I | KC_SPC		,"kyo"	)
	SetKana( KC_E | KC_I				,"ryo"	)	; りょ
	SetKana( KC_E | KC_I | KC_SPC		,"ryo"	)
	SetKana( KC_R | KC_I				,"syo"	)	; しょ
	SetKana( KC_R | KC_I | KC_SPC		,"syo"	)
	SetKana( KC_D | KC_I				,"nyo"	)	; にょ
	SetKana( KC_D | KC_I | KC_SPC		,"nyo"	)
	SetKana( KC_G | KC_I				,"tyo"	)	; ちょ
	SetKana( KC_G | KC_I | KC_SPC		,"tyo"	)
	SetKana( KC_X | KC_I				,"hyo"	)	; ひょ
	SetKana( KC_X | KC_I | KC_SPC		,"hyo"	)
	SetKana( KC_B | KC_I				,"myo"	)	; みょ
	SetKana( KC_B | KC_I | KC_SPC		,"myo"	)

;*****************************/
; 濁音拗音 */
	SetKana( KC_J | KC_W | KC_H				,"gya"		)	; ぎゃ
	SetKana( KC_J | KC_W | KC_H | KC_SPC	,"gya"		)
	SetKana( KC_J | KC_R | KC_H				,"ja"		)	; じゃ
	SetKana( KC_J | KC_R | KC_H | KC_SPC	,"ja"		)
	SetKana( KC_J | KC_G | KC_H				,"dya"		)	; ぢゃ
	SetKana( KC_J | KC_G | KC_H | KC_SPC	,"dya"		)
	SetKana( KC_J | KC_X | KC_H				,"bya"		)	; びゃ
	SetKana( KC_J | KC_X | KC_H | KC_SPC	,"bya"		)

	SetKana( KC_J | KC_W | KC_P				,"gyu"		)	; ぎゅ
	SetKana( KC_J | KC_W | KC_P | KC_SPC	,"gyu"		)
	SetKana( KC_J | KC_R | KC_P				,"ju"		)	; じゅ
	SetKana( KC_J | KC_R | KC_P | KC_SPC	,"ju"		)
	SetKana( KC_J | KC_G | KC_P				,"dyu"		)	; ぢゅ
	SetKana( KC_J | KC_G | KC_P | KC_SPC	,"dyu"		)
	SetKana( KC_J | KC_X | KC_P				,"byu"		)	; びゅ
	SetKana( KC_J | KC_X | KC_P | KC_SPC	,"byu"		)

	SetKana( KC_J | KC_W | KC_I				,"gyo"		)	; ぎょ
	SetKana( KC_J | KC_W | KC_I | KC_SPC	,"gyo"		)
	SetKana( KC_J | KC_R | KC_I				,"jo"		)	; じょ
	SetKana( KC_J | KC_R | KC_I | KC_SPC	,"jo"		)
	SetKana( KC_J | KC_G | KC_I				,"dyo"		)	; ぢょ
	SetKana( KC_J | KC_G | KC_I | KC_SPC	,"dyo"		)
	SetKana( KC_J | KC_X | KC_I				,"byo"		)	; びょ
	SetKana( KC_J | KC_X | KC_I | KC_SPC	,"byo"		)

;*****************************/
; 半濁音拗音 */
	SetKana( KC_M | KC_X | KC_I				,"pyo"		)	; ぴょ
	SetKana( KC_M | KC_X | KC_I | KC_SPC	,"pyo"		)
	SetKana( KC_M | KC_X | KC_P				,"pyu"		)	; ぴゅ
	SetKana( KC_M | KC_X | KC_P | KC_SPC	,"pyu"		)
	SetKana( KC_M | KC_X | KC_H				,"pya"		)	; ぴゃ
	SetKana( KC_M | KC_X | KC_H | KC_SPC	,"pya"		)

;**************************************/
; 外来音は3キー同時押しに統一しました */
;**************************************/
; 清音外来音は半濁音キーと使用二音の三音同時 */
; 濁音外来音は濁音キーと使用二音の三音同時 */
;*****************************/

; テ; ティテュディデュ*/
	SetKana( KC_M | KC_E | KC_P				,"thu"		)	; てゅ
	SetKana( KC_M | KC_E | KC_P | KC_SPC	,"thu"		)
	SetKana( KC_M | KC_E | KC_K				,"thi"		)	; てぃ
	SetKana( KC_M | KC_E | KC_K | KC_SPC	,"thi"		)

	SetKana( KC_J | KC_E | KC_P				,"dhu"		)	; でゅ
	SetKana( KC_J | KC_E | KC_P | KC_SPC	,"dhu"		)
	SetKana( KC_J | KC_E | KC_K				,"dhi"		)	; でぃ
	SetKana( KC_J | KC_E | KC_K | KC_SPC	,"dhi"		)

; ト; トゥドゥ*/
	SetKana( KC_M | KC_D | KC_L				,"twu"		)	; とぅ
	SetKana( KC_M | KC_D | KC_L | KC_SPC	,"twu"		)
	SetKana( KC_J | KC_D | KC_L				,"dwu"		)	; どぅ
	SetKana( KC_J | KC_D | KC_L | KC_SPC	,"dwu"		)

; シチ ェ; シェジェチェヂェ*/
	SetKana( KC_M | KC_R | KC_O				,"sye"		)	; しぇ
	SetKana( KC_M | KC_R | KC_O | KC_SPC	,"sye"		)
	SetKana( KC_M | KC_G | KC_O				,"tye"		)	; ちぇ
	SetKana( KC_M | KC_G | KC_O | KC_SPC	,"tye"		)
	SetKana( KC_J | KC_R | KC_O				,"je"		)	; じぇ
	SetKana( KC_J | KC_R | KC_O | KC_SPC	,"je"		)
	SetKana( KC_J | KC_G | KC_O				,"dye"		)	; ぢぇ
	SetKana( KC_J | KC_G | KC_O | KC_SPC	,"dye"		)

;*****************************/
; フ; ファフィフェフォフュ*/
	SetKana( KC_V | KC_DOT | KC_O			,"fe"		)	; ふぇ
	SetKana( KC_V | KC_DOT | KC_O | KC_SPC	,"fe"		)
	SetKana( KC_V | KC_DOT | KC_P			,"fyu"		)	; ふゅ
	SetKana( KC_V | KC_DOT | KC_P | KC_SPC	,"fyu"		)
	SetKana( KC_V | KC_DOT | KC_J			,"fa"		)	; ふぁ
	SetKana( KC_V | KC_DOT | KC_J | KC_SPC	,"fa"		)
	SetKana( KC_V | KC_DOT | KC_K			,"fi"		)	; ふぃ
	SetKana( KC_V | KC_DOT | KC_K | KC_SPC	,"fi"		)
	SetKana( KC_V | KC_DOT | KC_N			,"fo"		)	; ふぉ
	SetKana( KC_V | KC_DOT | KC_N | KC_SPC	,"fo"		)

; ヴ; ヴァヴィヴェヴォヴュ*/
	SetKana( KC_F | KC_L | KC_O				,"ve"		)	; ヴぇ
	SetKana( KC_F | KC_L | KC_O | KC_SPC	,"ve"		)
	SetKana( KC_F | KC_L | KC_P				,"vuxyu"	)	; ヴゅ
	SetKana( KC_F | KC_L | KC_P | KC_SPC	,"vuxyu"	)
	SetKana( KC_F | KC_L | KC_J				,"va"		)	; ヴぁ
	SetKana( KC_F | KC_L | KC_J | KC_SPC	,"va"		)
	SetKana( KC_F | KC_L | KC_K				,"vi"		)	; ヴぃ
	SetKana( KC_F | KC_L | KC_K | KC_SPC	,"vi"		)
	SetKana( KC_F | KC_L | KC_N				,"vo"		)	; ヴぉ
	SetKana( KC_F | KC_L | KC_N | KC_SPC	,"vo"		)

; う; ウィウェウォ　い；イェ */
	SetKana( KC_V | KC_L | KC_O				,"we"		)	; うぇ
	SetKana( KC_V | KC_L | KC_O | KC_SPC	,"we"		)
	SetKana( KC_V | KC_L | KC_K				,"wi"		)	; うぃ
	SetKana( KC_V | KC_L | KC_K | KC_SPC	,"wi"		)
	SetKana( KC_V | KC_L | KC_N				,"uxo"		)	; うぉ
	SetKana( KC_V | KC_L | KC_N | KC_SPC	,"uxo"		)

	SetKana( KC_V | KC_K | KC_O				,"ye"		)	; いぇ
	SetKana( KC_V | KC_K | KC_O | KC_SPC	,"ye"		)

; ク; クァクィクェクォ*/
	SetKana( KC_V | KC_H | KC_O				,"kuxe"		)	; くぇ
	SetKana( KC_V | KC_H | KC_O | KC_SPC	,"kuxe"		)
	SetKana( KC_V | KC_H | KC_J				,"kuxa"		)	; くぁ
	SetKana( KC_V | KC_H | KC_J | KC_SPC	,"kuxa"		)
	SetKana( KC_V | KC_H | KC_K				,"kuxi"		)	; くぃ
	SetKana( KC_V | KC_H | KC_K | KC_SPC	,"kuxi"		)
	SetKana( KC_V | KC_H | KC_L				,"kuxwa"	)	; くゎ
	SetKana( KC_V | KC_H | KC_L | KC_SPC	,"kuxwa"	)
	SetKana( KC_V | KC_H | KC_N				,"kuxo"		)	; くぉ
	SetKana( KC_V | KC_H | KC_N | KC_SPC	,"kuxo"		)

; グ; グァグィグェグォ*/
	SetKana( KC_F | KC_H | KC_O				,"guxe"		)	; ぐぇ
	SetKana( KC_F | KC_H | KC_O | KC_SPC	,"guxe"		)
	SetKana( KC_F | KC_H | KC_J				,"gwa"		)	; ぐぁ
	SetKana( KC_F | KC_H | KC_J | KC_SPC	,"gwa"		)
	SetKana( KC_F | KC_H | KC_K				,"guxi"		)	; ぐぃ
	SetKana( KC_F | KC_H | KC_K | KC_SPC	,"guxi"		)
	SetKana( KC_F | KC_H | KC_L				,"guxwa"	)	; ぐゎ
	SetKana( KC_F | KC_H | KC_L | KC_SPC	,"guxwa"	)
	SetKana( KC_F | KC_H | KC_N				,"guxo"		)	; ぐぉ
	SetKana( KC_F | KC_H | KC_N | KC_SPC	,"guxo"		)

; ツ; ツァツィツェツォ */
	SetKana( KC_V | KC_SCLN | KC_O			,"tse"		)	; つぇ
	SetKana( KC_V | KC_SCLN | KC_O | KC_SPC	,"tse"		)
	SetKana( KC_V | KC_SCLN | KC_J			,"tsa"		)	; つぁ
	SetKana( KC_V | KC_SCLN | KC_J | KC_SPC	,"tsa"		)
	SetKana( KC_V | KC_SCLN | KC_K			,"tsi"		)	; つぃ
	SetKana( KC_V | KC_SCLN | KC_K | KC_SPC	,"tsi"		)
	SetKana( KC_V | KC_SCLN | KC_N			,"tso"		)	; つぉ
	SetKana( KC_V | KC_SCLN | KC_N | KC_SPC	,"tso"		)

; IME ON/OFF */
; 事前に、MS-IMEのプロパティで、
; ひらがなカタカナキー：IME ON、無変換キー：IME OFFに設定のこと */
; HJ: ON / FG: OFF*/

	SetKana( KC_H | KC_J			,"{vkF2 2}"		)	; IME ON
	SetEisu( KC_H | KC_J			,"{vkF2 2}"		)
	SetKana( KC_F | KC_G			,"{vkF2}{vkF3}"	)	; IME OFF
	SetEisu( KC_F | KC_G			,"{vkF2}{vkF3}"	)

; Enter */
; VとMの同時押し */
	SetKana( KC_V | KC_M			,"{Enter}"		)	; 行送り
	SetKana( KC_V | KC_M | KC_SPC	,"{Enter}"		)
	SetEisu( KC_V | KC_M			,"{Enter}"		)	; 行送り
	SetEisu( KC_V | KC_M | KC_SPC	,"{Enter}"		)

;************************************/
;************************************/
; 編集モード、固有名詞ショートカット*/
;************************************/
;************************************/

; 編集モード１ */
; 中段人差し指＋中指を押しながら */
; 「て」の部分は定義できない。「ディ」があるため */

; 左手*/
Group := "1L"
	SetKana( KC_J | KC_K | KC_Q		,"^{End}"			)		; ◀最末尾
	SetKana( KC_J | KC_K | KC_W		,"｜"				)		; ｜
;	SetKana( KC_J | KC_K | KC_E		,"dhi"				)		; でぃ
	SetKana( KC_J | KC_K | KC_R		,"^s"				)		; 保存
	SetKana( KC_J | KC_K | KC_T		,"/"				)		; ・
	SetKana( KC_J | KC_K | KC_A		,"……"				)		; ……
	SetKana( KC_J | KC_K | KC_S		,"《"				)		; 《
	SetKana( KC_J | KC_K | KC_D		,"？"				)		; ？
	SetKana( KC_J | KC_K | KC_F		,"「"				)		; 「
	SetKana( KC_J | KC_K | KC_G		,"（"				)		; （
	SetKana( KC_J | KC_K | KC_Z		,"││"				)		; ──
	SetKana( KC_J | KC_K | KC_X		,"》"				)		; 》
	SetKana( KC_J | KC_K | KC_C		,"！"				)		; ！
	SetKana( KC_J | KC_K | KC_V		,"」"				)		; 」
	SetKana( KC_J | KC_K | KC_B		,"）"				)		; ）

	SetEisu( KC_J | KC_K | KC_Q		,"^{End}"			)		; ◀最末尾
	SetEisu( KC_J | KC_K | KC_W		,"｜"				)		; ｜
;	SetEisu( KC_J | KC_K | KC_E		,"dhi"				)		; でぃ
	SetEisu( KC_J | KC_K | KC_R		,"^s"				)		; 保存
	SetEisu( KC_J | KC_K | KC_T		,"・"				)		; ・
	SetEisu( KC_J | KC_K | KC_A		,"……"				)		; ……
	SetEisu( KC_J | KC_K | KC_S		,"《"				)		; 《
	SetEisu( KC_J | KC_K | KC_D		,"？"				)		; ？
	SetEisu( KC_J | KC_K | KC_F		,"「"				)		; 「
	SetEisu( KC_J | KC_K | KC_G		,"（"				)		; （
	SetEisu( KC_J | KC_K | KC_Z		,"││"				)		; ──
	SetEisu( KC_J | KC_K | KC_X		,"》"				)		; 》
	SetEisu( KC_J | KC_K | KC_C		,"！"				)		; ！
	SetEisu( KC_J | KC_K | KC_V		,"」"				)		; 」
	SetEisu( KC_J | KC_K | KC_B		,"）"				)		; ）

; 右手*/
Group := "1R"
	SetKana( KC_D | KC_F | KC_Y		,"{Home}"			)		; ▲Home
	SetKana( KC_D | KC_F | KC_U		,"+{End}{BS}"		)		; 末消
	SetKana( KC_D | KC_F | KC_I		,"{vk1C}"			)		; 再変換
	SetKana( KC_D | KC_F | KC_O		,"{Del}"			)		; Del
	SetKana( KC_D | KC_F | KC_P		,"{Esc 3}"			)		; 入力キャンセル
	SetKana( KC_D | KC_F | KC_H		,"{Enter}{End}"		)		; 確定End▼
	SetKana( KC_D | KC_F | KC_J		,"{↑}"				, R)	; ↑
	SetKana( KC_D | KC_F | KC_K		,"+{↑}"			, R)	; 選択↑
	SetKana( KC_D | KC_F | KC_L		,"{↑ 5}"			, R)	; 5↑
	SetKana( KC_D | KC_F | KC_SCLN	,"^i"				)		; カタカナ
	SetKana( KC_D | KC_F | KC_N		,"{End}"			)		; End▼
	SetKana( KC_D | KC_F | KC_M		,"{↓}"				, R)	; ↓
	SetKana( KC_D | KC_F | KC_COMM	,"+{↓}"			, R)	; 選択↓
	SetKana( KC_D | KC_F | KC_DOT	,"{↓ 5}"			, R)	; 5↓
	SetKana( KC_D | KC_F | KC_SLSH	,"^u"				)		; ひらがな

	SetEisu( KC_D | KC_F | KC_Y		,"{Home}"			)		; ▲Home
	SetEisu( KC_D | KC_F | KC_U		,"+{End}{BS}"		)		; 末消
	SetEisu( KC_D | KC_F | KC_I		,"{vk1C}"			)		; 再変換
	SetEisu( KC_D | KC_F | KC_O		,"{Del}"			)		; Del
	SetEisu( KC_D | KC_F | KC_P		,"{Esc 3}"			)		; 入力キャンセル
	SetEisu( KC_D | KC_F | KC_H		,"{Enter}{End}"		)		; 確定End▼
	SetEisu( KC_D | KC_F | KC_J		,"{↑}"				, R)	; ↑
	SetEisu( KC_D | KC_F | KC_K		,"+{↑}"			, R)	; 選択↑
	SetEisu( KC_D | KC_F | KC_L		,"{↑ 5}"			, R)	; 5↑
;	SetEisu( KC_D | KC_F | KC_SCLN	,"^i"				)		; カタカナ
	SetEisu( KC_D | KC_F | KC_N		,"{End}"			)		; End▼
	SetEisu( KC_D | KC_F | KC_M		,"{↓}"				, R)	; ↓
	SetEisu( KC_D | KC_F | KC_COMM	,"+{↓}"			, R)	; 選択↓
	SetEisu( KC_D | KC_F | KC_DOT	,"{↓ 5}"			, R)	; 5↓
;	SetEisu( KC_D | KC_F | KC_SLSH	,"^u"				)		; ひらがな

; 編集モード２ */
; 下段人差指＋中指 */

; 左手*/
Group := "2L"
	SetKana( KC_M | KC_COMM | KC_Q	,"／"								)		; ／
	SetKana( KC_M | KC_COMM | KC_W	,"｜{End}《》{↑}"					)		; ルビマクロ
	SetKana( KC_M | KC_COMM | KC_E	,"{Home}{改行}　　　{End}"			)		; トマクロ
	SetKana( KC_M | KC_COMM | KC_R	,"{Home}{改行}　{End}"				)		; 台マクロ
	SetKana( KC_M | KC_COMM | KC_T	,"〇"								)		; ○
	SetKana( KC_M | KC_COMM | KC_A	,"【"								)		; 【
	SetKana( KC_M | KC_COMM | KC_S	,"〈"								)		; 〈
	SetKana( KC_M | KC_COMM | KC_D	,"『"								)		; 『
	SetKana( KC_M | KC_COMM | KC_F	,"」{改行}「"						)		; 」「マクロ
	SetKana( KC_M | KC_COMM | KC_G	,"　　　"							)		; □□□
	SetKana( KC_M | KC_COMM | KC_Z	,"】"								)		; 】
	SetKana( KC_M | KC_COMM | KC_X	,"〉"								)		; 〉
	SetKana( KC_M | KC_COMM | KC_C	,"』"								)		; 』
	SetKana( KC_M | KC_COMM | KC_V	,"」{改行}　"						)		; 」□マクロ
	SetKana( KC_M | KC_COMM | KC_B	,"　　　×　　　×　　　×{改行}"	)		; x   x   x

	SetEisu( KC_M | KC_COMM | KC_Q	,"／"								)		; ／
	SetEisu( KC_M | KC_COMM | KC_W	,"｜{End}《》{↑}"					)		; ルビマクロ
	SetEisu( KC_M | KC_COMM | KC_E	,"{Home}{改行}　　　{End}"			)		; トマクロ
	SetEisu( KC_M | KC_COMM | KC_R	,"{Home}{改行}　{End}"				)		; 台マクロ
	SetEisu( KC_M | KC_COMM | KC_T	,"〇"								)		; ○
	SetEisu( KC_M | KC_COMM | KC_A	,"【"								)		; 【
	SetEisu( KC_M | KC_COMM | KC_S	,"〈"								)		; 〈
	SetEisu( KC_M | KC_COMM | KC_D	,"『"								)		; 『
	SetEisu( KC_M | KC_COMM | KC_F	,"」{改行}「"						)		; 」「マクロ
	SetEisu( KC_M | KC_COMM | KC_G	,"　　　"							)		; □□□
	SetEisu( KC_M | KC_COMM | KC_Z	,"】"								)		; 】
	SetEisu( KC_M | KC_COMM | KC_X	,"〉"								)		; 〉
	SetEisu( KC_M | KC_COMM | KC_C	,"』"								)		; 』
	SetEisu( KC_M | KC_COMM | KC_V	,"」{改行}　"						)		; 」□マクロ
	SetEisu( KC_M | KC_COMM | KC_B	,"　　　×　　　×　　　×{改行}"	)		; x  x	 x

; 右手*/
Group := "2R"
	SetKana( KC_C | KC_V | KC_Y		,"+{Home}"							)		; ▲Home選択
	SetKana( KC_C | KC_V | KC_U		,"^x"								)		; カット
	SetKana( KC_C | KC_V | KC_I		,"^v"								)		; ペースト
	SetKana( KC_C | KC_V | KC_O		,"^y"								)		; リドゥ
	SetKana( KC_C | KC_V | KC_P		,"^z"								)		; アンドゥ
	SetKana( KC_C | KC_V | KC_H		,"^c"								)		; コピー
	SetKana( KC_C | KC_V | KC_J		,"{→ 5}"							, R)	; →5
	SetKana( KC_C | KC_V | KC_K		,"+{→ 5}"							, R)	; →5選択
	SetKana( KC_C | KC_V | KC_L		,"^{PgUp}"							, R)	; 前ページ▶先頭
	SetKana( KC_C | KC_V | KC_SCLN	,"^{PgUp 5}"						, R)	; 前 5ページ▶先頭
	SetKana( KC_C | KC_V | KC_N		,"+{End}"							)		; 選択End▼
	SetKana( KC_C | KC_V | KC_M		,"{← 5}"							, R)	; ←5
	SetKana( KC_C | KC_V | KC_COMM	,"+{← 5}"							, R)	; ←5選択
	SetKana( KC_C | KC_V | KC_DOT	,"^{PgDn}"							, R)	; 次◀ページ先頭
	SetKana( KC_C | KC_V | KC_SLSH	,"^{PgDn 5}"						, R)	; 次 5◀ページ先頭

	SetEisu( KC_C | KC_V | KC_Y		,"+{Home}"							)		; ▲Home選択
	SetEisu( KC_C | KC_V | KC_U		,"^x"								)		; カット
	SetEisu( KC_C | KC_V | KC_I		,"^v"								)		; ペースト
	SetEisu( KC_C | KC_V | KC_O		,"^y"								)		; リドゥ
	SetEisu( KC_C | KC_V | KC_P		,"^z"								)		; アンドゥ
	SetEisu( KC_C | KC_V | KC_H		,"^c"								)		; コピー
	SetEisu( KC_C | KC_V | KC_J		,"{→ 5}"							, R)	; →5
	SetEisu( KC_C | KC_V | KC_K		,"+{→ 5}"							, R)	; →5選択
	SetEisu( KC_C | KC_V | KC_L		,"^{PgUp}"							, R)	; 前ページ▶先頭
	SetEisu( KC_C | KC_V | KC_SCLN	,"^{PgUp 5}"						, R)	; 前 5ページ▶先頭
	SetEisu( KC_C | KC_V | KC_N		,"+{End}"							)		; 選択End▼
	SetEisu( KC_C | KC_V | KC_M		,"{← 5}"							, R)	; ←5
	SetEisu( KC_C | KC_V | KC_COMM	,"+{← 5}"							, R)	; ←5選択
	SetEisu( KC_C | KC_V | KC_DOT	,"^{PgDn}"							, R)	; 次◀ページ先頭
	SetEisu( KC_C | KC_V | KC_SLSH	,"^{PgDn 5}"						, R)	; 次 5◀ページ先頭


Group := 0	; 0 はグループAll

; ----------------------------------------------------------------------
; 固有名詞ショートカット(U+I)を押し続けて
; 前文字削除(U)のリピートが起きる場合があるので対策
; ----------------------------------------------------------------------
	SetKana( KC_U | KC_I					,"{Null}"	)	; ダミー


; ----------------------------------------------------------------------
; 設定がUSキーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
; ----------------------------------------------------------------------
if (KeyDriver = "kbd101.dll")
{
	SetKana( KC_INT1			,"?"	)	; ？
	SetKana( KC_NUHS | KC_SPC	,"|"	)	; ｜
	SetKana( KC_LBRC | KC_SPC	,"『"	)	; 『
	SetKana( KC_RBRC | KC_SPC	,"』"	)	; 』
	SetKana( KC_INT1 | KC_SPC	,"{!}"	)	; ！

; おまけ
	SetEisu( JP_YEN				,"\"	)	; ￥
	SetEisu( KC_INT1			,"\"	)	; ￥
	SetEisu( JP_YEN | KC_SPC	,"|"	)	; ｜	スペース押しながら
	SetEisu( KC_INT1 | KC_SPC	,"_"	)	; ＿	スペース押しながら

	SetKana( JP_YEN				,"\"	)	; ￥
	SetKana( JP_YEN | KC_SPC	,"|"	)	; ｜	スペース押しながら
}
