`timescale 1ns / 1ps
module benes # (
	parameter DATA_TYPE = 16, // data type
	parameter NUM_PES = 8, // num of pes
	parameter LEVELS = 7) ( // 2*(log2PE) + 1
	clk,
	rst,
	i_data_bus, // input data bus
	i_mux_bus, // mux select control bus
	o_dist_bus // output bus to the multipliers
);
	input clk;
	input rst;
	input [NUM_PES * DATA_TYPE -1 : 0] i_data_bus; // input data bus
	input [2*(LEVELS-2)*NUM_PES + NUM_PES-1 : 0] i_mux_bus; // mux select bus
	output reg [NUM_PES * DATA_TYPE -1 : 0] o_dist_bus; // output distribution bus
	reg [NUM_PES * DATA_TYPE -1 : 0] r_data_bus_ff; // FF version of input data bus
	reg [2*(LEVELS-2)*NUM_PES + NUM_PES-1 : 0] r_mux_bus_ff; // FF version of mux select bus
	wire [NUM_PES * DATA_TYPE -1 : 0] w_dist_bus; // wire to be FF to o_dist_bus
	wire [DATA_TYPE-1 : 0] w_internal [2*NUM_PES*(LEVELS-1)-1:0]; // internal wire 
	always @ (*) begin // Fix: latched rather than FF (timing fix)
		if (rst == 1'b1) begin
			r_data_bus_ff <= 'd0;
		end else begin
			r_data_bus_ff <= i_data_bus;
		end
	end
	always @ (posedge clk) begin
		if (rst == 1'b1) begin
			r_mux_bus_ff <= 'd0;
			o_dist_bus <= 'd0;
		end else begin
			r_mux_bus_ff <= i_mux_bus;
			o_dist_bus <= w_dist_bus;		
		end
	end
	genvar i, j; 
	generate
		for (i=0; i<NUM_PES; i=i+1) begin : in_switch
			input_switch #(.WIDTH(DATA_TYPE)) in_switch (
				.y(w_internal[2*i*(LEVELS-1)]), // horizontal output of switch to w_internal
				.z(w_internal[2*i*(LEVELS-1)+1]), // diagonal output of switch to w_internal
				.in(r_data_bus_ff[(i+1)*DATA_TYPE-1:i*DATA_TYPE])
			);
		end
	endgenerate
	generate
		for (i=0; i<NUM_PES; i=i+1) begin : out_switch
			if (i % 2 == 0) begin : from_nw // input diagonal link from south-west switch, should always be horizontal
				output_switch  #(.WIDTH(DATA_TYPE))  out_switch (
					.y(w_dist_bus[i*DATA_TYPE+DATA_TYPE-1 : i*DATA_TYPE]), // to output dist bus
					.in0(w_internal[2*i*(LEVELS-1)+(2*(LEVELS-2))]), // connect from the horizontal switch
					.in1(w_internal[2*(i+1)*(LEVELS-1)+(2*(LEVELS-2))+1]), // connect from the south-west diagonal switch
					.sel(r_mux_bus_ff[2*NUM_PES*(LEVELS-2)+i]) // mux select bit
				);
			end else begin : from_sw // input diagonal link from north-west switch
				output_switch  #(.WIDTH(DATA_TYPE))  out_switch (
					.y(w_dist_bus[i*DATA_TYPE+DATA_TYPE-1 : i*DATA_TYPE]), // to output dist bus
					.in0(w_internal[2*i*(LEVELS-1)+(2*(LEVELS-2))]), // connect from the horizontal switch
					.in1(w_internal[2*(i-1)*(LEVELS-1)+(2*(LEVELS-2))+1]), // connect from the north-west diagonal switch
					.sel(r_mux_bus_ff[2*NUM_PES*(LEVELS-2)+i]) // mux select bit
				);
			end
		end
	endgenerate 
	generate
		for (i=0; i<NUM_PES; i=i+1) begin :mid_switch_y
			for (j=1; j<=(LEVELS-2); j=j+1) begin: mid_switch_x
				if (j <= (LEVELS-1)/2 ) begin : mid_and_left 
					if (i % (2**j) < (2**(j-1))) begin : from_sw // input diagonal link from south-west switch
						switch  #(.WIDTH(DATA_TYPE))  imm_switch (
							.y(w_internal[2*i*(LEVELS-1)+2*j]), // horizontal output of switch to w_internal
							.z(w_internal[2*i*(LEVELS-1)+2*j+1]), // diagonal output of switch to w_internal
							.in0(w_internal[2*i*(LEVELS-1)+2*(j-1)]), // connect from the horizontal switch
							.in1(w_internal[2*(i+(2**(j-1)))*(LEVELS-1)+2*(j-1)+1]), // connect from a diagonal switch
							.sel0(r_mux_bus_ff[2*(LEVELS-2)*i+(2*(j-1))]), // mux select bit
							.sel1(r_mux_bus_ff[2*(LEVELS-2)*i+(2*(j-1)+1)]) // mux select bit
						);
					end else begin : from_nw // input diagonal link from north-west switch
						switch  #(.WIDTH(DATA_TYPE))  imm_switch (
							.y(w_internal[2*i*(LEVELS-1)+2*j]),  // horizontal output of switch to w_internal
							.z(w_internal[2*i*(LEVELS-1)+2*j+1]), // diagonal output of switch to w_internal
							.in0(w_internal[2*i*(LEVELS-1)+2*(j-1)]), // connect from the horizontal switch
							.in1(w_internal[2*(i-(2**(j-1)))*(LEVELS-1)+2*(j-1)+1]), // connect from a diagonal switch
							.sel0(r_mux_bus_ff[2*(LEVELS-2)*i+(2*(j-1))]), // mux select bit
							.sel1(r_mux_bus_ff[2*(LEVELS-2)*i+(2*(j-1)+1)]) // mux select bit
						);
					end
				end else begin : right_of_mid
					if (i % (2**(LEVELS-j)) < (2**(LEVELS-j-1))) begin : from_sw // input diagonal link from south-west switch 
						switch  #(.WIDTH(DATA_TYPE))  imm_switch (
							.y(w_internal[2*i*(LEVELS-1)+2*j]), // horizontal output of switch to w_internal
							.z(w_internal[2*i*(LEVELS-1)+2*j+1]), // diagonal output of switch to w_internal
							.in0(w_internal[2*i*(LEVELS-1)+2*(j-1)]), // connect from the horizontal switch
							.in1(w_internal[2*(i+(2**(LEVELS-j-1)))*(LEVELS-1)+2*(j-1)+1]), // connect from a diagonal switch 
							.sel0(r_mux_bus_ff[2*(LEVELS-2)*i+(2*(j-1))]), // mux select bit
							.sel1(r_mux_bus_ff[2*(LEVELS-2)*i+(2*(j-1)+1)]) // mux select bit
						);
					end else begin : from_nw// input diagonal link from north-west switch
						switch  #(.WIDTH(DATA_TYPE))  imm_switch (
							.y(w_internal[2*i*(LEVELS-1)+2*j]), // horizontal output of switch to w_internal
							.z(w_internal[2*i*(LEVELS-1)+2*j+1]), // diagonal output of switch to w_internal
							.in0(w_internal[2*i*(LEVELS-1)+2*(j-1)]), // connect from the horizontal switch
							.in1(w_internal[2*(i-(2**(LEVELS-j-1)))*(LEVELS-1)+2*(j-1)+1]), // connect from a diagonal switch 
							.sel0(r_mux_bus_ff[2*(LEVELS-2)*i+(2*(j-1))]), // mux select bit
							.sel1(r_mux_bus_ff[2*(LEVELS-2)*i+(2*(j-1)+1)]) // mux select bit
						);
					end
				end
			end
		end
	endgenerate 
endmodule
module input_switch #(parameter WIDTH = 16) (y, z, in);
	output [WIDTH-1:0] y, z;
	input [WIDTH-1:0] in;
	assign y = in;
	assign z = in;
endmodule
module output_switch #(parameter WIDTH = 16) (y, in0, in1, sel);
	output [WIDTH-1:0] y;
	input [WIDTH-1:0] in0, in1;
	input sel;
	benes_mux #(.W(WIDTH)) mux0 ( .o(y), .a(in0), .b(in1), .sel(sel) );
endmodule
module switch #(parameter WIDTH = 16) (y, z, in0, in1, sel0, sel1);
	output [WIDTH-1:0] y, z;
	input [WIDTH-1:0] in0, in1;
	input sel0, sel1;
	benes_mux #(.W(WIDTH)) mux0 ( .o(y), .a(in0), .b(in1), .sel(sel0) ); // y output is horizontal
	benes_mux #(.W(WIDTH)) mux1 ( .o(z), .a(in0), .b(in1), .sel(sel1) ); // z output is diagonal
endmodule
module benes_mux #(parameter W = 16) (o, a, b, sel);
	output reg [W-1:0] o;
	input [W-1:0] a, b;
	input sel;
	always @ (sel or a or b) begin
		o = sel ? b : a;
	end
endmodule 