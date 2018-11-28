module mealey(x,reset,clk,y);
	input x,reset,clk;
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
			A:	begin
					y = 0;
					ns = x ? B : A;
				end
			B:	begin
					y=0;
					ns = x ? B : C;
				end
			C:	begin
					y=0;
					ns = x ? D : A;
				end
			D:	begin
					y = x ? 0 : 1;
					ns = x ? B: E;
				end
			E:	begin
					y=0;
					ns = x ? D : A;
				end
			default: ps=A;
		endcase
	end
endmodule

module TestMileyMachine;
	reg in,CLK, RESET;
	wire Out;
	mealey dut(.x(in), .clk(CLK), .reset(RESET), .y(Out));
	initial
	begin
		$dumpfile("mealey.vcd"); $dumpvars(0,TestMileyMachine);
		$display("\nThe mealey Machine to check the sequence 1010");
	end
	always #5 CLK=~CLK;
	initial
	begin
		$monitor($time, "\tRESET=%b\tCLK=%b\tINP=%b\tOUT=%b",RESET,CLK,in,Out);
		RESET=1; CLK=0;
		#12 RESET=0;
		 #8 in=1; #10 in=0; #10 in=1; #10 in=0;
		#10 in=0; #10 in=1; #10 in=0; #10 in=1;
		#10 in=0; #10 in=1; #10 in=0; #10 in=0;
		#10 $finish;
	end
endmodule

