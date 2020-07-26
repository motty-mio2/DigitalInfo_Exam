`timescale 1 ns / 1 ns

module HA (X, Y, S, C);
  inout X, Y;
  output S, C;
  reg S, C;

  always @ (*) begin
    #1
      S = X ^ Y;
      C = X & Y;
    end
endmodule

module FA (X, Y, C_in, S, C_out);
  input X, Y, C_in;
  output S, C_out;
  wire p, q, r;
  HA add0 (X, Y, p, q);
  HA add1 (p, C_in, S, r);
  assign C_out = q | r;
endmodule

module adder(X, Y, C_in, S, C_out);
  input [7:0] X;
  inout [7:0] Y;
  input C_in;
  output [7:0] S;
  output C_out;
  wire [6:0] r;
  FA add2 (X[0], Y[0], C_in, S[0], r[0]);
  FA add3 (X[1], Y[1], r[0], S[1], r[1]);
  FA add4 (X[2], Y[2], r[1], S[2], r[2]);
  FA add5 (X[3], Y[3], r[2], S[3], r[3]);
  FA add6 (X[4], Y[4], r[3], S[4], r[4]);
  FA add7 (X[5], Y[5], r[4], S[5], r[5]);
  FA add8 (X[6], Y[6], r[5], S[6], r[6]);
  FA add9 (X[7], Y[7], r[6], S[7], C_out);
endmodule

module multiplier (X, Y, Z);
  input [7:0] X,Y;
  output [15:0] Z;

  wire [7:0] a0;
  wire [7:0] a1;
  wire [7:0] a2;
  wire [7:0] a3;
  wire [7:0] a4;
  wire [7:0] a5;
  wire [7:0] a6;
  wire [7:0] b0;
  wire [7:0] b1;
  wire [7:0] b2;
  wire [7:0] b3;
  wire [7:0] b4;
  wire [7:0] b5;
  wire [7:0] b6;
  wire [7:0] c0;
  wire [7:0] c1;
  wire [7:0] c2;
  wire [7:0] c3;
  wire [7:0] c4;
  wire [7:0] c5;
  wire [7:0] c6;
  wire k, r0, r1, r2, r3, r4, r5, r6;
  assign k = 0;

    assign Z[0] = X[0] & Y[0];
    assign a0 = {k, X[7]&Y[0], X[6]&Y[0], X[5]&Y[0], X[4]&Y[0], X[3]&Y[0], X[2]&Y[0], X[1]&Y[0]};
    assign b0 = {X[7]&Y[1], X[6]&Y[1], X[5]&Y[1], X[4]&Y[1], X[3]&Y[1], X[2]&Y[1], X[1]&Y[1], X[0]&Y[1]};
    adder add10 (a0, b0, k, c0, r0);

    assign Z[1] = c0[0];
    assign a1 = {X[7]&Y[2], X[6]&Y[2], X[5]&Y[2], X[4]&Y[2], X[3]&Y[2], X[2]&Y[2], X[1]&Y[2], X[0]&Y[2]};
    assign b1 = {r0, c0[7], c0[6], c0[5], c0[4], c0[3], c0[2], c0[1]};
    adder add11 (a1, b1, k, c1, r1);

    assign Z[2] = c1[0];
    assign a2 = {X[7]&Y[3], X[6]&Y[3], X[5]&Y[3], X[4]&Y[3], X[3]&Y[3], X[2]&Y[3], X[1]&Y[3], X[0]&Y[3]};
    assign b2 = {r1, c1[7], c1[6], c1[5], c1[4], c1[3], c1[2], c1[1]};
    adder add12 (a2, b2, k, c2, r2);

    assign Z[3] = c2[0];
    assign a3 = {X[7]&Y[4], X[6]&Y[4], X[5]&Y[4], X[4]&Y[4], X[3]&Y[4], X[2]&Y[4], X[1]&Y[4], X[0]&Y[4]};
    assign b3 = {r2, c2[7], c2[6], c2[5], c2[4], c2[3], c2[2], c2[1]};
    adder add13 (a3, b3, k, c3, r3);

    assign Z[4] = c3[0];
    assign a4 = {X[7]&Y[5], X[6]&Y[5], X[5]&Y[5], X[4]&Y[5], X[3]&Y[5], X[2]&Y[5], X[1]&Y[5], X[0]&Y[5]};
    assign b4 = {r3, c3[7], c3[6], c3[5], c3[4], c3[3], c3[2], c3[1]};
    adder add14 (a4, b4, k, c4, r4);

    assign Z[5] = c4[0];
    assign a5 = {X[7]&Y[6], X[6]&Y[6], X[5]&Y[6], X[4]&Y[6], X[3]&Y[6], X[2]&Y[6], X[1]&Y[6], X[0]&Y[6]};
    assign b5 = {r4, c4[7], c4[6], c4[5], c4[4], c4[3], c4[2], c4[1]};
    adder add15 (a5, b5, k, c5, r5);

    assign Z[6] = c5[0];
    assign a6 = {X[7]&Y[7], X[6]&Y[7], X[5]&Y[7], X[4]&Y[7], X[3]&Y[7], X[2]&Y[7], X[1]&Y[7], X[0]&Y[7]};
    assign b6 = {r5, c5[7], c5[6], c5[5], c5[4], c5[3], c5[2], c5[1]};
    adder add16 (a6, b6, k, c6, r6);

    assign Z[7] = c6[0];
    assign Z[8] = c6[1];
    assign Z[9] = c6[2];
    assign Z[10] = c6[3];
    assign Z[11] = c6[4];
    assign Z[12] = c6[5];
    assign Z[13] = c6[6];
    assign Z[14] = c6[7];
    assign Z[15] = r6;
endmodule

module main (A, B, C, F, R, Z);
  input [7:0] A,B;
  input C, F, R;
  output [7:0] Z;

  wire [15:0] AN;
  reg [7:0] M;

  wire [7:0] target;

  assign target = R ? M : B;

  multiplier MU(A, target, AN);

  assign Z = C ? AN[15:8] : AN[7:0];

  always @ (*) begin
    if(F == 1'b1) begin
      M = Z;
    end
  end
endmodule

module MULTIPLIER_TEST;
  parameter CYCLE = 25;
  reg [7:0] X;
  reg [7:0] Y;
  reg C, F, R;
  wire [7:0] Z;
  main MAIN (X, Y, C, F, R, Z);
  initial
  begin
    $dumpfile("test.vcd");
    $dumpvars(0);
    $monitor("%4t X:%b Y:%b Z:%b",$time, X, Y, Z);
    #0
      C = 1;
      F = 0;
      R = 0;
      X = 0;
      Y = 0;
    #CYCLE	// 25 ns
      X = 1;
      Y = 11;
    #CYCLE	// 25 ns
      C = 0;
      X = 1;
      Y = 11;
    #CYCLE
      C = 1;
      F = 1;
      X = 53;
      Y = 78;
    #CYCLE
      C = 0;
      F=0;
      X = 53;
      Y = 78;
    #CYCLE
      R = 1;
      C = 1;
      X = 53;
      Y = 78;
    #CYCLE
      C = 0;
      X = 53;
      Y = 78;
    #CYCLE
      R = 0;
      C = 1;
      X = 255;
      Y = 255;
    #CYCLE
      C = 0;
      X = 255;
      Y = 255;
    #CYCLE
    $finish;
  end
endmodule
