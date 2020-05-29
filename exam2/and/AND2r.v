//=================================================================================
// 設計対象回路（CUT：Circuit Under Test）

module AND2 (SW0,SW1,L);		// モジュール名と入力・出力ポート名を記述
  input SW0, SW1;
  output L;
  assign L = SW0&SW1;
endmodule

//=================================================================================
// テストベンチ：CUT にテストパターンを与え，シミュレーション結果を表示させる

`timescale 1 ns / 1 ns		// 時間刻みの設定：最小 1 ns 単位

module AND2_TEST;
  reg SW0,SW1;
  wire L;

  AND2 A(SW1,SW0,L);
  initial begin
    $dumpfile("AND2_TEST.vcd");
    $dumpvars(0);
    $monitor("%4t SW0:%b SW1:%b L:%b",$time, SW0,SW1,L);

    SW0=0;
    SW1=0;

    #10 SW0 = 1;
    #10 SW1 = 1;
    #10 SW0 = 0;
    #10 $finish;
  end
endmodule