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
    output Q;

    function bcd;
        input CK, nClear;
        reg q1, q2, q3, q4, nq1, nq2, nq3, nq4, nq1o, nq2o, nq3o, nq4o;
        reg cfl;
        cfl = ~(~nClear | (q1 & q4));

        DFF_AR l1(.CK(CK) , .D(nq1o), .nCr(cfl), .Q(q1), .nQ(nq1));

        DFF_AR l2(nq1, nq2o, cflag, q2, nq2);
        DFF_AR l3(nq2, nq3o, cflag, q3, nq3);
        DFF_AR l4(nq3, nq4o, cflag, q4, nq4);

        nq1o = nq1;
        nq2o = nq2;
        nq3o = nq3;
        nq4o = nq4;

        bcd = q4;
    endfunction

    assign Q = bcd(CK,nClear);

endmodule

/*
module DFF_TEST;
    reg CK, nClear;
    wire Q;

    BCD_CNT_A dx (CK, nClear, Q);

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0);
        $monitor("%4t CK:%b nClear:%b Q:%b",$time, CK, nClear, Q);

        CK = 0;
        nClear = 1;
        #5 nClear = 0;
        #1 nClear = 1;
        #29 nclear = 0;
        #100 $finish;
    end

    always #10
        CK <= ~CK;


endmodule

*/