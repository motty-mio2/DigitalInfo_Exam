module PENC4(A, Y, VALID);
 // A：4 bit 入力，Y：2 bit エンコード出力，VALID：有効信号（= 1：Y 出力有効）
    input [3:0] A;
    output [1:0] Y;
    output VALID;

    function [2:0] enc;
        input [7:0] a;
        if      (A&4'b1000) enc = 3;
        else if (A&4'b0100) enc = 2;
        else if (A&4'b0010) enc = 1;
        else if (A&4'b0001) enc = 0;
        else enc = 0;
    endfunction

    assign Y = enc(A);
    assign VALID = |A;
endmodule

module PENC4_TEST;
    reg [3:0] A;
    wire [1:0] Y;
    wire V;

    integer i;

    PENC4 P (A, Y, V);

    initial begin;
        $dumpfile("pe4.vcd");    // CKTKWave による波形表示のためのシミュレーション結果出力ファイル名指定
        $dumpvars(0);        // すべての信号を表示対象とするための設定
        $monitor("%4t A:%d Y:%d Valid:%d", $time, A, Y, V);    // 表示設定

        A=0;
        for(i=1;i<16;i=i+1) begin
            #10 A=i;
        end
        #10 $finish;
    end
endmodule