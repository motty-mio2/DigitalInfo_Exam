// cnt4srar_and_test.v : 同期リセット／非同期リセット付き 4 進カウンタとテストベンチの例
//
//	本来は，論理合成対象となる回路部分（CNT4SR, CNT4AR）とテストベンチとは，
//	次のようにファイルを分離すべきだが，わかりやすさのため，あえてまとめている：
//	module CNT4SR	-> cnt4sr.v	（論理合成対象となる回路部分）
//	module CNT4AR	-> cnt4ar.v	（論理合成対象となる回路部分）
//	module CNT4_TEST-> cnt4_test.v	（上記回路のシミュレーションを行うためのテストベンチで，回路にはならない）

//--------------	同期リセット付き 4 進カウンタ	  --------------

module CNT4SR (CLK, nRES, Q);
  input CLK, nRES;	// nRES：リセット入力＠負論理（負論理信号を先頭の "n" or 末尾の "B" 等で区別）
  output [1:0] Q;
  reg [1:0] Q;		// 出力ポート名：Q と一致させれば，assign Q = reg 名; が不要となる
  always @(posedge CLK)	// CLK の立ち上がり↑時のみ実行
  begin
    if (!nRES)		// nRES == 0（有効）の時，CLK↑ でリセット
      Q <= 0;		// 複数の文（statement）を書く場合は，begin ～ end で括る
    else		// nRES == 1（無効）の時，CLK↑ でカウントアップ
      Q <= Q + 1;
  end
endmodule

//--------------	非同期リセット付き 4 進カウンタ	  --------------

module CNT4AR (CLK, nRES, Q);
  input CLK, nRES;	// nRES：リセット入力＠負論理（負論理信号を先頭の "n" or 末尾の "B" 等で区別）
  output [1:0] Q;
  reg [1:0] Q;		// 出力ポート名と一致させれば，output = reg の assign 文が不要となる
  always @ (posedge CLK or negedge nRES)	// CLK↑ or nRES↓ で実行
  begin
    if (!nRES)		// nRES == 0（有効）になると，直ちにリセット
      Q <= 0;
    else		// nRES == 1（無効）の時，CLK の立ち上がりでカウントアップ
      Q <= Q + 1;
  end
endmodule

//----------	同期／非同期リセット付き 4 進カウンタ用のテストベンチ	  ----------

`timescale 1 ns / 1 ns		// シミュレーション時刻の単位 / 精度をともに 1 ns とする

module CNT4_TEST;
  parameter CYCLE = 20;
  wire [1:0] QS, QA;
  reg  CLK, nRES;

  initial
  begin
    $dumpfile("test.vcd");	// VCD（Value Change Dump）ファイルの名前を指定
    $dumpvars(0);		// VCD データの出力対象：すべてに設定
    $monitor("%4t CLK:%b nRES:%b QS:%b QA:%b",$time, CLK, nRES, QS, QA);	// 結果を参照する信号線と表示形式の指定（cf. printf()）
    #0		// 時刻 0 ns での初期化（#0 は無くても良い）
      CLK = 0;
      nRES = 0;
    #(CYCLE/4)	// 5 ns（# の後に遅延時間）
      nRES = 1;	// CLK↑@10 ns の前に無効とする
    #CYCLE	// 25 ns
      nRES = 0;	// CLK↑@30 ns の前に有効とする
    #(CYCLE/2)	// 35 ns
      nRES = 1;
    #(CYCLE/4)	// 40 ns
    #(CYCLE*2)	// 80 ns
      nRES = 0;	// CLK↑にかからない短いパルス
    #(CYCLE/4)	// 85 ns
      nRES = 1;
    #(CYCLE*3)	// 145 ns
    $finish;	// シミュレーション終了
  end

  always #(CYCLE/2)	// クロック生成：上記初期化後，CLK↑,↓,↑,…
     CLK <= ~CLK;

//	CNT4SR, CNT4AR をインスタンス化（下位モジュール呼出し）
  CNT4SR SR (CLK, nRES, QS);	// 　同期リセット付き 4 進カウンタ（出力：QS[1:0]）
  CNT4AR AR (CLK, nRES, QA);	// 非同期リセット付き 4 進カウンタ（出力：QA[1:0]）
endmodule

/*--------------------------------------------------------------------*

ivgo.bat 実行によるシミュレーション結果の例（"//" 以降は注釈）

//	iverilog によるコンパイル：-o に続いて出力ファイル名を指定（省略時は a.out に出力），
//	その後に必要な Verilog-HDL ソースのファイル名を並べる
C:\iverilog\v>iverilog cnt4srar_and_test.v

//	生成された a.out を vvp コマンドに渡して，シミュレーション実行
C:\iverilog\v>vvp a.out
   0 CLK:0 nRES:0 QS:xx QA:00	// nRES = 0：非同期リセットの QA = 0 となるが，同期リセットの QS では CLK↑までそのまま不定値 x が残る
   5 CLK:0 nRES:1 QS:xx QA:00
  10 CLK:1 nRES:1 QS:xx QA:01	// CLK↑も，nRES = 1 で無効なので QS はリセットされず x のまま，QA はカウント・アップ
  20 CLK:0 nRES:1 QS:xx QA:01
  25 CLK:0 nRES:0 QS:xx QA:00
  30 CLK:1 nRES:0 QS:00 QA:00	// nRES = 0 で CLK↑により，QS もリセット
  35 CLK:1 nRES:1 QS:00 QA:00
  40 CLK:0 nRES:1 QS:00 QA:00
  50 CLK:1 nRES:1 QS:01 QA:01	// nRES = 1 でリセット解除：QS, QA ともにカウント・アップ
  60 CLK:0 nRES:1 QS:01 QA:01
  70 CLK:1 nRES:1 QS:10 QA:10	// 〃
  80 CLK:0 nRES:0 QS:10 QA:00	// nRES = 0 で有効となるも CLK↑にかからず，QA のみリセット
  85 CLK:0 nRES:1 QS:10 QA:00
  90 CLK:1 nRES:1 QS:11 QA:01	// QS, QA 異なる値でカウント・アップ
 100 CLK:0 nRES:1 QS:11 QA:01
 110 CLK:1 nRES:1 QS:00 QA:10	// 〃
 120 CLK:0 nRES:1 QS:00 QA:10
 130 CLK:1 nRES:1 QS:01 QA:11	// 〃
 140 CLK:0 nRES:1 QS:01 QA:11

 *--------------------------------------------------------------------*/
