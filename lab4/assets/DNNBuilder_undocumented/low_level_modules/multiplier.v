// Module declaration for a multiplier unit
module multiplier(
// Input clock signal for the module
	clk,
// Input data signal for the module
	d_i,
// Input weight signal for the module
	w_i,
// Output signal for the multiplication result
	m_o
	);
parameter C_WIDTH = 2; // data channel, set to 2 when using 8 bit 
// Setting the width for the input data to 8 bits.
parameter D_WIDTH = 8;
// Setting the width for the weight input to 16 bits.
parameter W_WIDTH = 16;
// Setting the width for the multiplier output to 32 bits.
parameter M_WIDTH = 32;
/* W_WIDTH should be 1/2/8/16 */
// Declaring the clock signal as an input.
input clk;
// Declaring the input data 'd_i' as a bus with a width of D_WIDTH.
input [D_WIDTH-1:0] d_i;
// Declaring the input width 'w_i' as a bus with a width of W_WIDTH.
input [W_WIDTH-1:0] w_i;
// Declaring the output port 'm_o' as a wire with a width of M_WIDTH.
output wire [M_WIDTH-1:0] m_o;
// Declaring the register 'm_o_reg' with a width of M_WIDTH to hold the output value.
reg  [M_WIDTH-1:0] m_o_reg;
// Defining a wire 'm_o_tmp' to temporarily hold the values before assigning it to the output register.
wire  [M_WIDTH-1:0] m_o_tmp;
// Defining a 24-bit wide wire 'w_i_tmp' to hold temporary values of input w_i during processing.
wire [23:0] w_i_tmp;
// Assigning w_i_tmp with a calculation that manipulates the bits of input w_i to generate the required temporary value.
assign w_i_tmp = {{w_i[15:8] + {8{w_i[7]}}},{8{w_i[7]}}, w_i[7:0]};
// Starting a generate block for conditional code generation based on the ratio of W_WIDTH to C_WIDTH.
generate 
// Case statement to handle different ratios of W_WIDTH to C_WIDTH.
case (W_WIDTH/C_WIDTH)
// Always block triggered at positive edge of clock for the case when ratio of W_WIDTH to C_WIDTH is 1.
	1: 	always @(posedge clk)
		begin
// If the least significant bit of w_i is 1, the one's complement of d_i is taken and incremented by 1. If not, the value of d_i is directly assigned to m_o_reg.
			m_o_reg <= w_i[0]?(~d_i[D_WIDTH-1:0]+1):D_WIDTH[D_WIDTH-1:0];
		end
// In case the ratio of word width to control width is 2, the following block will be triggered at the positive edge of the clock.
	2:  always @ (posedge clk)
        begin
// Assigning value to m_o_reg based on the value of w_i[1]. If it's true, invert d_i and add 1. If it's false, check w_i[0]. If w_i[0] is true, assign d_i, otherwise, assign a bit vector of 0s with length D_WIDTH.
			m_o_reg <= w_i[1]?(~d_i[D_WIDTH-1:0]+1):(w_i[0]?d_i[D_WIDTH-1:0]:{D_WIDTH{1'b0}});
        end
// Check if data width is 8, if so, start a block for signed multiplication.
	8:  if (D_WIDTH == 8) begin
// Instantiate the 24x8 signed multiplication module.
			mul24x8_signed u_mul24x8_signed (
// Connect the system clock to the module's clock input.
			.CLK(clk),
// Assigning the temporary input wire 'w_i_tmp' to the 'A' port of the multiplier module.
			.A(w_i_tmp),
// Assigning the lower 8 bits of the input data 'd_i' to the 'B' port of the multiplier module.
			.B(d_i[7:0]),
			.P(m_o_tmp) // output
			);
// Assign lower 16 bits of output to the lower 16 bits of temporary output
			assign m_o[15:0] = m_o_tmp[15:0];
// Assign upper 16 bits of output to the difference of the upper 16 bits of temporary output and sign extension of the 16th bit
			assign m_o[31:16] = m_o_tmp[31:16]-{16{m_o_tmp[15]}};
			end
// Else condition for when D_WIDTH is not equal to 8
		else 
// Initialize a 16x16 signed multiplier module when D_WIDTH is not 8
			mul16x16_signed u_mul16x16_signed (
			.CLK(clk),
// Passing the lower 16 bits of the input word to the multiplier module.
			.A(w_i[15:0]),
// Passing the lower 16 bits of the data input to the multiplier module.
			.B(d_i[15:0]),
// Assigning the output of the multiplier module to m_o.
			.P(m_o) // output
			);
// Default case: Instantiate the signed 16x16 multiplier module
	default: mul16x16_signed u_mul16x16_signed (
			.CLK(clk),
// Assigning lower 16 bits of w_i to input A of the multiplier.
			.A(w_i[15:0]),
// Assigning lower 16 bits of d_i to input B of the multiplier.
			.B(d_i[15:0]),
			.P(m_o) // output
			);
// End of case statement. This case statement is used to select the multiplier based on the W_WIDTH.
endcase
// Conditional check for W_WIDTH. If it's less than 3, then we start the generate block with label 'gen_mo'.
    if (W_WIDTH < 3) begin: gen_mo
// Assign the value of m_o_reg to m_o inside the generate block.
        assign m_o = m_o_reg;
// End of the conditional block checking if W_WIDTH is less than 3.
    end
// End of the generate construct which conditionally compiles hardware based on parameters.
endgenerate
// End of the module definition.
endmodule
