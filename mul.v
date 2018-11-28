

module MUL_datapath (eqz, ldA, ldB, ldP, clrP, decB, data_in, clk);
   input ldA, ldB, ldP, clrP, decB, clk;
   input [15:0] data_in;
   output 	eqz;
   wire [15:0] 	x, y, z, bout, bus;

   assign bus = data_in;
   
   PIPO1 A (x, bus, ldA, clk);
   PIPO2 P (y, z, ldP, clrP, clk);
   CNTR  B (bout, bus, ldB, decB, clk);
   ADD  AD (z, x, y);
   EQZ COMP(eqz, bout);
endmodule // MUL_datapath

module PIPO1 (dout, din, ld, clk);
   input [15:0] din;
   input 	ld, clk;
   output reg [15:0] dout;

   always @(posedge clk) begin
      if (ld) dout <= din;
   end
endmodule // PIPO1

module ADD (out, in1, in2);
   input [15:0] in1, in2;
   output reg [15:0] out;

   always @(*) begin
      out = in1 + in2;
   end
endmodule // ADD

module PIPO2 (dout, din, ld, clr, clk);
   input [15:0] din;
   input 	ld, clr, clk;
   output reg [15:0] dout;

   always @(posedge clk) begin
      if (clr) dout <= 16'b0;
      else if (ld) dout <= din;
   end
endmodule // PIPO2

module EQZ (eqz, data);
   input [15:0] data;
   output 	eqz;

   assign eqz = (data == 0); //not or reduction operator
endmodule // EQZ

module CNTR (dout, din, ld, dec, clk);
   input [15:0] din;
   input 	ld, dec, clk;
   output reg [15:0] dout;

   always @(posedge  clk) begin
      if (ld) dout <= din;
      else if (dec) dout <= dout - 1;
   end
endmodule // CNTR

module controller (ldA, ldB, ldP, clrP, decB, done, clk, eqz, start);
   input clk, eqz, start;
   output reg ldA, ldB, ldP, clrP, decB, done;

   reg [2:0]  state;
   parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100;

   always @(posedge clk) begin
      case (state)
	S0: if (start) state <= S1;
	S1: state <= S2;
	S2: state <= S3;
	S3: #2 if (eqz) state <= S4;
	S4: state <= S4;
	default: state <= S0;
      endcase // case (state)
   end

   always @(state) begin
      case (state)
	S0: begin #1 ldA=0; ldB=0; ldP=0; clrP=0; decB=0; end
	S1: begin #1 ldA=1; end
	S2: begin #1 ldA=0; ldB=1; clrP=1; end
	S3: begin #1 ldB=0; ldP=1; clrP=0; decB=1; end
	S4: begin #1 done=1; ldP=0; decB=0; end
	default: begin #1 ldA=0; ldB=0; ldP=0; clrP=0; decB=0; end
      endcase // case (state)
   end
endmodule // controller

module MUL_test;
   reg [15:0] data_in;
   reg 	      clk, start;
   wire       done;

   MUL_datapath DP (eqz, ldA, ldB, ldP, clrP, decB, data_in, clk);
   controller  CON (ldA, ldB, ldP, clrP, decB, done, clk, eqz, start);

   initial begin
      clk = 1'b0;
      #3 start = 1'b1;
      #500 $finish;
   end

   always #5 clk = ~clk;

   initial begin
      #17 data_in = 17;
      #10 data_in = 5;
   end

   initial begin
      $monitor("%2d\tclk=%b, DP.x=%d, DP.y=%d, DP.z=%d, done = %b, ldA=%b, ldB=%b, ldP=%b, clrP=%b, decB=%b, data_in=%d, eqz=%b", 
	      $time, clk, DP.x, DP.y, DP.z, done, ldA, ldB, ldP, clrP, decB, data_in, eqz);
      $dumpfile("multiplier.vcd");
      $dumpvars(0, MUL_test);
   end

endmodule // MUL_test



