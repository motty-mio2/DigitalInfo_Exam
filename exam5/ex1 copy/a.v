
module comp2(A,M);
    input [7:0] A;
    output [7:0] M;

    assign M = ~A+1;
endmodule

module comp2_test;
    reg [7:0] A;
    wire [7:0] M;
    integer i;

    comp2 c (A,M);

    initial begin;
        $dumpfile("comp_2.vcd");
        $dumpvars(0);
        $monitor("%4t A:%b M:%b", $time, A, M);


        for(i=-63; i<65; i=i+1)
        begin
             #1 A=i;

        end

        #1 $finish;
    end                // シミュレーションの終了指示

endmodule
