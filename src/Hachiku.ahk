; Copyright (C) 2021-2024  Satoru NAKAYA

; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>.


; **********************************************************************
; 薙刀式配列
;		ローマ字入力モード
; **********************************************************************
#Requires AutoHotkey v2.0.13 64-bit
version := "2.0-pre.2"	; String型

; --------〈起動処理〉--------------------------------------------------
#SingleInstance Force			; 既存のプロセスを終了して実行開始
#Include "%A_ScriptDir%/Sub/init.ahk"	; 初期設定
; --------〈AutoHotkey LIB〉-------------------------------------------
#Include "%A_ScriptDir%/Sub/IMEv2.ahk"	; Author: eamat. http://www6.atwiki.jp/eamat/
                                        ; https://github.com/k-ayaki/IMEv2.ahk
#Include "%A_ScriptDir%/Sub/Path.ahk"	; Author: eamat. http://www6.atwiki.jp/eamat/
; --------〈サブルーチン、関数〉--------------------------------------------------
#Include "%A_ScriptDir%/Sub/function.ahk"
; ----------------------------------------------------------------------


; **********************************************************************
; 英数／かな配列の定義ファイル (サポートファイル読み込み含む)
; **********************************************************************
#Include "%A_ScriptDir%/KanaTable/Naginata_v15.ahk"	; 薙刀式配列v15fix版


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
;		|Shift+Ctrl+変換  |Enter と同じ                                                                          |
;		|変換             |[文字未入力]-----                                                                     |
;		|Shift+Ctrl+無変換|[入力中][変換中][次候補表示中][文節区切り直し中]全文字削除[全候補表示中]全候補選択取消|
;		|ひらがな         |[記号入力以外]入力文字種全角ひらがな(あ)                                              |
;		|カタカナ         |[記号入力以外]入力文字種全角カタカナ(ア)                                              |
;		|半角／全角       |[文字未入力][記号入力]日本語入力ON/OFF [他]入力文字種半角無変換(A)                    |
;	☆ATOK プロパティ → 入力･変換 → 設定項目(Y) → 入力補助 → 特殊 → 設定一覧(L)
;		なし - 日本語入力オンで変更したモードを元に戻す
; **********************************************************************
;	※Google 日本語入力 のキー設定
;		|モード      |  入力キー         |    コマンド      |
;		|------------|:-----------------:|:----------------:|
;		|変換前入力中|Ctrl Shift Henkan  |       確定       |
;		|変換中      |      〃           |        〃        |
;		|変換前入力中|Ctrl Shift Muhenkan|    キャンセル    |
;		|変換中      |      〃           |        〃        |
;		|変換前入力中|Shift Muhenkan     |全角英数に入力切替|
;		|変換中      |      〃           |        〃        |
;		|入力文字なし|      〃           |        〃        |
; **********************************************************************
