module dlatch(d,en,reset,q,qbar);
	input d,en,reset;
	output reg q;
	output qbar;
	
	assign qbar = ~q;
	
	always @(d,en,reset)
		begin
			if(reset)
				q=1'b0;
			else
				q=d;
		end
endmodule
	
module tb;
	reg d,en,reset;
	wire q,qbar;
	
	dlatch dut(d,en,reset,q,qbar);
	
	initial
		begin
			$dumpfile("dlatch.vcd");
			$dumpvars(0,tb);
			$monitor($time, " d=%b\ten=%b\treset=%b\tq=%b\tqbar=%b",d,en,reset,q,qbar);
			#5 en =1'b0;reset=1'b0;d=1'b1;
			#5 en =1'b1; d=1'b0;
			#5 d =1;
			#5 d =0;
			#5 d =1;
			#5 d =0;
			#5 $finish;
			
		end
	
endmodule
