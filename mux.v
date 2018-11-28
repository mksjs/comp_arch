module mux(in,sel,out);
	input [7:0] in;
	input [2:0] sel;
	output   out;
	
	assign out =in[sel];
endmodule

module tb;
	reg [7:0] in;
	reg [2:0] sel;
	wire  out;
	
	mux dut(in,sel,out);
		
	initial
		begin
			$dumpfile("mux.vcd");
			$dumpvars(0,tb);
			$monitor($time, " in=%b\tsel=%b\tout=%b",in,sel,out);
			
			#5 in=8'b10101011;sel=3'b0;
			#5 sel=3'b1;
			#5 sel=3'b11;
			#5 sel=3'b010;
			#5 $finish;
		end
endmodule

