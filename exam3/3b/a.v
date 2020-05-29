module latch(G,D,Q);
    input G,D;
    output Q;
    reg Q;

    always @ (G or D)
    if(G)
        Q = D;
endmodule

module pe_ffi(CK,D,Q);
    input CK,D;
    output Q;
    //reg  Q;
    wire q1,Q;

    latch l1(!CK,D,q1);
    latch l2(CK,q1,Q);

endmodule

module ff_test;
    reg CK,D;
    wire Q;

    pe_ffi l (CK,D,Q);

    initial begin;
        $dumpfile("ff.vcd");    // CKTKWave による波形表示のためのシミュレーション結果出力ファイル名指定
        $dumpvars(0);        // すべての信号を表示対象とするための設定
        $monitor("%4t CK:%b D:%b Q:%b", $time, CK, D, Q);    // 表示設定

        D = 1;
        CK = 0;
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