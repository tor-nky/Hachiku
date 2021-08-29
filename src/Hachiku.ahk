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
Version := "v1.1.10-beta"
; --------〈起動処理〉--------------------------------------------------
SetWorkingDir %A_ScriptDir%		; スクリプトの作業ディレクトリを変更
#SingleInstance force			; 既存のプロセスを終了して実行開始
#Include Sub/IME.ahk	; Author: eamat. http://www6.atwiki.jp/eamat/
#Include Sub/Path.ahk	; Author: eamat. http://www6.atwiki.jp/eamat/
#Include Sub/init.ahk				; 初期設定
#Include KanaTable/Standard.ahk		; キーボード初期配列の読み込み
#Include KanaTable/Naginata_v13.ahk	; かな定義の読み込み

	if (USLike > 0)
		Gosub, toUSLike		; USキーボード風の配列へ
	GoSub, KoyuReadAll		; 固有名詞ショートカットの読み込み
	Setting()	; 出力確定する定義に印をつける
; --------〈変換〉------------------------------------------------------
#Include Sub/Conv.ahk
#Include KanaTable/USKBLike.ahk			; USキーボード風配列
#Include Sub/Koyu.ahk					; 固有名詞ショートカット関連
; ----------------------------------------------------------------------

; 追加のホットキー
+^sc0B::Suspend On	; 薙刀式中断 Shift+Ctrl+0
+^sc02::Suspend Off	; 薙刀式再開 Shift+Ctrl+1
