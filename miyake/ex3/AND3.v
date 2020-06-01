//=================================================================================
// 設計対象回路（CUT：Circuit Under Test）

module LATCH (G,D,Q);

  input G,D;
  output Q;
  reg Q;

  always @ (G or D)
    if (G)
      Q = D;

endmodule

module PE_FFi(CK, D, Qi); // CK：クロック入力，D：データ入力，Qi：FF 出力
  input  CK, D;
  output  Qi;

  wire q;
  LATCH L1 (CK, D, q);
  LATCH L2 (~CK, q, Qi);

endmodule

module PE_FFa(CK, D, Qa); // CK：クロック入力，D：データ入力，Qa：FF 出力
  input CK, D;
  output Qa;
  reg Qa;
  always @ (posedge CK)
  begin
    Qa <= D;
  end
endmodule

//=================================================================================
// テストベンチ：CUT にテストパターンを与え，シミュレーション結果を表示させる

`timescale 1 ns / 1 ns        // 時間刻みの設定：最小 1 ns 単位

module AND3_TEST;

  reg D, CK;
  wire Qi, Qa;

  PE_FFi A (CK, D, Qi);
  PE_FFa B (CK, D, Qa);

  initial begin
    $dumpfile("AND3_TEST.vcd");    // GTKWave による波形表示のためのシミュレーション結果出力ファイル名指定
    $dumpvars(0);        // すべての信号を表示対象とするための設定
    $monitor("%t D:%b CK:%b Qi:%b Qa:%b", $time, D, CK, Qi, Qa);    // 表示設定

    D = 0;
    CK = 0;
    #5
    D <= 1;
    #15
    D <= 0;
    #18
    D <= 1;
    #20
    D <= 0;
    #28
    D <= 1;
    #35
    D <= 0;
    #10
    $finish;
  end

  always #10
  begin
    CK <= ~CK;
  end


endmodule

//=================================================================================