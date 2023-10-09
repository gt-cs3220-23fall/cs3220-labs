// Start of 'busm2n' module definition.
module busm2n(
  clk,
  rst,
// Input data for the bus master to slave module.
  blob_din,
// Signal to indicate that the input data is ready.
  blob_din_rdy,
// Enable signal for input data.
  blob_din_en,
// End of Packet signal for input data.
  blob_din_eop,
// Output data.
  blob_dout,
// Indicates if output data is ready.
  blob_dout_rdy,
// Enables output data.
  blob_dout_en,
// Indicates the end of output data packet.
  blob_dout_eop
);
// Setting the width of the input data to 512 bits
parameter IN_WIDTH  = 512;
// Setting the width of the output data to 96 bits
parameter OUT_WIDTH = 96;
// Setting the total bits to be processed as 1536 bits
parameter COM_MUL   = 1536;
// Calculating the number of input data groups by dividing total bits with input width
parameter IN_COUNT  = COM_MUL / IN_WIDTH;
// Calculating the number of output data groups by dividing total bits with output width
parameter OUT_COUNT = COM_MUL / OUT_WIDTH;
// Setting N as 320, the significance of N depends on its use in the following code
parameter N         = 320;
//========================================
 //input/output  declare
 //========================================
input                                 clk;
input                                 rst;
// Data input with width defined by IN_WIDTH
input      [IN_WIDTH-1:0]             blob_din;
// Signal to indicate readiness of data input
output                                blob_din_rdy;
// Enable signal for data input
input                                 blob_din_en;
// End of Packet signal for data input
input                                 blob_din_eop;
// Data output of the blob module
output     [OUT_WIDTH-1:0]            blob_dout;
// Ready signal for data output of the blob module
input                                 blob_dout_rdy;
// Enable signal for data output of the blob module
output                                blob_dout_en;
// End of packet signal for data output of the blob module
output                                blob_dout_eop;
// Register to keep track of input data count
reg [15:0] din_cnt;
// Register to control automatic padding
reg auto_pad;
// Process triggered by rising edge of clock
always @ (posedge clk)
begin
// Check if reset is active
  if(rst)
// Reset the data input counter
    din_cnt <= 16'b0;
// Check if data is enabled or auto-padding is active.
  else if(blob_din_en | auto_pad)
    begin
// Check if input count has reached its limit
      if(din_cnt == IN_COUNT - 1)
// Reset the input count
        din_cnt <= 16'b0;
      else
// Increment the din_cnt if it's not reached IN_COUNT - 1
        din_cnt <= din_cnt + 1;
    end
  else
// Maintain the same count if conditions are not met.
    din_cnt <= din_cnt;
end
//auto_pad for shit register...
// Always block for the shift register, triggered on the rising edge of the clock.
always @ (posedge clk)
begin
// Checks if reset is active
  if(rst)
// Resets auto_pad when reset is active
    auto_pad <= 0;
// Checks if the data input count equals to the predefined IN_COUNT minus one
  else if(din_cnt == IN_COUNT - 1)
// Resets auto_pad to 0 when din_cnt equals to IN_COUNT - 1
    auto_pad <= 0;
// Sets auto_pad to 1 when both blob_din_en and blob_din_eop are active
  else if(blob_din_en & blob_din_eop)
    auto_pad <= 1;
  else
// Maintains the current state of auto_pad if none of the previous conditions are met.
    auto_pad <= auto_pad;
end
// Assigns the operation to blob_din_eop_pad, checks if either blob_din_eop or auto_pad are true, and if din_cnt equals to IN_COUNT minus one.
assign blob_din_eop_pad = (blob_din_eop | auto_pad) & (din_cnt == IN_COUNT - 1);
// Declaration of 16-bit register dout_cnt.
reg [15:0] dout_cnt;
// Declaration of 32-bit register dout_cnt_total.
reg [31:0] dout_cnt_total;
// Always block triggered on positive edge of the clock signal.
always @ (posedge clk)
begin
// Reset condition or when total counter reaches N-1, reset the output data counter
  if(rst | (dout_cnt_total == N-1))
// Reset the output data counter to zero
    dout_cnt <= 16'b0;
// Check if the output data enable signal is high
  else if(blob_dout_en)
    begin
// Checking if the data output count equals to the maximum count minus one
      if(dout_cnt == OUT_COUNT - 1)
// Reset the data output count to zero if it reaches the maximum
        dout_cnt <= 16'b0;
      else
// Increment the dout_cnt if conditions are not met for reset
        dout_cnt <= dout_cnt + 1;
    end
// In case none of the previous conditions are met, the dout_cnt value remains unchanged.
  else
    dout_cnt <= dout_cnt;
end
// Clock-driven always block for total data output count
always @ (posedge clk)
begin
// Check if reset is active
  if(rst)
// Reset the total count of data output
    dout_cnt_total <= 32'b0;
// Check if blob data output is enabled
  else if(blob_dout_en)
    begin
// Check if the total output data count reaches the pre-set value N-1
      if(dout_cnt_total == N-1)
// Reset the total output data count to zero when it reaches N-1
        dout_cnt_total <= 32'b0;
      else
// Increment the total data output counter if it's not reached the maximum count (N-1).
        dout_cnt_total <= dout_cnt_total + 1'b1;
    end
// In case the blob_dout_en is not enabled
  else
    dout_cnt_total <= dout_cnt_total;
end
// Declares a register 'din_tmp' with a width of 'COM_MUL' bits to temporarily store input data.
reg  [COM_MUL-1:0]  din_tmp;
// Starts the generate construct for creating conditional architecture according to the COM_MUL and IN_WIDTH comparison.
generate 
// Conditional generate block starts if COM_MUL equals IN_WIDTH.
  if (COM_MUL == IN_WIDTH) begin: gen_block
// Sequential logic block, activated on the rising edge of the clock.
    always @ (posedge clk)
        begin
// Checks if reset signal is active.
          if(rst)
// Resets din_tmp to 0 when reset is active.
            din_tmp <= 0;
// Assigns the value of blob_din to din_tmp if either blob_din_en or auto_pad is enabled.
          else if(blob_din_en | auto_pad)
            din_tmp <= blob_din;
// Check if blob_dout_en signal is high
          else if(blob_dout_en)
// Shift din_tmp right by OUT_WIDTH bits if blob_dout_en is high
            din_tmp <= (din_tmp >> OUT_WIDTH);
          else
// In all other cases, maintain the present state of din_tmp.
            din_tmp <= din_tmp;
        end
  end
// Start of the else branch where the operations are guided by the clock signal.
  else begin
// This block of code will execute at the positive edge of the clock signal.
    always @ (posedge clk)
        begin
// Reset condition, clears 'din_tmp' variable.
          if(rst)
// Resets 'din_tmp' to zero.
            din_tmp <= 0;
// Checks if either 'blob_din_en' or 'auto_pad' is high.
          else if(blob_din_en | auto_pad)
// Concatenate 'blob_din' and selected bits from 'din_tmp' to 'din_tmp'.
            din_tmp <= {blob_din, din_tmp[COM_MUL-1:IN_WIDTH]};
// Check if 'blob_dout_en' is true.
          else if(blob_dout_en)
// Shift 'din_tmp' right by 'OUT_WIDTH' bits.
            din_tmp <= (din_tmp >> OUT_WIDTH);
          else
// In all other cases, the current value of din_tmp is retained.
            din_tmp <= din_tmp;
        end
  end
// End of generate block, concludes the conditional generation of hardware blocks.
endgenerate
// Declaration of register to store the last value of the blob data input.
reg last_blob_din;
// This block of code is sensitive to the rising edge of the clock signal.
always @ (posedge clk)
begin
// Checks if reset is active
  if (rst)
// Sets last_blob_din to 0 if there is a reset
     last_blob_din <= 1'b0;
// If blob_din_en or auto_pad is true, control flow continues with the next statement
  else if (blob_din_en | auto_pad)
// Assign the padded end of packet signal to last_blob_din if blob_din_en or auto_pad is true
     last_blob_din <= blob_din_eop_pad;
  else
// Maintains the last value if no reset or valid input.
     last_blob_din <= last_blob_din;
end
// Declaration of register 'trunc_en' for truncation enable control.
reg trunc_en;
always @ (posedge clk)
begin
// Reset condition for trunc_en register
  if(rst)
// Sets trunc_en to 0 on reset
      trunc_en <= 1'b0;
// If blob_din_eop_pad is high, set trunc_en to false
  else if(blob_din_eop_pad)
      trunc_en <= 1'b0;
// If end of packet is detected and last data input is not set, enable truncation.
  else if(blob_dout_eop & (~last_blob_din))
      trunc_en <= 1'b1;
// In all other cases, retain the current value of trunc_en.
  else
      trunc_en <= trunc_en;
end
// Declaration of read/write select register.
reg read_write_sel;
// This block is triggered on the rising edge of the clock.
always @ (posedge clk)
begin
// Reset condition, read_write_sel is set to 0
  if(rst)
    read_write_sel <= 1'b0;
// Switch to write mode if input data is enabled, auto pad is active and input counter has reached its limit and trunc_en is inactive
  else if((blob_din_en | auto_pad) & (din_cnt == IN_COUNT-1) & (~trunc_en)) 
    read_write_sel <= 1'b1;
// Set read_write_sel to 0 when blob_dout_en is enabled and either dout_cnt equals OUT_COUNT-1 or dout_cnt_total equals N-1
  else if(blob_dout_en & ((dout_cnt == OUT_COUNT-1) | (dout_cnt_total == N-1)))
    read_write_sel <= 1'b0;
  else
// Preserve the current state if no conditions match
    read_write_sel <= read_write_sel;
end
// Assign blob_dout the least significant OUT_WIDTH bits from din_tmp
assign blob_dout = din_tmp[OUT_WIDTH-1:0];
// blob_din_rdy is high when read_write_sel is low and auto_pad is not engaged
assign blob_din_rdy = ~read_write_sel & (~auto_pad);
// blob_dout_en is high when read_write_sel is high and blob_dout_rdy is ready
assign blob_dout_en = read_write_sel & blob_dout_rdy;
// blob_dout_eop is high when blob_dout_en is high and dout_cnt_total equals (N-1)
assign blob_dout_eop = blob_dout_en & (dout_cnt_total == N-1);
endmodule
