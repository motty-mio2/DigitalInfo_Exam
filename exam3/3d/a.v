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

module pe_ffa(CK,D,Q);
    input CK,D;
    output Q;
    reg Q;

    always @ (posedge CK)
    Q=D;
endmodule

module ff_test;
    reg CK,D;
    wire Qi,Qa;

    pe_ffa ffa (CK,D,Qa);
    pe_ffi ffi (CK,D,Qi);

    initial begin;
        $dumpfile("ff.vcd");
        $dumpvars(0);
        $monitor("%4t CK:%b D:%b Qa:%b Qi:%b", $time, CK, D, Qa, Qi);

        CK = 0;
        D = 1;
        #5 D = 0;
        #10 D = 1;
        #10 D = 0;
        #2 D = 1;
        #8 D = 0;
        #10 D = 1;
        #5 $finish;
    end                // シミュレーションの終了指示

    always #10
    begin
        CK <= ~CK;
    end
endmodule