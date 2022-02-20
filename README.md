# Hachiku - Windows で薙刀式を使うスクリプト

薙刀式配列v14（集大成版） 2021年12月10日付

[【薙刀式】v14集大成版](http://oookaworks.seesaa.net/article/484704326.html#gsc.tab=0)

Autohotkey に実装しました。

パソコンの日本語キーボード、英語キーボードの設定に自動で合わせます。
トレイアイコンを右クリックしたところに、縦書き・横書きモード切り替え、設定メニューがあります。
レジストリの変更はしません。
不要になったら Hachiku.exe と Hachiku.ini を削除してください。

## 実行ファイル

https://github.com/tor-nky/Hachiku/releases

## ソースコードを修正した場合

ディレクトリ source の下にあるファイルをすべて保存します。

Autohotkey をインストールし、ディレクトリ source にある Hachiku.ahk のスクリプトを実行してください。

Ahk2Exe.exe でコンパイルする場合は、Unicode版で出力してください。

# IME の設定

### 旧MS-IME

初期状態の設定のままでもそこそこ使えますが、次の設定を行うことをおすすめします。

IME 入力モード切替の通知  → オフ: 画面中央に表示する

キー設定： 半角+全角	→	[入力/変換文字なし]IMEオフ, [他]半英固定

### 新MS-IME

初期状態の設定で使います。

### ATOK

Hachiku.ahk にあるコメントをご覧ください。
また、トレイアイコンを右クリックして設定を選び、ATOK対応をチェックしてください。

# 独自機能

* 方向キーだけリピートが働きます。
* 編集モードD+F+H、J+K+G、J+K+V、J+K+Bは変換中の文字があれば確定し、なければそのまま所定の動作をします。
* 編集モードM+Comma+W、M+Comma+S、M+Comma+F、M+Cooma+B の動作後、クリップボードは空です。
* 固有名詞ショートカットにはシフト面（スペース押下）もあります。

スペースキーを押したまま、そこから3つのキーを一定時間内に押すと入力されます。

* 固有名詞ショートカットを最大５組を切り替えられる。切り替えは M+Comma+1 で１番、M+Comma+2 で２番、など。

「固有名詞登録」画面が出ているときに切り替えると、登録内容がコピーされます。
(OK を押すと登録されます)

* スペースキーのリピートを設定できる

リピートで漢字変換が始まっても、文字キーを押せば変換を取り消して文字が入力されます。

* 左右の小指シフトの機能を「英数」・「かな」から選べる
* 「後置シフト」を設定可能
* CapsLock がオンでも配列変換する

オリジナルの DvorakJ版では、CapsLock をオンにすると薙刀式になりません。

# 最新のソースコードでの不具合

* 薙刀式に変換されないで出力されることがある

旧MS-IMEをお使いで、気になるようでしたら「Microsoft IME の詳細設定」で「予測入力を使用する」をオフにしてください。

* IMEの設定変更をしなければ、編集モードや固有名詞の入力でIME 入力モード切替の通知が出る。

一部の記号を出力するために一旦、IMEをオフにしているためです。
MS-IMEをお使いでしたら、上の IME の設定を行うと消すことができます。

* カーソルキー以外のキーリピートは、キーを上げることなく連打するようになっていない
* スタートメニューの検索、エクスプローラの検索では「選択範囲にカッコをつける」が正常に動作しない。
* スタートメニューの検索、エクスプローラの検索で入力した文字を確定しても色が変わらない。
* 記号入力、固有名詞ショートカットで不要な＝（イコール）が入力されることがある。

IME に未確定の文字がないか調べられないときには、＝（イコール）→エンター→前文字削除 を送っています。
それでまれに＝（イコール）が削除されずに残ってしまうことがあります。

* (新MS-IME) かな変換中に英数入力に切り替え、確定しないでキーを押すと最初の文字が入力されない。

新MS-IME の仕様です。

# 動作確認

* Windows 10 Home version 21H2 64-bit + AutoHotkey (v1.1.33.10) + 新旧MS-IME あるいは ATOK 2017

Windows 7 の頃の古いIMEでは記号、固有名詞ショートカットが正しく入力できないことがあります。

# 参考

[【薙刀式】v14集大成版](http://oookaworks.seesaa.net/article/484704326.html#gsc.tab=0)
* [【薙刀式】v14仮のバグフィックス](http://oookaworks.seesaa.net/article/483884499.html#gsc.tab=0)

## 詳細メニューを出現させるには

設定ファイル Hachiku.ini をエディタで下記のように編集します。そして、Hachiku を再起動してください。

[general]

AdvancedMenu=1

## src¥KanaTable¥*.ahk で使えるキーや記号の書き方

ASCIIコード文字だけで定義するときは、Autohotkey の書き方に準じます。

http://ahkwiki.net/Send の特殊キー名一覧もご覧ください。

そのまま入力	0〜9 A〜Z -^@[]./ 全角文字

{確定} {UndoIME} {IMEOFF} {IMEON} {全英} {半ｶﾅ}
{Enter} {Esc} {Space} {Tab} {BS} {Del} {Ins}
{Up} {Down} {Left} {Right}
{Home} {End} {PgUp} {PgDn}
など

ASCIIコード以外の文字があると、そこからは IME をオフにして残りを出力します。

{直接} の後は IME をオフにしてさらに無変換で出力します。これを固有名詞ショートカットの実装に使っています。

## 動作速度

* 最初の読み込み

２～３秒程度

* 英数、かなの普通の文字

通常 10 ms 以内、エクスプローラー 78 ms 以内。
(ローマ字の文字数によって変わる)

* 記号、固有名詞ショートカット

最大 0.7秒。
