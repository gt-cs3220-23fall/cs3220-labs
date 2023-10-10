// Documentation
 // The Verilog module 'interlayer_sync_fifo' is a synchronous FIFO. 'distribute_ram' flag determines if distributed ram will be used as the memory for FIFO.
 // The module takes in 1-bit 'clk_i' as clock signal and 1-bit 'reset_i' as asynchronous active-high reset signal. It also takes in 1-bit 'w_en_i' as write enable, 'w_din_i' with width 'dw' as data input, and 1-bit 'r_en_i' as read enable.
 // The module produces 'w_num_used_o' with width 'aw+1' that indicates how many lines have been used, 'r_dout_o' with width dw as data output, 'r_num_val_o' with width 'aw+1' that indicates valid lines for read. It also produces 3 1-bit flag: 'afull_o' as almost full flag, 'full_o' as full flag, and 'empty_o' as empty flag.
`timescale 1ns/100ps
module interlayer_sync_fifo
(
	reset_i,
	clk_i,
	w_en_i,
	w_din_i,
	w_num_used_o,			// how many line has been used
// Read enable signal
	r_en_i,
// Read data output signal
	r_dout_o,
	r_num_val_o,			// how many line can be read
// Flag indicating FIFO is almost full
	afull_o,
// Flag indicating FIFO is full
	full_o,
// Flag indicating FIFO is empty
	empty_o
);
parameter aw = 3;           // FIFO depth is 2^aw lines
parameter dw = 8;           // FIFO width
parameter afull_t = 6;      // Almost full threshold
parameter distribute_ram = "false";     // If True, use distributed ram; If False, the compiler make the desision 
// Reset signal input
input					reset_i;
// Clock signal input
input					clk_i;
// Write enable input signal
input					w_en_i;
// Input data to be written into the FIFO
input	[dw-1:0]		w_din_i;
// Output that shows the number of used positions in the FIFO
output	[aw:0]			w_num_used_o;
// Read enable input signal
input					r_en_i;
// Read data output signal
output	[dw-1:0] 		r_dout_o;
// Number of valid data in read buffer
output	[aw:0]			r_num_val_o;
// Output indicating if FIFO is almost full
output					afull_o;
// Output indicating if FIFO is full
output					full_o;
// Output indicating if FIFO is empty
output					empty_o;
// Register to hold number of used words in write.
reg		[aw:0]			w_num_used_o;
// Register to hold number of valid words in read.
reg		[aw:0]			r_num_val_o;
// Wire to signal if the FIFO is full.
wire					full_o;
// Reg to signal if the FIFO is almost full.
reg						afull_o;
// Reg to signal if the FIFO is empty.
reg						empty_o;
// Reg to delay the write enable signal.
reg						w_en_dly;
// Wire for write address.
wire	[aw-1:0]		write_addr;
// Wire for read address.
wire	[aw-1:0]		read_addr;
// Register for read address.
reg		[aw-1:0]		raddr;
// Wire for the next read address.
wire	[aw-1:0]		raddr_next;
// Register for the current write address.
reg		[aw-1:0]		waddr;
// Wire for the next write address.
wire	[aw-1:0]		waddr_next;
// Assign the write address to the current write address.
assign	write_addr [aw-1:0]	= waddr [aw-1:0];
// Increment the current write address by 1 for the next write operation.
assign	waddr_next [aw-1:0]	= waddr [aw-1:0] + 1;
// Increment the current read address by 1 for the next read operation.
assign	raddr_next [aw-1:0]	= raddr [aw-1:0] + 1;
// Assign the next read address if read enable signal is high, else keep the current read address.
assign	read_addr [aw-1:0]	= r_en_i ? raddr_next [aw-1:0] : raddr [aw-1:0];  
// Process triggered at the rising edge of the clock signal.
always	@ (posedge clk_i)
// Assign the input write enable signal to the delayed version at the rising edge of the clock.
	w_en_dly	<= w_en_i;
// Begin a process triggered at the positive edge of either the clock or the reset signals.
always	@ (posedge clk_i or posedge reset_i)
begin
// Check if reset is active
	if (reset_i)
// Reset write address
		waddr	<= 0;
// If write enable input is high
	else if (w_en_i)
// Update write address to the next value
    	waddr 	<= waddr_next;
end
// Start of always block, triggered on rising edge of clock or reset signal
always	@ (posedge clk_i or posedge reset_i)
begin
// Check if reset is active
	if (reset_i)
// Reset read address to 0
		raddr	<= 0;
// Condition to update the read address
	else if (r_en_i)
// Update the read address to the next one
    	raddr 	<= raddr_next;
end
// Assign full_o signal based on the address width
assign	full_o = w_num_used_o [aw];
always	@ (posedge clk_i or posedge reset_i)
begin
// If reset is active, set empty_o to 1
	if (reset_i)
// Set empty_o to 1 on reset
		empty_o	<= 1;
// Condition when write enable delay is set
	else if (w_en_dly)
// Set empty flag to false when write enable delay is set
		empty_o	<= 0;
// Check if read enable is set and next read address equals write address
	else if (r_en_i & (raddr_next == waddr))
		empty_o <= 1;
end
// A new always block, sensitive to both clock and reset signals
always	@ (posedge clk_i or posedge reset_i)
begin
// Check if reset signal is high.
	if (reset_i)
// Set the used word counter to zero when reset is high.
		w_num_used_o	<= 0;
// If write enable is on, read enable is off, and the used word counter isn't full, increment the used word counter.
	else if (w_en_i & (~r_en_i) & (~w_num_used_o [aw]))
		w_num_used_o	<= w_num_used_o + 1'b1;
// Decrement w_num_used_o if read enable and not write enable when w_num_used_o is not zero
	else if (r_en_i & (~w_en_i) & (|w_num_used_o))
		w_num_used_o	<= w_num_used_o - 1'b1;
end
// Triggering a new logic block on either rising edge of clock or reset signal
always	@ (posedge clk_i or posedge reset_i)
begin
// Check reset signal, if active, clear read valid count
	if (reset_i)
// On reset, clear the read valid count
		r_num_val_o	<= 0;
// Increment read valid count if write enabled, read not enabled and read valid count not full
	else if (w_en_dly & (~r_en_i) & (~r_num_val_o [aw]))
		r_num_val_o	<= r_num_val_o + 1'b1;
// Check if r_en_i is high, w_en_dly is low, and r_num_val_o is not zero
	else if (r_en_i & (~w_en_dly) & (|r_num_val_o))
// Decrements r_num_val_o by 1 if the condition on line 87 is true
		r_num_val_o	<= r_num_val_o - 1'b1;
end
// Start of always block, executes at positive edge of clock or reset
always	@ (posedge clk_i or posedge reset_i)
begin
// Check if reset signal is active
	if (reset_i)
// Set 'afull_o' to 0 if reset is active
		afull_o		<= 0;
// Set 'afull_o' to 1 if FIFO is almost full and write is enabled
	else if ((w_num_used_o == (afull_t - 1)) & w_en_i & (~r_en_i))
		afull_o		<= 1;
// Reset afull_o if read enable is active and write enable is not active.
	else if ((w_num_used_o == afull_t) & r_en_i & (~w_en_i))
		afull_o		<= 0;
end
//----------------------------------------------------------------------------//
 //-------------------------------    RAM    ----------------------------------//
 //----------------------------------------------------------------------------//
// Declare register for storing read address
reg 	[aw-1:0]		addr_reg;
always @(posedge clk_i)
// Update address register with read address on clock's rising edge
	addr_reg <= read_addr;	
// Condition to generate distributed RAM if distribute_ram is set to true
generate if (distribute_ram == "true") begin : fifo_ram
// Define the distributed memory style register
(*ram_style="distributed"*)reg		[dw-1:0]		mem [(1<<aw)-1:0];
    always @(posedge clk_i)
// Check if write enable (w_en_i) is high
    if (w_en_i)
// If write enable is high, write input data (w_din_i) to memory at the write address
        mem[write_addr] <= w_din_i;
// Assign the data output (r_dout_o) to the memory content at the address register
    assign	r_dout_o = mem[addr_reg];
// Start of alternative block if distribute_ram is not true
end else begin
// Declare memory register array
    reg		[dw-1:0]		mem [(1<<aw)-1:0];
// Process triggered at positive edge of clock
    always @(posedge clk_i)
// Condition to check if write enable is high
    if (w_en_i)
// Writing input data into memory at write address
        mem[write_addr] <= w_din_i;
// Assigning the data at address register to output
    assign	r_dout_o = mem[addr_reg];
end
// End of generate block, concludes conditionally generated code.
endgenerate
// End of the Verilog module.
endmodule
