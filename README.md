# Hachiku - Windows で薙刀式v13完成版 を使うスクリプト

[薙刀式v13完成版](http://oookaworks.seesaa.net/article/479173898.html#gsc.tab=0) 2020年12月25日版を Autohotkey に実装しました。

### Hachiku.ahk

ディレクトリ source の下にあるファイルをすべて保存します。

Autohotkey をインストールし、ディレクトリ source にある Hachiku.ahk のスクリプトを実行してください。

Ahk2Exe.exe でコンパイルする場合は、Unicode版で出力してください。

Shift+[ 、Shift+] で入力される『』は、確定文字になります。

# IME の設定

### 旧MS-IME

初期状態の設定のままでも使えますが、キー設定を行うことをおすすめします。

半角+全角	→	[入力/変換文字なし]IMEオフ, [他]半英固定

### 新MS-IME

初期状態の設定で使います。

### ATOK

Naginata.ahk にあるコメントをご覧ください。
また、デスクトップアイコンを右クリックして設定を選び、ATOK対応をチェックしてください。

## 動作確認

* Windows 10 Home version 20H2 + AutoHotkey (v1.1.33.09) + 新旧MS-IME あるいは ATOK 2017

# 不具合

* キーの押したときに、変換せずにそのまま通ってしまうことがまれにある。

* スタートメニューの検索、エクスプローラの検索で記号入力しても、その前に入力した文字の色が変わらない。

* (新MS-IME) かな変換中に英数入力に切り替え、確定しないでキーを押すと最初の文字が入力されない。

新MS-IME の仕様です。

* (ATOK) 記号入力、固有名詞ショートカットに時間がかかる。

ATOK の仕様です。

# 参考

* [【薙刀式】v13完成版、発表。](http://oookaworks.seesaa.net/article/479173898.html#gsc.tab=0)

## KanaTable.ahk で使えるキーや記号の書き方

Autohotkey の書き方に準じます。

http://ahkwiki.net/Send の特殊キー名一覧もご覧ください。

そのまま入力	0〜9 A〜Z -^@[]./ 全角文字

{Enter} {Esc} {Space} {Tab} {BS} {Del} {Ins}
{Up} {Down} {Left} {Right}
{Home} {End} {PgUp} {PgDn}
など

## 動作速度

* 最初の読み込み

２秒程度

* 英数、かなの普通の文字

通常 8 ms 以内、エクスプローラー 78 ms 以内。
(ローマ字の文字数によって変わる)

* 記号、固有名詞ショートカット

最大 0.6秒。

## おもな修正履歴

2021年6月19日までの分は https://github.com/tor-nky/KeyLayout/tree/master/Naginata/Win をご覧ください。

* Enterキーをシフトを兼ねられるようにした。
* トレイアイコンを右クリックして設定画面が出せるようにした。

(ここまで2021年7月10日追加)
