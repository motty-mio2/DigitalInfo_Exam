module PENC4 (A,Y,VARID); // A：4 bit 入力，Y：2 bit エンコード出力，VALID：有効信号（= 1：Y 出力有効）
    input [3:0] A;
    output [1:0] Y;
    output VARID;

    function [1:0] encode;
        input [3:0] a;

        encode[1] = a[3] | a[2];
        encode[0] = (~a[2] & a[1]) | a[3];
    endfunction

    assign Y = encode(A);
    assign VARID = |A;

endmodule