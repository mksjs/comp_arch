module dff(d,clk,reset,q,qbar);
	input d,clk,reset;
	output reg q;
	output qbar;
	
	assign qbar=~q;
	
	always @(posedge clk or posedge reset)
		begin
			if(reset)
				q<=1'b0;
			else
				q<=d;
		end
endmodule

module tb;
	reg d,clk,reset;
	wire q,qbar;
	
	dff dut(d,clk,reset,q,qbar);
	
	always #5 clk=~clk;
		initial begin
		$dumpfile("dff.vcd");
		$dumpvars(0,tb);
		$monitor($time ," d=%b\tclk=%b\treset=%b\tq=%b\tqbar=%b",d,clk,reset,q,qbar);
		clk=1'b0;
		#3 reset =1'b1;d=1'b0;
		#5 reset =1'b0; d=1'b1;
		#5 d=1;
		#5 d=0;
		#5 d=1;
		#5 d=0;
		#5 $finish;
	end
endmodule
	
