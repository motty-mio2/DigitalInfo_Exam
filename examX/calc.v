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
    wire c1,c2,c3,c4;

    FA f1 (a[0], b[0]^mo, mo, c[0], c1);
    FA f2 (a[1], b[1]^mo, c1, c[1], c2);
    FA f3 (a[2], b[2]^mo, c2, c[2], c3);
    FA f4 (a[3], b[3]^mo, c3, c[3], c[4]);
endmodule

module MULIT1x4 (a,b,s);
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

    MULIT1x4 m0 (a, b[0], ab0);
    MULIT1x4 m1 (a, b[1], ab1);
    MULIT1x4 m2 (a, b[2], ab2);
    MULIT1x4 m3 (a, b[3], ab3);

    assign s[0] = a[0]&b[0];
    FA4b5b f1 (.a({1'b0,ab0[3:1]}), .b(ab1), .mo(1'b0), .c(c1));
    assign s[1] = c1[0];
    FA4b5b f2 (.a(c1[4:1]), .b(ab2), .mo(1'b0), .c(c2));
    assign s[2] = c2[0];
    FA4b5b f3 (.a(c2[4:1]), .b(ab3), .mo(1'b0), .c(s[7:3]));
endmodule

module comp1 (a,b,s);
    input a, b;
    output s;

    if(~a&b) begin
        assign s = 2'b01;
    end else if (a&~b) begin
        assign s = 2'b10;
    end else begin
        assign s = 2'b11;
    end
endmodule

module comp4 (a,b,s);
    input[3:0] a,b;
    output [1:0] s;
    wire [1:0] w0, w1, w2, w3;

    comp1 c3 (a[3], b[3], w3);
    comp1 c2 (a[2], b[2], w2);
    comp1 c1 (a[1], b[1], w1);
    comp1 c0 (a[0], b[0], s);

    function [1:0] cp4;
        input [3:0] a, b;

        if(a[3]&~b[3]) begin
            s = 2'b10;
        end else if (~a[3]&b[3]) begin
            s = 2'b01;
        end else begin
            if(a[2]&~b[2]) begin
                s = 2'b10;
            end else if (~a[2]&b[2]) begin
                s = 2'b01;
            end else begin
                if(a[1]&~b[1]) begin
                    s = 2'b10;
                end else if (~a[1]&b[1]) begin
                    s = 2'b01;
                end else begin
                    if(a[0]&~b[0]) begin
                        s = 2'b10;
                    end else if (~a[0]&b[0]) begin
                        s = 2'b01;
                    end else begin
                        s = 2'b11;
                    end
                end
            end
        end
    endfunction
endmodule

module lshift (a,c,s);
    input [3:0] a;
    input [1:0] c;
    output [3:0] s;

    function [3:0] lshift;
        input [3:0] a;
        input [1:0] c;

        case (c)
            2'b11 : lshift = {a[0],3'b000};
            2'b10 : lshift = {a[1:0],2'b00};
            2'b01 : lshift = {a[2:0],1'b0};
            2'b00 : lshift = {a};
            default : lshift = 4'b000;
        endcase
    endfunction
endmodule

module div4 (a,b,s,r);
    input [3:0] a, b;
    output [3:0] s, r;

    wire [3:0] b3, b2, b1, b0;
    wire [1:0] s3, s2, s1, s0;
    wire [3:0] a3, a2, a1, a0;


    function [7:0] div4r;
        input [3:0] a, b;

        div4r = 4'b0000;

        lshift l3 (b, 2'b11, b3);
        comp4 c3 (a, b3, s3);
        if (s3==2'b10) begin
            div4r = div4r|4'b1000;
            FA4b5b FA3 (a, b3, 1'b1, a3);
        end else begin
            assign a3 = a;
        end

        lshift l2 (b, 2'b10, b2);
        comp4 c2 (a, b2, s2);
        if (s2 == 2'b10) begin
            div4r = div4r | 4'b0100;
            FA4b5b FA2 (a3, b2, 1'b1, a2);
        end else begin
            assign a2 = a3;
        end

        lshift l1 (b, 2'b01, b1);
        comp4 c1 (a, b1, s1);
        if (s1 == 2'b10) begin
            div4r = div4r | 4'b0010;
            FA4b5b FA1 (a2, b1, 1'b1, a1);
        end else begin
            assign a1 = a2;
        end

        lshift l0 (b, 2'b00, b0);
        comp4 c0 (a, b0, s0);
        if (s0 == 2'b10) begin
            div4r = div4r | 4'b0001;
            FA4b5b FA0 (a1, b0, 1'b0, a0);
        end else begin
            assign a0 = a1;
        end
    endfunction

endmodule

module ff_test;
    reg [3:0] a,b;
    wire [7:0] s;

    MULTI4b8b M (a,b,s);

    initial begin;
        $dumpfile("multi.vcd");    // CKTKWave による波形表示のためのシミュレーション結果出力ファイル名指定
        $dumpvars(0);        // すべての信号を表示対象とするための設定
        $monitor("%4t a:%d b:%d s:%d", $time, a, b, s);    // 表示設定

        a = 4'b0000;
        b = 4'b0011;
        #10
        a = 4'b0110;
        b = 4'b0011;
        #10
        a = 4'b1001;
        b = 4'b0011;
        #10
        a = 4'b1100;
        b = 4'b1011;
        #10 $finish;
    end                // シミュレーションの終了指示
endmodule