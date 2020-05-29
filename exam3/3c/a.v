module pe_ffa(CK,D,Q);
    input CK,D;
    output Q;
    reg  Q;

    always @ (posedge CK)
    begin
        if(D)
            Q=D;
    end
endmodule

module ff_test;
    reg CK,D;
    wire Q;

    pe_ffa f (CK,D,Q);

    initial begin;
        $dumpfile("ff.vcd");    // CKTKWave による波形表示のためのシミュレーション結果出力ファイル名指定
        $dumpvars(0);        // すべての信号を表示対象とするための設定
        $monitor("%4t CK:%b D:%b Q:%b", $time, CK, D, Q);    // 表示設定

        CK = 0;
        D = 1;
        #5 D = 0;
        #10 D = 1;
        #10 D = 0;
        #2 D = 1;
        #8 D = 0;
        #15 $finish;
    end                // シミュレーションの終了指示

    always #10
    begin
        CK <= ~CK;
    end
endmodule