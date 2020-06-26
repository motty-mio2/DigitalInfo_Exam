module HA (a,b,c,s);
  input a,b;
  output s,c;
  assign s = a^b;
  assign c = a&b;
endmodule

module FA (a,b,ci,co,s);
  input a,b,ci;
  output s,co;
  assign s = a^b^ci;
  assign co = a&b|b&ci|ci&a;
endmodule

module calc3(a,b,o,s,c);
    input [2:0] a,b;
    input s, c;
    output [5:0] o;
    wire t,u,v,w,x;
    wire [2:0] M;

    always @*
    if(c) begin
        assign M = ~b+1;
        assign b = M;
    end

    assign o = 0;

    if(s) begin
        assign o[0] = a[0]&b[0];
        HA h1 (a[1]&b[0],a[0]&b[1],o[1],t);
        FA f1 (a[2]&b[0],a[1]&b[1],a[0]&b[2],u,v);
        HA h2 (v,t,o[2],w);
        HA h3 (a[2]&b[1],a[1]&b[2], t, v);
        FA f2 (t,u,w,o[3],x);
        FA f3 (a[2]&b[2],v,x,o[4],o[5]);
    end else begin
        HA h1 (a[0],M[0],t,o[0]);
        FA f1 (a[1],M[1],t,u,o[1]);
        FA f1 (a[2],M[2],u,o[3],o[2]);
    end
endmodule

/*
module comp2_test;
    input [2:0] a,b;
    input [1:0] s;
    output [5:0] o;

    calc3 c (a,b,o,s);

    initial begin;
        $dumpfile("calc3.vcd");
        $dumpvars(0);
        $monitor("%4t a:%b b:%b o:%b s:%b", $time, a, b, o, s);

        s = 0;
        a = 3'b001;
        b = 3'b010;

        #1 $finish;
    end                // シミュレーションの終了指示

endmodule
*/