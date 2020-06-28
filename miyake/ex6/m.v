`timescale 1 ns / 1 ns

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

module bcd_test;
    parameter CYCLE = 20;
    reg CK ,CE, AR;
    wire CO;
    wire [3:0] Q;

    BCD_COUNT bc (CK, CE, AR, CO, Q);

    initial begin
        $dumpfile("testm.vcd");
        $dumpvars(0);
        $monitor("%4t CK:%b CE:%b AR:%b CO:%b Q:%b",$time, CK, CE, AR, CO, Q);

        #0
      CK = 0;
      CE = 0;
    #(CYCLE/4)
      AR = 0;
      CE = 1;
    #CYCLE    // 25 ns
      AR = 1;
    #(CYCLE/2)
    #(CYCLE/4)
    #(CYCLE*2)
      CE = 0;
    #(CYCLE)
      CE = 1;
    #(CYCLE*3)
      AR = 0;
    #(CYCLE)
      AR = 1;
    #(CYCLE)
        CE=0;
    #(CYCLE*3/4)
        CE=1;
    #(CYCLE*6)
    $finish;
  end

  always #(CYCLE/2)
     CK <= ~CK;
endmodule