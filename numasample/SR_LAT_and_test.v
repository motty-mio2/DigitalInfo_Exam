// SR_LAT_and_test.v : SR-Latch とテストベンチの例
//
//	本来は，論理合成対象となる回路部分（SR_LAT）とテストベンチ（SR_LAT_TEST）とは，
//	ファイルを分離すべきだが，わかりやすさのため，あえてまとめている。

//	先頭にもってくる必要あり（module 記述の前）
`timescale 1 ns / 1 ns	// シミュレーション時刻の単位 / 精度をともに 1 ns とする

//--------------	SR-Latch（assign 文）	  --------------

module SR_LAT (nS, nR, Q, nQ);
  input nS, nR;
  output Q, nQ;
  assign #1  Q = !(nS & nQ);
  assign #1 nQ = !(nR &  Q);
endmodule

//--------------	SR-Latch（gate 接続）	  --------------

module SR_LAT_GATE (nS, nR, Q, nQ);
  input nS, nR;
  output Q, nQ;
  nand #1 N3 ( Q, nS, nQ);
  nand #1 N4 (nQ, nR,  Q);
endmodule

//--------------	SR-Latch 用のテストベンチ	  --------------

module SR_LAT_TEST;
  parameter CYCLE = 5;
  wire Q, nQ, QG, nQG;
  reg nS, nR;

  initial
  begin
    $dumpfile("SR_LAT_and_test.vcd");	// VCD（Value Change Dump）ファイルの名前を指定
    $dumpvars(0);			// VCD データの出力対象：すべてに設定
    $monitor("%4t nS:%b nR:%b Q:%b nQ:%b QG:%b nQG:%b",$time, nS, nR, Q, nQ, QG, nQG);	// 結果を参照する信号線と表示形式の指定（cf. printf()）
    #0		// 時刻 0 ns での初期化（#0 は無くても良い）
      nS = 1; nR = 1;
    #CYCLE	// 1 * CYCLE ns（# の後に遅延時間）
      nR = 0;		// Q = 0 にリセット
    #CYCLE	// 2 * CYCLE ns
      nR = 1;
    #CYCLE	// 3 * CYCLE ns
      nS = 0;		// Q = 1 にセット
    #CYCLE	// 4 * CYCLE ns
      nS = 1;
    #CYCLE	// 5 * CYCLE ns
      nS = 0;  nR = 0;	// あえて禁止入力 nS = nR = 0 を与えてみる
    #CYCLE	// 6 * CYCLE ns
      nS = 1;		// nS が先に無効になる → Q = 0 にリセット
    #1
      nR = 1;
    #(CYCLE-1)	// 7 * CYCLE ns
      nS = 0;  nR = 0;	// 再度，禁止入力 nS = nR = 0 を与えてみる
    #CYCLE	// 8 * CYCLE ns
      nS = 1;  nR = 1;	// 今度は，同時に nS = nR = 1 と無効化すると..
    #(CYCLE*3)	// 11 * CYCLE ns
    $finish;	// シミュレーション終了
  end

//	SR_LAT, SR_LAT_GATE をインスタンス化（下位モジュール呼出し）
  SR_LAT      SR  (nS, nR, Q,  nQ );	// SR-Latch
  SR_LAT_GATE SRG (nS, nR, QG, nQG);	// SR-Latch（Gate 接続）
endmodule

/*--------------------------------------------------------------------*

ivgo.bat 実行によるシミュレーション結果の例（"//" 以降は注釈）

//	iverilog によるコンパイル：-o に続いて出力ファイル名を指定（省略時は a.out に出力），
//	その後に必要な Verilog-HDL ソースのファイル名を並べる
C:\iverilog\v>iverilog SR_LAT_and_test.v

//	生成された a.out を vvp コマンドに渡して，シミュレーション実行
C:\iverilog\v>vvp a.out
VCD info: dumpfile test.vcd opened for output.
  0 nS:1 nR:1 Q:x nQ:x QG:x nQG:x
  5 nS:1 nR:0 Q:x nQ:x QG:x nQG:x
  6 nS:1 nR:0 Q:x nQ:1 QG:x nQG:1
  7 nS:1 nR:0 Q:0 nQ:1 QG:0 nQG:1	nR = 0 -> Q = QG = 0 にリセット
 10 nS:1 nR:1 Q:0 nQ:1 QG:0 nQG:1
 15 nS:0 nR:1 Q:0 nQ:1 QG:0 nQG:1
 16 nS:0 nR:1 Q:1 nQ:1 QG:1 nQG:1	nS = 0 -> Q = GG
 17 nS:0 nR:1 Q:1 nQ:0 QG:1 nQG:0
 20 nS:1 nR:1 Q:1 nQ:0 QG:1 nQG:0
 25 nS:0 nR:0 Q:1 nQ:0 QG:1 nQG:0	あえて禁止入力：nS = nR = 0 に設定
 26 nS:0 nR:0 Q:1 nQ:1 QG:1 nQG:1
 30 nS:1 nR:0 Q:1 nQ:1 QG:1 nQG:1	nS = 1 で先に無効化
 31 nS:1 nR:1 Q:0 nQ:1 QG:0 nQG:1	-> Q = 0 にリセット
 35 nS:0 nR:0 Q:0 nQ:1 QG:0 nQG:1	再度禁止入力：nS = nR = 0 に設定
 36 nS:0 nR:0 Q:1 nQ:1 QG:1 nQG:1
 40 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1	同時に解除：nS = nR = 1 -> 発振
 41 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 42 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1
 43 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 44 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1
 45 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 46 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1
 47 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 48 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1
 49 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 50 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1
 51 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 52 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1
 53 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 54 nS:1 nR:1 Q:1 nQ:1 QG:1 nQG:1
 55 nS:1 nR:1 Q:0 nQ:0 QG:0 nQG:0
 *--------------------------------------------------------------------*/
