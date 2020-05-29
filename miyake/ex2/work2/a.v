//=================================================================================
// 設計対象回路（CUT：Circuit Under Test）

module AND2 (SW0,SW1,L);        // モジュール名と入力・出力ポート名を記述

  input SW0,SW1;                // 入力・出力ポートの宣言
  output L　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　

  assign L = SW0 & SW1;                // 処理内容の記述

endmodule

//=================================================================================
// テストベンチ：CUT にテストパターンを与え，シミュレーション結果を表示させる

`timescale 1 ns / 1 ns        // 時間刻みの設定：最小 1 ns 単位

module AND2_TEST;

  reg SW0, SW1;                // 内部信号線の宣言
  wire L;

  AND2 A (SW0, SW1, L);        // 下位モジュール接続：CUT をインスタンス化

  initial begin
    $dumpfile("AND2_TEST.vcd");    // GTKWave による波形表示のためのシミュレーション結果出力ファイル名指定
    $dumpvars(0);        // すべての信号を表示対象とするための設定
    $monitor("%4t　SW0:%b SW1:%b L:%b", $time, SW0, SW1, L);    // 表示設定

    SW0 = o;            // 以下，初期値・テストパターン設定
    SW1 = 0;
    #10 SW0 = 1;
    #10 SW1 = 1;
    #10 SW0 = 0;
     #10 $finish;
  end                // シミュレーションの終了指示

endmodule

//=================================================================================