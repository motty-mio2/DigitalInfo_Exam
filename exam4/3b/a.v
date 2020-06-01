module DEC7SEG(BCD, S); // BCD：4 bit BCD 入力，S：7 segment 出力
    input [3:0] BCD;
    output [6:0] S;
    reg [6:0] S, tp;

    always @*
    begin
        case(BCD)
            0 : tp = 7'b1111110;
            1 : tp = 7'b0110000;
            2 : tp = 7'b1101101;
            3 : tp = 7'b1111001;
            4 : tp = 7'b0110011;
            5 : tp = 7'b1011011;
            6 : tp = 7'b1011111;
            7 : tp = 7'b1110000;
            8 : tp = 7'b1111111;
            9 : tp = 7'b1111011;
            default : tp = 0;
        endcase

        S[0] = tp[0];   //A 6
        S[1] = tp[1];   //B 5
        S[2] = tp[2];   //C 4
        S[3] = tp[3];   //D 3
        S[4] = tp[4];   //E 2
        S[5] = tp[5];   //F 1
        S[6] = tp[6];   //G 0
    end
endmodule

module seg_test;
    reg [3:0] bcd;
    wire [6:0] seg;

    DEC7SEG D (bcd, seg);        // 下位モジュール接続：CUT をインスタンス化

    initial begin
        $dumpfile("7seg.vcd");
        $dumpvars(0);
        $monitor("%4t BCD:%b SEG:%b", $time, bcd, seg);

            bcd = 0;
        #10 bcd = 1;
        #10 bcd = 2;
        #10 bcd = 3;
        #10 bcd = 4;
        #10 bcd = 5;
        #10 bcd = 6;
        #10 bcd = 7;
        #10 bcd = 8;
        #10 bcd = 9;
        #10 $finish;
    end                // シミュレーションの終了指示
endmodule