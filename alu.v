module alu(a,b,op,carry,out);
	input [7:0] a,b;
	input [2:0] op;
	output reg [7:0]  out;
	output reg carry;

	parameter  ADD = 2'b00,SUB=2'b01, AND=2'b10,OR=2'b11;
	
	always @(*)
		begin
			case(op)
				ADD: {carry, out}=a+b;
				SUB: out =a-b;
				AND: out =a&b;
				OR:  out =a|b;
				default: out=~a;
			endcase
		end
endmodule

module tb;
	reg [7:0] a,b;
	reg [2:0] op;
	wire [7:0] out;
	wire carry;
	
	alu dut(a,b,op,carry,out);
	
	initial
		begin
			$dumpfile("alu.vcd");
			$dumpvars(0,tb);
			$monitor($time, " op=%b\ta=%b\tb=%b\tcarry=%b\tout=%b",op,a,b,carry,out);
			
			#5 a=8'b00001111; b=8'b00000001;op=0;
			#5 op=1;
			#5 op=10;
			#5 op=11;
			#5 op=100;
			#5 $finish;
		end
endmodule
	
