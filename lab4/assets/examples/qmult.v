// Sets the time resolution and the time precision of the Verilog code.
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
 // Documentation by Yang (07/31/2023):
 // Verilog code for a purely combinational sign-magnitude fixed-point multiplier, assuming N total bits (including the sign bit), Q fractional bits, and with overflow handling. 
 //////////////////////////////////////////////////////////////////////////////////
module qmult #(
	//Parameterized values
	parameter Q = 15,
	parameter N = 32
	)
	(
// Input port for the first operand of the multiplication operation, represented in sign-magnitude fixed-point format.
	 input			[N-1:0]	i_multiplicand,
// Input port for the second operand of the multiplication operation, represented in sign-magnitude fixed-point format.
	 input			[N-1:0]	i_multiplier,
// Output port for the result of the multiplication operation, represented in sign-magnitude fixed-point format.
	 output			[N-1:0]	o_result,
// Output register for the overflow indicator. It is set to '1' if the multiplication results in an overflow.
	 output	reg				ovr
	 );
	 //	The underlying assumption, here, is that both fixed-point values are of the same length (N,Q)
 	 //		Because of this, the results will be of length N+N = 2N bits....
 	 //		This also simplifies the hand-back of results, as the binimal point 
 	 //		will always be in the same location...
	reg [2*N-1:0]	r_result;		//	Multiplication by 2 values of N bits requires a 
											//		register that is N+N = 2N deep...
// Register to hold the final computed result to be returned
	reg [N-1:0]		r_RetVal;
//--------------------------------------------------------------------------------
	assign o_result = r_RetVal;	//	Only handing back the same number of bits as we received...
											//		with fixed point in same location...
 //---------------------------------------------------------------------------------
	always @(i_multiplicand, i_multiplier)	begin						//	Do the multiply any time the inputs change
		r_result <= i_multiplicand[N-2:0] * i_multiplier[N-2:0];	//	Removing the sign bits from the multiply - that 
																					//		would introduce *big* errors	
		ovr <= 1'b0;															//	reset overflow flag to zero
		end
		//	This always block will throw a warning, as it uses a & b, but only acts on changes in result...
	always @(r_result) begin													//	Any time the result changes, we need to recompute the sign bit,
		r_RetVal[N-1] <= i_multiplicand[N-1] ^ i_multiplier[N-1];	//		which is the XOR of the input sign bits...  (you do the truth table...)
		r_RetVal[N-2:0] <= r_result[N-2+Q:Q];								//	And we also need to push the proper N bits of result up to 
																						//		the calling entity...
		if (r_result[2*N-2:N-1+Q] > 0)										// And finally, we need to check for an overflow
// Set overflow flag to one when there is an overflow
			ovr <= 1'b1;
		end
// End of the module
endmodule
