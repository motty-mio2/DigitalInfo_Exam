module DEC7SEG(BCD, S); // BCD：4 bit BCD 入力，S：7 segment 出力
    input [3:0] BCD;
    output [6:0] S;
    reg [6:0] S, tp;

    always @*
    begin
        case(BCD)
            0 : S = 7'b1111110;
            1 : S = 7'b0110000;
            2 : S = 7'b1101101;
            3 : S = 7'b1111001;
            4 : S = 7'b0110011;
            5 : S = 7'b1011011;
            6 : S = 7'b1011111;
            7 : S = 7'b1110000;
            8 : S = 7'b1111111;
            9 : S = 7'b1111011;
            default : S = 0;
        endcase
    end
endmodule

module seg_test;
    reg [3:0] bcd;
    wire [6:0] seg;
    integer i;

    DEC7SEG D (bcd, seg);        // 下位モジュール接続：CUT をインスタンス化

    initial begin
        $dumpfile("7seg.vcd");
        $dumpvars(0);
        $monitor("%4t BCD:%b SEG:%b", $time, bcd, seg);

        bcd=0;
        for(i=1;i<8;i=i+1) begin
            #10 bcd=i;
        end
        #10 $finish;
    end                // シミュレーションの終了指示
endmodule