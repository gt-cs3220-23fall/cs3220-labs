// Documentation
 // The Verilog module 'vector_ave' performs vector averaging. In each clock cycle, the input data is multiplied with the fraction number. If enable is high, the multiplier output is added with the intermediate sum. Quantiation is achieved through truncating and rounding based on 'Q'. If 'RELU' is 1, the ReLU function is applied prior to the output.
 // The module takes in 1-bit 'clk' as clock signal and 1-bit 'rst' as synchronous active-high reset signal. It takes in 1-bit control signals 'op_din_en' as enable and 'op_din_eop' to indicate end of operation. 16-bit 'op_din' is the input data, and 16-bit 'fraction' is the input fraction number to be multiplied with input data.
 // The module produces 16-bit 'op_dout' as the averaged output.
module vector_ave(
  clk,
  rst,
  op_din_en,
  op_din_eop,
  op_din,
  fraction,
  op_dout
 );
//========================================
 //input/output  declare
 //======================================== 
input clk;
input rst;
input op_din_en;
input op_din_eop;
// 16-bit input data for operation
input [15:0] op_din;
// 16-bit input for fractional value
input [15:0] fraction;
// 16-bit output for result
output [15:0] op_dout; 
//========================================
 //parameter define                        
 //========================================
parameter RELU = 0;
//parameter FRACTION = 1000;
// Defines the precision parameter Q for fixed-point computations.
parameter Q = 8;
//========================================
 //call mul IP core : op_din[15:0] * FRACTION
 //========================================
// Declaring a 32-bit wire 'a1' to store the result of multiplication.
wire [31:0] a1;
// Instantiating the 'mul16_signed' module with instance name 'u_mul16_signed_1'.
mul16_signed u_mul16_signed_1 (
  .CLK(clk),
  .A(op_din),
  .B(fraction),
// Output of the multiplication operation is assigned to a1
  .P(a1)
);
//========================================
 //delay op_din_en 1 clock
 //========================================
reg op_din_en_d1;
// Triggered on every positive edge of the clock signal
always @ (posedge clk)
begin
// Check if reset is active
  if(rst)
// Reset op_din_en_d1 when reset is active
    op_din_en_d1 <= 1'b0;
  else
// Assign delayed op_din_en signal to op_din_en_d1 if not in reset state.
    op_din_en_d1 <= op_din_en;
end
//========================================
 //delay op_din_eop 2 clock
 //========================================
wire op_din_eop_d2;
delay #(2)u_delay_1(
  .clk(clk),
  .rst(rst),
  .in(op_din_eop),
  .out(op_din_eop_d2)
);
//========================================
 //accumulation with signal
 //========================================
// Declare an accumulator for the signal.
reg [31:0] sum;
// Operational block triggered at the rising edge of the clock.
always @ (posedge clk)
begin
// Reset condition, clear the accumulator sum
  if(rst)
// If reset is high, accumulator sum is reset to zero
    sum <= 32'b0;
// If end of packet signal and enable signal are high, accumulator is set to a1
  else if ((op_din_eop_d2 == 1) && (op_din_en_d1 == 1))
// Accumulator is set to the value of a1
    sum <= a1;
// If end of packet detected and data not enabled, reset sum
  else if ((op_din_eop_d2 == 1) && (op_din_en_d1 == 0))
    sum <= 32'b0;
// When 'op_din_eop_d2' is low and 'op_din_en_d1' is high, sum is incremented by 'a1'
  else if ((op_din_eop_d2 == 0) && (op_din_en_d1 == 1))
    sum <= sum + a1;
// Defaults to keep the current value of sum
  else  
    sum <= sum;	
end
// Declaring a 16-bit wire for temporary output.
wire [15:0] op_dout_tmp;
// Instantiating a bit_trunc module for bit truncation.
bit_trunc #(
// Setting the bit width of the bit truncation module to 32.
  .WIDTH(32),
// Defining the most significant bit of the bit truncation module.
  .MSB(Q+15),
// Defining the least significant bit of the bit truncation module.
  .LSB(Q)
) 
u_bit_trunc_2(
// Assigning the 'sum' as the data input to the bit truncation module
  .din(sum),
// Assigning the data output of the bit truncation module to 'op_dout_tmp'
  .dout(op_dout_tmp)
);
// Conditional assignment for 'op_dout' based on 'RELU' and 16th bit of 'op_dout_tmp'
assign op_dout = RELU ? (op_dout_tmp[15] ? 0 : op_dout_tmp) : op_dout_tmp;
endmodule
