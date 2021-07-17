/*****************************************************************************
  IME制御用 関数群 (IME.ahk)

	グローバル変数 : なし
	各関数の依存性 : なし(必要関数だけ切出してコピペでも使えます)

	AutoHotkey: 	L 1.1.08.01
	Language:		Japanease
	Platform:		NT系
	Author: 		eamat.		http://www6.atwiki.jp/eamat/
*****************************************************************************
履歴
	2008.07.11 v1.0.47以降の 関数ライブラリスクリプト対応用にファイル名を変更
	2008.12.10 コメント修正
	2009.07.03 IME_GetConverting() 追加
			   Last Found Windowが有効にならない問題修正、他。
	2009.12.03
	  ・IME 状態チェック GUIThreadInfo 利用版 入れ込み
	   （IEや秀丸8βでもIME状態が取れるように）
		http://blechmusik.xrea.jp/resources/keyboard_layout/DvorakJ/inc/IME.ahk
	  ・Google日本語入力β 向け調整
		入力モード 及び 変換モードは取れないっぽい
		IME_GET/SET() と IME_GetConverting()は有効

	2012.11.10 x64 & Unicode対応
	  実行環境を AHK_L U64に (本家およびA32,U32版との互換性は維持したつもり)
	  ・LongPtr対策：ポインタサイズをA_PtrSizeで見るようにした

				;==================================
				;  GUIThreadInfo
				;=================================
				; 構造体 GUITreadInfo
				;typedef struct tagGUITHREADINFO {(x86) (x64)
				;	DWORD	cbSize; 				0	 0
				;	DWORD	flags;					4	 4	 ※
				;	HWND	hwndActive; 			8	 8
				;	HWND	hwndFocus;			   12	 16  ※
				;	HWND	hwndCapture;		   16	 24
				;	HWND	hwndMenuOwner;		   20	 32
				;	HWND	hwndMoveSize;		   24	 40
				;	HWND	hwndCaret;			   28	 48
				;	RECT	rcCaret;			   32	 56
				;} GUITHREADINFO, *PGUITHREADINFO;

	  ・WinTitleパラメータが実質無意味化していたのを修正
		対象がアクティブウィンドウの時のみ GetGUIThreadInfoを使い
		そうでないときはControlハンドルを使用
		一応バックグラウンドのIME情報も取れるように戻した
		(取得ハンドルをWindowからControlに変えたことでブラウザ以外の大半の
		アプリではバックグラウンドでも正しく値が取れるようになった。
		※ブラウザ系でもアクティブ窓のみでの使用なら問題ないと思う、たぶん)

*/

;---------------------------------------------------------------------------
;  汎用関数 (多分どのIMEでもいけるはず)

;-----------------------------------------------------------
; IMEの状態の取得
;	WinTitle="A"	対象Window
;	戻り値			1:ON / 0:OFF / "":失敗
;-----------------------------------------------------------
IME_GET(WinTitle="A")  {
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
		VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
		NumPut(cbSize, stGTI,  0, "UInt")	;	DWORD	cbSize;
		hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
				 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
	}

	return DllCall("SendMessage"
		  , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
		  , UInt, 0x0283  ;Message : WM_IME_CONTROL
		  ,  Int, 0x0005  ;wParam  : IMC_GETOPENSTATUS
		  ,  Int, 0)	  ;lParam  : 0
}

;===========================================================================
; IME 入力モード (どの IMEでも共通っぽい)
;	DEC  HEX	BIN
;	  0 (0x00  0000 0000) かな	  半英数
;	  3 (0x03  0000 0011)		  半ｶﾅ
;	  8 (0x08  0000 1000)		  全英数
;	  9 (0x09  0000 1001)		  ひらがな
;	 11 (0x0B  0000 1011)		  全カタカナ
;	 16 (0x10  0001 0000) ローマ字半英数
;	 19 (0x13  0001 0011)		  半ｶﾅ
;	 24 (0x18  0001 1000)		  全英数
;	 25 (0x19  0001 1001)		  ひらがな
;	 27 (0x1B  0001 1011)		  全カタカナ

;  ※ 地域と言語のオプション - [詳細] - 詳細設定
;	  - 詳細なテキストサービスのサポートをプログラムのすべてに拡張する
;	 が ONになってると値が取れない模様
;	 (Google日本語入力βはここをONにしないと駄目なので値が取れないっぽい)

;-------------------------------------------------------
; IME 入力モード取得
;	WinTitle="A"	対象Window
;	戻り値			入力モード / "":失敗
;--------------------------------------------------------
IME_GetConvMode(WinTitle="A")	{
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
		VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
		NumPut(cbSize, stGTI,  0, "UInt")	;	DWORD	cbSize;
		hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
				 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
	}
	return DllCall("SendMessage"
		  , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
		  , UInt, 0x0283  ;Message : WM_IME_CONTROL
		  ,  Int, 0x001   ;wParam  : IMC_GETCONVERSIONMODE
		  ,  Int, 0)	  ;lParam  : 0
}

;-------------------------------------------------------
; IME 入力モードセット
;	ConvMode		入力モード
;	WinTitle="A"	対象Window
;	戻り値			0:成功 / 0以外:失敗
;--------------------------------------------------------
IME_SetConvMode(ConvMode,WinTitle="A")	 {
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
		VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
		NumPut(cbSize, stGTI,  0, "UInt")	;	DWORD	cbSize;
		hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
				 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
	}
	return DllCall("SendMessage"
		  , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
		  , UInt, 0x0283	  ;Message : WM_IME_CONTROL
		  ,  Int, 0x002 	  ;wParam  : IMC_SETCONVERSIONMODE
		  ,  Int, ConvMode)   ;lParam  : CONVERSIONMODE
}

;===========================================================================
; IME 変換モード (ATOKはver.16で調査、バージョンで多少違うかも)

;	MS-IME	0:無変換 / 1:人名/地名					  / 8:一般	  /16:話し言葉
;	ATOK系	0:固定	 / 1:複合語 			 / 4:自動 / 8:連文節
;	WXG 			 / 1:複合語  / 2:無変換  / 4:自動 / 8:連文節
;	SKK系			 / 1:ノーマル (他のモードは存在しない？)
;	Googleβ										  / 8:ノーマル
;------------------------------------------------------------------
; IME 変換モード取得
;	WinTitle="A"	対象Window
;	戻り値 MS-IME  0:無変換 1:人名/地名 			  8:一般	16:話し言葉
;		   ATOK系  0:固定	1:複合語		   4:自動 8:連文節
;		   WXG4 			1:複合語  2:無変換 4:自動 8:連文節
;		   共通				"":失敗
;------------------------------------------------------------------
IME_GetSentenceMode(WinTitle="A")	{
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
		VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
		NumPut(cbSize, stGTI,  0, "UInt")	;	DWORD	cbSize;
		hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
				 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
	}
	return DllCall("SendMessage"
		  , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
		  , UInt, 0x0283  ;Message : WM_IME_CONTROL
		  ,  Int, 0x003   ;wParam  : IMC_GETSENTENCEMODE
		  ,  Int, 0)	  ;lParam  : 0
}
