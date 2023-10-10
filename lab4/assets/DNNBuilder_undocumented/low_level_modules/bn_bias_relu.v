// Documentation
 // The Verilog module 'bn_bias_relu' performs bias addition or batch normalization and applies ReLU activation function on the input and supports arbitrary quantization schemes. If 'BN' is 0, the module performs bias addition. If 'BN' is 1, the module performs batch normalization. If 'RELU' is 1, the ReLU acitivation function is applied to this intermediate value to producde the final output. Parameter definitions determine the fractional point position, and desired quantization is achieved through truncating and rounding.
 // The module takes in 1-bit 'clk' as clock signal and 1-bit 'rst' as synchronous active-high reset signal. It also takes in input data 'acc_in' with width 'ACC_WIDTH' and 'op_bias' with width 'BIAS_DW' that specifies the bias value.
 // The module produces 'op_dout' with width 'DOUT_DW' that represents the output with BN/bias and ReLU applied.
module bn_bias_relu(
  clk,
  rst,
  acc_in,
  op_bias,
  op_dout
);
//========================================
 //parameter define                        
 //========================================
// Defining a parameter RELU. If RELU is set to 1, the ReLU activation function is applied. In this case, it's set to 0, meaning ReLU activation function will not be applied.
parameter RELU = 0;
// Defining a parameter Q which is used to determine the fractional point position for quantization.
parameter Q = 8;
// Defining a parameter DIN_Q which is used to determine the fractional point position for input data quantization.
parameter DIN_Q = 6;
// Defining a parameter DOUT_DW which is used to set the output data width.
parameter DOUT_DW = 16;
// Defining a parameter DOUT_Q which is used to set the fractional point position for the output data.
parameter DOUT_Q = 6;
// Defining a parameter ACC_WIDTH which is used to set the width of the accumulator.
parameter ACC_WIDTH = 40;
// Defining a parameter BIAS_DW which sets the width of the bias.
parameter BIAS_DW = 16;
// Defining a parameter BN, which is used to control whether batch normalization is performed.
parameter BN = 0;
// Setting the scaling factor for batch normalization operation in fixed point format.
parameter BN_SCALE_Q = 13;
// Setting the quantization level for the bias in batch normalization operation.
parameter BN_BIAS_Q = 13;
// Setting the quantization level for the mid operation.
parameter MID_Q = 13;
//========================================
 //input/output  declare
 //========================================
input clk;
input rst;
// Input for the accumulated value with a width defined by ACC_WIDTH.
input [ACC_WIDTH-1: 0] acc_in;
// Input for the bias value with width defined by BIAS_DW.
input [BIAS_DW-1:0] op_bias;
// Output register for the processed data with width defined by DOUT_DW.
output reg[DOUT_DW-1:0] op_dout;
//========================================
 // BN or bias
 //========================================
// Temporary output wire for storing processed data before it is transferred to the output register.
wire [DOUT_DW-1:0] op_dout_tmp;
// The 'generate' keyword in Verilog is used for generating code based on parameterized values. It is used here to conditionally instantiate hardware blocks.
generate
  //Without BN, use bias
  if (BN == 0) begin: gen_block_without_bn
// Declaration of the register 'op_acc' with a width of 'ACC_WIDTH'.
    reg [ACC_WIDTH-1:0] op_acc;
// Always block triggered at the positive edge of clock cycle.
    always @ (posedge clk)
    begin
// Reset condition
      if(rst)
// Reset op_acc to zero
        op_acc <= {ACC_WIDTH{1'b0}};
      else
        op_acc <= acc_in + ({{(ACC_WIDTH-BIAS_DW){op_bias[BIAS_DW-1]}}, op_bias} << DIN_Q);  //bias with bw=BIAS_DW, Q=Q
    //acc_in with bw=ACC_WIDTH, Q=DIN_Q+Q(from weight)
     //op_acc with bw=ACC_WIDTH, Q=DIN_Q+Q
    end
// Instantiate bit truncation module to reduce the bit width of the accumulator output
    bit_trunc #(
// Enable rounding for bit truncation.
      .ROUND(1),
// Set the width of the bit truncation to ACC_WIDTH.
      .WIDTH(ACC_WIDTH),
// Setting the Most Significant Bit (MSB) of the truncation range.
      .MSB(Q+DIN_Q-DOUT_Q+DOUT_DW-1),
// Setting the Least Significant Bit (LSB) of the truncation range.
      .LSB(Q+DIN_Q-DOUT_Q)
    )
// Instantiate the bit truncation module for operation accuracy
    u0_bit_trunc(
// Input for the bit truncation module is op_acc
      .din(op_acc),
// Output from the bit truncation module is op_dout_tmp
      .dout(op_dout_tmp)
    );
// End of the block for the case when BN is not enabled
  end
  // With BN enable
  else begin: gen_block_with_bn
    wire[15:0] acc_mid; //with Q=MID_Q
    //assign acc_mid = acc_in[Q+DIN_Q-MID_Q+15: Q+DIN_Q-MID_Q];
// Calling bit truncation function with certain parameters for acc_mid
    bit_trunc #(
// Setting ROUND parameter to 0 for bit truncation
      .ROUND(0),
// Setting the WIDTH parameter to ACC_WIDTH for bit truncation
      .WIDTH(ACC_WIDTH),
// Setting the MSB to (Q+DIN_Q-MID_Q+15) for bit truncation
      .MSB(Q+DIN_Q-MID_Q+15),
// Setting the LSB to (Q+DIN_Q-MID_Q) for bit truncation
      .LSB(Q+DIN_Q-MID_Q)
    )
// Instantiate bit truncation module for accumulator input
    u1_bit_trunc(
// Set accumulator input as the input for bit truncation
      .din(acc_in),
// Output the truncated accumulator value to acc_mid
      .dout(acc_mid)
    );
    wire[15:0] bn_scale = op_bias[15:0];//with Q=BN_SCALE_Q
// Declaration of register for delayed bias
    reg[15:0] bn_bias_d1;
    always @ (posedge clk)
    begin
// Assigning the second half (16 bits) of op_bias to bn_bias_d1
        bn_bias_d1 <= op_bias[31:16];
    end
// Declaring a 32-bit wire 'acc_scaled' to store the scaled accumulator value.
    wire[31:0] acc_scaled;
// Instantiating the signed 16-bit multiplier module 'mul16_signed' named 'u_mul16_signed_bn'.
    mul16_signed u_mul16_signed_bn (
      .CLK(clk),
      .A(acc_mid),
      .B(bn_scale),
      .P(acc_scaled) //with 32bit, Q=MID_Q+BN_SCALE_Q
    );
// Declaration of a 32-bit register to store the output of the batch operation.
    reg[31:0] batch_out;
// Always block triggered on the positive edge of the clock signal.
    always @(posedge clk)
    begin
// Check if reset signal is active
      if (rst)
// If reset is active, clear the batch_out register
        batch_out <= 32'b0;
      else
// Scale the bias and add it to the accumulated value.
        batch_out <= acc_scaled + ({{16{bn_bias_d1[15]}}, bn_bias_d1} << (MID_Q+BN_SCALE_Q-BN_BIAS_Q));
    end    
// Instantiate bit truncation module to adjust the data width
    bit_trunc #(
    //  .WIDTH(ACC_WIDTH),
// Set rounding option for bit truncation
      .ROUND(1),
// Set the width of the truncation to 32 bits
      .WIDTH(32),
// Set the Most Significant Bit (MSB) of the truncation
      .MSB(MID_Q+BN_SCALE_Q-DOUT_Q+DOUT_DW-1),
// Set the Least Significant Bit (LSB) of the truncation
      .LSB(MID_Q+BN_SCALE_Q-DOUT_Q)
    )
// Instantiating the bit truncation module to reduce the bit width of batch_out
    u2_bit_trunc(
// Pass the batch_out as input to the bit truncation module
      .din(batch_out),
// Output of the bit truncation module is stored in op_dout_tmp
      .dout(op_dout_tmp)
    );
  end
endgenerate
//========================================
 //non-linearization deal
 //========================================
// Synchronous block triggered at the rising edge of the clock
always @(posedge clk)
begin
// Check if reset is active
  if (rst)
// If reset is high, output is set to zero
    op_dout <= {DOUT_DW{1'b0}};
  else 
// Apply ReLU non-linearization if RELU is high, else pass the output as is. If output is negative (determined by the MSB), zero is returned.
    op_dout <= RELU ? (op_dout_tmp[DOUT_DW-1] ? 0 : op_dout_tmp) : op_dout_tmp;
end
// End of the module.
endmodule
