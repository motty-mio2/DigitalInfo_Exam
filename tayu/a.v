module test(A,Y,VALID);
    input[3:0] A;
    output [1:0] Y;
    output VALID;

    function [1:0] encode;
        input [3:0] a;

        /*
        encode[1] = a[3] | a[2];
        encode[0] = (~a[2] & a[1]) | a[3];
        */

        encode = {a[3] | a[2], (~a[2] & a[1]) | a[3]};
    endfunction

    assign Y = encode(A);
    assign VALID = |A;
endmodule