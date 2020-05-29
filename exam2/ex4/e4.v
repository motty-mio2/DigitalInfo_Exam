module FA (a,b,ci,s,co);
  input a,b,ci;
  output s,co;
  assign s = a^b^ci;
  assign co = a&b|b&ci|ci&a;
endmodule

`timescale 1 ns / 1 ns

module FA_TEST;
  reg a,b,ci;
  wire s,co;

  FA A(a,b,ci,s,co);
  initial begin
    $dumpfile("FA_TEST.vcd");
    $dumpvars(0);
    $monitor("%4t a:%b b:%b ci:%b co:%b s:%b ",$time, a,b,ci,co,s);

    a = 0;
    b = 0;
    ci = 0;

    #10 a = 1;
    #10 b = 1;
    #10 a = 0;
    #10 b = 0;
    #0 ci = 1;
    #10 a = 1;
    #10 b = 1;
    #10 a = 0;
    #10 $finish;
  end
endmodule