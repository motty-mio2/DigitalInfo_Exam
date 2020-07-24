`timescale 1 ms / 1 ms

module COUNT(CK,nRES,Z,Q);
	input CK,nRES,Z;
	output reg [3:0]Q;

	parameter IDLE = 1'b0;
    parameter RUN = 1'b1;

	reg [0:0] rSTATE;

	always @(posedge CK)
	begin
		if(!nRES)begin
			Q<=0;
		end else begin
		case(rSTATE)
			IDLE:
				if(Z==1)begin
					rSTATE<=RUN;
				end
			RUN:
				if(Z==1)begin
					rSTATE<=IDLE;
				end else if(Q==4'd9)begin
					Q<=0;
				end else begin
					Q<=Q+4'd1;
				end
			default:
				rSTATE<=IDLE;
		endcase
		end
	end
endmodule



module stopwatch_TEST;
	reg CK,nRES,Z;
	wire [3:0]Q;


	COUNT A(CK,nRES,Z,Q);

	initial begin
	$dumpfile("test.vcd");
	$dumpvars(0);
	$monitor("%4t CK:%b nRES:%b Z:%b Q:%b",$time, CK, nRES, Z, Q);

	CK=0;
	nRES=0;
	Z=0;
	#10 nRES=1;
	#14 Z=1;//スタートを押した
	#2 Z=0;
	#200 $finish;
	end

	always #5 CK=~CK;
endmodule



