module moore(x,clk,reset,y);
	input x,clk,reset;
	output reg y;
	parameter A=0, B=1, C=2, D=3, E=4;
	reg [2:0] ps,ns;
	always@(posedge clk, posedge reset)
	begin
		if(reset)
			ps <= A;
		else
			ps <= ns;
	end

	always@(ps,x)
	begin
		case(ps)
			A: ns = x ? B : A;
			B: ns = x ? B : C;
			C: ns = x ? D : A;
			D: ns = x ? B : E;
			E: ns = x ? D : A;
			default: ps = A;
		endcase
	end

	always@(ps)
	begin
		case(ps)
			A: y=0;
			B: y=0;
			C: y=0;
			D: y=0;
			E: y=1;
		endcase
	end
endmodule

module TestMooreMachine;
	reg x,clk,reset;
	wire y;
	moore dut(.x(x), .clk(clk), .reset(reset), .y(y));
	initial
	begin
		$dumpfile("moore.vcd"); 
		$dumpvars(0,TestMooreMachine);
		$display("\nThis machine is check the sequence of 1010");
	end
	always #5 clk=~clk;
	initial
	begin
		$monitor($time, "\tReset=%b  X=%b  PS=%b  NS=%b  Y=%b", reset, x, dut.ps, dut.ns, y);
		#10 clk=1'b0; reset=1'b1;
		#12 reset=1'b0;
		 #8 x=1; #10 x=0; #10 x=1; #10 x=0;
		#10 x=0; #10 x=0; #10 x=1; #10 x=0;
		#10 x=1; #10 x=0; #10 x=1; #10 x=0;
		#10 x=1; #10 x=0;
		#10 $finish;
	end
endmodule
