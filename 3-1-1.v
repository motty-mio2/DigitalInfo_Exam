module sample3_1(Y,A,B,S);
    input A,B,S;
    output Y;
    assign Y = A & B | B & !S;
endmodule