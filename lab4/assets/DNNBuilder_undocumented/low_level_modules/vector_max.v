// Documentation
 // The Verilog module 'vector_max' produces the maximum value among input data. A temporary max value is stored in 'op_dout_tmp'. In each clock cycle, if enable is high, the input data is compared with the temporary max and bigger value is kept. If 'RELU' is 1, the ReLU function is applied prior to the output.
 // The module takes in 1-bit 'clk' as clock signal and 1-bit 'rst' as synchronous active-high reset signal. It takes in 1-bit control signals 'op_din_en' as enable and 'op_din_eop' to indicate end of operation. 'op_din' of width 'DIN_W' is the input data.
 // The module produces 'op_dout' of width 'DIN_W' as the maximum output.
module vector_max(
        clk,
        rst,
        op_din_en,
        op_din_eop,
        op_din,
        op_dout
);
//========================================
 //parameter define                        
 //========================================
// Define the parameter 'RELU'. If 'RELU' is 1, it applies the ReLU function (max(0,x)) to the input before processing.
parameter RELU = 0;
// Define the parameter 'DIN_W' as the width (in bits) of the input data 'op_din'.
parameter DIN_W = 16;
// Define the parameter 'Q'. This is typically used for the fixed point precision of the data.
parameter Q = 8;
//========================================
 //input/output  declare
 //========================================
input clk;
input rst;
input op_din_en;
input op_din_eop;
// Declare input signal 'op_din' as a signed number with width defined by 'DIN_W'
input signed [DIN_W-1:0] op_din;
// Declare output signal 'op_dout' as a signed number with width defined by 'DIN_W'
output signed [DIN_W-1:0] op_dout; 
//========================================
 //delay op_din_eop 1 clock
 //========================================
reg op_din_eop_d1;
// This block is triggered at every rising edge of the clock
always @ (posedge clk)
begin
// Check if the reset signal is active
  if(rst)
// Reset op_din_eop_d1 signal to 0 when reset is active
    op_din_eop_d1 <= 1'b0;
  else
// If not in reset state, copy the current end of packet signal to the delayed signal
    op_din_eop_d1 <= op_din_eop;
end
//========================================
 //select max value with signal
 //========================================
reg signed [DIN_W-1:0] op_dout_tmp; 
always @ (posedge clk)
begin
// On reset, clear the temporary output variable to 0.
  if(rst)
// On reset, initialize temporary output register to all zeros.
    op_dout_tmp <= {DIN_W{1'b0}};
// If end of packet (eop) is detected and input is enabled, assign input to the temporary output.
  else if ((op_din_eop_d1 == 1'b1) && (op_din_en == 1'b1))
    op_dout_tmp <= op_din;
// When end of packet signal is high and enable signal is low, op_dout_tmp is assigned with a value where the most significant bit is 1 and rest bits are 0.
  else if ((op_din_eop_d1 == 1'b1) && (op_din_en == 1'b0))
    op_dout_tmp <= {1'b1, {(DIN_W-1){1'b0}}};
// If the end of operation signal is low and the enable signal is high, the register op_dout_tmp is updated with the larger value between the current value and the input data.
  else if ((op_din_eop_d1 == 1'b0) && (op_din_en == 1'b1))
    op_dout_tmp <= op_dout_tmp > op_din ? op_dout_tmp : op_din;
// In all other cases, keep the value of op_dout_tmp unchanged.
  else  
    op_dout_tmp <= op_dout_tmp;	
end
//========================================
 //non-linearization deal
 //========================================
// Assign the value of op_dout based on the RELU condition. If RELU is true and the most significant bit of op_dout_tmp is 1, assign 0 to op_dout. Otherwise, assign the value of op_dout_tmp to op_dout.
assign op_dout = RELU ? (op_dout_tmp[DIN_W-1] ? 0 : op_dout_tmp) : op_dout_tmp;
endmodule
