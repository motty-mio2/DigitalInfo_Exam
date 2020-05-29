module latch(G,D,Q);
    input G,D;
    output Q;
    reg Q;

    always @ (G or D)
    if(G)
        Q = D;
endmodule

module latch_test;
    reg G,D;
    wire Q;

    latch l (G,D,Q);

    initial begin;
        $dumpfile("latch.vcd");    // GTKWave による波形表示のためのシミュレーション結果出力ファイル名指定
        $dumpvars(0);        // すべての信号を表示対象とするための設定
        $monitor("%4t G:%b D:%b Q:%b", $time, G, D, Q);    // 表示設定

        G = 1;            // 以下，初期値・テストパターン設定
        D = 1;
        #10 D = 0;
        #10 D = 1;
        #10 G = 0;
        #10 D = 0;
        #10 D = 1;
        #10 D = 0;
        #10 $finish;
    end                // シミュレーションの終了指示

endmodule