module PENC4 (A,Y,VALID); // A：4 bit 入力，Y：2 bit エンコード出力，VALID：有効信号（= 1：Y 出力有効）
    input [3:0] A;
    output [1:0] Y;
    output VALID;

    function [1:0] encode;
        input [3:0] a;

        encode = {a[3] | a[2],(~a[2] & a[1]) | a[3]};
    endfunction

    assign Y = encode(A);
    assign VALID = |A;
endmodule

//テストベンチ

`timescale 1ns / 1ns

module PENC4_test_2;
  reg [3:0] A;
  wire[1:0] Y;
  wire VALID;

  PENC4 pe4(A, Y, VALID);

  initial begin
      $dumpfile("PENC4_test_2.vcd");
      $dumpvars(0);
      $monitor("%4t: A = %b, VALID = %b, Y = %d", $time,A,VALID,Y);

      A = 4'b0000;
    #10 A = 4'b1000;
    #10 A = 4'b1100;
    #10 A = 4'b0100;
    #10 A = 4'b0110;
    #10 A = 4'b0010;
    #10 A = 4'b0011;
    #10 A = 4'b0001;
    #5 $finish;
  end
endmodule