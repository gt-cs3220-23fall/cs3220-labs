// Documentation
 // Global: this module is used to achieve the quantization specification in AccDNN.
 // The Verilog module 'bit_trunc' represents a truncation module that truncates the input based on parameters 'MSB' and 'LSB'. If 'ROUND' equals 1, the module performs rounding. It also handles overflow/underflow situations by assigning output to the maximum/minimum possible value within the truncated range.
 // The module takes in 'din' of width 'WIDTH'.
 // The module produces 'dout' of width 'MSB-LSB+1'.
module bit_trunc(
          din,
          dout
    );
//========================================
 //parameter define                        
 //========================================
// Defining the width of the input data to be 16 bits.
	 parameter WIDTH = 16;
// Setting the most significant bit (MSB) to be at the 15th position.
	 parameter MSB   = 15;
// Setting the least significant bit (LSB) at the starting position.
	 parameter LSB   = 0;
// Parameter ROUND is set as 0, if it's set as 1 the module performs rounding.
     parameter ROUND = 0;
//========================================
 //input/output  declare
 //========================================
// Declaring 'din' as input with width 'WIDTH-1:0'.
   input      [WIDTH -1:0]    din ;
// Declaring 'dout' as output register with width 'MSB : LSB'.
   output reg [MSB : LSB]     dout;
//========================================
 //code begin here
 //========================================	 
// Declare 'din_tmp' as wire with width 'WIDTH' to hold temporary input data.
wire [WIDTH -1:0] din_tmp;	 
// Start generate block for conditionally assigning values to 'din_tmp' based on 'ROUND' and 'LSB'.
generate
// Check if 'ROUND' is 1 and 'LSB' is greater than 0, if true, the block 'round' begins.
  if (ROUND == 1 && LSB > 0) begin: round
// Assign 'din_tmp' based on 'din[LSB-1]'. If 'din[LSB-1]' is 1, add 1 to 'din', else keep 'din' unchanged.
    assign din_tmp = din[LSB-1] == 1'b1 ? din + {{(WIDTH-LSB-1){din[WIDTH-1]}},1'b1,{(LSB){1'b0}}} : din;
  end
// Start of else block, executed when ROUND is 0 or LSB is 0.
  else begin
// Assign the input din directly to din_tmp when not rounding.
    assign din_tmp = din;
  end
endgenerate
// Start of always block, defining behavior based on din_tmp value.
always@( * )
  begin
    if(din_tmp[WIDTH-1] == 1'b0 && ((|din_tmp[WIDTH-1 : MSB])) == 1'b1) //overflow	 
// Sets dout to 0 with remaining bits as 1 in case of overflow
      dout <= {1'b0, {(MSB - LSB){1'b1}}};
    else if(din_tmp[WIDTH-1] == 1'b1 && ((&din_tmp[WIDTH-1 : MSB])) == 1'b0) //underflow  
// Setting output to max negative value in case of underflow
      dout <= {1'b1, {(MSB - LSB){1'b0}}};
    else //without flow
// Assigning the bit range from MSB to LSB of din_tmp to dout in case of no overflow or underflow
      dout <= din_tmp[MSB : LSB];
  end
// End of module
endmodule
