module BARREL(Y, A, S); // A：8 bit 入力，S：2 bit シフト量指示，Y：出力
    input [7:0] A;
    input [1:0] S;
    output [7:0] Y;
    reg [7:0] Y;
    integer i;

    always @*
    begin
        case (2*S[1]+S[0])
            0 : Y = A;
            1 : Y = {A[7-1:0], 1'b0};
            2 : Y = {A[7-2:0], 2'b0};
            3 : Y = {A[7-3:0], 3'b0};
            default : Y = A;
        endcase
    end
endmodule

module BARREL_TEST;
    wire [7:0] Y;
    reg [7:0] A;
    reg [1:0] S;

    BARREL B (Y, A, S);

    initial begin;
        $dumpfile("bs.vcd");    // CKTKWave による波形表示のためのシミュレーション結果出力ファイル名指定
        $dumpvars(0);        // すべての信号を表示対象とするための設定
        $monitor("%4t A:%b S:%d Y:%b", $time, A, S, Y);    // 表示設定

        // A = "11000111";
        A = 8'b11000111;
        #0  S = 0;
        #10 S = 1;
        #10 S = 2;
        #10 S = 3;
        #10 $finish;
    end
endmodule