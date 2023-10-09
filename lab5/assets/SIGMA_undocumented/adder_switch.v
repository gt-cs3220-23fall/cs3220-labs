`timescale 1ns / 1ps
module adder_switch # (
	parameter DATA_TYPE = 32,
	parameter NUM_IN = 4,
	parameter SEL_IN = 2) (
	clk,
	rst,
	i_valid, 
	i_data_bus, 
	i_add_en, 
	i_cmd,
	i_sel,
	o_vn,
	o_vn_valid, // vn output valid
	o_adder // output of the adders (can be sum or forwarding)
);
	parameter NUM_OUT =2;
	input clk;
	input rst;
	input i_valid; // input data valid
	input [(DATA_TYPE*NUM_IN)-1:0] i_data_bus; // input data bus to select from
	input i_add_en;
	input [2:0] i_cmd; // Adder functionality bits
	input [SEL_IN-1:0] i_sel; // select bits for the reduction mux
	output reg [(2*DATA_TYPE)-1:0] o_vn; // vn output
	output reg [1:0] o_vn_valid; // vn output valid
	output reg [(DATA_TYPE*NUM_OUT)-1:0] o_adder; // output of the adders (can be sum or forwarding), upper half --> left, lower half --> right
	wire [(2 * DATA_TYPE)-1:0] w_sel_data; // selected data from reduction mux
	wire [DATA_TYPE-1:0] w_O; // output of adder
	reg [(DATA_TYPE*NUM_OUT)-1:0] r_adder;
	reg r_add_en;
	reg [(2*DATA_TYPE)-1:0] r_vn;
	reg [1:0] r_vn_valid; 
	reduction_mux # (
		.W(DATA_TYPE),
		.NUM_IN(NUM_IN),
		.SEL_IN(SEL_IN),
		.NUM_OUT(NUM_OUT)) my_reduction_mux (
		.i_data(i_data_bus),
		.i_sel(i_sel),
		.o_data(w_sel_data)
	);
	always @ (posedge clk) begin
		if (rst == 1'b1) begin
			r_adder <= 'b0;
			r_vn <= 'b0;
			r_vn_valid <= 'b0;
		end else begin
			if (i_valid == 1'b1) begin
				case (i_cmd)
					3'b000 : begin
						r_vn_valid <= 2'b00;
					end
					3'b001 : begin
						r_adder <= w_sel_data;
						r_vn_valid <= 2'b00;
					end
					3'b010 : begin
						r_vn_valid <= 2'b00;
					end
					3'b011 : begin
						r_adder[2*DATA_TYPE-1:DATA_TYPE] <= w_sel_data[2*DATA_TYPE-1:DATA_TYPE];
						r_vn[DATA_TYPE-1:0] <= i_data_bus[DATA_TYPE-1:0];
						r_vn_valid <= 2'b01;
					end
					3'b100 : begin 
						r_adder[DATA_TYPE-1:0] <= w_sel_data[DATA_TYPE-1:0];
						r_vn[2*DATA_TYPE-1:DATA_TYPE] <= i_data_bus[(DATA_TYPE*NUM_IN)-1:DATA_TYPE*(NUM_IN-1)];
						r_vn_valid <= 2'b10;
					end
					3'b101: begin
						r_vn <= w_sel_data;
						r_vn_valid <= 2'b11;					
					end
					default: begin
						r_vn_valid <= 2'b00;
					end
				endcase
			end
		end
	end
	always @ (posedge clk) begin
		if (rst == 1'b1) begin
			r_add_en <= 'b0;
		end else begin
			r_add_en <= i_add_en;
		end
	end
	always @ (*) begin
		if (rst == 1'b1) begin
			o_adder <= 'd0;
			o_vn <= 'd0;
			o_vn_valid <= 'd0;
		end else begin
			if (r_add_en == 1'b0) begin
				o_adder <= r_adder;
			end else begin
				o_adder <= {w_O,w_O};
			end
			o_vn <= r_vn;
			o_vn_valid <= r_vn_valid;
		end
	end
	adder32 my_adder (
		.clk(clk),
		.rst(rst),
		.A(w_sel_data[DATA_TYPE+:DATA_TYPE]),
		.B(w_sel_data[0+:DATA_TYPE]),
		.O(w_O)
	);
endmodule
