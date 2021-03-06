`timescale 1ns / 1ns // `timescale time_unit/time_precision

module CNT_Display (SW, HEX0, CLOCK_50);
	input [9:0] SW;
	input CLOCK_50;
	output [6:0] HEX0;
	wire [3:0] w;
	wire clk_w;
	
	RateDivider w1 (
			.clk_in(CLOCK_50),
			.clk_out(clk_w),
			.s0 (SW[0]),
			.s1 (SW[1])
			);
	
	DisplayCounter u0 (
			.clock(clk_w),
			.Clear_b(1),
			.Enable(1),
			.ParLoad(0),
			.d(4'b0000),
			.q(w)
			);
	
	hex_decoder hex0  (
			.data(w),
			.segments(HEX0)
			);
endmodule

module RateDivider (clk_in, clk_out, s0, s1);
	input clk_in;
	output reg clk_out;
	input s0, s1;
	reg q;
	
	always @(*)
	begin
		case ({s0,s1})
			2'b00: q = 0; 
			2'b01: q = 50000000; 
			2'b10: q = 2*50000000; 
			2'b11: q = 4*50000000; 
			default: q = 0;
		endcase
	end
	
	
	always @(posedge clk_in)
	begin 
		q <= q - 1;
		assign clk_out = (q == 0)?1:0;
	end

endmodule

module DisplayCounter (clock, Clear_b, q, Enable, ParLoad, d);
	input clock;
	input ParLoad;
	input Clear_b;
	input Enable;
	output reg [3:0] q = 1'b0000; 
	input [3:0] d; 
	always @(posedge clock) 
	begin
		if (Clear_b == 1'b0) 
			q <= 0; 
		else if (ParLoad == 1'b1) 
			q <= d; 
		else if (q == 4'b1111) 
			q <= 0;
		else if (Enable == 1'b1) 
			q <= q + 1;
	end
endmodule


module hex_decoder(data, segments);
	input [3:0] data;
	output [6:0] segments;
	reg [6:0] segments;

	parameter BLANK = 7'b111_1111; 
	parameter ZERO = 7'b100_0000; 
	parameter ONE = 7'b111_1001; 
	parameter TWO = 7'b010_0100; 
	parameter THREE = 7'b011_0000; 
	parameter FOUR = 7'b001_1001; 
	parameter FIVE = 7'b001_0010; 
	parameter SIX = 7'b000_0010; 
	parameter SEVEN = 7'b111_1000; 
	parameter EIGHT = 7'b000_0000; 
	parameter NINE = 7'b001_0000; 
	parameter A = 7'b000_1000;
	parameter B = 7'b000_0011;
	parameter C = 7'b100_0110;
	parameter D = 7'b010_0001;
	parameter E = 7'b000_0110;
	parameter F = 7'b000_1110;
	always @(*)
	begin
		case (data)
			4'b0000: segments <= ZERO;
			4'b0001: segments <= ONE;
			4'b0010: segments <= TWO;
			4'b0011: segments <= THREE;
			4'b0100: segments <= FOUR;
			4'b0101: segments <= FIVE;
			4'b0110: segments <= SIX;
			4'b0111: segments <= SEVEN;
			4'b1000: segments <= EIGHT;
			4'b1001: segments <= NINE;
			4'b1010: segments <= A;
			4'b1011: segments <= B;
			4'b1100: segments <= C;
			4'b1101: segments <= D;
			4'b1110: segments <= E;
			4'b1111: segments <= F;
			default: segments <= BLANK;
		endcase
	end
endmodule

module mux4to1 (s1,s0,m);
	input s1;
	input s0;
	output m;
	
endmodule
