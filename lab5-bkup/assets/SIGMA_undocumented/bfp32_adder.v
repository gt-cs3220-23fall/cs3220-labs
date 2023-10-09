`timescale 1ns / 1ps
module adder32(clk, rst, A, B, O);
  input [31:0] A, B;
  input clk;
  input rst;
  output reg [31:0] O;
  wire a_sign;
  wire b_sign;
  wire [7:0] a_exponent;
  wire [7:0] b_exponent; 
  wire [23:0] a_mantissa; // plus one bit
  wire [23:0] b_mantissa; // plus one bit 
  reg o_sign;
  reg [7:0] o_exponent;
  reg [24:0] o_mantissa;  // plus two bits
  reg [31:0] adder_a_in;
  reg [31:0] adder_b_in;
  wire [31:0] adder_out;
  assign a_sign = A[31];
  assign a_exponent[7:0] = A[30:23];
  assign a_mantissa[23:0] = {1'b1, A[22:0]};
  assign b_sign = B[31];
  assign b_exponent[7:0] = B[30:23];
  assign b_mantissa[23:0] = {1'b1, B[22:0]};
  generalAdder gAdder (
    .a(adder_a_in),
    .b(adder_b_in),
    .out(adder_out)
  );
  assign adder_a_in = A;
  assign adder_b_in = B;
  always @ ( posedge clk ) begin
	if (rst == 1'b1) begin
		O = 32'd0;
	end else begin
		if ((a_exponent == 255 && a_mantissa[22:0] != 0) || (b_exponent == 0) && (b_mantissa[22:0] == 0)) begin
			o_sign = a_sign;
			o_exponent = a_exponent;
			o_mantissa = a_mantissa;
			O = {o_sign, o_exponent, o_mantissa[22:0]};
		end else if ((b_exponent == 255 && b_mantissa[22:0] != 0) || (a_exponent == 0) && (a_mantissa[22:0] == 0)) begin
			o_sign = b_sign;
			o_exponent = b_exponent;
			o_mantissa = b_mantissa;
			O = {o_sign, o_exponent, o_mantissa[22:0]};
		end else if ((a_exponent == 255) || (b_exponent == 255)) begin
			o_sign = a_sign ^ b_sign;
			o_exponent = 255;
			o_mantissa = 0;
			O = {o_sign, o_exponent, o_mantissa[22:0]};
		end else begin // Passed all corner cases
			o_sign = adder_out[31];
			o_exponent = adder_out[30:23];
			o_mantissa = adder_out[22:0];
			O = {o_sign, o_exponent, o_mantissa[22:0]};
		end
	end
  end  
endmodule