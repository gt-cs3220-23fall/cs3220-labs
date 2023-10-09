// Start of the bus512ton module definition.
module bus512ton(
  clk,
  rst,
// Input data for the bus module
  blob_din,
// Signal indicating input data is ready
  blob_din_rdy,
// Signal to enable input data
  blob_din_en,
// Signal to indicate end of packet for input data
  blob_din_eop,
// Output data signal
  blob_dout,
// Output data ready signal
  blob_dout_rdy,
// Output data enable signal
  blob_dout_en,
// Output data end of packet signal
  blob_dout_eop
);
// Defines the width of the input data
parameter IN_WIDTH  = 512 ;
// Defines the width of the output data
parameter OUT_WIDTH = 32;
// Defines the number of data items to be processed
parameter COUNT     = 4;
// Defines the size of the memory block
parameter N         = 320;
//========================================
 //input/output  declare
 //========================================
// Declaration of the clock signal input
input                                 clk;
// Declaration of the reset signal input
input                                 rst;
// Declaration of the input data signal with a width specified by IN_WIDTH parameter
input      [IN_WIDTH-1:0]             blob_din;
// Declaration of the output signal indicating readiness of the input data
output                                blob_din_rdy;
// Declaration of the input signal to enable the input data
input                                 blob_din_en;
// Declaration of the input signal to indicate the end of packet for input data
input                                 blob_din_eop;
// Declaration of the output signal that will carry the processed data of width defined by OUT_WIDTH
output     [OUT_WIDTH-1:0]            blob_dout;
// Input signal that indicates whether the next module in the pipeline is ready to receive data
input                                 blob_dout_rdy;
// Output signal that indicates whether the current module has data available for output
output                                blob_dout_en;
// Output signal that indicates the end of output data packet from the current module
output                                blob_dout_eop;
// Register to hold the count of data output
reg [COUNT-1:0] dout_cnt;
// Register to hold the total count of data output
reg [31:0] dout_cnt_total;
// Always block triggered on every positive edge of the clock
always @ (posedge clk)
begin
// Check if reset signal is high or if total output data count has reached the maximum. If either condition is true, reset the output data count.
  if(rst | (dout_cnt_total == N-1))
// Reset the output data count to zero when reset signal is high or total output data count reaches the maximum.
    dout_cnt <= 0;
// Check if the output data enable signal is active.
  else if(blob_dout_en)
// Increment the output data counter if the output data enable signal is active.
    dout_cnt <= dout_cnt + 1'b1;
  else
// Maintains the current value of dout_cnt if conditions for reset or blob_dout_en are not met.
    dout_cnt <= dout_cnt;
end
// This block of procedural code is triggered on the rising edge of the clock signal.
always @ (posedge clk)
begin
// Check if the reset signal is high
  if(rst)
// If reset is high, set the total count of dout to 0
    dout_cnt_total <= 32'b0;
// Else, if blob_dout_en is enabled, go to the next set of conditions to update dout_cnt_total
  else if(blob_dout_en)
  begin
// Check if the total output data count has reached the limit (N-1). If true, reset the counter.
    if(dout_cnt_total == N-1)
// Reset the total output data count to zero when it reaches the limit.
      dout_cnt_total <= 32'b0;
    else
// Increment the total data output count when the total count is not yet N-1.
      dout_cnt_total <= dout_cnt_total + 1'b1;
  end
// In case of no reset or 'blob_dout_en' signal, the previous value of 'dout_cnt_total' is maintained.
  else
    dout_cnt_total <= dout_cnt_total;
end
// Declaring a register to store the status of the last data blob input.
reg last_blob_din;
// Begin sequential logic block, sensitive to positive edge of clock signal.
always @ (posedge clk)
begin
// Check if reset signal is high. If it is, reset the last_blob_din register.
  if (rst)
// In the case of a reset signal, set last_blob_din to 0.
     last_blob_din <= 1'b0;
// If blob_din_en signal is high, execute the following instructions.
  else if (blob_din_en)
// Assign the blob_din_eop value to last_blob_din when blob_din_en is high.
     last_blob_din <= blob_din_eop;
  else
// Maintains the previous state of last_blob_din if none of the conditions are met.
     last_blob_din <= last_blob_din;
end
// Declaration of the trunc_en register
reg trunc_en;
// A procedural block that gets triggered at the rising edge of the clock
always @ (posedge clk)
begin
// In case of reset, the trunc_en signal is set to zero.
  if(rst)
      trunc_en <= 1'b0;
// Check if there is an end of packet on the data input, if so, disable the truncation enable flag.
  else if(blob_din_eop)
// Disable the truncation enable flag when there's an end of packet on the data input.
      trunc_en <= 1'b0;
// Enable the truncation flag when there's an end of packet on the data output and not on the last data input.
  else if(blob_dout_eop & (~last_blob_din)) 
// Set truncation flag high under the given condition.
      trunc_en <= 1'b1;
// In all other cases, retain the previous value of trunc_en.
  else
      trunc_en <= trunc_en;
end
// Declaration of read/write select register.
reg read_write_sel;
// Always block triggered on positive edge of clock.
always @ (posedge clk)
begin
// Check if reset signal is active, if yes, set read_write_sel to 0
  if(rst)
    read_write_sel <= 1'b0;
// If the blob data input is enabled and truncation is not enabled, set the read-write selector to 1
  else if(blob_din_en & (~trunc_en))
    read_write_sel <= 1'b1;
// If blob_dout_en is enabled and either all bits of dout_cnt are 1 or dout_cnt_total equals N-1, read_write_sel is set to 0.
  else if(blob_dout_en & ((&dout_cnt)|(dout_cnt_total == N-1)))
    read_write_sel <= 1'b0;
// If none of the previous conditions are met, keep the current state of 'read_write_sel'.
  else
    read_write_sel <= read_write_sel;
end
// Define a register 'din_tmp' to hold temporary input data.
reg  [IN_WIDTH-1:0]  din_tmp;
// This block of code will be executed at the rising edge of the clock signal.
always @ (posedge clk)
begin
// Check if reset is active, if so, clear the din_tmp register
  if(rst)
// Reset din_tmp register to zero when reset is active
    din_tmp <= 0;
// Check if blob_din is enabled and truncation is not active. If so, get ready to update din_tmp with blob_din.
  else if(blob_din_en & (~trunc_en))
// Load blob_din into din_tmp. This occurs when blob_din is enabled and truncation is not active.
    din_tmp <= blob_din;
// Check if blob_dout is ready. If so, prepare to shift din_tmp right by OUT_WIDTH bits.
  else if(blob_dout_rdy)
// Shifts the din_tmp register right by OUT_WIDTH bits. This operation effectively divides the value of din_tmp by 2^OUT_WIDTH.
    din_tmp <= (din_tmp >> OUT_WIDTH);
// Fallback case, if none of the previous conditions are met, the value of din_tmp is simply preserved.
  else
    din_tmp <= din_tmp;
// End of always block which deals with conditions for din_tmp variable based on different conditions
end
// Assigning the least significant OUT_WIDTH bits of din_tmp to blob_dout
assign blob_dout = din_tmp[OUT_WIDTH-1:0];
// blob_din_rdy is true when read_write_sel is false
assign blob_din_rdy = ~read_write_sel;
// blob_dout_en is true when both read_write_sel is true and blob_dout_rdy is true
assign blob_dout_en = read_write_sel & blob_dout_rdy;
// blob_dout_eop is true when blob_dout_en is true and dout_cnt_total is equal to N-1
assign blob_dout_eop = blob_dout_en & (dout_cnt_total == N-1);
endmodule
