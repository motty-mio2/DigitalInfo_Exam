`default_nettype none

module latch(G,D,Q);
    input G,D;
    output Q;
    reg Q;

    always @ (G or D)
    if(G)
        Q = D;
endmodule