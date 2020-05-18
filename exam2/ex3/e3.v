//=================================================================================
// 設計対象回路（CUT：Circuit Under Test）

module HA (a,b,s,c);		// モジュール名と入力・出力ポート名を記述
  input a,b;
  output s,c;
  assign s = a^b;
  assign c = a&b;
endmodule

//=================================================================================
// テストベンチ：CUT にテストパターンを与え，シミュレーション結果を表示させる

`timescale 1 ns / 1 ns		// 時間刻みの設定：最小 1 ns 単位

module HA_TEST;
  reg a,b;
  wire s,c;

  HA A(a,b,s,c);
  initial begin
    $dumpfile("HA_TEST.vcd");
    $dumpvars(0);
    $monitor("%4t a:%b b:%b s:%b c:%b",$time, a,b,s,c);

    a = 0;
    b = 0;

    #10 a = 1;
    #10 b = 1;
    #10 a = 0;
    #10 $finish;
  end
endmodule