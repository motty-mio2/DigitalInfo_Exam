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

module FA4b4b (a, b, mo, c);
    input [3:0] a,b;
    input mo;
    //0:plus, 1:minus
    output [3:0] c;
    wire c1,c2,c3,c4;

    FA f1 (a[0], b[0]^mo, mo, c[0], c1);
    FA f2 (a[1], b[1]^mo, c1, c[1], c2);
    FA f3 (a[2], b[2]^mo, c2, c[2], c3);
    FA f4 (a[3], b[3]^mo, c3, c[3], c1);
endmodule

module ALU (a, b, f, y);
    input [3:0] a,b;
    input [4:0] f;
    output [3:0] y;
    wire [3:0] c;

    assign y = mainALU(a,b,f);

    function [3:0] mainALU;
        input[3:0] a,b;
        input [4:0] f;

        if(f==5'b00010) begin
            mainALU = (a+b);
        end else if(f==5'b00011) begin
            mainALU = (a-b);

        end else if(f==5'b01000) begin
             mainALU = a&b;
        end else if(f==5'b01100) begin
            mainALU = a|b;

        end else if(f==5'b00000) begin
            mainALU = {1'b0, a[3:1]};
        end else if(f==5'b10000) begin
            mainALU = {a[2:0], 1'b0};

        end else begin
            mainALU = 4'b0000;
        end
    endfunction
endmodule


module fa4b4b_test;
    reg [3:0] a, b;
    reg m;
    wire [3:0] c;

    FA4b4b f44 (a,b,m,c);

    initial begin;
        $dumpfile("div.vcd");    // CKTKWave による波形表示のためのシミュレーション結果出力ファイル名指定
        $dumpvars(0);        // すべての信号を表示対象とするための設定
        $monitor("%4t a:%d b:%d m:%d c:%d", $time, a, b, m, c);    // 表示設定

        m=1'b1;
        a = 4'b1111;
        b = 4'b0001;
        #10
        a = 4'b1111;
        b = 4'b0010;
        #10
        a = 4'b1111;
        b = 4'b0011;
        #10
        a = 4'b1111;
        b = 4'b1100;
        #10 $finish;
    end                // シミュレーションの終了指示
endmodule

