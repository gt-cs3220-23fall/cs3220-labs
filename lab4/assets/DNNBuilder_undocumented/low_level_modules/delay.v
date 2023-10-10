// Documentation
 // The Verilog module 'delay' produces a certain number of clock cycles delay to an input signel 'in' based on parameter 'N', which determines the delay clock cycles. 1 ns as the time unit and 1 ps as the time precision are set for simulation.
 // The module takes in 1-bit 'clk' as clock signal and 1-bit 'rst' that is unused. 1-bit 'in' is the input signal to be delayed.
 // The module produces 1-bit 'out' as the delayed output signal.
`timescale 1ns / 1ps
// Definition of the module 'delay' with inputs 'clk', 'rst', 'in' and output 'out'.
module delay(clk,rst,in,out);
input clk;
input rst;
input in;
output out;
// Set delay parameter 'N' to 2. This will determine the clock cycle delay of the input signal.
parameter N = 2;
// Start of generate construct to create different delay blocks based on the value of parameter 'N'.
generate
// Starting of condition check for delay parameter 'N'. If 'N' equals 0, the delay block will directly assign the input to the output.
	if (N == 0) begin : gen_delay_block
// When 'N' equals 0 (no delay), the input 'in' is directly assigned to the output 'out'
		assign out = in;
	end
// If the delay parameter 'N' is 1, then create a register 'delay_line' and assign the input to it on every positive edge of the clock. The output is then assigned the value of 'delay_line'.
	else if (N == 1) begin
// Declare a register 'delay_line' for storing the input values. The 'mark_debug' attribute is used for easier debugging.
(*mark_debug="true"*)reg				delay_line;
// This line denotes a sensitivity list which triggers at the rising edge of the clock. It means this block of code will be executed at every positive edge of the clock.
		always @ (posedge clk)
		begin
// Assigning the input to the delay line on the rising edge of the clock.
			delay_line 	<= in;
		end
// Assigning the delay line output to the overall output in the case N equals 1.
		assign out = delay_line;
	end
// This block handles the case when N is greater than 1
	else begin
// Declaring the genvar i for the loop to create delay lines
		genvar i;
// Declaration of a register array named delay_line of size N
(*mark_debug="true"*)reg		[N-1:0]		delay_line;
		always @ (posedge clk)
		begin
// Assigning the input to the first position of the delay_line array
			delay_line [0]	<= in;
		end
// Starting a for loop to generate a delay line for each bit from 1 to N-1
		for (i=1; i < N; i=i+1) begin:gen_delay_line
			always @ (posedge clk)
			begin
// Shifts the previous delay line value to the current index at every clock cycle
				delay_line [i]	<= delay_line [i-1];
			end
// End of the for loop that generates the delay line
		end
// Assigning the last element of the delay line to the output
		assign	out = delay_line [N-1];
	end
// End of generate block which creates the delay line logic for each stage
endgenerate
// End of Verilog module defining the delay line
endmodule
