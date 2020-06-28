`timescale 1 ns / 1 ns
module BCD_COUNT(CK, CE, AR, CO, Q);
  input CK, CE, AR;
  output CO;
  reg CO = 0;
  output [3:0] Q;
  reg [3:0] Q;

  always @(posedge CK&CE or negedge AR)
  begin
    if (~AR) begin
      assign Q = 0;
      CO = 0;
    end else if (CO) begin
      assign Q = 0;
      CO = 0;
    end else begin
      assign Q = Q + 1;
      if (Q == 4'b1001)
        CO = 1;
    end
  end
endmodule

module BCD_COUNT_TEST;
  parameter CYCLE = 20;
  reg  CK, CE, AR;
  wire CO;
  wire [3:0] Q;

  initial
  begin
    $dumpfile("test.vcd");
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
    #(CYCLE*6)
    $finish;
  end

  always #(CYCLE/2)
     CK <= ~CK;
BCD_COUNT BCD (CK, CE, AR, CO, Q);
endmodule