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

module BCD_CNT_A(CK, nClear, Q); // CK：クロック入力，nClear：負論理リセット入力，Q：カウント出力
    input CK,nClear;
    output [3:0] Q;

    wire q1, q2, q3, q4, nq1, nq2, nq3, nq4;
    wire clear;

    assign clear = !(q2&q4)&nClear;

    DFF_AR l1(CK , nq1, clear, q1, nq1);
    DFF_AR l2(nq1, nq2, clear, q2, nq2);
    DFF_AR l3(nq2, nq3, clear, q3, nq3);
    DFF_AR l4(nq3, nq4, clear, q4, nq4);

    assign Q = {q4,q3,q2,q1};
endmodule


module BCD_TEST;
    reg CK, nClear;
    wire [3:0] Q;

    BCD_CNT_A dx (CK, nClear, Q);

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0);
        $monitor("%4t CK:%b nClear:%b Q:%b",$time, CK, nClear, Q);

        CK = 0;
        nClear = 1;
        #9 nClear = 0;
        #1 nClear = 1;

        #25 nClear = 0;
        #5 nClear = 1;
        #250 $finish;
    end

    always #10
        CK <= ~CK;
endmodule

