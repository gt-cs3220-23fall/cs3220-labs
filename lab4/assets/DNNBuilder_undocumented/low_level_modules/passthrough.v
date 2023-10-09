// Initiating the passthrough module with its parameters and inputs.
module passthrough(
// clk is the clock signal input to the module.
  clk,
// rst is the reset signal input to the module.
  rst,
// op_din_en is the enable signal for the input data.
  op_din_en,
// op_din_eop signifies the end of packet for input data.
  op_din_eop,
// op_din is the input data.
  op_din,
// op_dout is the output data.
  op_dout
);
// Sets the quantization parameter to 8.
parameter Q = 8;
// Sets the ReLU activation function parameter to 0, which means it is inactive.
parameter RELU = 0;
// Declares clk as an input, which will be used as the clock signal.
input clk;
// Declares rst as an input, which will be used as the reset signal.
input rst;
// Declares op_din_en as an input, which will be used as the enable signal for input data.
input op_din_en;
// Declares op_din_eop as an input, this is the signal to indicate the end of the package.
input op_din_eop;
// Declares op_din as an input with 16-bit width. This is the data input signal.
input [15:0] op_din;
// Declares op_dout as an output with 16-bit width. This is the data output signal.
output [15:0] op_dout;
// The output signal op_dout is assigned as the input signal op_din.
assign op_dout = op_din;
// End of the module definition.
endmodule
