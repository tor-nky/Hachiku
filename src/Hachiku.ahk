; **********************************************************************
; 薙刀式配列
;		ローマ字入力モード
; **********************************************************************
version := "1.9.1"	; String型

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
;#Include %A_ScriptDir%/KanaTable/PreviewRelease/Naginata_20221120#1.ahk	; 薙刀式v15（仮安定版）
#Include %A_ScriptDir%/KanaTable/PreviewRelease/Naginata_20221120#2.ahk	; 薙刀式v15新候補版

;#Include %A_ScriptDir%/KanaTable/Naginata_tor.ahk
