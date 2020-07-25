module FA (a,b,ci,s,co);
  input a,b,ci;
  output s,co;
  assign s = a^b^ci;
  assign co = a&b|b&ci|ci&a;
endmodule

module FA4b5b (a, b, mo, c);
    input [3:0] a,b;
    input mo;
    //0:plus, 1:minus
    output [4:0] c;
    wire c1, c2, c3, c4;

    FA f1 (a[0], b[0]^mo, mo, c[0], c1);
    FA f2 (a[1], b[1]^mo, c1, c[1], c2);
    FA f3 (a[2], b[2]^mo, c2, c[2], c3);
    FA f4 (a[3], b[3]^mo, c3, c[3], c4);
    assign c[4] = c4^mo;
endmodule

module MULTI1x4 (a,b,s);
    input [3:0] a;
    input b;
    output [3:0] s;

    assign s = {a[3]&b, a[2]&b, a[1]&b, a[0]&b};
endmodule

module MULTI4b8b (a,b,s);
    input [3:0] a,b;
    output [7:0] s;
    wire [3:0] ab0, ab1, ab2, ab3;
    wire [4:0] c1, c2, c3;

    MULTI1x4 m0 (a, b[0], ab0);
    MULTI1x4 m1 (a, b[1], ab1);
    MULTI1x4 m2 (a, b[2], ab2);
    MULTI1x4 m3 (a, b[3], ab3);

    assign s[0] = a[0]&b[0];
    FA4b5b f1 (.a({1'b0,ab0[3:1]}), .b(ab1), .mo(1'b0), .c(c1));
    assign s[1] = c1[0];
    FA4b5b f2 (.a(c1[4:1]), .b(ab2), .mo(1'b0), .c(c2));
    assign s[2] = c2[0];
    FA4b5b f3 (.a(c2[4:1]), .b(ab3), .mo(1'b0), .c(s[7:3]));
endmodule

module comp4 (a,b,s);
    input[3:0] a,b;
    output [1:0] s;

    assign s =
        (a[3]&~b[3]) ? 2'b10 :
        (~a[3]&b[3]) ? 2'b01 :
        (a[2]&~b[2]) ? 2'b10 :
        (~a[2]&b[2]) ? 2'b01 :
        (a[1]&~b[1]) ? 2'b10 :
        (~a[1]&b[1]) ? 2'b01 :
        (a[0]&~b[0]) ? 2'b10 :
        (~a[0]&b[0]) ? 2'b01 : 2'b11;
endmodule

module lshift (a,c,s);
    input [3:0] a;
    input [1:0] c;
    output [3:0] s;

    function [3:0] lshifter;
        input [3:0] a;
        input [1:0] c;

        case (c)
            2'b11 : lshifter = {a[0],3'b000};
            2'b10 : lshifter = {a[1:0],2'b00};
            2'b01 : lshifter = {a[2:0],1'b0};
            2'b00 : lshifter = {a};
            default : lshifter = 4'b000;
        endcase
    endfunction

    assign s = lshifter(a, c);
endmodule

module div4once(a, b, c, ar, sr);
// a: 割られる数, b:割る数, c:シフト数,  , ar:余り, sr:商
    input [3:0] a, b;
    input [1:0] c;
    output [3:0] ar, sr;

    wire [3:0] bx;
    wire [1:0] cy;
    wire [4:0] arf;
    wire [3:0] sw;

    lshift lc (b, c, bx);
    comp4 cxv (a, bx, cy);
    FA4b5b fx (a, bx, 1'b1, arf);
    lshift ls (4'b0001, c, sw);

    assign sr = cy[1] ? sw : 4'b0000;
    assign ar = cy[1] ? arf[3:0] : a;
endmodule

module div4 (a,b,s,r);
    input [3:0] a, b;
    output [3:0] s, r;

    wire [3:0] av3,av2,av1,av0;
    wire [3:0] sv3,sv2,sv1,sv0;
    wire [7:0] as3, as2, as1, as0;

    div4once d3 (a  , b, 2'b11, av3, sv3);
    assign as3 = (~(b[3]|b[2]|b[1]))
        ? {av3, 4'b0000 | sv3}
        : {a, 4'b0000};

    div4once d2 (as3 [7:4], b, 2'b10, av2, sv2);
    assign as2 = (~(b[3]|b[2]))
        ? {av2, as3 [3:0] | sv2}
        : as3;

    div4once d1 (as2 [7:4], b, 2'b01, av1, sv1);
    assign as1 = (~(b[3]))
        ? {av1, as2 [3:0] | sv1}
        : as2;

    div4once d0 (as1 [7:4], b, 2'b00, av0, sv0);

    assign r = av0;
    assign s = as1 [3:0] | sv0;
endmodule

module ALU (a, b, f, CLK, CLR, v, y);
    input [3:0] a,b;
    input [4:0] f;
    input CLK, CLR, v;
    output [3:0] y;
    reg [3:0] y;
    reg state;

    wire [4:0] adder, minus;
    FA4b5b p4 (a, b, 1'b0, adder);
    FA4b5b d4 (a, b, 1'b1, minus);

    wire [7:0] multi;
    MULTI4b8b m4 (a, b, multi);

    wire [3:0] divis, remai;
    div4 di4 (a, b, divis, remai);
// or
    always @ (posedge CLK, negedge CLR) begin
        if (CLR==1'b0) begin
            state = 1'b1;
            y = 4'b0000;
        end else begin
            state = 1'b0;
            case (f)
                5'b00010 : y = v ? {3'b000, adder[4]} : adder[3:0]; //足し算
                5'b00011 : y = v ? {minus[4], minus[4], minus[4], minus[4]} : minus[3:0]; //引き算
                5'b01000 : y = a&b; //AND
                5'b01100 : y = a|b; //OR
                5'b00000 : y = {a[2:0], 1'b0}; //左シフト
                5'b10000 : y = {1'b0, a[3:1]}; //右シフト
                5'b00100 : y = v ? multi[7:4] : multi[3:0]; //掛け算
                5'b00110 : y = v ? remai : divis; //割り算
                default  : y = 4'b0000;
            endcase
        end
    end
endmodule

module ALU_test;
    reg [3:0] a, b;
    reg [4:0] f;
    reg clk, clr, v;
    wire [3:0] c;

    ALU mainALU (a, b, f, clk, clr, v, c);

    initial begin;
        $dumpfile("alun.vcd");    // CKTKWave による波形表示のためのシミュレーション結果出力ファイル名指定
        $dumpvars(0);        // すべての信号を表示対象とするための設定
        $monitor("%4t a:%d b:%d f:%b CLK:%b CLR:%b v:%d c:%b", $time, a, b, f, clk, clr, v, c);    // 表示設定

        #0
        clr=1;
        a = 4'b1110;
        b = 4'b0110;
        v=1'b1;
        clk=0;
        #1
        clr=0;
        #1
        clr=1;
        #2
        f=5'b00010;
        #10
        v=1'b0;
        #10
        v=1'b1;
        f=5'b00011;
        #10
        v=1'b0;
        #10
        f=5'b01000;
        #10
        f=5'b01100;
        #10
        f=5'b00000;
        #10
        f=5'b10000;
        #10
        v=1'b1;
        f=5'b00100;
        #10
        v=1'b0;
        #10
        f=5'b00110;
        #10
        v=1'b1;
        #10
        f=5'b11111;


        #0
        a = 4'b0110;
        b = 4'b1010;
        clr=0;
        #2
        clr=1;
        #3
        v=1'b1;
        f=5'b11111;
        #10
        v=1'b1;
        f=5'b00010;
        #10
        v=1'b0;
        #10
        v=1'b1;
        f=5'b00011;
        #10
        v=1'b0;
        #10
        f=5'b01000;
        #10
        f=5'b01100;
        #10
        f=5'b00000;
        #10
        f=5'b10000;
        #10
        v=1'b1;
        f=5'b00100;
        #10
        v=1'b0;
        #10
        f=5'b00110;
        #10
        v=1'b1;
        #10
        f=5'b11111;
        #10 $finish;
    end                // シミュレーションの終了指示

    always #(5)
        clk <= ~clk;
endmodule

