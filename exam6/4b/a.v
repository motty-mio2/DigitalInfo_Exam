`timescale 1 ns / 1 ns

module DFF_AR(CK, D, nCr, Q, nQ);
    input CK, D, nCr;
    output Q, nQ;
    reg Q, nQ;

    always @(posedge CK or negedge nCr)
    begin
        if(~nCr)
            #1 Q = 0;
        else
            #1 Q = D;
        nQ = ~Q;
    end
endmodule

module BCD_COUNT(CK, CE, AR, CO, Q); // CE = 1 で CK = 0 から CK = 1 に立ち上がるとカウントアップ
    input CK, CE, AR;
    output CO;
    reg CO;
    output [3:0] Q;
    reg [3:0] Q;

    always @ (posedge CK or negedge AR)
    begin
        if(~AR | Q[3]&Q[0]&CE)
            Q = 0;
        else if(CE)
            Q = Q+1;

        CO = Q[3]&Q[0]&CE;
    end
endmodule

module main(CK, CE, AR, CO, Q);
    input CK, CE, AR;
    output CO;
    //reg CO;
    output [3:0] Q;
    //reg [3:0] Q;

    wire GCK, nGCK;
    DFF_AR dgl (CK, CE, 1'b1, GCK, nGCK);
    BCD_COUNT bc (GCK&CK, CE, AR, CO, Q);
endmodule

module bcd_test;
    reg CK ,CE, AR;
    wire CO;
    wire [3:0] Qb, Qg;

    BCD_COUNT bc (CK, CE, AR, CO, Qb);
    main m (CK, CE, AR, CO, Qg);

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0);
        $monitor("%4t CK:%b CE:%b AR:%b CO:%b Qb:%b Qg:%b",$time, CK, CE, AR, CO, Qb, Qg);

        CK = 0;
        CE = 0;
        #15AR = 1;
        #1 AR = 0;
        #4 AR = 1;
           CE = 1;
        #20 CE = 0;
        #20 CE = 1;
        #155 CE = 0;
        #20 CE = 1;
        #39 AR = 0;
        #1 AR = 1;
        #20 $finish;
    end

    always #10
        CK <= ~CK;
endmodule