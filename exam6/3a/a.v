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

module DFF_TEST;
    reg CK ,D, nCr;
    wire Q, nQ;

    DFF_AR dx (CK, D, nCr, Q, nQ);

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0);
        $monitor("%4t CK:%b D:%b nCr:%b Q:%b nQ:%b",$time, CK, D, nCr, Q, nQ);

        CK = 0;
        D = 1;
        nCr = 1;
        #5 nCr = 0;
        #1 nCr = 1;
        #9 D = 0;
            nCr = 1;
        #20 $finish;
    end

    always #10
        CK <= ~CK;


endmodule