; **********************************************************************
; 薙刀式配列
;		ローマ字入力モード
;	※MS-IME は初期設定のままでも使えます
;	※ATOK を使う場合のキー設定
;		変換		→ [文字未入力]再変換
;		ひらがな	→ 入力文字種全角ひらがな(あ)
;		カタカナ	→ 入力文字種全角カタカナ(ア)
;		半角／全角	→ [文字未入力]日本語入力ON/OFF [他]入力文字種半角無変換(A)
;	※Google 日本語入力 を使う場合のキー設定
;		モード			入力キー		コマンド
;		--------------------------------------------------
;		変換前入力中	Shift Muhenkan	全角英数に入力切替
;		変換中				〃					〃
;		入力文字なし		〃					〃
; **********************************************************************
version := "1.9-beta.11m"

; --------〈起動処理〉--------------------------------------------------
SetWorkingDir %A_ScriptDir%		; スクリプトの作業ディレクトリを変更
#SingleInstance force			; 既存のプロセスを終了して実行開始
#Include %A_ScriptDir%/Sub/init.ahk	; 初期設定
; --------〈AutoHotkey LIB〉-------------------------------------------
#Include %A_ScriptDir%/Sub/IME.ahk	; Author: eamat. http://www6.atwiki.jp/eamat/
#Include %A_ScriptDir%/Sub/Path.ahk	; Author: eamat. http://www6.atwiki.jp/eamat/
; --------〈サブルーチン、関数〉--------------------------------------------------
#Include %A_ScriptDir%/Sub/function.ahk
; ----------------------------------------------------------------------


; **********************************************************************
; 英数／かな配列の定義ファイル (サポートファイル読み込み含む)
; **********************************************************************
;#Include %A_ScriptDir%/KanaTable/Naginata_v14.ahk	; 薙刀式配列v14（集大成版）
;#Include %A_ScriptDir%/KanaTable/PreviewRelease/Naginata_20220703.ahk	; 薙刀式15（仮）安定版
#Include %A_ScriptDir%/KanaTable/PreviewRelease/Naginata_20220612.ahk	; 薙刀式v15(仮)B1

;#Include %A_ScriptDir%/KanaTable/Naginata_tor.ahk
