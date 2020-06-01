module BARREL(Y, A, S); // A：8 bit 入力，S：2 bit シフト量指示，Y：出力
    input [7:0] A;
    input [1:0] S;
    output [7:0] Y;
    // reg [7:0] Y;

    always @'
    begin
        if(S[1]+S[0])
            assign Y = {A[7-2*S[1]-S[0]:0+2*S[1]+S[0]],(S[1]+S[0])'b0};
        else
            assign Y = A;
    end
endmodule

module BARREL_TEST;
    reg [7:0] A;
    reg [1:0] S;
    wire [7:0] Y;

    BARREL B (Y, A, S);

    initial begin;
        $dumpfile("bs.vcd");    // CKTKWave による波形表示のためのシミュレーション結果出力ファイル名指定
        $dumpvars(0);        // すべての信号を表示対象とするための設定
        $monitor("%4t A:%d S:%d Y:%d", $time, A, S, Y);    // 表示設定

        A = $urandom_range(7,0);
        #0  S = 0;
        #10 S = 1;
        #10 S = 2;
        #10 S = 3;
        #10 $finish;
    end
endmodule